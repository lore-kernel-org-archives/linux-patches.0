Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215575;
	b=SCz2Px8ndAOZ2iiHP5X+0wukVC9VDl8VRTnJ4zAUuQfswmEaDiFwlgPkT4YZR9Cbq3S7
	 9A+bag8zIKVsE0D/LOGWOk47mAe1GWfYKhW8EHBcGoe5fTcU7RmOHSJD855ogSa8+W5PC
	 XLT1PMRUAz2MlCXuXcrCuhkGsWwo27mMGNbghDNLfL4nhFmN37DpWpFah6DdPkEgXteTQ
	 JYmBb1il75ioBbm/9OEiq2bPurzVRhLguXRYBYsHhAxwP10E7xeqKRZPStK2UW/afYrRm
	 5TlrCUO5y06OiviRJQNJztkh6zs2C4msjec71JWtLv6aduaQNXtVT3qfkIihtbah2BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AFNWGPyRq7kTNKi+QH2cWYMidQ1kEWByTrf4UFKqtLQ=;
	b=lppSymT77wv99FLVgVk2xXHAR5ImKRG8nEzamKojDmRaAoh7K7wSHXifM/BLOBYBC7xP
	 N20r0LosJRX0GyIiV8OMJ28VpPYWcvpu/Y2fvYfqbfCAoRwPuVLwhBABUIsms6CYvRVH7
	 w3rpnc9Zkq8Vu5+Hk1ceuiTMPZ822I8f6i2oq5uaMtl4niua+HP7UMEJ2RPMnQYGjedTc
	 tL8NlHFbVvF5K6yCmchYxH4Tvlu97l6Nf+YySPJ9goXPau7VSCLL6gFdYjgbyOpFbiIAm
	 TUBA68tiVjIpPlg7Zhy8bJaKma1oyMQg3kC83PHXVi4qRPYAovWRMUmn2gJNB4tJxcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGpXutPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60314606A31A;
	Wed, 28 Oct 2026 19:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGpXutPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B201F01825;
	Wed, 28 Oct 2026 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215575;
	bh=AFNWGPyRq7kTNKi+QH2cWYMidQ1kEWByTrf4UFKqtLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGpXutPEeoUjnTSjKUVbsCJesJae2/vI/9IGXIdB7UnoYrTUyXASn2UHkzkqQcYXi
	 kI2YMTFzxXgzyPi2CnjUg/EbKA5kuou2ADNWqYjB5M81aOg1JHmLvqNM8RTpz8lVaS
	 CJWClPD3nZzUlKyPxfjpONMyvfoSoEYZrVomezE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Simon Horman <horms@kernel.org>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1257/1887] ixgbe: do not configure xps for XDP queues
Date: Wed, 28 Oct 2026 17:55:53 +0100
Message-ID: <20261028170528.032086947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 7bd4355272de34c2e90e34b72c5613736d03c32b ]

netif_set_xps_queue() should not be called for an XDP Tx queue, since such
queues are not netdev-exposed. On systems with number of CPUs >=64, on E610
adapter, netdev is configured with maximum number queue pairs being 63
(due to MSI-X assignment), but configuring XDP results in 64 XDP queues.

So, during XDP program load, when netif_set_xps_queue() is called for the
last XDP queue, we get a WARNING with a call trace and KASAN report
afterwards (if enabled).

[ 2012.699800] WARNING: net/core/dev.c:2854 at __netif_set_xps_queue+0x116a/0x1e40, CPU#36: xdpsock/103668
[...]
[ 2012.700029] RIP: 0010:__netif_set_xps_queue+0x116a/0x1e40
[ 2012.700035] Code: b6 34 06 48 89 f8 83 e0 07 83 c0 01 40 38 f0 7c 09 40 84 f6 0f 85 03 0a 00 00 0f b7 44 24 40 66 43 89 44 6a 18 e9 01 fb ff ff <0f> 0b e9 f2 ee ff ff 44 8b 44 24 44 45 85 c0 74 50 4d 85 e4 0f 84
[ 2012.700040] RSP: 0018:ffff8882369aeb28 EFLAGS: 00010246
[ 2012.700046] RAX: 0000000000000000 RBX: 000000000000003f RCX: 0000000000000000
[ 2012.700050] RDX: 1ffff1111da3d891 RSI: ffff888120e34250 RDI: ffff8888ed1ec488
[ 2012.700054] RBP: ffff888913281560 R08: 0000000000000000 R09: ffff8888ed1ec000
[ 2012.700058] R10: ffff8888a2e83180 R11: 0000000000000000 R12: 0000000000007fa8
[ 2012.700061] R13: 000000000000003f R14: ffff888120e34854 R15: ffff8889132817c8
[ 2012.700065] FS:  00007fc8ea9ff740(0000) GS:ffff88884cefe000(0000) knlGS:0000000000000000
[ 2012.700069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2012.700073] CR2: 00007f81c8000020 CR3: 00000002299f8006 CR4: 00000000007726f0
[ 2012.700077] PKRU: 55555554
[ 2012.700080] Call Trace:
[ 2012.700084]  <TASK>
[ 2012.700087]  ? ktime_get+0x61/0x150
[ 2012.700097]  ? usleep_range_state+0x133/0x1b0
[ 2012.700108]  ? __pfx_usleep_range_state+0x10/0x10
[ 2012.700114]  netif_set_xps_queue+0x31/0x50
[ 2012.700119]  ixgbe_configure_tx_ring+0x472/0x920 [ixgbe]
[...]
[ 2012.700486]  ixgbe_xdp+0x38f/0x750 [ixgbe]

[...]

[ 2012.701094] BUG: KASAN: slab-out-of-bounds in __netif_set_xps_queue+0x1ac5/0x1e40
[ 2012.701100] Write of size 4 at addr ffff88888d43cff8 by task xdpsock/103668

Skip XPS configuration for XDP Tx queues.

Fixes: 33fdc82f0883 ("ixgbe: add support for XDP_TX action")
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 086cc25730338..fd5a2ce4862b8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -3522,7 +3522,8 @@ void ixgbe_configure_tx_ring(struct ixgbe_adapter *adapter,
 	}
 
 	/* initialize XPS */
-	if (!test_and_set_bit(__IXGBE_TX_XPS_INIT_DONE, &ring->state)) {
+	if (!ring_is_xdp(ring) &&
+	    !test_and_set_bit(__IXGBE_TX_XPS_INIT_DONE, &ring->state)) {
 		struct ixgbe_q_vector *q_vector = ring->q_vector;
 
 		if (q_vector)
-- 
2.53.0



