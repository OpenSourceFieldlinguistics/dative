define [
  './resource'
  './form-add-widget'
  './person-field-display'
  './date-field-display'
  './object-with-name-field-display'
  './array-of-objects-with-name-field-display'
  './judgement-value-field-display'
  './morpheme-break-field-display'
  './morpheme-gloss-field-display'
  './phonetic-transcription-field-display'
  './grammaticality-value-field-display'
  './translations-field-display'
  './source-field-display'
  './array-of-objects-with-title-field-display'
  './comments-field-display'
  './modified-by-user-field-display'
  './../models/form'
  './../utils/globals'
], (ResourceView, FormAddWidgetView, PersonFieldDisplayView,
  DateFieldDisplayView, ObjectWithNameFieldDisplayView,
  ArrayOfObjectsWithNameFieldDisplayView, JudgementValueFieldDisplayView,
  MorphemeBreakFieldDisplayView, MorphemeGlossFieldDisplayView,
  PhoneticTranscriptionFieldDisplayView, GrammaticalityValueFieldDisplayView,
  TranslationsFieldDisplayView, SourceFieldDisplayView,
  ArrayOfObjectsWithTitleFieldDisplayView, CommentsFieldDisplayView,
  ModifiedByUserFieldDisplayView, FormModel, globals) ->

  # Form View
  # --------------
  #
  # For displaying individual forms.

  class FormView extends ResourceView

    className: 'dative-resource-widget dative-form-object dative-paginated-item
      dative-widget-center ui-corner-all'

    # TODO: listenTo `fetchHistory...`-type events on Backbone
    initialize: (options) ->
      super
      @headerAlwaysVisible = false
      @setAttribute2DisplayView()
      @setAttributeClasses()

    listenToEvents: ->
      super
      @listenTo @model, "fetchHistoryFormStart", @fetchHistoryFormStart
      @listenTo @model, "fetchHistoryFormEnd", @fetchHistoryFormEnd
      @listenTo @model, "fetchHistoryFormFail", @fetchHistoryFormFail
      @listenTo @model, "fetchHistoryFormSuccess", @fetchHistoryFormSuccess

    fetchHistoryFormStart: ->
      console.log 'fetchHistoryFormStart'
      @spin()

    fetchHistoryFormEnd: ->
      console.log 'fetchHistoryFormEnd'
      @stopSpin()

    fetchHistoryFormFail: ->
      console.log 'fetchHistoryFormFail'

    fetchHistoryFormSuccess: (responseJSON) ->
      console.log 'fetchHistoryFormSuccess'
      console.log responseJSON
      console.log responseJSON.previous_versions
      @previousVersionModels = ((new FormModel(pv)) for pv in responseJSON.previous_versions)
      # D'oh, circular FormView reference rquired ...
      #@previousVersionViews = ((new FormView
      console.log @previousVersions


    setAttributeClasses: ->
      @setPrimaryAttributes()
      @setSecondaryAttributes()

    setPrimaryAttributes: ->
      igtAttributes = @getFormAttributes @activeServerType, 'igt'
      translationAttributes =
        @getFormAttributes @activeServerType, 'translation'
      @primaryAttributes = igtAttributes.concat translationAttributes

    setSecondaryAttributes: ->
      secondaryAttributes = @getFormAttributes @activeServerType, 'secondary'
      if @activeServerType is 'FieldDB'
        # In the FieldDB case, we want to display all datum fields, even if
        # they're not listed in the secondary attributes array of the
        # application settings model.
        datumFields = (x.label for x in @model.get('datumFields'))
        grammaticalityAttributes =
          @getFormAttributes @activeServerType, 'grammaticality'
        accountedForAttributes = grammaticalityAttributes.concat(
          secondaryAttributes, @primaryAttributes)
        for field in datumFields
          if field not in accountedForAttributes
            secondaryAttributes.push field
      @secondaryAttributes = secondaryAttributes

    setAttribute2DisplayView: ->
      switch @activeServerType
        when 'FieldDB'
          @attribute2displayView = @attribute2displayViewFieldDB
        when 'OLD'
          @attribute2displayView = @attribute2displayViewOLD

    resourceName: 'form'

    resourceAddWidgetView: FormAddWidgetView

    attribute2displayView: {}

    attribute2displayViewFieldDB:
      utterance: JudgementValueFieldDisplayView
      morphemes: MorphemeBreakFieldDisplayView
      gloss: MorphemeGlossFieldDisplayView
      dateElicited: DateFieldDisplayView
      dateEntered: DateFieldDisplayView
      dateModified: DateFieldDisplayView
      comments: CommentsFieldDisplayView
      modifiedByUser: ModifiedByUserFieldDisplayView

    attribute2displayViewOLD:
      narrow_phonetic_transcription: PhoneticTranscriptionFieldDisplayView
      phonetic_transcription: PhoneticTranscriptionFieldDisplayView
      transcription: GrammaticalityValueFieldDisplayView
      translations: TranslationsFieldDisplayView
      morpheme_break: MorphemeBreakFieldDisplayView
      morpheme_gloss: MorphemeGlossFieldDisplayView
      syntactic_category: ObjectWithNameFieldDisplayView
      elicitation_method: ObjectWithNameFieldDisplayView
      source: SourceFieldDisplayView
      date_elicited: DateFieldDisplayView
      datetime_entered: DateFieldDisplayView
      datetime_modified: DateFieldDisplayView
      speaker: PersonFieldDisplayView
      elicitor: PersonFieldDisplayView
      enterer: PersonFieldDisplayView
      modifier: PersonFieldDisplayView
      verifier: PersonFieldDisplayView
      collections: ArrayOfObjectsWithTitleFieldDisplayView
      tags: ArrayOfObjectsWithNameFieldDisplayView
      files: ArrayOfObjectsWithNameFieldDisplayView

    # We don't want form widgets to have headers.
    getHeaderTitle: -> ''

    # Get an array of form attributes (form app settings model) for the
    # specified server type and category (e.g., 'igt' or 'secondary').
    getFormAttributes: (serverType, category) ->
      switch serverType
        when 'FieldDB' then attribute = 'fieldDBFormCategories'
        when 'OLD' then attribute = 'oldFormCategories'
      try
        globals.applicationSettings.get(attribute)[category]
      catch
        console.log "WARNING: could not get an attributes array for
          #{serverType} and #{category}"
        []

