Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585655;
	b=gB1+0E7P5MI0xUkCh8UdrXwtbVlWP/DeGNz8JQxJkLu1BR/uK0sqX6OGqCrS/mTz1yCn
	 Zlpp/edE20XMnmpdbbqk0UpkIQIqV6rLot2eXS7OUgFNLRmBwi9OCXZGg/YI7SKjDg70g
	 B7VR/8C+1Rkeu8/400Q2kYIjUsWR1k7tApchI4WvcCT9MaJSO3R0Gbtjp86S9Mj0suZDk
	 iyPSYnjNm5gRyOox3xE+tXu065DbOaVSSj3poiuxkwnTFSUE3tAuakMrUfqEf++zdHoZk
	 94mSFV0PUNVWRo0ojjXXRVkatoRY5qxxe8aJal+R/5C++dMzS1BoW0DowhZTLoDGNAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZa3o7twmPTIcDFVPyTz48KCFoHW/R8NMRDMVLSDZ7Q=;
	b=sFSMb++iyEYnlGHtaTVx5Al0VXAH+s/ZWhV5IltmbTbI/om/uzv81MB9Zs5CiBzNxjMS
	 4c4yYHd/ZlJ3SLf0k+W0BgW1kCYsP3xmqCr9x0WMxDpczE+SYqrrar8uQJD/3p0bLzpLY
	 i0e9u9NqcNfoGiuffYFA/x8KocXygc72f//emKOk+XYXBjDz8buDsfh62Ebw/6K/0tvrO
	 DV80r4E6Ca0f1h8lFAeNLEHe9+5E+wCgYVPvuQVuLxXnqafqz2ki5h+qimZD2/l+SGKJT
	 mv7fElAYPPFbV4UxzO+9o4u3Bnciei4kOLgRKFayN3UGOC+slgCwaEHgQ0qwULho4ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOK2F0rn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D0D606B5E9;
	Fri, 13 Nov 2026 16:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOK2F0rn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4109C1F000C4;
	Fri, 13 Nov 2026 16:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585655;
	bh=eZa3o7twmPTIcDFVPyTz48KCFoHW/R8NMRDMVLSDZ7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOK2F0rnaXRMLEn5rzNn6e5UUj41fHl4/YVbRn+voYqHtie3zgpXfM2j6bWtJXT0r
	 34/ckU2ZVZeEgRW0ttwPsmtaLkQWON80gaiVKZuIMrAMduQRLbKqt+eFAdzeDYqhhQ
	 UZEf1jta/zGQTlM1QVSCwA+rI30zjxJuisfTFswU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 234/507] mm/damon/core: move static variable rotation to damon_ctx
Date: Fri, 13 Nov 2026 10:48:58 -0500
Message-ID: <20261113153802.425618450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

[ Upstream commit c4ff3ea30640b394df4156d7ddf60ad8ffe765f1 ]

damon_split_some_reigons() uses a static variable, rotation, to remember
how many times it was called.  It is again used to determine fair
selection of regions to split.  Since it is a static variable, it can be
indeterministic and therefore less fair.

The user impact is not critical.  No crash, no leak.  DAMON's
best-effort and indeterministic monitoring accuracy could be slightly
more indeterministic when multiple kdamonds are used in parallel.

Fix the problem by moving the static variable into the damon_ctx struct.

Link: https://lore.kernel.org/20261025164808.152048-4-sj@kernel.org
Fixes: 1a582e6e0174 ("mm/damon/core: split a fraction of regions when nr_regions exceeds max/2")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-eebfcdde-2881-48ef-8df1-e2019d2a47f2
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: <stable@vger.kernel.org> # 7.3.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/damon.h | 5 +++++
 mm/damon/core.c       | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index c6de3ac2f4453..9772309b2b587 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -919,6 +919,11 @@ struct damon_ctx {
 	 * for more details.
 	 */
 	unsigned long last_nr_regions;
+	/*
+	 * number of damon_split_some_regions() invocations for this context.
+	 * Read damon_split_some_regions() for more details.
+	 */
+	unsigned long region_split_rotation;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6db6d2a80e812..85bcb6da9ad0b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3568,12 +3568,13 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 static void damon_split_some_regions(struct damon_ctx *ctx,
 				     unsigned long split_step)
 {
-	static unsigned long rotation;
 	struct damon_target *t;
 	struct damon_region *r, *next;
-	unsigned long offset = rotation++ % split_step;
+	unsigned long offset;
 	unsigned long idx = 0;
 
+	offset = ctx->region_split_rotation++ % split_step;
+
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			unsigned long sz_region, sz_sub;
-- 
2.53.0



