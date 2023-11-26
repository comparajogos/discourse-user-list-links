import { tracked } from "@glimmer/tracking";
import Component from "@glimmer/component";
import { ajax } from "discourse/lib/ajax";
import didUpdate from "@ember/render-modifiers/modifiers/did-update";
import icon from "discourse-common/helpers/d-icon";

const GRAPHQL_URL = "https://api.comparajogos.com.br/v1/graphql";

async function graphql(query, variables) {
  return await ajax(GRAPHQL_URL, {
    type: "POST",
    headers: { "Content-Type": "application/json" },
    data: JSON.stringify({ query, variables }),
  });
}

const LIST_QUERY = `query list($username: String!) {
  lists(where: {user: {username: {_eq: $username}}}, limit: 4) {
    name
    slug
    type
    items_aggregate {
      aggregate {
        count
      }
    }
  }
}`;

const ICON_MAP = {
  OWN: "check",
  WISH: "star",
  TRADE: "exchange-alt",
};

export default class ExternalProfileLinks extends Component {
  @tracked
  externalProfileLinks;

  constructor() {
    super(...arguments);
    this.fetchLinks();
  }

  async fetchLinks() {
    const { data } = await graphql(LIST_QUERY, {
      username: this.args.username,
    });

    this.externalProfileLinks = data.lists.map((list) => ({
      name: `${list.name} (${list.items_aggregate.aggregate.count})`,
      href: `https://www.comparajogos.com.br/u/${this.args.username}/list/${list.slug}`,
      icon: ICON_MAP[list.type] ?? "eye",
    }));
  }

  get listsUrl() {
    return `https://www.comparajogos.com.br/u/${this.args.username}/lists`;
  }

  <template>
    {{#if this.externalProfileLinks}}
      <div class="external-profile-links" {{didUpdate this.fetchLinks}}>
        <a class="desc" href={{this.listsUrl}}>{{icon "list"}} Listas</a>
        |
        {{#each this.externalProfileLinks as |l|}}
          <a class="external-profile-link" href="{{l.href}}">
            {{icon l.icon}}
            {{l.name}}
          </a>
        {{/each}}
      </div>
    {{/if}}
  </template>
}
