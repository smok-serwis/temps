import os
import unittest


class TestDB(unittest.TestCase):
    def test_create_series(self):
        from tempsdb.series import create_series

        series = create_series('test', 1, 10)
        start, ts = 127, 100
        for i in range(20):
            series.append(ts, bytes(bytearray([start])))
            start -= 1
            ts += 100

        self.do_verify_series(series, 0, 2000)
        self.do_verify_series(series, 500, 2000)
        self.do_verify_series(series, 1000, 2000)
        self.do_verify_series(series, 1500, 2000)
        self.do_verify_series(series, 0, 500)
        self.do_verify_series(series, 0, 1200)
        self.do_verify_series(series, 0, 1800)

    def do_verify_series(self, series, start, stop):
        items = list(series.iterate_range(start, stop))
        self.assertGreaterEqual(items[0][0], start)
        self.assertLessEqual(items[-1][0], stop)

    def test_chunk(self):
        from tempsdb.chunks import create_chunk
        data = [(0, b'ala '), (1, b'ma  '), (4, b'kota')]
        chunk = create_chunk(None, 'chunk.db', 0, b'ala ', 4096)
        chunk.append(1, b'ma  ')
        chunk.append(4, b'kota')
        self.assertEqual(chunk.min_ts, 0)
        self.assertEqual(chunk.max_ts, 4)
        self.assertEqual(chunk.block_size, 4)
        self.assertEqual(chunk.get_piece_at(0), (0, b'ala '))
        self.assertEqual(chunk.get_piece_at(1), (1, b'ma  '))
        self.assertEqual(chunk.get_piece_at(2), (4, b'kota'))
        self.assertEqual(len(chunk), 3)
        self.assertEqual(list(iter(chunk)), data)
        chunk.append(5, b'test')
        self.assertEqual(chunk.find_left(0), 0)
        self.assertEqual(chunk.find_left(1), 1)
        self.assertEqual(chunk.find_left(2), 2)
        self.assertEqual(chunk.find_left(3), 2)
        self.assertEqual(chunk.find_left(4), 2)
        self.assertEqual(chunk.find_left(5), 3)
        self.assertEqual(chunk.find_left(6), 4)
        self.assertEqual(chunk.find_right(0), 1)
        self.assertEqual(chunk.find_right(1), 2)
        self.assertEqual(chunk.find_right(2), 2)
        self.assertEqual(chunk.find_right(3), 2)
        self.assertEqual(chunk.find_right(4), 3)
        self.assertEqual(chunk.find_right(5), 4)
        self.assertEqual(chunk.find_right(6), 4)
        chunk.close()
        self.assertEqual(os.path.getsize('chunk.db'), 8192)
