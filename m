Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C4F41A80
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHxdK2oZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FD4C433C8;
	Wed, 15 Nov 2023 19:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076993;
	bh=Ljni98DJiBdWATp82nboyq3nvQ947Ki+3eCplWv92ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHxdK2oZ7e0izkwqvHnS0ov5kNtWwpDFPsxx8vsf18ewnllJIMkDho2DfqWWz5PKp
	 dbN1y4GS4GdYh018GMh4Tweb4t/jcHmaRMqeoL9liCZeOZ2NK7tP4MzZD+wI45AvNe
	 86C03iaFEDpWWwqloBBNDPVyr7VbxJgxu8Okt0pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/603] net: ethernet: mtk_wed: fix EXT_INT_STATUS_RX_FBUF definitions for MT7986 SoC
Date: Wed, 15 Nov 2023 14:10:17 -0500
Message-ID: <20231115191618.097667035@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c80471ba74b7f332ac19b985ccb76d852d507acf ]

Fix MTK_WED_EXT_INT_STATUS_RX_FBUF_LO_TH and
MTK_WED_EXT_INT_STATUS_RX_FBUF_HI_TH definitions for MT7986 (MT7986 is
the only SoC to use them).

Fixes: de84a090d99a ("net: ethernet: mtk_eth_wed: add wed support for mt7986 chipset")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index 47ea69feb3b24..f87ab9b8a5901 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -64,8 +64,8 @@ struct mtk_wdma_desc {
 #define MTK_WED_EXT_INT_STATUS_TKID_TITO_INVALID	BIT(4)
 #define MTK_WED_EXT_INT_STATUS_TX_FBUF_LO_TH		BIT(8)
 #define MTK_WED_EXT_INT_STATUS_TX_FBUF_HI_TH		BIT(9)
-#define MTK_WED_EXT_INT_STATUS_RX_FBUF_LO_TH		BIT(12)
-#define MTK_WED_EXT_INT_STATUS_RX_FBUF_HI_TH		BIT(13)
+#define MTK_WED_EXT_INT_STATUS_RX_FBUF_LO_TH		BIT(10) /* wed v2 */
+#define MTK_WED_EXT_INT_STATUS_RX_FBUF_HI_TH		BIT(11) /* wed v2 */
 #define MTK_WED_EXT_INT_STATUS_RX_DRV_R_RESP_ERR	BIT(16)
 #define MTK_WED_EXT_INT_STATUS_RX_DRV_W_RESP_ERR	BIT(17)
 #define MTK_WED_EXT_INT_STATUS_RX_DRV_COHERENT		BIT(18)
-- 
2.42.0



