Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056880;
	b=l4b52phPLKfEsO+vovC9TYf4ZYj6/9FPi87mAoWFhP6PhZibI59Fgl8riUabj3SuZGm2
	 ciQgOVhSe4Gp1HLN1hIezRQAgMKCyBa4VHhtfkbpH1EASLm7DAFGKGub0EhyR62SLaN/g
	 TQQSkx7H+ylk8CyBCn+BSeQwrgCR5SSIhBXTR0KhY36Fb0Qs6oxvmAn1qPAkkfs1ZYRsi
	 1ktDBrxtrgrCkNRKEyajemjiAGZSRJqIMbVCuoiQ95e8UKijXJcAFh7yeDCrdNoC0eArZ
	 R/llFRnYg2znLDQnLcJC/fkhrXZhIeEZ9kPw59v/7NSevPv2/bzs4VT90bhKXFmIcgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wgR6TXDryZziJ7kF7XyOw0okTQWr097GLS7kxUxEAfk=;
	b=b+U9czF4mPuwiq4XwPmfEBW66xDZKTcJAuURlc7rw65buwgEkh5Z4eakoWJHJZrHn1hj
	 5oY2WyeCHWVnFW0rXhPiumQ3liBWMGnclxA/T4pGmQqooLpBsN/zbEND3YvuVbDmDoIxj
	 tQYTolvLdQM5AjU9NOIOHAAj46WQBKEB8R7ktAo3x6IG1aPPY+c2WCS5dORghyCIMF+Pr
	 izATbeVNsku4VhJy3JtWvRcet/gr7QxtQUeUte1d+E+d7ZpkNYteJO1Yb9SSKjDi3v44x
	 T6gVERlV6NYVhKovYlxQqicfORdX9kHW16v8+pMsxn/XR5i1TVukqqo/JC4d1R9eNkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NkHnZZ2B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00243606A320;
	Thu, 19 Nov 2026 02:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NkHnZZ2B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539FB1F000C4;
	Thu, 19 Nov 2026 02:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056879;
	bh=wgR6TXDryZziJ7kF7XyOw0okTQWr097GLS7kxUxEAfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkHnZZ2BnVYokjzcOEGCUSVZhW1ZCJ3W408u/M3E/tgz0rbppETFWhU2595ohkbkj
	 tOoNXpJyGLsG2Uvc0f90s2/l31pBPzU6E0rXCx/5eLW/ehEO7Ek8HDyp/2EgiqBl4t
	 o8VqeXAQQf4hWD8RLyuFhezakqMq/BsfWyFYSY24=
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
Subject: [PATCH 5.15 2145/2214] perf mmap: Preserve the consumed cursor in forward mode
Date: Wed, 18 Nov 2026 16:03:41 +0100
Message-ID: <20261118150136.288523210@linuxfoundation.org>
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
index c89dfa5f67b3a..2aaf3d7d1e501 100644
--- a/tools/lib/perf/mmap.c
+++ b/tools/lib/perf/mmap.c
@@ -193,7 +193,7 @@ void perf_mmap__read_done(struct perf_mmap *map)
 	/*
 	 * Check if event was unmapped due to a POLLHUP/POLLERR.
 	 */
-	if (!refcount_read(&map->refcnt))
+	if (!refcount_read(&map->refcnt) || !map->overwrite)
 		return;
 
 	map->prev = perf_mmap__read_head(map);
-- 
2.53.0



