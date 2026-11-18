Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046070;
	b=vvZub81s9kbMU4i9d2YsY06rpwFKuOqt3IlH67Fir7h0kateShRRTAG+SojWS9DOABiq
	 Jj+iEjd/OSaywKW3zB0Rfe+BDTIM37yPIKHSKVuZHkREZONtV41drbUnssWuzvO+wvJ2D
	 o5DheaMg43z1bDEkgSt9qDt8E9yduPHZ2SK/bjwsBJDyo+QOSlULRI+beKzq2iX2qVpjW
	 FIm/3C96ON8qS0HSrxg1fNmVOaCyeXDWl1j8NnJMFHTc2JqKyjrgXr7R5m1wP+kMUvXJo
	 0CeLU7mp712EiqmaFKQDCMp9g8HRrQ4a0Hb02oMJGi0KcdQ0Eu8yC5VBLSmq9lRnghA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kNNOyBb0+I6R2+wLHmvXk13XE2vWLCrfN6i88p8KMGQ=;
	b=ZbDk0ysGG2LYnVG/h+kyYSyWjlRa+FrxbrxOzNO19a1UV/HjzuQJ7sKnJ8XaqajVMoJ9
	 PcbtAzXreSc50TAAHyiT45vwWAIuE4TaG0PTYCbMIj05mbiZBi4C9heUa5fQFk0mAL14O
	 ufAsoPR/souQDs7yBqwjgXV/mYLEy9+CNHP3Q0delFLe0C4BpikS3MnMfaq+w1EN5vxqo
	 WqNyauuy6oB9lUMcAk+F+mCE3lLhtk9+1E9VrxnRKnGKunTKNkD/0YCq0x3wcJGc2mmHl
	 bdqv0VP2oP7vyElvFps9b4jRdmUxujD9nD6cJbmcHxKMQZFFY5Kq5u24mcCArbArM2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B6kY7s7a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7607C606A31C;
	Wed, 18 Nov 2026 23:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B6kY7s7a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47BA1F000C4;
	Wed, 18 Nov 2026 23:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046070;
	bh=kNNOyBb0+I6R2+wLHmvXk13XE2vWLCrfN6i88p8KMGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6kY7s7ahOzfS4OWkI2dkEXtfoZ/Z08gy7npzKpN0DR6IhmXUohyev8kfbqlvr8U2
	 /zaY4CWIezPGjkIDbfmjXBO83QBJE35aS8CQ8vnBK2w8/yAcJm9fMGu3BXwY7ac2oe
	 yKWTDMy+gtPiZIemTJRW/4nEP2V/9BathBLb2n0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1149/2857] mm/damon/core: skip applying scheme if region split for quota fails
Date: Wed, 18 Nov 2026 15:36:23 +0100
Message-ID: <20261118150242.954147922@linuxfoundation.org>
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

6.1.y porting notes.  Modify damon_split_region_at() to return failures.
It is a part of commit c60874860762 ("mm/damon/core: handle region split
failure in apply_min_nr_regions()").  Without it, build fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f0da5cb2b88a0..9206737d05ae7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -718,7 +718,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 	}
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
@@ -810,7 +810,8 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 						DAMON_MIN_REGION);
 				if (!sz)
 					goto update_stat;
-				damon_split_region_at(t, r, sz);
+				if (damon_split_region_at(t, r, sz))
+					goto update_stat;
 			}
 			ktime_get_coarse_ts64(&begin);
 			sz_applied = c->ops.apply_scheme(c, t, r, s);
@@ -1015,15 +1016,17 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
  *
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
+ *
+ * Return: 0 on success, negative error code otherwise.
  */
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
 
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
-		return;
+		return -ENOMEM;
 
 	r->ar.end = new->ar.start;
 
@@ -1031,6 +1034,7 @@ static void damon_split_region_at(struct damon_target *t,
 	new->last_nr_accesses = r->last_nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-- 
2.53.0



