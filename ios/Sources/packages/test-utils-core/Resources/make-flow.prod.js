!function(e,t){"object"===typeof exports&&"object"===typeof module?module.exports=t():"function"===typeof define&&define.amd?define([],t):"object"===typeof exports?exports.MakeFlow=t():e.MakeFlow=t()}(this,(function(){return function(e){var t={};function n(o){if(t[o])return t[o].exports;var r=t[o]={i:o,l:!1,exports:{}};return e[o].call(r.exports,r,r.exports,n),r.l=!0,r.exports}return n.m=e,n.c=t,n.d=function(e,t,o){n.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:o})},n.r=function(e){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},n.t=function(e,t){if(1&t&&(e=n(e)),8&t)return e;if(4&t&&"object"===typeof e&&e&&e.__esModule)return e;var o=Object.create(null);if(n.r(o),Object.defineProperty(o,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var r in e)n.d(o,r,function(t){return e[t]}.bind(null,r));return o},n.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return n.d(t,"a",t),t},n.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},n.p="",n(n.s=0)}([function(e,t,n){"use strict";var o,r;function i(e){return"id"in e&&"type"in e?1:"asset"in e&&1===i(e.asset)?2:"navigation"in e||"schema"in e||"views"in e?0:3}n.r(t),n.d(t,"ObjType",(function(){return o})),n.d(t,"identify",(function(){return i})),n.d(t,"makeFlow",(function(){return y})),(r=o||(o={}))[r.FLOW=0]="FLOW",r[r.ASSET=1]="ASSET",r[r.ASSET_WRAPPER=2]="ASSET_WRAPPER",r[r.UNKNOWN=3]="UNKNOWN";var a=Object.defineProperty,u=Object.defineProperties,l=Object.getOwnPropertyDescriptors,s=Object.getOwnPropertySymbols,c=Object.prototype.hasOwnProperty,f=Object.prototype.propertyIsEnumerable,d=(e,t,n)=>t in e?a(e,t,{enumerable:!0,configurable:!0,writable:!0,value:n}):e[t]=n;const p=(e,t)=>{var n,o,r;if((void 0===e.navigation||null===e.navigation)&&Array.isArray(e.views)&&1===e.views.length){const i={startState:"VIEW_0",VIEW_0:{state_type:"VIEW",ref:null!=(n=e.views[0].id)?n:`${e.id}-views-0`,transitions:{"*":"END_done",Prev:"END_back"}},END_done:{state_type:"END",outcome:null!=(o=null==t?void 0:t.outcome)?o:"doneWithFlow"},END_back:{state_type:"END",outcome:"BACK"}};return void 0!==(null==t?void 0:t.onStart)&&(i.onStart=t.onStart),void 0!==(null==t?void 0:t.onEnd)&&(i.onEnd=t.onEnd),r=((e,t)=>{for(var n in t||(t={}))c.call(t,n)&&d(e,n,t[n]);if(s)for(var n of s(t))f.call(t,n)&&d(e,n,t[n]);return e})({},e),u(r,l({navigation:{BEGIN:"Flow",Flow:i}}))}return e};function y(e,t){const n=function(e){return"status"in e&&"data"in e?e.data:e}("string"===typeof e?JSON.parse(e):e);if(Array.isArray(n)){return y({id:"collection",type:"collection",values:n.map((e=>i(e)===o.ASSET?{asset:e}:e))})}const r=i(e);if(r===o.UNKNOWN)throw new Error("No clue how to convert this into a flow. Just do it yourself");return r===o.FLOW?p(e,t):r===o.ASSET_WRAPPER?y(e.asset):{id:"generated-flow",views:[e],data:{},navigation:{BEGIN:"FLOW_1",FLOW_1:{startState:"VIEW_1",VIEW_1:{state_type:"VIEW",ref:e.id,transitions:{"*":"END_Done"}},END_Done:{state_type:"END",outcome:"done"}}}}}}])}));