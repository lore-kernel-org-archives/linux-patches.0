Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAF333B945;
	Wed, 21 Jan 2026 18:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020293; cv=none; b=J8g5bCIwU9qdHi69SifrgQQV99Ho/ICu7PYsPBZ5mMoHQog80OmPqrKLS0aAxoCYGC5GYQbQpU9oNXrNdf6//AJ1W1JIRtRDR9iid9/TRC3HLaPfSIs6cPr710GGsImtq8DqYJoZ3R3CAHRLkHPTk40wJ3UpZSLTQ++BuMV3tLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020293; c=relaxed/simple;
	bh=xTj7JxwrCL9vYMlTzlXKulmTPpji20XIYxfLAl8R3lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLr7HyNWGncM0S8OImiM5GdTpdeKkBRwHG2w8OYp8dUGM/nFYE4L5YntBlDdqUKQH7UqJnk5FLz3h3CqTcH8sOQ2BJrF7FYJCxqTycys0Y4y3t09T7dkHa/c6LTuqrbLu93my9a3QXIRMTHkcKNe2w4bgEo+CU/t4zeuJan932I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zn3dHnMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zn3dHnMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D08EC4CEF1;
	Wed, 21 Jan 2026 18:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020292;
	bh=xTj7JxwrCL9vYMlTzlXKulmTPpji20XIYxfLAl8R3lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zn3dHnMiylOJ++sJMmN9UXVKVjlZs5T1gxGVknYAObasb6zS+I7ZRTItiKfQtxXDJ
	 pdNKBwsQ2bKxWHri9MfTsuMKz+BBqtOqF9mZDo/kNwKEyTNRsFk9w4lnl5PRUh6lzf
	 CPMmt2WpBlv1F7iLLEe0tqc7TmZvfXUb24QAXgeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 116/198] phy: tegra: xusb: Explicitly configure HS_DISCON_LEVEL to 0x7
Date: Wed, 21 Jan 2026 19:15:44 +0100
Message-ID: <20260121181422.727885876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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


