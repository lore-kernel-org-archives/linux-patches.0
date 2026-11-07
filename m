Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064496;
	b=jJcrHmxHpeNUTBXqpFXr1x0I7i+ouDgcArlfUTYYFT+ybvIZcKfA9+rtpRgADA2kFiSs
	 RsVBToIjc1wNxtyJI448UGZ3bc/2H1u5gjBfViRiOV+Zec0XrqXdGflzECykzjL5GMibF
	 t7JazoIQtASjF5KiTMVWBeKaPzqem5osGK50Ug8rA2yUrfOS3FpdOTAr0qFMnggncQXoJ
	 pXlAdicB8opfJ2OL9MjmhrgRw1WW9kW/RErh7c3K4yMCFmtM+bGMQ2BN1bMXt6IeamFjZ
	 1BftSWqVbQ6kUuQngaIoVuRUQXLka9eAR4cH4+aDP5qwIOM7Stq87CzwJEKqyac3bUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tw+BCoNBCGQ7vCsUUrgPkWHUbQT9EKBZKTOfTXpTpbA=;
	b=NTWqDjRNs6Qe/3M6CmrEspk0N6QDYivnnVnL2UBjTWdrOtS9dI4USdvIrhi0b2IUjpcx
	 MGZynL0sNDhZdobMBqUzvLowRjIEgeTJksu67s3hscYlGZjUygwJ+q7cWnc5+y8dwFvFm
	 z3NimDAeW4N5HJZKXvkXfnFkarhBnxOlWDkwy1VGpHxh2Gki3RZOL4eRDrqzEh/pdpsEI
	 MocK9JlmgMVOONdQFTZRmllRf3WWDrD0G55F+sVJ6cXNXduLhvxNTdWU+Gd+Cpcqo3+kS
	 3g4jqTecszEGnC/q2hWrsvr1wAR5JiUD4Nqu5gx5AEVT20Y+FV0hhyKTlSmaKU01/4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wiJO99qs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83967606A336;
	Sat,  7 Nov 2026 15:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wiJO99qs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323EA1F008A1;
	Sat,  7 Nov 2026 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064496;
	bh=Tw+BCoNBCGQ7vCsUUrgPkWHUbQT9EKBZKTOfTXpTpbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wiJO99qsRVte9/ayHbP+c6aWAWlACzhk10s5mMqEN0euzBRj+DNtZU5i7Ypq8dU/r
	 +aALqEPaCW5s9wDzQ4Srxz1uuzEHEs217tsoKt2w/4yMCn7XzvE6eAFqJ1yq4CNWiI
	 YDUDV1agYebzXh+6awVrxAYVLGvD1DDWr/ICR32M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0504/1257] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  7 Nov 2026 08:46:40 -0500
Message-ID: <20261107134953.347816794@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 90c2fa6adfed7abe0935506a43cdff3a05c1fff0 ]

Patch series "mm/damon: fix DAMOS bugs in core, paddr and vaddr".

Fix misc bugs of DAMOS.  Patch 1 makes DAMOS less stress memory allocator
under extreme situation.  Patches 2 and 3 fix wrong folios walking in
DAMON_PADDR.  Patches 4 and 5 fix wrong folios walking in DAMON_VADDR.
Patches 6-8 handle extreme and unlikely memory situations that can cause
divide by zero and underflow.

All bugs are discovered by Sashiko.

This patch (of 8):

damos_apply_scheme() splits a region and apply the action to the subregion
if it is needed for not violating the quota.  The split operation
(damon_split_region_at()) could fail for allocation failure.  In the case,
the quota could be violated.  From the user's perspective, DAMOS becomes
more aggressive than expected under the extreme situation.  Handle the
failure.

The user impact is not critical.  The failure of damon_split_region_at()
is unlikely since it is arguably too small to fail.  Also DAMOS being
aggressive is limited to the single region.  Users can set min_nr_regions
to set the maximum size of each region.  If it is reasonably set, the
transient overhead shouldn't be critical.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 74d22a596fc13..b3390978581a6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2626,7 +2626,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
-- 
2.53.0



