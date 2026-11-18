Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028109;
	b=xCiotSj1P920ky6JIEAJUC04XtEXrG4FfqXScpy5Cq1fDUfk4ndP4N4oNTOcven/TwEr
	 Wp93IGYoESoPGi0HKxfKKJEVV0tffU5HD2ivniKeaz+vz2w3k66B8fI77uel+hVvow0qW
	 +ApyrktfUN2VxjGhaKvQvF3kobvv4jP+ZsN44ryzhlig/z3PLuRhBCqgZjZZGASjZ2TyV
	 DBd78ydKYkGlzY1TJ+QFRBm4xN/jN79egsYT8iy6/kU+5HVBvTnMPi9jAK2WyCuB4MjLh
	 b+UAOx0IY8v5jjPrJuv457bZ+q/D6g+RKij+1S0NooTiSXp6oXx0t/5JuE9vVjeBDAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EZ7aq1a081gmXZacgH0BClhZ3E+XyZQd07zjgP3n0Qw=;
	b=Tb0lDSX43K1GMCRjhIVQUYBC+hswySzqcWEbvgnIFxuHm0sewtcjWhCJ2AMd4LP3S+XK
	 PYeI+fRrtbV5VX8X9rBL8eMMY/3jmWFCj/FBiq0SLIMS0L7+LIhAqe+ylWF3j/t1Vd3Bl
	 tD419PNKmgUnCYAKFR5YC8vathX5jYHfOdFuC0IdVHFBtPckvH3NHOmovXVsIXkRFeQIM
	 LVsVykM03lTPjahJ6uW7vKfMbOrk1yb6BwEZOHV7t6cqZ9baxOc7OSagX6XJ9qM1e0rNU
	 czGB+ICLY8wUOBYo6lHsSV7ZPkQqgggCh6IXN8/RVY0WC6oNGJIGnwBMHfcg+AtTw3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMvXlyiS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AFA606A31C;
	Wed, 18 Nov 2026 18:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMvXlyiS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1171F000C4;
	Wed, 18 Nov 2026 18:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028109;
	bh=EZ7aq1a081gmXZacgH0BClhZ3E+XyZQd07zjgP3n0Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMvXlyiSqGRM+YfEerPsFl+gCqvlUAC1e7DMb7XYzbBG64tgODhUSiQ+AFfJ0OwnQ
	 AIHMoMq0+7SYB8pUoNlRlhBqAScqu8n3u8N+YUEq9zb19PKNVolzkl+KWBRy9DcuCP
	 67EWw620jhLjYmfZqlxmD8f3ZHyQrKqFh/OarQ28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2001/2151] perf mmap: Use the head selected by read_init
Date: Wed, 18 Nov 2026 16:02:16 +0100
Message-ID: <20261118150234.615450822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moses <p@1g4.org>

[ Upstream commit 022c64992af554cfd8c564bff86100fb5ed98678 ]

perf_mmap__push() reads the producer head before calling
perf_mmap__read_init(), which reads it again to select the range to
copy.

If the producer advances between those reads, push() copies through the
newer head but stores the earlier head in prev. The next drain starts at
that earlier position and can write the same records to perf.data again.

Use the head selected by read_init(): end for forward buffers and start
for overwrite buffers. Save it before the copy loop advances start so
prev matches the range that was copied.

Fixes: 8872481bd04850b1 ("perf mmap: Introduce perf_mmap__read_init()")
Signed-off-by: Paul Moses <p@1g4.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/mmap.c b/tools/perf/util/mmap.c
index d64aec6c7c843..704d7e7217ada 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -328,7 +328,7 @@ int mmap__mmap(struct mmap *map, struct mmap_params *mp, int fd, struct perf_cpu
 int perf_mmap__push(struct mmap *md, void *to,
 		    int push(struct mmap *map, void *to, void *buf, size_t size))
 {
-	u64 head = perf_mmap__read_head(&md->core);
+	u64 head;
 	unsigned char *data = md->core.base + page_size;
 	unsigned long size;
 	void *buf;
@@ -338,6 +338,7 @@ int perf_mmap__push(struct mmap *md, void *to,
 	if (rc < 0)
 		return (rc == -EAGAIN) ? 1 : -1;
 
+	head = md->core.overwrite ? md->core.start : md->core.end;
 	size = md->core.end - md->core.start;
 
 	if ((md->core.start & md->core.mask) + size != (md->core.end & md->core.mask)) {
-- 
2.53.0



