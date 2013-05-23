Feature: Pages
  As a designer
  In order to improve my site navigation
  I want to list its pages

Background:
  Given I have the site: "test site" set up with name: "test site"

Scenario: List all of them
  Given a page named "all" with the template:
    """
    {% for page in site.pages %}{{ page.title }}, {% endfor %}
    """
  When I view the rendered page at "/all"
  Then the rendered output should look like:
    """
    Home page, All, Page not found,
    """

Scenario: Scoped listing
  Given a page named "hidden-page" with the template:
    """
    Hidden content
    """
  And the page "hidden-page" is unpublished
  And a page named "hidden-pages" with the template:
    """
    {% with_scope published: false %}
      {% for page in site.pages %}{{ page.slug }}, {% endfor %}
    {% endwith_scope %}
    """
  When I view the rendered page at "/hidden-pages"
  Then the rendered output should look like:
    """
    hidden-page,
    """

Scenario: link_to tag
  Given the site "test site" has locales "en, es"
  And a page named "about-us" with the handle "about-us"
  And the page named "about-us" has the title "Acerca de" in the "es" locale
  And a page named "page-with-links" with the template:
    """
    {% locale_switcher %}
    {% link_to about-us %}
    {% link_to about-us %}
      <i class="icon-info-sign"></i> {{ target.title }}
    {% endlink_to %}
    """
  And the page named "page-with-links" has the title "Página con links" in the "es" locale
  When I view the rendered page at "/page-with-links"
  Then the rendered output should look like:
    """
    <a href="/about-us">About us</a>
    <a href="/about-us">
      <i class="icon-info-sign"></i> About us
    </a>
    """
  When I follow "es"
  Then the rendered output should look like:
    """
    <a href="/es/acerca-de">Acerca de</a>
    <a href="/es/acerca-de">
      <i class="icon-info-sign"></i> Acerca de
    </a>
    """