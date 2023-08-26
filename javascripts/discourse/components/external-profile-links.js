import Component from "@glimmer/component";

export default class ExternalProfileLinks extends Component {
  get externalProfileLinks() {
    return [
      {
        name: "Coleção",
        href: `https://www.comparajogos.com.br/u/${this.args.username}/colecao`,
        icon: "check",
        title: "ver a coleção deste usuário",
      },
      {
        name: "Lista de Desejos",
        href: `https://www.comparajogos.com.br/u/${this.args.username}/desejos`,
        icon: "star",
        title: "ver a lista de desejos deste usuário",
      },
    ];
  }
}
