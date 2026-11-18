Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020689;
	b=IARQ28NsJDmgHFt+5jOxj/RacxgyxEV4nvFogELvi9RhWPmNl1/sIOZUXLW3APGhKk3D
	 HSXbtirE5xozFpeqMJ66Ql9yJjMKYMTAbt1NMyEYMp7qPkqNemo0PHb3hW6X0br40Aalb
	 7rzLgb61Z27W21jTXXvO2GM6b1u9UxpVYsFB5Hl2VLks/1fRIrT/vmDAiLPdVgKTN1sQB
	 wxR5fYiP3UG6J/MC7zY+FHuSvnW/Dnl58OH5YheqGn+S4PtSeF4a1Q4cGghHO0a4ChRD3
	 /7E9//DEXheJ4nZGTOsMGWdwpMw70tfjPmkrf3PMinf3xpYcKV1K+UJxsIIJPkZskhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l6LwVULxkd5eh50lFKic74hW1aIyDKqdxc//AcX621g=;
	b=eKBOMnOwaBrW51yOKFR06f36pOr0enjliOEeiJySY56vgLeD7heBaescMcCgMlMTCkp8
	 8JWam9YUzJmTog4YapXluDlESiqnB2xqatC566dViocuihKq7WNNxE0VwAvECcfhLwb1A
	 7F0jHqeuB+rybimMaHcCfNV6MsEzKLcXdwd0GmN5il99ANwNg1AozOn6fwu/eUwWqBKGc
	 h7Fx+u02vpoT9pa+SQ1UJ4IvEjlXByoGUNaRSkT8vkQ8pBAFgdHjeL3zv2a2QjZwpor1W
	 /ij5tZ/xVRN0PzqiK3niSKA0YUkCuRICKjYSQ4Tit46k1rfWhFj7cviolmMApJjXEhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OEebB9c2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF1460A260F;
	Wed, 18 Nov 2026 16:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OEebB9c2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC64C1F000C8;
	Wed, 18 Nov 2026 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020689;
	bh=l6LwVULxkd5eh50lFKic74hW1aIyDKqdxc//AcX621g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OEebB9c2Fpc6ZxWVS6UUc7OfDhIaMxleh77Phk0jdOaNeaQDR4kDxeyZCohBQ2XHB
	 6xrdAbtJRlHRNIkGtii0cJd1Qfgl8/RA1Sl5c/U7qroRWvfD7zBrPvM98NdbQd9awC
	 lTLyVQw5tu6NlMfcjGKhwnklY8GbJ1CFQYNWA/+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2040/2651] drm/panthor: Dont invalidate OTHER caches
Date: Wed, 18 Nov 2026 15:54:40 +0100
Message-ID: <20261118150359.540619834@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit b1bbfb6c0245cd35ad197d290e26ee1cdee467ff ]

Don't invalidate the OTHER caches (AKA L1 read-only caches) since
this seems to trip out the flush-elimination logic on v13, and it's not
needed in practice (can't leak other context data because of TLB
invalidation or corrupt physical pages returned to the system because
it's a RO cache).

It's also worth noting that the downstream driver has been avoid
OTHER caches invalidation from the start, and that we were doing
the same until atomic page table update was introduced.

Fixes: 6e2d3b3e8589 ("drm/panthor: Add support for atomic page table updates")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
[Update comment as suggested by sashiko]
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260924-panthor-mmu-fixes-v1-1-e25f9b106466@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 9f63a048df61c..41ae159aeb7dd 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -634,7 +634,7 @@ static int panthor_mmu_as_disable(struct panthor_device *ptdev, u32 as_nr,
 
 	/* Flush+invalidate RW caches, invalidate RO ones. */
 	ret = panthor_gpu_flush_caches(ptdev, CACHE_CLEAN | CACHE_INV,
-				       CACHE_CLEAN | CACHE_INV, CACHE_INV);
+				       CACHE_CLEAN | CACHE_INV, 0);
 	if (ret)
 		return ret;
 
@@ -1836,13 +1836,12 @@ static void panthor_vm_unlock_region(struct panthor_vm *vm)
 	if (vm->as.id >= 0) {
 		int ret;
 
-		/* flush+invalidate RW caches and invalidate RO ones.
+		/* flush+invalidate RW caches.
 		 * TODO: See if we can use FLUSH_PA_RANGE when the physical
 		 * range is narrow enough and the HW supports it.
 		 */
 		ret = panthor_gpu_flush_caches(ptdev, CACHE_CLEAN | CACHE_INV,
-					       CACHE_CLEAN | CACHE_INV,
-					       CACHE_INV);
+					       CACHE_CLEAN | CACHE_INV, 0);
 
 		/* Unlock the region if the flush is effective. */
 		if (!ret)
-- 
2.53.0



