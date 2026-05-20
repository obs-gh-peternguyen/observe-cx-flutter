class UsefulLink {
  final String title;
  final String url;
  final String description;

  const UsefulLink({
    required this.title,
    required this.url,
    required this.description,
  });
}

final List<UsefulLink> usefulLinks = [
  UsefulLink(
    title: 'Observe Documentation',
    url: 'https://docs.observeinc.com',
    description: 'Official Observe platform documentation.',
  ),
  UsefulLink(
    title: 'OPAL Reference',
    url: 'https://docs.observeinc.com/en/latest/content/query/opal-reference.html',
    description: 'Complete OPAL language reference guide.',
  ),
  UsefulLink(
    title: 'Observe Community',
    url: 'https://community.observeinc.com',
    description: 'Community forums for questions and best practices.',
  ),
  UsefulLink(
    title: 'OpenTelemetry',
    url: 'https://opentelemetry.io',
    description: 'OpenTelemetry project — observability framework.',
  ),
  UsefulLink(
    title: 'Observe Status Page',
    url: 'https://status.observeinc.com',
    description: 'Check Observe platform availability and incidents.',
  ),
  UsefulLink(
    title: 'Observe GitHub',
    url: 'https://github.com/observeinc',
    description: 'Open-source integrations and examples.',
  ),
  UsefulLink(
    title: 'Snowflake',
    url: 'https://www.snowflake.com',
    description: 'Snowflake — the AI Data Cloud.',
  ),
  UsefulLink(
    title: 'Observe FAQs Streamlit App',
    url: 'https://observe-faqs.streamlit.app',
    description: 'Interactive FAQ companion app for Observe.',
  ),
];
