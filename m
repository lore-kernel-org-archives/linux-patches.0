Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063757;
	b=Vm7kZu54JWAE5EkiC3nj5/t2FU0BZWZtXeavfj8GoHcXPEkx+1Z1VBtqHeDqZhcGep7g
	 Gc+R33FoBxMM17b2I71M6Tze5OM8Qhm7kr3g5yUahfwM+lRfQMeO0nayOoTnKoC14EbDb
	 TV5fyQWxCfGis+sUk02YGl+PwEA45CtUxYRClr6szA30Mg1RFhwr62QI1fBLP5DT7n9yp
	 eg4gEQS/6dEADvxeXSDSSXKMKQu4mCaccsUlPbSnhnNVFah6PKiL8nps1i4zXH65IWCXJ
	 CN1OfMBQViMBCsFAgGiqvwK+vIkmHWghmFfsGEZlMWSrPxZs9AXUBRrZmVGNG+2MDPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G0vr4mYHswj4TuPjykFdMaCvld+goqcXHvkDqvlbNM0=;
	b=fp0xog+5rYN0mO8bK7Q/2K7JlmS8T1hSU8cpchlJVV0JXG6Gn6pxrJBSkMpMEf/S4KKS
	 udOw0dVFuGKQTql8G4+xBnSKzdiZ9T44WkWCj1chOeXXZVnFcjcd5X4pSemgpGfQOGGnz
	 AyXxPGsglLfnms7RVz1OKb8h8D0Ll2hD6xPdjrkaD7BtlN4hF1drxeKizphJzFphJ0RXu
	 io1kcXVRJMi5r8UtuRSzd9uC8KrtNKUdMzyjV3vvAvD7OfNzTVZMge9yMiWvwxGcqOosM
	 xhyPpD6o8gKC+b5zyNx92LewdtTbMrMN9ydOoZfOMUis2mTfbiNKmrZDfHgjnuYDs8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzGHp+vh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5A2608362E;
	Sat,  7 Nov 2026 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzGHp+vh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F6C1F008A3;
	Sat,  7 Nov 2026 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063757;
	bh=G0vr4mYHswj4TuPjykFdMaCvld+goqcXHvkDqvlbNM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzGHp+vhLJobtDqSEfOEuKRNucrgg6cn0PyncDYC9vCVMmAhEOF9a38GOsUFxorHt
	 guykX5qCe9glaNn5z0uPjZ6C/NPcijni0lofKH+HKSkw/7ufZNdOzn4JM6dWZivWDR
	 6ejY95kc4pO4STynaDRnQx3qsnFPMN6GQjUTUfw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	lvyating <lv.yating@zte.com.cn>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Dai Hualiang <dai.hualiang@zte.com.cn>,
	he.yilin@zte.com.cn,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Qingtao Liu <liu.qingtao2@zte.com.cn>,
	Shen Lin <shen.lin1@zte.com.cn>,
	ye.zhihao1@zte.com.cn,
	zhang.cheng35@zte.com.cn,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 812/869] perf machine: Fix NULL deref in thread__resolve_callchain_sample()
Date: Sat,  7 Nov 2026 08:58:14 -0500
Message-ID: <20261107134920.562121015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: lvyating <lv.yating@zte.com.cn>

[ Upstream commit 4626d370ae89b8af4d46a45372b269f926ec662d ]

When recording with -j stack, resolve_lbr_callchain_sample() can
dereference a NULL 'chain' pointer while resolving the branch
stack.

$ perf record -j stack -e branches:u uname
perf: Segmentation fault

Fix it by checking 'chain' for NULL before dereferencing it.

Fixes: 29be60c93d2d9300 ("perf build-id: Mark DSO in sample callchains")
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>
Signed-off-by: lvyating <lv.yating@zte.com.cn>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Dai Hualiang <dai.hualiang@zte.com.cn>
Cc: he.yilin@zte.com.cn
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qingtao Liu <liu.qingtao2@zte.com.cn>
Cc: Shen Lin <shen.lin1@zte.com.cn>
Cc: stable@vger.kernel.org
Cc: ye.zhihao1@zte.com.cn
Cc: zhang.cheng35@zte.com.cn
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index cb138d1bdd7b9..8452d776d994a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2743,7 +2743,7 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 	if (chain)
 		chain_nr = chain->nr;
 
-	if (evsel__has_branch_callstack(evsel)) {
+	if (chain && evsel__has_branch_callstack(evsel)) {
 		struct perf_env *env = evsel__env(evsel);
 
 		err = resolve_lbr_callchain_sample(thread, cursor, sample, parent,
-- 
2.53.0



