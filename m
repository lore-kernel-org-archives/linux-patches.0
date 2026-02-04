Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B7841B34E;
	Wed,  4 Feb 2026 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216889; cv=none; b=Sj1HGpBLoPrGVtJFAcJF1rbM7S2jMpDCHN0KstvRvyOKa6hdl+6hzeBmpsGTnz18YsQnwY5phm/a1WgLDlBMgsapcPAipyJKljL/FycgbCHuMBEed6KycR40ZIoemK1BfLCoLxoA2gZPruh5ClbTiEBDqj5Mb/I+72O890BXdCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216889; c=relaxed/simple;
	bh=TAmvoTHtwkOnA53lmXkZHpcJKU3LRm2JaYnq7mi/tb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUm9bwaac5s8/EnP5AIeoWx8JUG3h8+mAow/l8vk8alaguW6uM+TZrK3Ghcvom1XMSg+zwVz1lbZOYGPOpzo+wSul0zQ2x65qRv78wY6QBVAlmjpt57yD6SHys4+tuol8guxeV+7uOo9lp/ZA2T7In7WU71mvkeA0xCGEf3RYGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+yOhqW2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+yOhqW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E0EC4CEF7;
	Wed,  4 Feb 2026 14:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216888;
	bh=TAmvoTHtwkOnA53lmXkZHpcJKU3LRm2JaYnq7mi/tb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+yOhqW2paGeiz+SUFnrWamGwNlU2z79ZS6Dp/pkrW4CuCWp8wGMeNNNfD6QTOWV7
	 AsTu38P/YMsB4y1IVUGwW++RIi7uhU7kHRgLP0LyT23DbWEH4yXOayDXMYzgR/T+Gu
	 yZAjoSkf7VyT2vk+cndxTFBEoQR3Zc4TPlcU7DbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 028/206] phy: tegra: xusb: Explicitly configure HS_DISCON_LEVEL to 0x7
Date: Wed,  4 Feb 2026 15:37:39 +0100
Message-ID: <20260204143859.217687166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -601,6 +602,8 @@ static void tegra186_utmi_bias_pad_power
 	value &= ~BIAS_PAD_PD;
 	value &= ~HS_SQUELCH_LEVEL(~0);
 	value |= HS_SQUELCH_LEVEL(priv->calib.hs_squelch);
+	value &= ~HS_DISCON_LEVEL(~0);
+	value |= HS_DISCON_LEVEL(0x7);
 	padctl_writel(padctl, value, XUSB_PADCTL_USB2_BIAS_PAD_CTL0);
 
 	udelay(1);


