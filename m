Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021903;
	b=qqqWLG8HBi4GpfzJpL0r0fDAtrqTL27McPPHNV/2rdoKFsVYCLXo2u9m1nKQ7ABQEBTB
	 eyRsF9IDq42ld5A74DI0IHn5GYiT6OGK7L9RIfgnJFvKG/0pt5yo3st7hxNm6FQM/2Je/
	 WuBNzXHyS96wscmIKQRcq8vreN6NALvBu90vz9qKKIKKMShMPlbcsiQ6WHIu/RNXGUprW
	 UdScuJ9xF4+6614plSi3VlP4WaZD2PhkfLJ7IdGf0HmeShS/drjhKfiubRBsFqwH0gZIi
	 mRdzmZUU0sjBdICedM7LIBExr4hGSfDubPR8HILIxdDEdeaIUw2pjVDtm1shgCCPq9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+kCKtQI42IbFgYAx+owLp4+iIntH2x7IizL8esg5Y0s=;
	b=vkO6KrAmGPSWWm962Cybr+DRdBsZ27ymxrPmK0R/ra5nONEg/G2/OnjQwZobacuqyXm2
	 QauodS+v/9pUmL5NyaHPCHv0r9ESWhKdT6c4uXKLQvcWI7rYNKOhzaNR6e9WXPqcO4CCj
	 LUJRyulM2qW9HvZQ1XqmuhisWp1+vVK2Iw6GEUoag0km6+2EKniJwvoI6JnKz+LgI6iDr
	 XdoEmd2a1/9p307fL8XNYwPJgixBfdlaFkrGxjGYlmTa3HV7CWVCaQtmX8NHU3/J0NHBV
	 8xx7b/dgChsS2DvwbWm9Bvkir0+DP3eDv4DjBkHlOjbrNYw5WXFgB16mqIagSS7vGFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWKX6G8n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCBE60A2603;
	Wed, 18 Nov 2026 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWKX6G8n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F84D1F000C5;
	Wed, 18 Nov 2026 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021902;
	bh=+kCKtQI42IbFgYAx+owLp4+iIntH2x7IizL8esg5Y0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWKX6G8nPVkf5k4aZ6XWQ7ElDfplhhNn4It4unwFdzzDD1W4/h4U/Hq+xrYphv21c
	 DddEL7345m5FVCuosLo9SGrHVs1lyWT/LHP8IxBypggMVvjF/Y7HjIPLcApjDEm6Ft
	 bEDi9euruI1/HUZ5dzylQ35xC7KkgVw9XO542vP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2472/2651] net: xps: bound the cleanup loop by the old maps num_tc
Date: Wed, 18 Nov 2026 16:01:52 +0100
Message-ID: <20261118150413.976098854@linuxfoundation.org>
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

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 6d5a2cb0b7d6caf170d37ae7ac74738d592d2a05 ]

__netif_set_xps_queue() walks the OLD dev_maps to free its entries.  The
per-row trip count uses the NEW num_tc while the row stride uses the OLD
dev_maps->num_tc, so when dev->num_tc was raised without rebuilding the
XPS map the last row indexes attr_map[] past the allocation:

  BUG: KASAN: slab-out-of-bounds in __netif_set_xps_queue+0x1458/0x1ee8
  Read of size 8 at addr ffff000014f69458 by task insmod/112

The loop frees entries in dev_maps, so both the trip count and the stride
must come from dev_maps->num_tc.  The map is sized
XPS_CPU_DEV_MAPS_SIZE(old num_tc)/XPS_RXQ_DEV_MAPS_SIZE(old num_tc, ...),
so iterating the new (larger) num_tc reads past the end.

Fixes: 255c04a87f43 ("net: embed num_tc in the xps maps")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20261021155538.67867-1-phx0fer@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2d033b45a3f00..94570c9601b79 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3003,7 +3003,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_old_maps;
 
 	for (j = 0; j < dev_maps->nr_ids; j++) {
-		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
+		for (i = dev_maps->num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			if (!map)
 				continue;
-- 
2.53.0



