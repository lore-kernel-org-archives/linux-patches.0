Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6318023A99F;
	Thu, 30 Jul 2026 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424519; cv=none; b=cDCGFdpMpRWPGsIv3rGEWt6GU+PDCYB/S/FQdlOjQ0XqtpxFLrpZfkDc0gx82um6N7PmCObd+G7O6Khzts6gtu9m1oZB63fKu8ffaxRu5u/EXtMdRHAf77ld2Si/cw+5aDwTDHNbMA5Jy1Nqu2HEEXBxy8m6uHBAPoB1gc4+9W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424519; c=relaxed/simple;
	bh=h7cv3AflkkDgos/VJwTxJE6ydA4fLpv9r/fGfL6WJuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IodYZr6YAkJ1dcQBwzAL5EaCL/cgoryg1sdMUWqxgvNcHx2AVNmGUmfkuzKcQj5250r+rl+WsGF8OUgAMmx84WvsCmjHKJvO87ZpU6dZELBNWA8mZWvmD3IDQEKdf3Mz3fwhidkWsCkiu5nqk/k7tafBkLZPb9yxqRT3wAVbBYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjQNZz4u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjQNZz4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A7E1F000E9;
	Thu, 30 Jul 2026 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424518;
	bh=hVdgerIsgmx94Riao+ex/AcxHVTtXEZ85LVmvkxkcR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjQNZz4upZHbxuqPZFRfDhy2q+mE9azLX+ueUda+ydbRmCiWs1OToPUxiIgys4S2/
	 lOdVYH+LL2dkkeK4GYT+5LMsTiFFXoPqBDqnMcMrXwowkEuJ9GPBV8+AULMKq3Z2C2
	 ak+Ry55Q0ec37il8aBzOmg+dz6ARvH0nw1W4POG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.18 423/675] media: qcom: camss: Fix RDI streaming for CSID GEN3
Date: Thu, 30 Jul 2026 16:12:33 +0200
Message-ID: <20260730141454.123750984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit ad136e52634d5a393a9dc93383f8ea1e898faf37 upstream.

Fix streaming from CSIDn RDI1 and RDI2 to VFEn RDI1 and RDI2. A pattern we
have replicated throughout CAMSS where we use the VC number to populate
both the VC fields and port fields of the CSID means that in practice only
VC = 0 on CSIDn:RDI0 to VFEn:RDI0 works.

Fix that for CSID gen3 by separating VC and port. Fix to VC zero as a
bugfix we will look to properly populate the VC field with follow on
patches later.

Fixes: d96fe1808dcc ("media: qcom: camss: Add CSID 780 support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-csid-gen3.c |   28 ++++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss-csid-gen3.c
+++ b/drivers/media/platform/qcom/camss/camss-csid-gen3.c
@@ -145,12 +145,12 @@ static void __csid_configure_wrapper(str
 	writel(val, csid->camss->csid_wrapper_base + CSID_IO_PATH_CFG0(csid->id));
 }
 
-static void __csid_configure_rdi_stream(struct csid_device *csid, u8 enable, u8 vc)
+static void __csid_configure_rdi_stream(struct csid_device *csid, u8 enable, u8 port, u8 vc)
 {
 	u32 val;
 	u8 lane_cnt = csid->phy.lane_cnt;
 	/* Source pads matching RDI channels on hardware. Pad 1 -> RDI0, Pad 2 -> RDI1, etc. */
-	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + vc];
+	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + port];
 	const struct csid_format_info *format = csid_get_fmt_entry(csid->res->formats->formats,
 								   csid->res->formats->nformats,
 								   input_format->code);
@@ -163,14 +163,14 @@ static void __csid_configure_rdi_stream(
 	 * the four least significant bits of the five bit VC
 	 * bitfield to generate an internal CID value.
 	 *
-	 * CSID_RDI_CFG0(vc)
+	 * CSID_RDI_CFG0(port)
 	 * DT_ID : 28:27
 	 * VC    : 26:22
 	 * DT    : 21:16
 	 *
 	 * CID   : VC 3:0 << 2 | DT_ID 1:0
 	 */
-	u8 dt_id = vc & 0x03;
+	u8 dt_id = port & 0x03;
 
 	val = RDI_CFG0_TIMESTAMP_EN;
 	val |= RDI_CFG0_TIMESTAMP_STB_SEL;
@@ -180,7 +180,7 @@ static void __csid_configure_rdi_stream(
 	val |= format->data_type << RDI_CFG0_DT;
 	val |= dt_id << RDI_CFG0_DT_ID;
 
-	writel(val, csid->base + CSID_RDI_CFG0(vc));
+	writel(val, csid->base + CSID_RDI_CFG0(port));
 
 	val = RDI_CFG1_PACKING_FORMAT_MIPI;
 	val |= RDI_CFG1_PIX_STORE;
@@ -189,22 +189,22 @@ static void __csid_configure_rdi_stream(
 	val |= RDI_CFG1_CROP_H_EN;
 	val |= RDI_CFG1_CROP_V_EN;
 
-	writel(val, csid->base + CSID_RDI_CFG1(vc));
+	writel(val, csid->base + CSID_RDI_CFG1(port));
 
 	val = 0;
-	writel(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PERIOD(vc));
+	writel(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PERIOD(port));
 
 	val = 1;
-	writel(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PATTERN(vc));
+	writel(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PATTERN(port));
 
 	val = 0;
-	writel(val, csid->base + CSID_RDI_CTRL(vc));
+	writel(val, csid->base + CSID_RDI_CTRL(port));
 
-	val = readl(csid->base + CSID_RDI_CFG0(vc));
+	val = readl(csid->base + CSID_RDI_CFG0(port));
 
 	if (enable)
 		val |= RDI_CFG0_EN;
-	writel(val, csid->base + CSID_RDI_CFG0(vc));
+	writel(val, csid->base + CSID_RDI_CFG0(port));
 }
 
 static void csid_configure_stream(struct csid_device *csid, u8 enable)
@@ -213,11 +213,11 @@ static void csid_configure_stream(struct
 
 	__csid_configure_wrapper(csid);
 
-	/* Loop through all enabled VCs and configure stream for each */
+	/* Loop through all enabled ports and configure a stream for each */
 	for (i = 0; i < MSM_CSID_MAX_SRC_STREAMS; i++)
 		if (csid->phy.en_vc & BIT(i)) {
-			__csid_configure_rdi_stream(csid, enable, i);
-			__csid_configure_rx(csid, &csid->phy, i);
+			__csid_configure_rdi_stream(csid, enable, i, 0);
+			__csid_configure_rx(csid, &csid->phy, 0);
 			__csid_ctrl_rdi(csid, enable, i);
 		}
 }


