Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033105;
	b=nvCrzuI4ERmNBJCrbs2bqUgr8kUFPf1hbzXw5R8jQw6/RI33z1uN9TYIB9kgmxrMUbsN
	 j8CdUTaygFKCa/7wXkdVMth04U5cPfBXPzJAQyiyvHeAu4sTXkzza29r6kxLrVlFNw1Z1
	 rjNBxdWUk2DXdGFlBgTy8fPsW7gzqq4yiph17sk1/PDBjdiHOfr6R3ry8swuiI5l/Ldbz
	 6t0yLHrLkreJhYRMEcSehtAEU8QX4KClkRxx1oTuMAmNkYI10NrB5OwrEHO+irdpb+H7S
	 lq8d88i8fKyXi9ol2ZIToXcPat6XMXMwlUDT2KJQp1cYysasGuZBFQenpxfZaSxCiTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DNBw4UKzGHzw0uVOkENKJVcX+SA1Gz8wtpzwsNgDINU=;
	b=Fhib+E4PkRP4QHOyGdVsShM8+jsnZKO+b4rCPCj7KB1cldmxx5Ye32kxmMJmoulQZmeA
	 rs7i1vADub9AL7+ZLeOegI3R2WJMc9i3uLogLWvSQXZ++MrhgCxhkLVVxpUL6Nog10rja
	 mf+jLwuaxtLRklwBRJkfwMg0KPSWOg7vZa6NiZTfxmX5rS9oQs3XdvcBHHMDHUmyXEkxc
	 YtjQNbmtcpo4c2EK3+rH1pba1oEnoZYNqe/dAh/UIlUjpDbrNrT1NUGUEV22T+p0m5wAc
	 35KVAOnkAQmrf8JzVxKfb96acfrO32ZVUtgwaf1fvQkbGlqqY8aPkvfO1HeqsmEWszA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dueyaLvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE80606A31C;
	Wed, 18 Nov 2026 20:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dueyaLvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCEB1F000C4;
	Wed, 18 Nov 2026 20:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033105;
	bh=DNBw4UKzGHzw0uVOkENKJVcX+SA1Gz8wtpzwsNgDINU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dueyaLvqHxSS8FOOWXfU+D/xlBTMJoS9aqP2dfNb8TuIxp8bGTvgaU4ydUTUNqir6
	 /P4TlU0ksrHfGNkoWc8oNfau4180sWjlASD19X4LvXzIA1vfi1vbDur5fuEezbl/PM
	 AL7n7Hv5pG/ePGwuFrMXZfCzBk1C0HVjs6lZww0E=
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
Subject: [PATCH 6.12 1607/1756] perf mmap: Use the head selected by read_init
Date: Wed, 18 Nov 2026 16:02:14 +0100
Message-ID: <20261118150113.847407995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 43b02293f1d2d..3033b454643b4 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -319,7 +319,7 @@ int mmap__mmap(struct mmap *map, struct mmap_params *mp, int fd, struct perf_cpu
 int perf_mmap__push(struct mmap *md, void *to,
 		    int push(struct mmap *map, void *to, void *buf, size_t size))
 {
-	u64 head = perf_mmap__read_head(&md->core);
+	u64 head;
 	unsigned char *data = md->core.base + page_size;
 	unsigned long size;
 	void *buf;
@@ -329,6 +329,7 @@ int perf_mmap__push(struct mmap *md, void *to,
 	if (rc < 0)
 		return (rc == -EAGAIN) ? 1 : -1;
 
+	head = md->core.overwrite ? md->core.start : md->core.end;
 	size = md->core.end - md->core.start;
 
 	if ((md->core.start & md->core.mask) + size != (md->core.end & md->core.mask)) {
-- 
2.53.0



