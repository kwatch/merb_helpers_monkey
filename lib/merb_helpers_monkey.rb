##
## enhances some helper methods in merb_helpers.
## see:
##   http://merb.lighthouseapp.com/projects/7435/tickets/10
##
## this monkey patch is based on merb-helpers 1.0.0.
##


require 'merb-helpers'


##
## enhances radio_button() to take boolean value as :checked option.
##

module Merb::Helpers::Form

  alias _radio_button_orig radio_button

  def radio_button(*args)
    if (opts = args.last).is_a?(Hash)
      opts[:checked] = "checked" if opts.delete(:checked)
    end
    _radio_button_orig(*args)
  end

end


##
## enhances form_for(), fields_for(), and fieldset_for() to support :index_by option.
## see:
##   http://merb.lighthouseapp.com/projects/7435/tickets/10
##

## --
## merb-helpers-1.0/lib/merb-helpers/builder.rb
## ++
module Merb::Helpers::Form::Builder


  class Base

    ##--
    ##def bound_text_area(method, attrs = {})
    ##  name = "#{@name}[#{method}]"
    ##  update_bound_controls(method, attrs, "text_area")
    ##  unbound_text_area(control_value(method), {:name => name}.merge(attrs))
    ##end
    ##++
    def bound_text_area(method, attrs = {})
      name = control_name(method)
      update_bound_controls(method, attrs, "text_area")
      unbound_text_area(control_value(method), {:name => name}.merge(attrs))
    end

    private

    ##--
    ##def control_name(method)
    ##  @obj ? "#{@name}[#{method}]" : method
    ##end
    ##++
    def control_name(method)
      #!@obj ? method : !@index_by ? "#{@name}[#{method}]" : "#{@name}[#{@obj.__send__(@index_by)}][#{method}]"
      !@obj ? method : !@index ? "#{@name}[#{method}]" : "#{@name}[#{@index}][#{method}]"
    end

  end


  class Form

    private

    ##--
    ##def update_bound_controls(method, attrs, type)
    ## attrs.merge!(:id => "#{@name}_#{method}") unless attrs[:id]
    ##end
    ##++
    def update_bound_controls(method, attrs, type)
      #attrs.merge!(:id => "#{@name}_#{method}") unless attrs[:id]
      unless attrs[:id]
        id_attr = "#{@name}_#{method}"
        #id_attr << "_#{@obj.__send__(@index_by)}" if @index_by
        id_attr << "_#{@index}" if @index
        attrs.merge!(:id => id_attr)
      end
      super
    end

    ##--
    ##def radio_group_item(method, attrs)
    ##  unless attrs[:id]
    ##    attrs.merge!(:id => "#{@name}_#{method}_#{attrs[:value]}")
    ##  end
    ##
    ##  attrs.merge!(:label => attrs[:label] || attrs[:value])
    ##  super
    ##end
    ##++
    def radio_group_item(method, attrs)
      unless attrs[:id]
        #attrs.merge!(:id => "#{@name}_#{method}_#{attrs[:value]}")
        id_attr = "#{@name}_#{method}_#{attrs[:value]}"
        #id_attr << "_#{@obj.__send__(@index_by)}" if @index_by
        id_attr << "_#{@index}" if @index
        attrs.merge!(:id => id_attr)
      end

      attrs.merge!(:label => attrs[:label] || attrs[:value])
      super
    end

  end


end


## --
## merb-helpers-1.0/lib/merb-helpers/helper.rb
## ++
module Merb::Helpers::Form

  ##--
  ##def with_form_context(name, builder)
  ##  form_contexts.push(_new_form_context(name, builder))
  ##  ret = yield
  ##  form_contexts.pop
  ##  ret
  ##end
  ##++
  def with_form_context(name, builder, index_by=nil)
    form_contexts.push(c = _new_form_context(name, builder))
    if index_by
      c.instance_variable_set("@index_by", index_by) if index_by
      index = c.instance_variable_get("@obj").__send__(index_by)
      c.instance_variable_set("@index", index)
    end
    ret = yield
    form_contexts.pop
    ret
  end

  ##--
  ##def form_for(name, attrs = {}, &blk)
  ##  with_form_context(name, attrs.delete(:builder)) do
  ##    current_form_context.form(attrs, &blk)
  ##  end
  ##end
  ##++
  def form_for(name, attrs = {}, &blk)
    with_form_context(name, attrs.delete(:builder), attrs.delete(:index_by)) do
      current_form_context.form(attrs, &blk)
    end
  end

  ##--
  ##def fields_for(name, attrs = {}, &blk)
  ##  attrs ||= {}
  ##  with_form_context(name, attrs.delete(:builder)) do
  ##    capture(&blk)
  ##  end
  ##end
  ##++
  def fields_for(name, attrs = {}, &blk)
    attrs ||= {}
    with_form_context(name, attrs.delete(:builder), attrs.delete(:index_by)) do
      capture(&blk)
    end
  end

  ##--
  ##def fieldset_for(name, attrs = {}, &blk)
  ##  with_form_context(name, attrs.delete(:builder), attrs.delete(:index_by)) do
  ##    current_form_context.fieldset(attrs, &blk)
  ##  end
  ##end
  ##++
  def fieldset_for(name, attrs = {}, &blk)
    with_form_context(name, attrs.delete(:builder)) do
      current_form_context.fieldset(attrs, &blk)
    end
  end


end
