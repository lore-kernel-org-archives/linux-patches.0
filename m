Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056877;
	b=cmK92HpnBHhAdF4ctfef8q2NRVA4GI5Nn+8hw+lUQhoeMY/Aal8rglVOPBksFWq/iHxC
	 XLSpqncJzW1Ix1vk7zMpQCaKrgwtGzQHgxSUCTvh0yU8cius81Vc/z2VT+l8p2lhh7WVT
	 bgxA9jw9zxHVqPDQ6YmIDTsFXKqAk9k+mPSwXeDOC3XkarwZ2AE7hk/rwTKFOFkYDG1mI
	 AcEAHxR9nh6Z1nFUmTdz30vFfro83ONC2SzstF8TUpQpVm07jwPRwN1eoOvbDktwRdd6q
	 Jqb+YBlGUe3GjI4QxI1XD8U8d0zjbUlajQGmIS6Xe8nPdOgoYYH8N8pT/25aXZYx+sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+d7vsu++mHyR7e5fDc1hPiFTwwE6+mnNkhKd/cRvYgk=;
	b=zgUuI46ShT9uI38uRWjEG9yYEVRfjWv1Neh7IL1YFKqRQDSX7wnLY7gIuSCwTpxHYV3G
	 h9ht4Cb/3RZTT63hfVRlW9HpK19bIccxAE0Ag92xiZx2x1UAcv6jiiONnWCfQjFwOz8aJ
	 5DOLoR54+L8U2pdICuk+TkyrYp+2ViBsFFFCeEqEdDJU5oeHX258flBjQtArPNN9J8Vj7
	 fnKD36QKPx3I+sdL41B/i5PQdlR0kkYt1W4t81+gycJEZ9GFMVyqtvMuDifV5/brkdhii
	 lfcshFFGCJGSctEjCTJsIn3IySJ50vx0jto562WDUDz3uSe80pcfWU49DVQHkUVCWXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAGP+2O9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ABC606A320;
	Thu, 19 Nov 2026 02:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAGP+2O9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D3A1F000C4;
	Thu, 19 Nov 2026 02:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056877;
	bh=+d7vsu++mHyR7e5fDc1hPiFTwwE6+mnNkhKd/cRvYgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAGP+2O9JMdaWCdbm8SuHTYooi7AwAPX/DCn3Winh4ayEglW7xyoFfbmfEtqF3BsL
	 3/WG9FBpdc6uzbXhPAidXBYAPiFJ6s4YYJ/pOCYEMf/MkU1UN3kJegEhEqCnEwVpKV
	 np0RMkjyGWhkyzAZfwHQPJ5JKxkj6Ksks1k0cGk8=
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
Subject: [PATCH 5.15 2144/2214] perf mmap: Use the head selected by read_init
Date: Wed, 18 Nov 2026 16:03:40 +0100
Message-ID: <20261118150136.255546523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 512dc8b9c1685..f40c953cb2bf7 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -313,7 +313,7 @@ int mmap__mmap(struct mmap *map, struct mmap_params *mp, int fd, int cpu)
 int perf_mmap__push(struct mmap *md, void *to,
 		    int push(struct mmap *map, void *to, void *buf, size_t size))
 {
-	u64 head = perf_mmap__read_head(&md->core);
+	u64 head;
 	unsigned char *data = md->core.base + page_size;
 	unsigned long size;
 	void *buf;
@@ -323,6 +323,7 @@ int perf_mmap__push(struct mmap *md, void *to,
 	if (rc < 0)
 		return (rc == -EAGAIN) ? 1 : -1;
 
+	head = md->core.overwrite ? md->core.start : md->core.end;
 	size = md->core.end - md->core.start;
 
 	if ((md->core.start & md->core.mask) + size != (md->core.end & md->core.mask)) {
-- 
2.53.0



