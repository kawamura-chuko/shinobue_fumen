module ScaleInfo
  extend ActiveSupport::Concern

  def scale_info
    [
      [
        {
          # 都節音階(レベル1)
          last: [3],
          pitch: ["O3b-", "O4d", "O4e-", "O4g", "O4a"],
          probability: 45,
        },
        {
          # 民謡音階(レベル1)
          last: [1, 2],
          pitch: ["O3b-", "O4c", "O4e-", "O4f", "O4g"],
          probability: 20,
        },
        {
          # 律音階(レベル1)
          last: [2],
          pitch: ["O4c", "O4d", "O4f", "O4g", "O4a"],
          probability: 25,
        },
        {
          # 琉球音階(レベル1)
          last: [0],
          pitch: ["O3b-", "O4d", "O4e-", "O4f", "O4a"],
          probability: 10,
        },
      ],
      [
        {
          # 都節音階(レベル2)
          last: [3, 8],
          pitch: ["O3b-", "O4d", "O4e-", "O4g", "O4a", "O4b-", "O5d", "O5e-", "O5g", "O5a","O5b-"],
          probability: 45,
        },
        {
          # 民謡音階(レベル2)
          last: [1, 2, 6, 7],
          pitch: ["O3b-", "O4c", "O4e-", "O4f", "O4g", "O4b-", "O5c", "O5e-", "O5f", "O5g","O5b-"],
          probability: 15,
        },
        {
          # 律音階(レベル2-1)
          last: [2, 7],
          pitch: ["O4c", "O4d", "O4f", "O4g", "O4a", "O5c", "O5d", "O5f", "O5g", "O5a"],
          probability: 15,
        },
        {
          # 律音階(レベル2-2)
          last: [0, 5],
          pitch: ["O3b-", "O4c", "O4d", "O4f", "O4g", "O4b-", "O5c", "O5d", "O5f", "O5g","O5b-"],
          probability: 15,
        },
        {
          # 琉球音階(レベル2)
          last: [0, 5],
          pitch: ["O3b-", "O4d", "O4e-", "O4f", "O4a", "O4b-", "O5d", "O5e-", "O5f", "O5a","O5b-"],
          probability: 10,
        },
      ],
      [
        {
          # 都節音階(レベル3)
          last: [0, 5],
          pitch: ["O4c", "O4d", "O4e-", "O4g", "O4a-", "O5c", "O5d", "O5e-", "O5g", "O5a-"],
          probability: 45,
        },
        {
          # 民謡音階(レベル3)
          last: [3, 4, 8, 9],
          pitch: ["O3b-", "O4c", "O4e-", "O4f", "O4a-", "O4b-", "O5c", "O5e-", "O5f", "O5a-", "O5b-"],
          probability: 45,
        },
        {
          # 琉球音階(レベル3)
          last: [2, 7],
          pitch: ["O3b-", "O4d", "O4e-", "O4g", "O4a-", "O4b-", "O5d", "O5e-", "O5g", "O5a-", "O5b-"],
          probability: 10,
        },
      ],
      [
        {
          # 都節音階(レベル4)
          last: [2, 7],
          pitch: ["O4c", "O4d-", "O4f", "O4g", "O4a-", "O5c", "O5d-", "O5f", "O5g", "O5a-"],
          probability: 45,
        },
        {
          # 民謡音階(レベル4)
          last: [0, 1, 5, 6],
          pitch: ["O3b-", "O4d-", "O4e-", "O4f", "O4a-", "O4b-", "O5d-", "O5e-", "O5f", "O5a-", "O5b-"],
          probability: 45,
        },
        {
          # 琉球音階(レベル4)
          last: [4, 9],
          pitch: ["O4c", "O4d-", "O4e-", "O4g", "O4a-", "O5c", "O5d-", "O5e-", "O5g", "O5a-"],
          probability: 10,
        },
      ],
      [
        {
          # 都節音階(レベル5)
          last: [2, 7],
          pitch: ["O3b-", "O3b", "O4e-", "O4f", "O4g-", "O4b-", "O4b", "O5e-", "O5f", "O5g-", "O5b-"],
          probability: 35,
        },
        {
          # ヨナ抜き短音階(レベル5)
          last: [0, 5],
          pitch: ["O3b-", "O4c", "O4d-", "O4f", "O4g-", "O4b-", "O5c", "O5d-", "O5f", "O5g-", "O5b-"],
          probability: 30,
        },
        {
          # 岩戸音階(レベル5)
          last: [4, 9],
          pitch: ["O3b-", "O3b", "O4e-", "O4e", "O4a-", "O4b-", "O4b", "O5e-", "O5e", "O5a-", "O5b-"],
          probability: 35,
        },
      ],
    ]
  end

  def get_scale_info(level, scale)
    scale_info[level][scale]
  end

  def get_scale_info_par_level(level)
    scale_info[level]
  end
end
