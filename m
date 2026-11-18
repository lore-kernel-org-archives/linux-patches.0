Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062110;
	b=zEmFFMM9yEkH5uRtPhp1l5wmQCHP1cdXthIbu8cvytfiyV8EkQwlzOjj4Me6nXT3+Bx6
	 HZZKyJN9z/YiUIyQb/fkdQt6+sdqML1sJeed6hmYXKZSqhSs1N0MX5GnfjN0I2/XSx29S
	 qgFzI1hwpUlXvo7VYCFuYHeZQ0gsURqZpGX/kz5wq7ITrj59Eu8rBEGrxUflyVBgRD+wM
	 nxMN+R8Y428FI/hp/wDQKTQOv9O8d82xC7pMglrembolbGx60oDXkblhFBQKz6WGLUTRJ
	 HR9ha4daJn9LsOT5H9ukvk7jVcV0cA0HyayFm4BZrIzP7j1HHuJ/AZxVypZvwlomp1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Ix3uvJaUC0t6HGZxOg0IvLG7V8ZHM4dIZhGvaZ88nM=;
	b=HQP3GCGTGpsczg+a2PtzIVj8SPLHBQ/1eTp+ICQZfSKZf6LPWLzUq799/3M7FTGmRD9P
	 JgtKwAw1GcE9pL2U5ZjsmtL1L1OYSIyKwuiaJkfYXpScs/veXW0XIhCWyqdIBq1KbPwup
	 AVS4lnQOqnHUaWY8a5X26D3fHSZjxPcrUlq9GzSxQhfPzPNj05yvGoPekAbRrSpf4vfAS
	 KB0XPgjtaJGB96nzwCty10BNzbEauW8ijrbNMAtmgPccJklmTIHqHu5CQmz3+Ok0Pbg67
	 OzFjcWMpxaXFj71H/xow2SLOJkjvCLqwdLEsZz4p6VqVk8/UFcdFPFtHX+mBDs5Ghjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPzSE5tP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80785606A32A;
	Thu, 19 Nov 2026 04:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPzSE5tP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79B61F000C4;
	Thu, 19 Nov 2026 04:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062110;
	bh=0Ix3uvJaUC0t6HGZxOg0IvLG7V8ZHM4dIZhGvaZ88nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPzSE5tPe7QPYpp0gptkpErF+eZ3fbTfy2IJMCQaZLLuIiAfWdyIk3bxGc8v/EPCs
	 mH0n+ufFOng5KEYA6o934D0AS8jyGut5AiMHo/EL9uFrSDyVjhoNlTPZk30v0Mwg5R
	 QriptdUt9fM/PF3F98Wq4H7ajrDikm1T9sfLPgDU=
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
Subject: [PATCH 5.10 1793/1848] perf mmap: Preserve the consumed cursor in forward mode
Date: Wed, 18 Nov 2026 16:03:51 +0100
Message-ID: <20261118150034.351969550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 79d5ed6c38cc5..4a49d31fd9ee5 100644
--- a/tools/lib/perf/mmap.c
+++ b/tools/lib/perf/mmap.c
@@ -191,7 +191,7 @@ void perf_mmap__read_done(struct perf_mmap *map)
 	/*
 	 * Check if event was unmapped due to a POLLHUP/POLLERR.
 	 */
-	if (!refcount_read(&map->refcnt))
+	if (!refcount_read(&map->refcnt) || !map->overwrite)
 		return;
 
 	map->prev = perf_mmap__read_head(map);
-- 
2.53.0



