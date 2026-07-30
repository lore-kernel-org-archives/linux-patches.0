Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22861FE44A;
	Thu, 30 Jul 2026 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422755; cv=none; b=cln6MOu5FolbW89hXNKHsvAPTEgIYK690fn7CIB55roM3LRsplc7zTzmanyddCB6HdyfFcmu/JFZpuNfR9Vn51WXX92o0MCLz25AgoEEH61F1JmvMAF74P/KpN7Aj55zpLgjJyzHnf2TZcBpOu1dMQkdIYVjpUFNVKzxv/K9rAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422755; c=relaxed/simple;
	bh=ihBh7Z0h7hVg5pjs/TXfQfb5gTLlHCJuoZZEQOkE8LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UawhqT1TRIyU+hAoMCAcfbeAYKQS5ltQyJvoxvgg9BA9TisxJvHD09i0Ap6QeWrkFHBufnpnVi1HnZuB2jBM6jeInlxRK/Hgr7en1NhnYMLVH1O7uIL33sbYwHpzBoBoQBer8QXJkpgOxOhBcFOiB3ZpXVas4FoJob2pnp1FvJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tkpa+Ord; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tkpa+Ord"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8371F000E9;
	Thu, 30 Jul 2026 14:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422753;
	bh=haV+aLctTrLz3CXkVMhS0hbc71bV4qXoF8tEgOx4wBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tkpa+Ord6Kv7MT5Er+YEMfNA7S4Q2BtPxjluQnCkxZ2QmVu2lfJ9FMWiPdyqRjD2w
	 OTQOIuUBOp8fu0zUqVhx7+u5ui5Hni+hR7XDwZ/Mu5QAzfSnCr1oyM0bi0fDodfjjH
	 yU1kn1xmQBi/t+tF/F1Q9ODA5CfrwbA2+bpX9yYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 7.1 508/744] media: qcom: camss: Fix RDI streaming for CSID GEN3
Date: Thu, 30 Jul 2026 16:13:01 +0200
Message-ID: <20260730141455.077750980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


