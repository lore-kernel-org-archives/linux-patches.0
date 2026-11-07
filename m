Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064739;
	b=xqlWrM8tFkD9NGt2NuvTXEamBpaDkG5EFQJMdwU2COcxixEojJpQqDSNzX+UIKI5L7kL
	 zS2jwovQKLYUXCZK/0L0zJbDnBSpav8PZWp2bcxbsAXcf5LGvdhb+JvnKzl1AM90Q7xLy
	 FYnvFiM8lA2x6ZAmfW3gxdhq95RFbLCHKUCp1/0ZzMZL/REmsmMUfLpLLJINa0bFH+HKf
	 9nURj5Jt70UteuJWxnN2NSSk5hne5g/4rtXSDLluISxuhIsMMt5+GGv83gA0j2XnMGqOz
	 PX3pvqtSPJeXvP9n8utq9J0wcUJJKq9KEc7q7DrI9NMtpkoWDOPbsD1bzDWzE9e0y/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n6KgWXviOqxWrJ+Kf+wXtBfRrechNNbDLaeKYl3d7u8=;
	b=YOfbYMWSYDiYzXzr5huTL6oEE31PwAqIl6107d9wgL3b0SJmo3aD9W6Z4E5JybwfFvNe
	 znomKLjnw+10eF+asxl2IiNd7fsGbi6es+OGyopO4X1FqQfQOZgchF+T91QwRKOVBX8e5
	 B2w6KXrrPrc85gjmrmTb9PiWWHUvIvnJh4hCQmZZrh8/uch8C7JQ6DOd6bqfassxHw154
	 YfjzBjjL+6QNDWDcGAwW7U/GDPGUqulx8Cs9qiWx6qmuWknIZzB80WJLUDWopJdpPbMOw
	 iCiUbEOy4TS63QkhC/B243JSCWVbPSA069ntrzLqeIJqM1uBSmJYWkX/FJR4ICNANCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mJx5ojnw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FB8606A9C9;
	Sat,  7 Nov 2026 15:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mJx5ojnw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612C01F008A1;
	Sat,  7 Nov 2026 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064738;
	bh=n6KgWXviOqxWrJ+Kf+wXtBfRrechNNbDLaeKYl3d7u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJx5ojnwaCQXdQdddbizXwI/SQ6rHGVaf7cVqgYWQCDusQkD4cDiwzIf/80F+dB+b
	 S9Q3Vs3r7qNLYeFOfCfUgRwqjfuNdampCvofI4Fez9isD8/w19X7vCEyUfNbM3gusz
	 rALkT9tSpq8nJ5nz+iS16fsuLbpbjt4BX8NZxqZw=
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
Subject: [PATCH 7.3 0665/1257] mm/damon/core: charge only the part of a region the filter left
Date: Sat,  7 Nov 2026 08:49:21 -0500
Message-ID: <20261107134957.620039228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index a4542a49ff80a..4290e2a1c7e8d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2653,6 +2653,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
+		sz = damon_sz_region(r);
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r, nr_accesses,
 				damon_nr_regions(t), do_trace);
-- 
2.53.0



