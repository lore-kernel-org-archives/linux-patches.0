Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C626C376466;
	Thu, 30 Jul 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422779; cv=none; b=Y8dW6ax3Z0WOIBOfExZvoYWjgjnxgfLZoSTHQkC1jcjR2lDBpc1FGkxnNcQ9SdZzWTzg+Xeh4MmERmBeJbTvYPLqZ10+PeqDdQwGJkUtWeh2XW1ILCmrMLabpPlM4+n8qxhVbj+jkk5uYmzu7JtYXfV4cExqAECx0JwRM21fEoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422779; c=relaxed/simple;
	bh=apErl9oQtYrv6okl0znovBR7C0yD0203083A62utZ14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+8teMoIifZ/xf69rNlr6GZeVdyT/ZUIioPuOogelHsAfbxpywKdqhgozgrO0L9lX31B8XrYgAo6VVZHfv6O1B7Z0dgg4geHMMLN9gYeTVfTE8upSZsq7Cda7wVfK6XkktKVq66wWoQ6Z8pSkCvlp98cVRV2rdP18J/knNQyI3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQXs1+/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQXs1+/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5271F000E9;
	Thu, 30 Jul 2026 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422777;
	bh=EVsmVmI5lMMZcuu1LTxNtT5J/JUwZzYf4fweugWCpc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQXs1+/cMsgeODUWcfsE3j04k+Xnk1Fx0eP7F31Cz4hJeRGnoCNy09F/8YMnNSJAK
	 QPWfufqEahh695EMNdoI+GCwRWYjfDTw8IBfFiGmgMiJDsAMc5nIpvnaRac9je/PFx
	 BqVCg5CyB8rs40R3U/nRfudmwDPeHSqS1vWnh0ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 7.1 509/744] media: qcom: camss: Fix RDI streaming for CSID 340
Date: Thu, 30 Jul 2026 16:13:02 +0200
Message-ID: <20260730141455.098479482@linuxfoundation.org>
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

commit cc1c35619c9895f918f9e388e3caa6ab2ff2fbe7 upstream.

Fix streaming from CSIDn RDI1 and RDI2 to VFEn RDI1 and RDI2. A pattern we
have replicated throughout CAMSS where we use the VC number to populate
both the VC fields and port fields of the CSID means that in practice only
VC = 0 on CSIDn:RDI0 to VFEn:RDI0 works.

Fix that for CSID 340 by separating VC and port. Fix to VC zero as a bugfix
we will look to properly populate the VC field with follow on patches
later.

Fixes: f0fc808a466a ("media: qcom: camss: Add CSID 340 support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-csid-340.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss-csid-340.c
+++ b/drivers/media/platform/qcom/camss/camss-csid-340.c
@@ -74,9 +74,9 @@ static void __csid_ctrl_rdi(struct csid_
 	writel_relaxed(!!enable, csid->base + CSID_RDI_CTRL(rdi));
 }
 
-static void __csid_configure_rdi_stream(struct csid_device *csid, u8 enable, u8 vc)
+static void __csid_configure_rdi_stream(struct csid_device *csid, u8 enable, u8 port, u8 vc)
 {
-	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + vc];
+	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + port];
 	const struct csid_format_info *format = csid_get_fmt_entry(csid->res->formats->formats,
 								   csid->res->formats->nformats,
 								   input_format->code);
@@ -88,14 +88,14 @@ static void __csid_configure_rdi_stream(
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
-	dt_id = vc & 0x03;
+	dt_id = port & 0x03;
 
 	val = CSID_RDI_CFG0_DECODE_FORMAT_NOP; /* only for RDI path */
 	val |= FIELD_PREP(CSID_RDI_CFG0_DT_MASK, format->data_type);
@@ -105,10 +105,11 @@ static void __csid_configure_rdi_stream(
 	if (enable)
 		val |= CSID_RDI_CFG0_ENABLE;
 
-	dev_dbg(csid->camss->dev, "CSID%u: Stream %s (dt:0x%x vc=%u)\n",
-		csid->id, enable ? "enable" : "disable", format->data_type, vc);
+	dev_dbg(csid->camss->dev, "CSID%u: Stream %s (dt:0x%x port=%u vc=%u)\n",
+		csid->id, enable ? "enable" : "disable", format->data_type,
+		port, vc);
 
-	writel_relaxed(val, csid->base + CSID_RDI_CFG0(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_CFG0(port));
 }
 
 static void csid_configure_stream(struct csid_device *csid, u8 enable)
@@ -117,9 +118,10 @@ static void csid_configure_stream(struct
 
 	__csid_configure_rx(csid, &csid->phy);
 
+	/* Loop through all enabled ports and configure a stream for each */
 	for (i = 0; i < MSM_CSID_MAX_SRC_STREAMS; i++) {
 		if (csid->phy.en_vc & BIT(i)) {
-			__csid_configure_rdi_stream(csid, enable, i);
+			__csid_configure_rdi_stream(csid, enable, i, 0);
 			__csid_ctrl_rdi(csid, enable, i);
 		}
 	}


