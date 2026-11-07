Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061053;
	b=O6EIP/68cbmlbZ3QJRI8LcW4MwhoIEPq4P+vStnaSaSoc6uX0e8WPNc2ud4tmBjVfNU5
	 EdYNpSwFQbdPnOz8PoKlGddExgfo7CBG5HUcYG/dnn1aiuXTyckaNn6XD5fVxOqfxHD4p
	 Rg8qvpstwOczYoh9MzsNT6lqWGh8OfQaqpK3G15rJvMMiJCkDoz+pe9rBbFS69ajlj4gK
	 V739R27Kk+5Q4Dvyf7+32oWu5odTFrm+dxmWNk8nVjM8aVlJjbuYV67MksjVbxFUSJTk3
	 Yk2Sf8+X5TabjVWHpMv65n2vN0Q+OF2naJD15yaFdJG+mipYipbWkEhH41rMWhb5kzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t9PiublJjs5vQju3QeCn/QoVRyFiAjpjuc+ktuvv5mM=;
	b=YXwYiMjYnTo24VWjzqRiBpkr4vi2rNwA5A4MnbJLH/auMUsPi8+/fngDJlOXWh/9NdmJ
	 f6fX6cMc+foKQ+273njqeRo8/k0DVwJ02/bLFDAWgz5RPkNgeD+EgVZClZDvrvPeAxZ3L
	 jXg7gWl7f7CWJs7mYce74Wv70VTnHsS9S6pXb6xtq6ZA8YPU/fy9cfNb6W5zfIegrRlfO
	 Sz2J5z9yizysWvERsYJo1GFqxaFGsS/koxt/wyeVdPy6rkd8jlGRRMriucC/mBp8M8plc
	 zgxSwFaE2W4LV83G+mKheJ3RHLcyBTrjv+udNZsvOGkupguL6kCv2PMtfD6a44tzV2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7CLheyb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADB6606A339;
	Sat,  7 Nov 2026 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7CLheyb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B5C1F0089F;
	Sat,  7 Nov 2026 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061053;
	bh=t9PiublJjs5vQju3QeCn/QoVRyFiAjpjuc+ktuvv5mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7CLheybwod21EPCPGBXKyHXQUg4xd3BRLaHRLMuCKf8cW9ixB8WIlR2MtkGFhHJX
	 9OX3VB4ntDndG+7ojrA7mc0ZLtz3CvZpbeT1XFh8hkm7v90aLI+O90I6yX4SsnE6nc
	 cgWoA144Ibzx7FbnSU454qBOSDDK8V2vbnGS7oq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0385/1536] net: ethernet: mtk_wed: increase WED v2 WDMA RESV_BUFF to 0x80
Date: Sat,  7 Nov 2026 08:40:01 -0500
Message-ID: <20261107135008.428130102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 499ca70001259..8d95765a3813f 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -2072,6 +2072,11 @@ mtk_wed_dma_enable(struct mtk_wed_device *dev)
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



