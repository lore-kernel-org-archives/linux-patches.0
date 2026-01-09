Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FB53596FE;
	Fri,  9 Jan 2026 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961843; cv=none; b=gOF3bcUsbOANZvNRNNQ+pNWHLQ6E1uBx3RQFGbIjyMZMV3hEa32iHti+AT9OWI5iFzg9Jw1Q8cKE6ZSiH7VSAZC+rqbmv2/187T1n8Q+m/On3s9dQAi1GmgCj9PNEBkqszq2Tvrc/RGpT3iFaDzi6IABWenLxzF5B+K8LTBK/qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961843; c=relaxed/simple;
	bh=osB9cTRsEXhld3q+FrxbvIJHwv69uVGwj057mZX9xJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWH4xOXY/kptnNU3xW3iA3OHj3aVHWYBUd2LZr3FcjxnEAz6uZkDxKy2yKEMJzilkBOCmv72CZbxD37mkO3pD1hPqqCZ3WSHaRBI9rUUx7HWSBKtm720fUfRAunS6sKfhAkST66HSrL0NxkfeUTodJlrHMMqHed7nXrM4Zg7Jgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gh3K0Fn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gh3K0Fn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B7CC4CEF1;
	Fri,  9 Jan 2026 12:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961842;
	bh=osB9cTRsEXhld3q+FrxbvIJHwv69uVGwj057mZX9xJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gh3K0Fn46BQ8WiAv/QoSALZy9i4NTfOrUbmdQiQzIPCVGcR9JpK+KIzX3dlEm3PPI
	 ICxk80jc42AZ1w50VOWmSXnPMPFvR3Z/QRKLrv6z1p9/7ghJLABB06CHK1kwg/FmIW
	 3ei1dYhyEH3rwoNpm9Z14Q/X/vlLJNLDGwjJT9YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/634] ASoC: fsl_xcvr: Add Counter registers
Date: Fri,  9 Jan 2026 12:37:13 +0100
Message-ID: <20260109112123.284339063@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 107d170dc46e14cfa575d1b995107ef2f2e51dfe ]

These counter registers are part of register list,
add them to complete the register map

- DMAC counter control registers
- Data path Timestamp counter register
- Data path bit counter register
- Data path bit count timestamp register
- Data path bit read timestamp register

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1666940627-7611-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 73b97d46dde6 ("ASoC: fsl_xcvr: clear the channel status control memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 40 ++++++++++++++++++++++++++++++++++++++++
 sound/soc/fsl/fsl_xcvr.h | 21 +++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 4c5864e8267d0..6c8a2519cc1bd 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -934,6 +934,14 @@ static const struct reg_default fsl_xcvr_reg_defaults[] = {
 	{ FSL_XCVR_RX_DPTH_CTRL_SET,	0x00002C89 },
 	{ FSL_XCVR_RX_DPTH_CTRL_CLR,	0x00002C89 },
 	{ FSL_XCVR_RX_DPTH_CTRL_TOG,	0x00002C89 },
+	{ FSL_XCVR_RX_DPTH_CNTR_CTRL,	0x00000000 },
+	{ FSL_XCVR_RX_DPTH_CNTR_CTRL_SET, 0x00000000 },
+	{ FSL_XCVR_RX_DPTH_CNTR_CTRL_CLR, 0x00000000 },
+	{ FSL_XCVR_RX_DPTH_CNTR_CTRL_TOG, 0x00000000 },
+	{ FSL_XCVR_RX_DPTH_TSCR, 0x00000000 },
+	{ FSL_XCVR_RX_DPTH_BCR,  0x00000000 },
+	{ FSL_XCVR_RX_DPTH_BCTR, 0x00000000 },
+	{ FSL_XCVR_RX_DPTH_BCRR, 0x00000000 },
 	{ FSL_XCVR_TX_DPTH_CTRL,	0x00000000 },
 	{ FSL_XCVR_TX_DPTH_CTRL_SET,	0x00000000 },
 	{ FSL_XCVR_TX_DPTH_CTRL_CLR,	0x00000000 },
@@ -944,6 +952,14 @@ static const struct reg_default fsl_xcvr_reg_defaults[] = {
 	{ FSL_XCVR_TX_CS_DATA_3,	0x00000000 },
 	{ FSL_XCVR_TX_CS_DATA_4,	0x00000000 },
 	{ FSL_XCVR_TX_CS_DATA_5,	0x00000000 },
+	{ FSL_XCVR_TX_DPTH_CNTR_CTRL,	0x00000000 },
+	{ FSL_XCVR_TX_DPTH_CNTR_CTRL_SET, 0x00000000 },
+	{ FSL_XCVR_TX_DPTH_CNTR_CTRL_CLR, 0x00000000 },
+	{ FSL_XCVR_TX_DPTH_CNTR_CTRL_TOG, 0x00000000 },
+	{ FSL_XCVR_TX_DPTH_TSCR, 0x00000000 },
+	{ FSL_XCVR_TX_DPTH_BCR,	 0x00000000 },
+	{ FSL_XCVR_TX_DPTH_BCTR, 0x00000000 },
+	{ FSL_XCVR_TX_DPTH_BCRR, 0x00000000 },
 	{ FSL_XCVR_DEBUG_REG_0,		0x00000000 },
 	{ FSL_XCVR_DEBUG_REG_1,		0x00000000 },
 };
@@ -975,6 +991,14 @@ static bool fsl_xcvr_readable_reg(struct device *dev, unsigned int reg)
 	case FSL_XCVR_RX_DPTH_CTRL_SET:
 	case FSL_XCVR_RX_DPTH_CTRL_CLR:
 	case FSL_XCVR_RX_DPTH_CTRL_TOG:
+	case FSL_XCVR_RX_DPTH_CNTR_CTRL:
+	case FSL_XCVR_RX_DPTH_CNTR_CTRL_SET:
+	case FSL_XCVR_RX_DPTH_CNTR_CTRL_CLR:
+	case FSL_XCVR_RX_DPTH_CNTR_CTRL_TOG:
+	case FSL_XCVR_RX_DPTH_TSCR:
+	case FSL_XCVR_RX_DPTH_BCR:
+	case FSL_XCVR_RX_DPTH_BCTR:
+	case FSL_XCVR_RX_DPTH_BCRR:
 	case FSL_XCVR_TX_DPTH_CTRL:
 	case FSL_XCVR_TX_DPTH_CTRL_SET:
 	case FSL_XCVR_TX_DPTH_CTRL_CLR:
@@ -985,6 +1009,14 @@ static bool fsl_xcvr_readable_reg(struct device *dev, unsigned int reg)
 	case FSL_XCVR_TX_CS_DATA_3:
 	case FSL_XCVR_TX_CS_DATA_4:
 	case FSL_XCVR_TX_CS_DATA_5:
+	case FSL_XCVR_TX_DPTH_CNTR_CTRL:
+	case FSL_XCVR_TX_DPTH_CNTR_CTRL_SET:
+	case FSL_XCVR_TX_DPTH_CNTR_CTRL_CLR:
+	case FSL_XCVR_TX_DPTH_CNTR_CTRL_TOG:
+	case FSL_XCVR_TX_DPTH_TSCR:
+	case FSL_XCVR_TX_DPTH_BCR:
+	case FSL_XCVR_TX_DPTH_BCTR:
+	case FSL_XCVR_TX_DPTH_BCRR:
 	case FSL_XCVR_DEBUG_REG_0:
 	case FSL_XCVR_DEBUG_REG_1:
 		return true;
@@ -1017,6 +1049,10 @@ static bool fsl_xcvr_writeable_reg(struct device *dev, unsigned int reg)
 	case FSL_XCVR_RX_DPTH_CTRL_SET:
 	case FSL_XCVR_RX_DPTH_CTRL_CLR:
 	case FSL_XCVR_RX_DPTH_CTRL_TOG:
+	case FSL_XCVR_RX_DPTH_CNTR_CTRL:
+	case FSL_XCVR_RX_DPTH_CNTR_CTRL_SET:
+	case FSL_XCVR_RX_DPTH_CNTR_CTRL_CLR:
+	case FSL_XCVR_RX_DPTH_CNTR_CTRL_TOG:
 	case FSL_XCVR_TX_DPTH_CTRL_SET:
 	case FSL_XCVR_TX_DPTH_CTRL_CLR:
 	case FSL_XCVR_TX_DPTH_CTRL_TOG:
@@ -1026,6 +1062,10 @@ static bool fsl_xcvr_writeable_reg(struct device *dev, unsigned int reg)
 	case FSL_XCVR_TX_CS_DATA_3:
 	case FSL_XCVR_TX_CS_DATA_4:
 	case FSL_XCVR_TX_CS_DATA_5:
+	case FSL_XCVR_TX_DPTH_CNTR_CTRL:
+	case FSL_XCVR_TX_DPTH_CNTR_CTRL_SET:
+	case FSL_XCVR_TX_DPTH_CNTR_CTRL_CLR:
+	case FSL_XCVR_TX_DPTH_CNTR_CTRL_TOG:
 		return true;
 	default:
 		return false;
diff --git a/sound/soc/fsl/fsl_xcvr.h b/sound/soc/fsl/fsl_xcvr.h
index 7f2853c60085e..4769b0fca21de 100644
--- a/sound/soc/fsl/fsl_xcvr.h
+++ b/sound/soc/fsl/fsl_xcvr.h
@@ -49,6 +49,16 @@
 #define FSL_XCVR_RX_DPTH_CTRL_CLR	0x188
 #define FSL_XCVR_RX_DPTH_CTRL_TOG	0x18c
 
+#define FSL_XCVR_RX_DPTH_CNTR_CTRL	0x1C0
+#define FSL_XCVR_RX_DPTH_CNTR_CTRL_SET	0x1C4
+#define FSL_XCVR_RX_DPTH_CNTR_CTRL_CLR	0x1C8
+#define FSL_XCVR_RX_DPTH_CNTR_CTRL_TOG	0x1CC
+
+#define FSL_XCVR_RX_DPTH_TSCR		0x1D0
+#define FSL_XCVR_RX_DPTH_BCR		0x1D4
+#define FSL_XCVR_RX_DPTH_BCTR		0x1D8
+#define FSL_XCVR_RX_DPTH_BCRR		0x1DC
+
 #define FSL_XCVR_TX_DPTH_CTRL		0x220 /* TX datapath ctrl reg */
 #define FSL_XCVR_TX_DPTH_CTRL_SET	0x224
 #define FSL_XCVR_TX_DPTH_CTRL_CLR	0x228
@@ -59,6 +69,17 @@
 #define FSL_XCVR_TX_CS_DATA_3		0x23C
 #define FSL_XCVR_TX_CS_DATA_4		0x240
 #define FSL_XCVR_TX_CS_DATA_5		0x244
+
+#define FSL_XCVR_TX_DPTH_CNTR_CTRL	0x260
+#define FSL_XCVR_TX_DPTH_CNTR_CTRL_SET	0x264
+#define FSL_XCVR_TX_DPTH_CNTR_CTRL_CLR	0x268
+#define FSL_XCVR_TX_DPTH_CNTR_CTRL_TOG	0x26C
+
+#define FSL_XCVR_TX_DPTH_TSCR		0x270
+#define FSL_XCVR_TX_DPTH_BCR		0x274
+#define FSL_XCVR_TX_DPTH_BCTR		0x278
+#define FSL_XCVR_TX_DPTH_BCRR		0x27C
+
 #define FSL_XCVR_DEBUG_REG_0		0x2E0
 #define FSL_XCVR_DEBUG_REG_1		0x2F0
 
-- 
2.51.0



