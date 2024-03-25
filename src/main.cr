require "./kepala"

p Kepala::RSS.read(URI.parse(ARGV[0]))
