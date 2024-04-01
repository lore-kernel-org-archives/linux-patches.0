Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3051C0DE7;
	Mon,  1 Apr 2024 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990949; cv=none; b=ZZeQkELJw3HmEDm9rn2SDJOv2T1fmln9pbrHQZtGGEFWOq7vJfsIE0uw/XZgL89GDT8RFr2Z/kcDfVLH97feW55emOY6B05tsq243wE4sMTbFXWM7FW3C15Dj33bwhEctb4lr+lLakmHEk9YEOd0BXT3XUNTdXggyfR1RPAQErQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990949; c=relaxed/simple;
	bh=3ULS1fHPvT0t8tlj8hF1e6HZaCVfnCrEZZQB/skBJtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O96LJV/p8w4LVh4xKxFULOFS/wruZK2OMX2udvTFeQXcQBOFK4DjgIZPlJ3uuwZGSNWW/NdK/bDNa/PmK6uCyRPstH1D2+fHY9TcxBtzVpwJUglx8kYyj+Khs4lMX4f9EG8emD6kqzIZM1lEwjkespOVNw0kx7qdLA6+Ak4iXso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aepf8i6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aepf8i6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE674C433F1;
	Mon,  1 Apr 2024 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990949;
	bh=3ULS1fHPvT0t8tlj8hF1e6HZaCVfnCrEZZQB/skBJtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aepf8i6+clT4p8NkkSI1IahgCHV/0oX6r7tx+w3oJ6uJ24+g2SuG9KAEBBeCnA7o4
	 /HQVLRLUb0a61BhaZGNYZt6pg83dPVFm3I6doqsGxtdlZcIqLZNDpIhj/xvK33s72J
	 LR4XxuwMQrmQclU5onz1Huw7BohUOZqOig4oEvzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/272] phy: tegra: xusb: Add API to retrieve the port number of phy
Date: Mon,  1 Apr 2024 17:44:38 +0200
Message-ID: <20240401152533.370013869@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit d843f031d9e90462253015bc0bd9e3852d206bf2 ]

This patch introduces a new API, tegra_xusb_padctl_get_port_number,
to the Tegra XUSB Pad Controller driver. This API is used to identify
the USB port that is associated with a given PHY.

The function takes a PHY pointer for either a USB2 PHY or USB3 PHY as input
and returns the corresponding port number. If the PHY pointer is invalid,
it returns -ENODEV.

Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20240307030328.1487748-2-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/tegra/xusb.c       | 13 +++++++++++++
 include/linux/phy/tegra/xusb.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/phy/tegra/xusb.c b/drivers/phy/tegra/xusb.c
index 4d5b4071d47d5..dc22b1dd2c8ba 100644
--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -1518,6 +1518,19 @@ int tegra_xusb_padctl_get_usb3_companion(struct tegra_xusb_padctl *padctl,
 }
 EXPORT_SYMBOL_GPL(tegra_xusb_padctl_get_usb3_companion);
 
+int tegra_xusb_padctl_get_port_number(struct phy *phy)
+{
+	struct tegra_xusb_lane *lane;
+
+	if (!phy)
+		return -ENODEV;
+
+	lane = phy_get_drvdata(phy);
+
+	return lane->index;
+}
+EXPORT_SYMBOL_GPL(tegra_xusb_padctl_get_port_number);
+
 MODULE_AUTHOR("Thierry Reding <treding@nvidia.com>");
 MODULE_DESCRIPTION("Tegra XUSB Pad Controller driver");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phy/tegra/xusb.h b/include/linux/phy/tegra/xusb.h
index 70998e6dd6fdc..6ca51e0080ec0 100644
--- a/include/linux/phy/tegra/xusb.h
+++ b/include/linux/phy/tegra/xusb.h
@@ -26,6 +26,7 @@ void tegra_phy_xusb_utmi_pad_power_down(struct phy *phy);
 int tegra_phy_xusb_utmi_port_reset(struct phy *phy);
 int tegra_xusb_padctl_get_usb3_companion(struct tegra_xusb_padctl *padctl,
 					 unsigned int port);
+int tegra_xusb_padctl_get_port_number(struct phy *phy);
 int tegra_xusb_padctl_enable_phy_sleepwalk(struct tegra_xusb_padctl *padctl, struct phy *phy,
 					   enum usb_device_speed speed);
 int tegra_xusb_padctl_disable_phy_sleepwalk(struct tegra_xusb_padctl *padctl, struct phy *phy);
-- 
2.43.0



