require "http/client"
require "xml"

class Kepala::RSS
  record Item,
    title : String,
    publication_date : Time,
    torrent_download_url : URI

  def self.read(url : URI) : Indexable(Item)
    doc = nil
    HTTP::Client.get(url) do |response|
      unless response.status.success?
        raise "RSS request returned unexpected status code: #{response.status}"
      end

      if response.mime_type.try &.media_type != "application/xml"
        raise "RSS request didn't return application/xml"
      end

      doc = XML.parse(response.body_io)
      items = doc.xpath_nodes("/rss/channel/item")

      items.compact_map do |item|
        unless title = item.xpath_node("title")
          next
        end
        unless pub_date = item.xpath_node("pubDate")
          next
        end
        unless enclosure = item.xpath_node("enclosure[@type='application/x-bittorrent']")
          next
        end
        Item.new(
          title: title.content,
          publication_date: Time::Format::RFC_2822.parse(pub_date.content),
          torrent_download_url: URI.parse(enclosure["url"])
        )
      end
    end
  end
end
