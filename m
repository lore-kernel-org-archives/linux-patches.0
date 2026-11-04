Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831013;
	b=ljBsQiiRWksQvQOjm15AWVR1KBm57baVzS1MhYzJdX3ly2xWeLZvvWLE5CJfDKPpl3ga
	 t2HswDouEVRM3nkfR21MiWtzVJ9W0N2+IYoT/gxIMZpbh8iyaVa24/kiuHtgi7zEXk9E4
	 6sKa62aXVwAr1rtV0cNq6E16WJn2P5YpS3apAqpdzVNyK9mNq69jREHFiWwwBaxFxsrdo
	 URZWkRJUFtILT4DQhO3KAWdFwTrjkwqvBMkSXCdb10R2djwNHfDJPA+qWdf9eJ2D5GtE2
	 gfm7XOn6Z0qVWCIPOs3ljrKO1vjC8zNvXE4JjIVa0l0wPx8+PETxrdSOtm2e0kDDz0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3X2Vwvfble6xDEfF3d4nvDmD6Jf1IJkoP+zm8M/8ypw=;
	b=uyFtrzmbU6X8TBA8w4X7uHDqyv4sPrO9ittB3+xwPmPY2vyZRTqjIqTUHwN0zZBjoEOI
	 boibVEDKVKDaZMvfg8nygcEJPIU/zb8/lSpYGIZmyrSEuAFUi9TlskddXnfnaP4a0wwet
	 T31JgIxAMjb/YnAtAR0aSuddQSXru6f/cdedqBmO7ruZW7MXR8af+YHDFPGyK65J/ZadL
	 TwWBwFCtVs4oiFYmPSAP9PFU98XeFNILa9eRHbCm+lipEEbSpG5E8+991HJ816THS3uM8
	 wYyZ3sljXbczBlooFp5u8vZE2WvSQRgwlZVe0oXn9PBzh5We4wTu3W0yragtiHFq6Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mvYr4aCm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B826070327;
	Wed,  4 Nov 2026 22:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mvYr4aCm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1211F000C1;
	Wed,  4 Nov 2026 22:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831013;
	bh=3X2Vwvfble6xDEfF3d4nvDmD6Jf1IJkoP+zm8M/8ypw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvYr4aCmDnF1daFhCaLmoXeb2N9/5IXTQ9QXHnAuPstUpzEDxSCecCtA/zSuL15xV
	 iawcHraq99ccZlW1psVIxMdw7/CGfKohdPNhaB34IdhARdt6FrkVjjapXbpirXkCZG
	 p7PBR5MpnVDBL6/JTWg0ABsmDd8SGAcEXWzZ+uSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0456/1005] net: ethernet: mtk_wed: increase WED v2 WDMA RESV_BUFF to 0x80
Date: Wed,  4 Nov 2026 16:03:09 -0500
Message-ID: <20261104211056.813908680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit c0ef04232f9fac083c3d8a77ce58ba32243e6734 ]

Change WDMA RESV_BUFF from 0x40 to 0x80 to avoid CDM TX FIFO overflow.
Without this patch mt7986 and mt7981 may have WDMA TX hang issue. This
patch was pulled from mtk-openwrt-feeds GPL open source project.

Link: https://github.com/mediatek/mtk-openwrt-feeds/commit/07c87502e854b68b48544d101b6fe17ec059b97b
Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/OSZPR01MB779537889255E2F606E47EABBCA52@OSZPR01MB7795.jpnprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c      | 5 +++++
 drivers/net/ethernet/mediatek/mtk_wed_regs.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 1ed1f88dd7f8b..fdb487e5d46e1 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -2071,6 +2071,11 @@ mtk_wed_dma_enable(struct mtk_wed_device *dev)
 		wdma_set(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_TX_DMA_EN);
 	}
 
+	if (mtk_wed_is_v2(dev->hw))
+		wdma_m32(dev, MTK_WDMA_GLO_CFG,
+			 MTK_WDMA_GLO_CFG_RESV_BUFF,
+			 FIELD_PREP(MTK_WDMA_GLO_CFG_RESV_BUFF, 0x80));
+
 	wed_set(dev, MTK_WED_GLO_CFG,
 		MTK_WED_GLO_CFG_TX_DMA_EN |
 		MTK_WED_GLO_CFG_RX_DMA_EN);
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index c71190924816c..e5f83100ded52 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -433,6 +433,7 @@ struct mtk_wdma_desc {
 #define MTK_WDMA_GLO_CFG_TX_DMA_BUSY			BIT(1)
 #define MTK_WDMA_GLO_CFG_RX_DMA_EN			BIT(2)
 #define MTK_WDMA_GLO_CFG_RX_DMA_BUSY			BIT(3)
+#define MTK_WDMA_GLO_CFG_RESV_BUFF			GENMASK(23, 16)
 #define MTK_WDMA_GLO_CFG_RX_INFO3_PRERES		BIT(26)
 #define MTK_WDMA_GLO_CFG_RX_INFO2_PRERES		BIT(27)
 #define MTK_WDMA_GLO_CFG_RX_INFO1_PRERES		BIT(28)
-- 
2.53.0



