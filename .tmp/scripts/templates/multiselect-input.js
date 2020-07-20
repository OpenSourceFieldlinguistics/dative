define(function(){
  var template = function(__obj) {
  var _safe = function(value) {
    if (typeof value === 'undefined' && value == null)
      value = '';
    var result = new String(value);
    result.ecoSafe = true;
    return result;
  };
  return (function() {
    var __out = [], __self = this, _print = function(value) {
      if (typeof value !== 'undefined' && value != null)
        __out.push(value.ecoSafe ? value : __self.escape(value));
    }, _capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return _safe(result);
    };
    (function() {
      var i, len, options, ref, ref1, selectOption, x,
        indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };
    
      _print(_safe('<select\n  multiple=\'multiple\'\n  name=\''));
    
      _print(this.name);
    
      _print(_safe('\'\n  class=\''));
    
      _print(this["class"]);
    
      _print(_safe('\n         dative-tooltip\'\n  title=\''));
    
      _print(this.title);
    
      _print(_safe('\'>\n  '));
    
      options = this.options[this.optionsAttribute] || [];
    
      _print(_safe('\n  '));
    
      ref = _.sortBy(options, (function(_this) {
        return function(x) {
          return x[_this.sortByAttribute].toLowerCase();
        };
      })(this));
      for (i = 0, len = ref.length; i < len; i++) {
        selectOption = ref[i];
        _print(_safe('\n    '));
        if (ref1 = this.selectValueGetter(selectOption), indexOf.call((function() {
          var j, len1, ref2, results;
          ref2 = this.value;
          results = [];
          for (j = 0, len1 = ref2.length; j < len1; j++) {
            x = ref2[j];
            results.push(this.selectValueGetter(x));
          }
          return results;
        }).call(this), ref1) >= 0) {
          _print(_safe('\n      <option value="'));
          _print(this.selectValueGetter(selectOption));
          _print(_safe('" selected\n        >'));
          _print(this.selectTextGetter(selectOption));
          _print(_safe('</option>\n    '));
        } else {
          _print(_safe('\n      <option value="'));
          _print(this.selectValueGetter(selectOption));
          _print(_safe('"\n        >'));
          _print(this.selectTextGetter(selectOption));
          _print(_safe('</option>\n    '));
        }
        _print(_safe('\n  '));
      }
    
      _print(_safe('\n</select>\n\n'));
    
    }).call(this);
    
    return __out.join('');
  }).call((function() {
    var obj = {
      escape: function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      },
      safe: _safe
    }, key;
    for (key in __obj) obj[key] = __obj[key];
    return obj;
  })());
};
  return template;
});
