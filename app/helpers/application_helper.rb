module ApplicationHelper
  def default_meta_tags
    {
      site: 'shinobue-dx',
      title: '篠笛練習曲自動作成',
      reverse: true,
      separator: '|',
      description: '篠笛にピッタリな練習曲を、自動で作曲し数字譜に起こします。六本調子の篠笛とほぼ同じ音程で視聴できます。',
      keywords: '篠笛, 自動作曲, 練習, 数字譜, 譜面, 六本調子, 指打ち, ソルフェジオ周波数, 528ヘルツ',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('icon.png'), rel: 'apple-touch-icon', sizes: '180x180' }
      ],
      og: {
        site_name: 'shinobue-dx',
        title: '篠笛練習曲自動作成',
        description: '篠笛にピッタリな練習曲を、自動で作曲し数字譜に起こします。六本調子の篠笛とほぼ同じ音程で視聴できます。',
        type: 'website',
        url: request.original_url,
        image: image_url('shinobue_etude.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@chuko_engineer'
      }
    }
  end
end
