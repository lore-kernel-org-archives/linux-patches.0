Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617800;
	b=NkBIEIzC0cXkV9sAhG9kSCL3AJFL/G3fkC62w1Kvl/orIClR1Fhyp4vRGP49FG6NXngH
	 jdDwgHuot3Nb0ej9aORyGE8nXBDoOSAtnDnd3kD8G2ar9uAMMJqP81MNvr0J6Dd+zTK0u
	 oE1ZSdR+AL+H/hgavbkOSXEJeXenZHzvv1bbDBQ6TlSckrnweE8OBof6tuuHjRv2av7jf
	 d82SNbCD3nTh71fe9zcekYazvxtLEIQ0EeCUOs7o+uhl6aMd7vU5kuYZbdhXLbPdTJ1/w
	 Ptvb/Bk4WTyXiaDYX1/OhAI2Mu4dCoB8hkjkORw4jKpbq7m55rHPQ2JV1VxKMaYUVMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rC/w3xMiFWCp3RvzHA1RLDlsVn90igNdwfbrmgSFTiM=;
	b=n2ow+o2XmPzN6PA+wu8Ao5L4MDBF2Nzk1u5paUxhf7w3LGS7uPmydQ+avn/mhIz1EYj+
	 CBVZlh5niFlrrFhBDYP1Kl3ZUH/MvyWf6IotLNmPd2FI34ScBTCEEeUUpJ7JsCXcO6QYY
	 aJhBesqhizWXEe92LY56D3vpnWuYNSR3p0GCM2P43RDIk0thmulTfzCDlYO+whn+BstiU
	 /swwyZDUf4lwSDnLlAvEdyO7JK1Y0xleNJjhWY9PtTycvzDbo5KHl9sraYGqzeIYieTEf
	 4uEnyiLkhifSVF7uqpETVzSekAtW1C6w956OEe4LQyPgniW3X1miaI9R0kLpz3PJBlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLgNKFvb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAAE606A326;
	Wed, 25 Nov 2026 14:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLgNKFvb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606131F000C6;
	Wed, 25 Nov 2026 14:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617799;
	bh=rC/w3xMiFWCp3RvzHA1RLDlsVn90igNdwfbrmgSFTiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLgNKFvb5nBFY5w9UbJSKWr+NbGTmL0KV2tkvO6U1CXdBZf9bWwOkg2OGAA1CGbnp
	 1G0JjTGl1aofpZgLBbUKQlrMe12XnbTHg4jfGSv7i5iRPDvO8NjD8hNM2eU+K2VBp1
	 DC5JA7TS6/2THFjboYfbi2X+rjXVzH/PQ/2xUK/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0079/1005] net: ethernet: mtk_wed: setup WDMA_RING_TX(0) for non-DBDC MT7986
Date: Wed, 25 Nov 2026 15:23:37 +0100
Message-ID: <20261125143823.591973860@linuxfoundation.org>
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

[ Upstream commit dd6efae5529107cc8db277eaeaff5c5f15e6bc15 ]

WDMA_RING_TX(0) is required to set MTK_WED_WDMA_RING_TX for WED RX
but on a non-DBDC MT7986 it is never setup because idx is 1.

Setting MTK_WED_WDMA_RING_TX with WDMA_RING_TX(1) is not feasible because
WED still tries to send through WDMA_RING_TX(0). This is verified with
register dump.

Fix this by calling mtk_wed_wdma_tx_ring_setup if wed is v2 and
rx_ring[0] is not allocated and reset tx_wdma[0] if it's already
allocated also add error messages and bail when mtk_wed_start fails.

Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-4-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 3044a7a8ea03e..f40ac5794341c 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -2345,7 +2345,20 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 
 	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++)
 		if (!dev->rx_wdma[i].desc)
-			mtk_wed_wdma_rx_ring_setup(dev, i, 16, false);
+			if (mtk_wed_wdma_rx_ring_setup(dev, i, 16, false)) {
+				dev_err(dev->hw->dev, "wdma rx ring %d setup failed\n", i);
+				return;
+			}
+
+	/*
+	 * non-DBDC MT7986 allocates only rx_ring[1] and tx_wdma[1] during setup
+	 * but tx_wdma[0] is also needed for WED to function.
+	 */
+	if (mtk_wed_is_v2(dev->hw) && !dev->rx_ring[0].desc)
+		if (mtk_wed_wdma_tx_ring_setup(dev, 0, MTK_WED_WDMA_RING_SIZE, !!dev->tx_wdma[0].desc)) {
+			dev_err(dev->hw->dev, "wdma tx ring 0 setup failed\n");
+			return;
+		}
 
 	if (dev->wlan.hw_rro) {
 		for (i = 0; i < MTK_WED_RX_PAGE_QUEUES; i++) {
-- 
2.53.0



