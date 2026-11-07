Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063293;
	b=pAuwokW5iN5MTPml1QCO7CpIl7TLgOqLvtgZTscUkwkeZ7M7FmNYBKtSLC3b0MINuzEO
	 Myv/b+ISdh3JkMFLBfyVEMpLjvKk8yhYHC/aS+NWOKxU+VLnkcgdXAZsZ3bVH12jE9/q5
	 pSAaSZ0gHEqy/dgx7o/Ziq43BC07ABPVGf7Sh73UWXZ0oKTOvgk1Uv4EHNowGBHwDgxeE
	 bo5QcgO0mp/ew1Vm3wIou/9/v4ccIEYIpzCdqT+Z+UfCdYC4wO8zAYX9QFGfUc0AuIvqV
	 kZqVeAwdMQ7ZV84SQ3/1j1UW6IUu9i9KRFJ23Jm1XjuYoOLOJTqUcej94I2YkgPptZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j3OTmNY9O81Fy8n/w8yI7KXI/iGTndCu785T2czZ1GE=;
	b=Rrf5wM21+G74dANkkJS3YmhsaSv3zHa0wtteJ9UNQGQti8S4ffEQ4qBfXCebFmjsz5sC
	 Z9WxrsM2SibTeD2E2xO3igDlEsIZk9oLT81ZB7XoCzNw0uiAhZqWdJDJPczmzx9ab/gWo
	 8Ij5iZnjBlFA9KmaotUpAfafsXtxQ8ZqdqwawFiZ90KHyOQXPCBXOE3d2Raey/FnaLIR4
	 BQTSs2IGRslsYUQBbtTOQ0rYwMWbijA2agaGlZ14kTstJyWJ/sp2RGOTngM3PS3Ty3Oww
	 2hwCH9pzttJFFcGhT5mzBFsA4ZQW43EczePmJ/PrV1+kkKgUeFi7eRNPTb/jXIYxmZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bdjYKV7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2BC606D80C;
	Sat,  7 Nov 2026 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bdjYKV7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1FE1F008A2;
	Sat,  7 Nov 2026 14:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063293;
	bh=j3OTmNY9O81Fy8n/w8yI7KXI/iGTndCu785T2czZ1GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2bdjYKV75R75YIxweWL2kN2QSQzBeXtpY3mZjddfFgDBxn4F44ql2YuzOxVK0HdLP
	 zmto2pE4jY6w9oWvUUjCCJZSahLyCWwa0urRrYx6HHJsRx5zGwO2kZaZg/uWnCNO9i
	 W7QgkBJC6XiChxmSSFZUnBwTovL0etHcSYvsFHB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 486/869] mm/damon/core: charge only the part of a region the filter left
Date: Sat,  7 Nov 2026 08:52:48 -0500
Message-ID: <20261107134910.057768288@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 4ff3b4a54a32142497fb44b79d0920aa6ba3393d ]

Patch series "mm/damon/core: fix the size charged for a filter-trimmed
region", v2.

An address range DAMOS filter that partially overlaps a monitoring region
splits it, so the scheme action reaches only one side of the boundary.
damos_apply_scheme() reads the region size before that split and never
re-reads it, so the quota charge and schemes/<S>/stats/sz_tried account
for the whole original region.

Patch 1 re-reads the size after the core filters have run.  Patch 2 adds
KUnit coverage for what the function charges and reports, for the trimmed
cases and for the cases that must not change.

This patch (of 2):

An address range DAMOS filter that partially overlaps a monitoring region
splits the region at the filter boundary, so the scheme action is applied
to only one side of it.  damos_apply_scheme() reads the region size once
on entry, before damos_core_filter_out() performs that split.

The quota charge and the statistics update therefore account for the
region as it was before the trim.  schemes/<S>/stats/sz_tried counts
memory the filter excluded, which Documentation/mm/damon/design.rst says
is not counted as tried, and with quotas/bytes set the excluded part is
charged against the budget, throttling the scheme to a fraction of what
was configured.

User impact is that DAMOS could unexpectedly slowly run, due to
over-charged quota.  DAMOS stat could also be confusing.  No critical
events such as crashes or leask happen.

Re-read the region size after the core filters have run.

Link: https://lore.kernel.org/20260921152443.80132-1-sj@kernel.org
Link: https://lore.kernel.org/20260921152443.80132-2-sj@kernel.org
Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0bed1cd9e3a23..56f2343ffefac 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2004,6 +2004,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		}
 		if (damos_filter_out(c, t, r, s))
 			return;
+		sz = damon_sz_region(r);
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r,
 				damon_nr_regions(t), do_trace);
-- 
2.53.0



