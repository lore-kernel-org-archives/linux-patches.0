Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021707;
	b=SOPtXUDuD95CIpQ3HQXVfLc1xCdONwWMmupHO++32wZmV2elxfLN6ICrShrXduQ0rZq2
	 kn3ABaSlcTXek29Ma8YNkqSf457pCLoirXNqHQySv4xQNPmcZ0yU2yJCQ0gqYezZztaJK
	 LfcfIgW/1RF/tYg5oTWFshWYf6GIQnPEKr2MKS19pJ9BSi4gWATZ5woq9QN0bRBUjl1Z5
	 kkDX3fxUzioENm83p8zNNNwhcomlOdHpcHlhO+cbHlLWtNZHvdYcVBp90tztQq1JDfU0b
	 Kd43omeCcMh0Y/CDCQ4ASpguIjGGa7NDoRZ8tST0tJlozfNjucyOp4atpYK6qBTPlDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BZcscJPOK3iHN2Q9K4jua7O7sHbI+KWOs85FloIwIrw=;
	b=HCwGLa5sFdbWX/u5ao5PIIJPwnloRP4fb4ANCFLFvFlC1tK0xJIyrHAbGTwmgCvsgbra
	 eUitgUcfuhdnqR4zGeUcUPxMO9sv3WoCNIB/JxupPU2VmWjKiOZLkN1S/DAKI9+xtLBWi
	 y79nwTlpkvOV7yabbOVCIwfBQPaCtYa3pQmRrwdOLz2GWzyJSPLj0b47X21j9goCwPVFZ
	 wqJIwSLxcOLyo9KxkAVZPpjeOxAhgmoU7x6b+xsG6eJ4iOAP3ToH2lUDugp1dyjCIhSYE
	 t123E6Qev3wn5RcBYC5J8wLFr9guAk61ACID40DKi88ns13dm0wkriU831ot89U7uFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQyoGjbO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C331606A31C;
	Wed, 18 Nov 2026 17:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQyoGjbO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC25D1F000C4;
	Wed, 18 Nov 2026 17:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021707;
	bh=BZcscJPOK3iHN2Q9K4jua7O7sHbI+KWOs85FloIwIrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQyoGjbOYLEDd1WpGyorKFctDEe0YNt9Qkv9UT0xKrtFTNxHvnM/EoC34PdFgwEMN
	 53KkILBjDuAd5p54olug8vSK4DjwwsnMWuFFsrhVKFL6VVFe2DJCnkirYjdC6exSgX
	 sVXQiKUmU9wN+6sEDO1yCirqOiJ5xI3cBekjMBMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2401/2651] tools/testing/shared: catch a failed posix_memalign()
Date: Wed, 18 Nov 2026 16:00:41 +0100
Message-ID: <20261118150411.789298070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Liam R. Howlett (Google) <liam@infradead.org>

[ Upstream commit c9ed13789061af00d9239f9fab8e246adbed2076 ]

posix_memalign() returns zero or a positive error number and never sets
errno, so the checks for a negative return in kmem_cache_alloc_lru() and
kmem_cache_alloc_bulk() is not possible.  A failed aligned allocation
carries on with the pointer unset, into the constructor or the memset().

Test for any non-zero return.

Link: https://lore.kernel.org/20261020033128.1934349-1-liam@infradead.org
Fixes: 8801c35c3672 ("tools: fix -Wunused-result in linux.c")
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/shared/linux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index e0a0693df08f5..a37d2f86d3254 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -83,7 +83,7 @@ void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
 	} else {
 		pthread_mutex_unlock(&cachep->lock);
 		if (cachep->align) {
-			if (posix_memalign(&p, cachep->align, cachep->size) < 0)
+			if (posix_memalign(&p, cachep->align, cachep->size))
 				return NULL;
 		} else {
 			p = malloc(cachep->size);
@@ -191,7 +191,7 @@ bool kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 
 			if (cachep->align) {
 				if (posix_memalign(&p[i], cachep->align,
-					       cachep->size) < 0)
+					       cachep->size))
 					break;
 			} else {
 				p[i] = malloc(cachep->size);
-- 
2.53.0



