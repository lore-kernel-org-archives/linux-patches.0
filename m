Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617797;
	b=LbVEiTl3x/w0L+xn8iY4FSxprxGRqGRO4YA4NQGIMDhahfUSUy/fiD90w+2WFn/HjDY6
	 N27pPhLIEq2Ybqym5+ESTRVUd/f8ounNR8p+H4Z/aaSP5funkxkTXrL0Dz20Jk3SPfN2l
	 FrObpv9zpJ9QWk/eRrF9Midbw6qOwApN2wmcVIJey+mXqgWbahXj25vtJOPmXXhKeGh1R
	 XZX8Q6zTtD2MPQ6ojt2G92C+zFROPFMEMvYfgMTByXzpAwtg3OklT8YvCw7gsZioDzaXI
	 Bl5CzPMA9FIq1sZ1XpKOhilLFnkiDKrk092/62I/lr0o2eRnoz2j8Fr8wEF0iEy7HUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sfVRSLn1tEb9SB8VMlsvR9WHCw1R3IkxqB/Ix5dwdT0=;
	b=CPmNbldLa8HudFbURO/PhKK+WyfUFIveoNUodZ71Y5HieymwSjNQ0ybGkghCgDthiE2K
	 Ste9JkvBu9MQU1RpCfKiVbV3WS1I9wt+JK3UDR+byINRRlbx3bktSdFrd2y8UCxf50iss
	 KkGCDd6gkLOrkuJV46hcmgVUwH4l+8xcI5gSOyvgfPpCGDkriipzKSvZEBNUdQG13BosB
	 vx6k/xUEtX0YfXS6EQKlPXWp5+8YH1hh+u6vZQdBJKr7KSNF2Bhqs1ajsX5gMBOKSYNUW
	 KHQjlgBjonMLlmd4tbxoBsf1+kvil5g0L7o5g8Krz5tI25Yo6Owwqjy9foImQsy9Qtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AzO7oji3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70620606A31E;
	Wed, 25 Nov 2026 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AzO7oji3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3210A1F000C0;
	Wed, 25 Nov 2026 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617796;
	bh=sfVRSLn1tEb9SB8VMlsvR9WHCw1R3IkxqB/Ix5dwdT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzO7oji3xUTWrByUCHTcL2OH/BX6iI4l1eJRPWZu0ERz23h0/eUPTE/H8v3QT7Kcn
	 98+X2VMz+8OOc6jFk8g5PEiiwKN77CR6COYpqnIIGnt50NrbGzdmZMf+po8AK8kcA+
	 GlXcrUZ5OTEwe22MPjWuNPuLtVZray5jEDiB2uD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0078/1005] net: ethernet: mtk_wed: free up rings during detach
Date: Wed, 25 Nov 2026 15:23:36 +0100
Message-ID: <20261125143823.567625649@linuxfoundation.org>
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

[ Upstream commit 5b8d12512cbd3495dbd8c38e8047bb5d716f0f3f ]

During __mtk_wed_detach, rx_ring and tx_wdma aren't freed up.

Fix this by add them to mtk_wed_free_rx_rings.

This patch is pulled from mtk-openwrt-feeds to address Sashiko's review
and edit to rely on ring->desc instead of an extra flag.

Link: https://github.com/mediatek/mtk-openwrt-feeds/blob/main/25.12/files/target/linux/mediatek/patches-6.12/999-wed-04-Fix-reinsert-wifi-module-cause-memory-leak-issue.patch
Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/message/179000700034.2160803.10594281691384015089%40kernel.org
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-3-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 3f0be70c3f145..3044a7a8ea03e 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -949,6 +949,14 @@ mtk_wed_free_ring(struct mtk_wed_device *dev, struct mtk_wed_ring *ring)
 static void
 mtk_wed_free_rx_rings(struct mtk_wed_device *dev)
 {
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->rx_ring); i++)
+		mtk_wed_free_ring(dev, &dev->rx_ring[i]);
+
+	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++)
+		mtk_wed_free_ring(dev, &dev->tx_wdma[i]);
+
 	mtk_wed_free_rx_buffer(dev);
 	mtk_wed_free_ring(dev, &dev->rro.ring);
 }
-- 
2.53.0



