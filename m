Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042538;
	b=HkTQGyuucv9tamab6KzFrgs2ZKMqWNaFVjtiHuHhpI2XvGhbzLSgNfeR3rIlpyHpx0yL
	 YRmNOnFCqvfR7cdqXhbKlKepRgk1efjXTrCxAlDVowKZ4TNteF/uJQOYV2xmKP9c2OIKv
	 wPxCWLWaBzYAJg3LJOQBgFWClmtfQywpBpk9NSVSGjMDDV6eRr6Ok8PZNINXg9J+/kij9
	 hsZisIiuIifMhwlyhgUWDC+XAiz2nxkF1rhgseY5KhSr5GLN1qA2RNUBvaX0RNCUNuF/L
	 99WEkvINCDwg4Z6nLzc+y+4sKOCBI8xdVr8v4HUfqdPN3ILHhus3TXTTAYG73uFL0rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xSPLpqHiqAOPe23TXxaZDfwL10m6WMJcb6/A8YV6jD0=;
	b=tAQa5RuQcVKNPHAwXtJL14nXDOd4l9sl2aFZivGaFyVVCFNBF/5eBRpsaMmZXr3qDRsD
	 SvWdZ8mxis2pwXGrHux6ApBWJ2sZEJVW3W69auLN9q97FtK0GqCr6lWjtyng8lL6KpSJ8
	 PzzQRMVeVLto5HswV1l89o9xBcRMvtP1PzTeyB6/S7NkwYK+6w4zOSXwJMvRYQ1hupWaD
	 te2xK2vw/P+vjkLh6GH6dy8VEqOOhh+yLRdEiT332IUDa5FI2I4igHMECfpFH7eeU2kRV
	 TJq0HbuD2tJ8PXTO0tfbeSPROpdh9Sz3fdgMfBv90QTUx21pOEFAdjtNxA+5/kdMtQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2UAHFwV2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3344606A31C;
	Wed, 18 Nov 2026 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2UAHFwV2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198B91F000C4;
	Wed, 18 Nov 2026 22:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042537;
	bh=xSPLpqHiqAOPe23TXxaZDfwL10m6WMJcb6/A8YV6jD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2UAHFwV2aTo/HXEPWO2E7j31sFbk6M/1sPodp4h5BwPFRXz0Wyv9V+84K48qWUDEp
	 XLUemhMy9mVYUaYaa+Tb+LKOENm5imgzo4s4Q6CZIa3irAYtn/3adnx3lNYTrNi17O
	 WbCjW8VI3BHfh8tstOnOup5t0Phm3icQOviVIwQs=
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
Subject: [PATCH 6.6 3199/3318] perf mmap: Use the head selected by read_init
Date: Wed, 18 Nov 2026 16:03:41 +0100
Message-ID: <20261118150455.735236205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 49093b21ee2da..4d3e351ccf553 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -324,7 +324,7 @@ int mmap__mmap(struct mmap *map, struct mmap_params *mp, int fd, struct perf_cpu
 int perf_mmap__push(struct mmap *md, void *to,
 		    int push(struct mmap *map, void *to, void *buf, size_t size))
 {
-	u64 head = perf_mmap__read_head(&md->core);
+	u64 head;
 	unsigned char *data = md->core.base + page_size;
 	unsigned long size;
 	void *buf;
@@ -334,6 +334,7 @@ int perf_mmap__push(struct mmap *md, void *to,
 	if (rc < 0)
 		return (rc == -EAGAIN) ? 1 : -1;
 
+	head = md->core.overwrite ? md->core.start : md->core.end;
 	size = md->core.end - md->core.start;
 
 	if ((md->core.start & md->core.mask) + size != (md->core.end & md->core.mask)) {
-- 
2.53.0



