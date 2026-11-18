Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028139;
	b=FMWBfGLWt6EDEicXqYKckHnhr0c77smKrm/6CvI6TCbpKuC1uno+cCcSRpxK2hrXZY4g
	 4PwECDsBjV32s4v5+2rbSvWTnYXKBxVt3rgb65jYkAdJ4K9D+4LZSHRedM6HA/vt6SqJZ
	 EVWgpYcDmlQfoOP9+4v0AANpbC43/8BgIVTimnQKYc7VyKJGTLWdeIvTPdDutQxddWg2U
	 m4/zw18lpVZQaq1RcrMeNdIx7NTmXX8OeFb2OS4N5Owd3Pud/eg66Gr24vdwPHm9P3Sz7
	 eMfEm0d9Omrbk+AbhF8+vZSw8FWd8Ms9vZ9s5hEjwij0+nGopE2rCjj8FbLlbI8vc5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SwAUFDj4xNzMbFp7WPDLI8hQ9GiZoBnXz8nb13kcc68=;
	b=DLo+wHYxx1KQDga/d1ywVAwUV0KQKmk3kewi3HdR60edCH2dww6sOPwZ+URRR31Kzkj3
	 aTl96b1cJhNMkp93gwH9fKjgi1aiRzj8AD83j/8e+9IUmRNsCDd/kG4NGqm3gy13bCMi/
	 VFsGWo5pUh2gQKF7qCW2OYE0KVDIu8dTb/cYIhQmfkvmWIIjf1fDRqKaaEYlLnsue1jNm
	 DdDca7yw+p42nja6GbAiVjasx5W9dPkJrsK7BOq4CLB1Ir0m4laClD0a4egtETNDwtRU6
	 dstBYHZ/VNOrMvR820o1A2nkryLFmemOs5gjtf2VlWVpg8FxCo10qz3z9IIS2LoIinQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcUmw8k1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2A6606A31C;
	Wed, 18 Nov 2026 18:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcUmw8k1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AE11F000C4;
	Wed, 18 Nov 2026 18:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028139;
	bh=SwAUFDj4xNzMbFp7WPDLI8hQ9GiZoBnXz8nb13kcc68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcUmw8k1Dc1R8jVOJqUWy8iIBpyEkbI9mdnbhTvVrP2NWJF8+f8nuslBt/SSx7QwI
	 AtEgzryJIkNzUJImbsoDNLWgjEIZ2mYBgRV26XFXKVEWmSAveWqzFPSuK+A7zrLVP2
	 FdSkaldE1D7XB0tWOASeEYEd+JdMvIzIdLBN5Ba0=
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
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2002/2151] perf mmap: Preserve the consumed cursor in forward mode
Date: Wed, 18 Nov 2026 16:02:17 +0100
Message-ID: <20261118150234.652813868@linuxfoundation.org>
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

[ Upstream commit 1e826983ceef421d7047ed76581840b778294ad4 ]

perf_mmap__read_event() updates prev as it consumes forward-buffer
records. perf_mmap__read_done() then overwrites prev with a fresh
producer head, even when unread records remain.

perf_kvm__mmap_read_idx() stops after 25 records per mmap and calls
read_done(). If more records are pending, prev advances past them. The
next drain starts at that new position and skips the unread remainder.

An event arriving after the last empty read_event() and before
read_done() can also be skipped. read_done() does not itself update the
kernel's data_tail.

Only refresh prev for overwrite buffers, which need the current head as
the end of the next backward read. Leave the forward cursor at the
consumed position.

Fixes: 53172f9057e92c9b ("perf kvm: Switch to new perf_mmap__read_event() interface")
Signed-off-by: Paul Moses <p@1g4.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/perf/mmap.c b/tools/lib/perf/mmap.c
index ec124eb0ec0ab..ab3adf1d8baf9 100644
--- a/tools/lib/perf/mmap.c
+++ b/tools/lib/perf/mmap.c
@@ -200,7 +200,7 @@ void perf_mmap__read_done(struct perf_mmap *map)
 	/*
 	 * Check if event was unmapped due to a POLLHUP/POLLERR.
 	 */
-	if (!refcount_read(&map->refcnt))
+	if (!refcount_read(&map->refcnt) || !map->overwrite)
 		return;
 
 	map->prev = perf_mmap__read_head(map);
-- 
2.53.0



