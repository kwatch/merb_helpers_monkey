======
README
======


About
=====

merb_helpers_monkey is a Merb plug-in to extend the following helper methods.

* radio_button() to take boolean value as :checked options.
* fields_for(), form_for(), and fieldset_for() to take :index_by option.


Install
=======

  ### install gem
  $ sudo gem install merb_helpers_monkey --source=http://gems.github.com
  ## add 'dependency "merb_helpers_monkey"
  $ vi config/dependencies.rb


Usage
=====


radio_button()
--------------

In Merb, 'radio_button :checked=>true' and 'radio_button :checked=>false'
will genereate:

    <input type="radio" checked="true" />
    <input type="radio" checked="false" />

But the following output should be generated:

    <input type="radio" checked="checked" />
    <input type="radio" />

Merb_helpers_monkey extends radio_button() to generate the above <input> tag.
So you can write such as 'radio_button :checked=>(params[:foo]="y")'.


fields_for(), form_for(), fieldsset_for()
----------------------------------------- 

These methods are extended to accept new ':index_by' option.

For example:

    <% @users.each do |user| %>
    <%=  fields_for user, :index_by => :id do %>
    <p>
      <%= text_field :name, :label => 'Name' %>
      <%= text_field :mail, :label => 'Mail' %>
    </p>
    <%   end =%>
    <% end %>

will generate:

    <p>
      <label for="user_name_101">Name</label>
      <input type="text" name="user[101][name]" id="user_name_101" value="Foo" />
      <label for="user_mail_101">Mail</label>
      <input type="text" name="user[101][mail]" id="user_mail_101" value="foo@mail.com" />
    </p>
    <p>
      <label for="user_name_102">Name</label>
      <input type="text" name="user[102][name]" id="user_name_102" value="Bar" />
      <label for="user_mail_102">Mail</label>
      <input type="text" name="user[102][mail]" id="user_mail_102" value="bar@mail.com" />
    </p>

and the following parameters will be sent:

    params = {
      :user => {
        "101" => { :name => "Foo", :mail => "foo@mail.com" },
        "102" => { :name => "Bar", :mail => "bar@mail.com" },
      }
    }

So you can define controller action like the following:

    def update
      params[:user].each do |user_id, values|
        user = User.get(ur_id)  or raise NotFound
        user.update_attribute(values)
        ...
      end
    end


Author
------

makoto kuwata <kwa(at)kuwata-lab.com>
copyright(c) 2008 kuwata-lab.com all rights reserved.


License
-------

MIT License

