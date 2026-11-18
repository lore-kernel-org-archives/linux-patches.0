Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050695;
	b=e3XRAE7UMpevA4R8jBgQHV1tbTOG3SDCL83lN3yvxB+5Kuulputw91uaz1O02TO5iYV2
	 FomRfif/eANSWBJvIKibwRZ7JsQZsR02CRXy+bRfT8Mnv9Z31KvXAnKQj1wbkoC8wXAGA
	 PAi/nd2FiMMxQyUL9zrGAn0Wfa+4AZxvn2k/YGkeJjiKOBpAIJaEvOvvwphM8pNRKGyP4
	 W1DWnYZNzLiO5niNG3De/m5JpHQyv4qOaFFb0ptKWQKk9ZVM8c4C/f450gLNo245tARel
	 emt93WK7B5Pw8B+bPFCSUXMkq+coLEsMumeei4VGaTX9aWoRd7KA/tEAn/TYKs68UlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dlEh2P3LOXDzsm12PFc6Pc/b8PV1WVgLn2sB7rjyKn8=;
	b=YTuYfOpENdKNYQgRGIhbUiuUtd6tbZc/WbjFsCnTHwgsFRhB/+VOoIGbdvGEBfmbDImT
	 02W+2l3gklDxXr8tI4tcXMqYhIIpKhc1mzoLLIvI6LaPtthNvvFq/QPLhG7pUcL0XL1lu
	 k4Vu5tQO6rmmoy3D3mcSjfRReA2ScvouipxwslBI6AQqcrGeedL9yDcIyANHczL3m267H
	 4tqNvzCD3jTYeEXWokFpABf+B84GIJx0uabzCPyvBFgBIduWFBoioc6vGu2xEh+c8tYK6
	 5YajOb8mmTsKf4d75MfP1QxFJBIYjsAhNVce5NzhvBrxgDFO7qI/e+ET6Rm+yFoUAQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V++1r6iH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC82606A332;
	Thu, 19 Nov 2026 01:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V++1r6iH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807341F000C5;
	Thu, 19 Nov 2026 01:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050695;
	bh=dlEh2P3LOXDzsm12PFc6Pc/b8PV1WVgLn2sB7rjyKn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V++1r6iHLXaowKAKcnQrXz31ULpMgVIfzuf2YanmV9RkzvklbDM2t/W53yCsWddl1
	 S+Off/PMwkpuBLixBAWPB7RqdzyuFI3NH7IYWMOtUimJ2sAOhPS5E9ugG1eRd1N031
	 DUf7XY/7WKvz8fVrzcfsJPQ/Q1RtrpDK/9X+jAPE=
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
Subject: [PATCH 6.1 2758/2857] perf mmap: Preserve the consumed cursor in forward mode
Date: Wed, 18 Nov 2026 16:03:12 +0100
Message-ID: <20261118150340.910229069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0d1634cedf44e..fde7cb403f697 100644
--- a/tools/lib/perf/mmap.c
+++ b/tools/lib/perf/mmap.c
@@ -194,7 +194,7 @@ void perf_mmap__read_done(struct perf_mmap *map)
 	/*
 	 * Check if event was unmapped due to a POLLHUP/POLLERR.
 	 */
-	if (!refcount_read(&map->refcnt))
+	if (!refcount_read(&map->refcnt) || !map->overwrite)
 		return;
 
 	map->prev = perf_mmap__read_head(map);
-- 
2.53.0



