Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BBF315D48;
	Wed, 21 Jan 2026 18:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019683; cv=none; b=Xzt4p7Eh2mIlfq1tvQWE2O1gyyEncZcTETvzJXDLIliHdk9K7U6JVYwcOay6VwCZwDw5wveKL87fDV0ZQrOnfWvl5qUEwI4mA7KP1XZYUtWoxNUdwk6H6rES424+Rzj0+vnyFf5O6RYBApqqRS2wgsRx3FQKEtXOtIQ6SfEAzDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019683; c=relaxed/simple;
	bh=goQQ6UVPoeeJVBR+wUzjnhAPsk93VcVMxgY5FRq18nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASr3sq6hh0YTE7MckEb9RywpfoQQc9XphzzNE+mLOm69fJqOx9DpHcORa3MC0+tp2kIa7iKzeqgqS4DLqk0aXMaICUmSOnOPmRRR9+WnQm3/yhyFBeyBiHlrVlZ5qQey+hki7nCPHHq6ARcUdmeLZO4xs+1f6eFklcm/bnArtoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKASgxVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKASgxVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31CEC4CEF1;
	Wed, 21 Jan 2026 18:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019683;
	bh=goQQ6UVPoeeJVBR+wUzjnhAPsk93VcVMxgY5FRq18nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKASgxVET5GF1In0z3WyA3DF+c6qHpVnC4VVsiOkYZt5RlR4nEfPtC8XG9OLtBRXZ
	 Az7SXba6jP1ZaWRnARuPEwjlC6/IPtoHOXaUndNjnxhVKcZckbBVs6dIA5MxhOraxh
	 o86JXDaq7ljTEd2v3l6KcQg83YY2k9KuAR+6qj3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 077/139] phy: tegra: xusb: Explicitly configure HS_DISCON_LEVEL to 0x7
Date: Wed, 21 Jan 2026 19:15:25 +0100
Message-ID: <20260121181414.225194649@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Chang <waynec@nvidia.com>

commit b246caa68037aa495390a60d080acaeb84f45fff upstream.

The USB2 Bias Pad Control register manages analog parameters for signal
detection. Previously, the HS_DISCON_LEVEL relied on hardware reset
values, which may lead to the detection failure.

Explicitly configure HS_DISCON_LEVEL to 0x7. This ensures the disconnect
threshold is sufficient to guarantee reliable detection.

Fixes: bbf711682cd5 ("phy: tegra: xusb: Add Tegra186 support")
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://patch.msgid.link/20251212032116.768307-1-waynec@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra186.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/phy/tegra/xusb-tegra186.c
+++ b/drivers/phy/tegra/xusb-tegra186.c
@@ -84,6 +84,7 @@
 #define XUSB_PADCTL_USB2_BIAS_PAD_CTL0		0x284
 #define  BIAS_PAD_PD				BIT(11)
 #define  HS_SQUELCH_LEVEL(x)			(((x) & 0x7) << 0)
+#define  HS_DISCON_LEVEL(x)			(((x) & 0x7) << 3)
 
 #define XUSB_PADCTL_USB2_BIAS_PAD_CTL1		0x288
 #define  USB2_TRK_START_TIMER(x)		(((x) & 0x7f) << 12)
@@ -623,6 +624,8 @@ static void tegra186_utmi_bias_pad_power
 	value &= ~BIAS_PAD_PD;
 	value &= ~HS_SQUELCH_LEVEL(~0);
 	value |= HS_SQUELCH_LEVEL(priv->calib.hs_squelch);
+	value &= ~HS_DISCON_LEVEL(~0);
+	value |= HS_DISCON_LEVEL(0x7);
 	padctl_writel(padctl, value, XUSB_PADCTL_USB2_BIAS_PAD_CTL0);
 
 	udelay(1);


