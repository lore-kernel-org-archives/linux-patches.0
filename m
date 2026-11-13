Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590563;
	b=Gm2JLVEJLTAf56KtvcM5CvWK8pGrrvNV3mDEYmq0O64mvlkjtT4+YBk9tNH/WWJhTb8O
	 cb94+MVRa4MoioXhJ8/gy+Du+IMDeI59sZ+PkLFio5M/OBF0Izmmqg2HCmQve9PAsb17X
	 JOWwAZv1yo6CuSPj0qRogwrdp89OFYy3lXID3jjwuJ0e5+J6U26jUALtoBS+Q5ICsqvYk
	 rqxpm1ImAuHm9Zanb521jT62G2CkzyQTGbdKg1d/pTw8CedohtKJsGVMdx6qYGOXM9l+p
	 Y9wML5rA1ianeiZCfmRR1QnqwBmU0aCY0wiEVSWEAFtIg741rmATmIqsthWNqZDaleA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TFCXk95eHWKbzbcl47U5CmuEtL01E7RXceek4iuwROc=;
	b=KtKtruG2DVs5GEcwxoEBwCa9UFdw9RViO9g9QuCBfJSfW/K1T0RWJhhC3RkIV0WOCUug
	 rpb4UHWXYa+5rmP8+iFJetWZKsabILxHa6Jfz+2JIn69ELIpykYNT531nxzpZUaoZz0Rm
	 DyDmMKZm5YWjSIuMM4ejvxSSGxwIaxpiYISG5iHFe4opo5aebcsDndi32hMXjGQW34/Hi
	 q0XiOdXSJmOxMntvFIedaRRJYv340Uu6NGf+/+n6ESfPsLz5ybRItAaouhPbYmFMUfAbK
	 vuuqc8LZ9pvQrve41gDyv4OZRPmMUYfAezcUSs5ZhJyipxri6UFTBukoL1s3DgWxrwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5RfnXc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA8D606BD13;
	Fri, 13 Nov 2026 17:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5RfnXc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5961F000C6;
	Fri, 13 Nov 2026 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590563;
	bh=TFCXk95eHWKbzbcl47U5CmuEtL01E7RXceek4iuwROc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5RfnXc8aPnBaTK5Oqa/IHUpEeHkTORmRT9ILatOLe7TR/FCyPtk+b4/TLlacQEth
	 miyhfWE/NEKIgfI8yC0kTKQ1XIXJ42Z58GxkdEOIFgZ2BVmKFcfmtVincSUU3lQuNM
	 ejNSM47SnvrS3yCrBgt/q9GiKGoLO5qrCAjGca60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 497/686] media: microchip-isc: fix ISC_PFG_CFG0_BPS macro name typo
Date: Fri, 13 Nov 2026 10:50:30 -0500
Message-ID: <20261113153837.763579978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 96defd0723fc893db6ccf5f4968323db4af0b0aa ]

The BPS field macros for ISC_PFE_CFG0 were spelled ISC_PFG_CFG0_BPS_*
(NINE, TEN, ELEVEN, TWELVE). The register is PFE, not PFG. Rename them
to ISC_PFE_CFG0_BPS_* to match the register and the EIGHT and MASK
macros. No functional change.

Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: bb96c78c5f87 ("media: microchip-isc: fix SBGGR10 Bayer pattern")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/microchip/microchip-isc-regs.h    |  8 ++++----
 .../platform/microchip/microchip-sama5d2-isc.c | 18 +++++++++---------
 .../platform/microchip/microchip-sama7g5-isc.c | 18 +++++++++---------
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-regs.h b/drivers/media/platform/microchip/microchip-isc-regs.h
index cabecf128b37a..fe145b142b826 100644
--- a/drivers/media/platform/microchip/microchip-isc-regs.h
+++ b/drivers/media/platform/microchip/microchip-isc-regs.h
@@ -32,10 +32,10 @@
 #define ISC_PFE_CFG0_MODE_MASK          GENMASK(6, 4)
 
 #define ISC_PFE_CFG0_BPS_EIGHT  0x4
-#define ISC_PFG_CFG0_BPS_NINE   0x3
-#define ISC_PFG_CFG0_BPS_TEN    0x2
-#define ISC_PFG_CFG0_BPS_ELEVEN 0x1
-#define ISC_PFG_CFG0_BPS_TWELVE 0x0
+#define ISC_PFE_CFG0_BPS_NINE   0x3
+#define ISC_PFE_CFG0_BPS_TEN    0x2
+#define ISC_PFE_CFG0_BPS_ELEVEN 0x1
+#define ISC_PFE_CFG0_BPS_TWELVE 0x0
 #define ISC_PFE_CFG0_BPS_MASK   GENMASK(30, 28)
 
 #define ISC_PFE_CFG0_COLEN	BIT(12)
diff --git a/drivers/media/platform/microchip/microchip-sama5d2-isc.c b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
index 5bd109e93a8fb..57a5aae3cabfb 100644
--- a/drivers/media/platform/microchip/microchip-sama5d2-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
@@ -147,49 +147,49 @@ static struct isc_format sama5d2_formats_list[] = {
 	{
 		.fourcc		= V4L2_PIX_FMT_SBGGR10,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG10,
 		.mbus_code	= MEDIA_BUS_FMT_SGBRG10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGRBG10,
 		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SRGGB10,
 		.mbus_code	= MEDIA_BUS_FMT_SRGGB10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SBGGR12,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR12_1X12,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TWELVE,
 		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG12,
 		.mbus_code	= MEDIA_BUS_FMT_SGBRG12_1X12,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TWELVE,
 		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGRBG12,
 		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TWELVE,
 		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SRGGB12,
 		.mbus_code	= MEDIA_BUS_FMT_SRGGB12_1X12,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TWELVE,
 		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
 	},
 	{
@@ -210,7 +210,7 @@ static struct isc_format sama5d2_formats_list[] = {
 	{
 		.fourcc		= V4L2_PIX_FMT_Y10,
 		.mbus_code	= MEDIA_BUS_FMT_Y10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 	},
 
 };
diff --git a/drivers/media/platform/microchip/microchip-sama7g5-isc.c b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
index d978ce448a4d2..a841266ffc30f 100644
--- a/drivers/media/platform/microchip/microchip-sama7g5-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
@@ -156,49 +156,49 @@ static struct isc_format sama7g5_formats_list[] = {
 	{
 		.fourcc		= V4L2_PIX_FMT_SBGGR10,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG10,
 		.mbus_code	= MEDIA_BUS_FMT_SGBRG10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGRBG10,
 		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SRGGB10,
 		.mbus_code	= MEDIA_BUS_FMT_SRGGB10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SBGGR12,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR12_1X12,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TWELVE,
 		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG12,
 		.mbus_code	= MEDIA_BUS_FMT_SGBRG12_1X12,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TWELVE,
 		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGRBG12,
 		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TWELVE,
 		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SRGGB12,
 		.mbus_code	= MEDIA_BUS_FMT_SRGGB12_1X12,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TWELVE,
 		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
 	},
 	{
@@ -224,7 +224,7 @@ static struct isc_format sama7g5_formats_list[] = {
 	{
 		.fourcc		= V4L2_PIX_FMT_Y10,
 		.mbus_code	= MEDIA_BUS_FMT_Y10_1X10,
-		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
+		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
 	},
 };
 
-- 
2.53.0



