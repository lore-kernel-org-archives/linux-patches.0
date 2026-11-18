Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022073;
	b=mLdeO3wFkN5ZvDg5KenxSXfmJ8R9MOrqQIVRYFccmyA51PJCnsrBgjGhomByMpbVulYh
	 juEXTkmZ8rTqcqu4wi1Iit4/Jd5HHXKtSNfp/LLTOlPZzWJ1LTZP9jqOxiFDJlgR12k7R
	 b2VO53WpgI5Zz4rOOF5wQj1Pa/MD3nX3M0erIaUfz8ekq6ulfJnYY+Wk1ifS2o6plJosQ
	 oivOThbT8/9SbBTN4dc5wkJAp1Kx5BO6s3rsaEfktFZEXAjjuV/UrFNp8lclX7PkSmED7
	 IWMFP2pfGJOggBq90TNN0ux/A9eh4G3uwpJelGc+TWpfF0Pu+P7TOteIBZG3g9R26Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b+1HXk2NJYDOF3m3wZLnToz57Uf07fuOZcvf9Op0Fco=;
	b=ZTvq6K2Wdghyy65VUQOHj0oH7pgcUkNadgyRTSEuCZo1b9vbMddA3832pDfuma8ErqF3
	 PaeWXTay7O3RL2iGZ0mzj5dcQNpkym1a1hZbGj4wh1ULSCosFcl0QZ9Gk8zvDrgWwzpAi
	 v8yiqHvj3QZLYXsVAk7E0YDFL9h6qZEncRBCdPKbbPSmDmhUg+sa6FQJL5jM5K0D84al3
	 /oNA1hNwOmgKYz7jYTSlOw6IaNvwX3vZlFxFUPiCRaPg30EzBCBASpj1IFJhuonMsfpqU
	 9iiYeVA15PUbMF9Zqw+ok0SVA6/4xDXrkl67Q93+rL4DT6yLr2mvV+0e0rw2IoFsLPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPlxlPQl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841F4606A335;
	Wed, 18 Nov 2026 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPlxlPQl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA3D1F000C4;
	Wed, 18 Nov 2026 17:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022073;
	bh=b+1HXk2NJYDOF3m3wZLnToz57Uf07fuOZcvf9Op0Fco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPlxlPQl9qj+GIp+xp+sukG2W9Pc7jGhhUB5nrtGI20Td0cbMgjEMLc7D+DQXgOFt
	 tT2mqHjUQx7nyxVcpR0twjLypsZYM1YYLTy7zohzotSBZ70/HBWvOpTUX2i9clKGhU
	 A0lAV6HqmWHYQcjJyaQVspJ/Vo6g3RPfCrijj1Ls=
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
Subject: [PATCH 7.3 2495/2651] perf mmap: Use the head selected by read_init
Date: Wed, 18 Nov 2026 16:02:15 +0100
Message-ID: <20261118150414.653789799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 358e70c4f3edd..6dcc4a9304b92 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -330,7 +330,7 @@ int mmap__mmap(struct mmap *map, struct mmap_params *mp, int fd, struct perf_cpu
 int perf_mmap__push(struct mmap *md, void *to,
 		    int push(struct mmap *map, void *to, void *buf, size_t size))
 {
-	u64 head = perf_mmap__read_head(&md->core);
+	u64 head;
 	unsigned char *data = md->core.base + page_size;
 	unsigned long size;
 	void *buf;
@@ -340,6 +340,7 @@ int perf_mmap__push(struct mmap *md, void *to,
 	if (rc < 0)
 		return (rc == -EAGAIN) ? 1 : -1;
 
+	head = md->core.overwrite ? md->core.start : md->core.end;
 	size = md->core.end - md->core.start;
 
 	if ((md->core.start & md->core.mask) + size != (md->core.end & md->core.mask)) {
-- 
2.53.0



