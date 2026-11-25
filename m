Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617934;
	b=4i6B+x7rlV8HEFu4rh75qelSI247aWN6L2npBYSZTUf25w/i8CsWznSPUeqr9EyHFpE1
	 Tt+rNIBPap/RbWKruFSo81dQnypf1E/VWwJStMnyb6ErMlHBGGJfpmPsvFsC9WhFOOvmJ
	 wFQtv6Vdb9Fh8Ef0z5VByA4hWo2mNsKgLQoo2ELbNK67q6qC08fseG3ZEEbYHvy4oRon7
	 XhybYxwYuIUVfyrKuHxw4j65r4m2bDjfBeXP8OJskZGWS2iQ10b2IVo9NbvELj5EjpSTD
	 GuB1kCW2EIWcpLA+nIIjAvK/wyChCrx7MxbPGAK2X/YWr5YKfttL2zsUyHhyvJ28pqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rd/WwAXYtilDQM0qKTFrVwI7Jjo3vB3xV/cVMwvhA7o=;
	b=0PsGO3Mpb1d8miLbbMZjxUEob55gSs9rIpf9KcrCkHAGVuFUL76L/XKx9eVpSnREL31u
	 BMHm1OCPzDqbrjp3ShFseOY6Tq2/+Hrd1U51v/93OZ17JJQSh7XhvIZqRaGT5lks88X6r
	 F0QGGNkmvatsV2GtmEeD6XEa2rAmw6HIxp5zTyWGKr2LqN6QhERmKe3HriZ2klpvIS2im
	 WY3o1atB10+TXLvQ0m32Hd9jM1Q+/Ab8j1EfQiWehYZpUULOpbKh4yBoeggZD8lPXxjR4
	 RRQG3P1WjBxMvA2OICMvziBBWbXAfVAm0cpCq4rPU0OkJXn49UqoLQAfxqncIrO56WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bjp71wpu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77524606A31E;
	Wed, 25 Nov 2026 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bjp71wpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8613C1F00AD3;
	Wed, 25 Nov 2026 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617934;
	bh=Rd/WwAXYtilDQM0qKTFrVwI7Jjo3vB3xV/cVMwvhA7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bjp71wpuH4JLkRuvenm/NkKD0aqjVWY0IOyl83Ns1GyRqaJMN+WhEqdFBVW8f2rVq
	 s/dBkb6B51EAugVOAjEF/3g28VrFL5MJJ6SMEXlbyKIQcWCRDgq4E7MuHkMsHFzu/e
	 jsTzKzzgI+YZFcj1S9yyHvNuJ1xSY+PLTQl5GNBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0076/1005] net: ethernet: mtk_wed: skip ring reset in wdma_tx_ring_setup for WED v3
Date: Wed, 25 Nov 2026 15:23:34 +0100
Message-ID: <20261125143823.520678579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit cb50f16f37fc3429085c454ee5978e05732d10ba ]

Currently WED v3 tx wdma ring, ring reset happens in a separate code
block unconditionally.

Moreover, v3 has double the size of wdma_desc and has different init
values. mtk_wed_ring_reset doens't deal with that and would corrupt the
wdma_desc.

Fix this by skipping mtk_wed_ring_reset in mtk_wdma_tx_ring_setup for
WED v3.

Fixes: e2f64db13aa1 ("net: ethernet: mtk_wed: introduce WED support for MT7988")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260711112128.971-1-hujy652@gmail.com?part=1
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-1-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 53d3b7e00e1cd..d55042ccaff16 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -1938,7 +1938,7 @@ mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int size,
 	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_CPU_IDX, 0);
 	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_DMA_IDX, 0);
 
-	if (reset)
+	if (!mtk_wed_is_v3_or_greater(dev->hw) && reset)
 		mtk_wed_ring_reset(wdma, MTK_WED_WDMA_RING_SIZE, true);
 
 	if (!idx)  {
-- 
2.53.0



