Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0290B29B8E1;
	Wed, 28 Jan 2026 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614198; cv=none; b=Af8F2RNv5HxeOksyETmY5o+/9YiUzFl0nqVaWQ7AORR40I6c8EjF3VFXstt7qTxUMu8bv0l2uCwR1teMMnimwhDDfr1HZCabEvPMlPEaKi0wDfpSvbKCSoKXUOki1RcU+jNBlF9BNPG2R8mdx7wFDsdkIju1iKKgKBdrqfvDhkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614198; c=relaxed/simple;
	bh=/f8CPOR4jvR2U86wwkooz471uixLii5AQZoEV3JDdF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUqUtU6idHS/lKQFASSJ4Z72Mi7oekUGfiZU/gU4RzkA/xQN9ZZM212Nhso8shV8bWbMoUFKtQKEpRPlqJOu0FwCq8jklZdqZukPAiNbddYRN401877NuSqzM2RbfLDfiVkvxKerhhu5q41HqTzMmJ5QPdBLLMDt60n4mkvDFVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSzv3XDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSzv3XDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6A4C4CEF1;
	Wed, 28 Jan 2026 15:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614197;
	bh=/f8CPOR4jvR2U86wwkooz471uixLii5AQZoEV3JDdF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSzv3XDVc08//7lyGrerBcw74xOQdxTnN0+xdqDuh1ewLhmdbVE+ifrKZpB6ofF0U
	 vGLmecDX9ZG7W1i6vq2PsviG6g8OSK3xL+9j08s9ZN5gPih93OmjXdCtXTAhJcgns9
	 dCbzHiI6P983ypY/XvPQCh9pI7dQ+8nbbqQ5+Rf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/254] phy: drop probe registration printks
Date: Wed, 28 Jan 2026 16:20:13 +0100
Message-ID: <20260128145346.037239351@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 95463cbb4fe6489921fb8c72890113dca54ce83f ]

Drivers should generally be quiet on successful probe, but this is not
followed by some PHY drivers, for example:

	snps-eusb2-hsphy 88e1000.phy: Registered Snps-eUSB2 phy
	qcom-eusb2-repeater c432000.spmi:pmic@7:phy@fd00: Registered Qcom-eUSB2 repeater
	qcom-eusb2-repeater c432000.spmi:pmic@a:phy@fd00: Registered Qcom-eUSB2 repeater
	qcom-eusb2-repeater c432000.spmi:pmic@b:phy@fd00: Registered Qcom-eUSB2 repeater
	snps-eusb2-hsphy fd3000.phy: Registered Snps-eUSB2 phy
	snps-eusb2-hsphy fd9000.phy: Registered Snps-eUSB2 phy
	snps-eusb2-hsphy fde000.phy: Registered Snps-eUSB2 phy
	snps-eusb2-hsphy 88e0000.phy: Registered Snps-eUSB2 phy
	snps-eusb2-hsphy 88e2000.phy: Registered Snps-eUSB2 phy

Drop (or demote to debug level) unnecessary registration info messages
to make boot logs a little less noisy.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250523085112.11287-1-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 1ca52c0983c3 ("phy: qcom-qusb2: Fix NULL pointer dereference on early suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-bcm-ns2-pcie.c        | 2 --
 drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c      | 1 -
 drivers/phy/broadcom/phy-bcm-sr-pcie.c         | 2 --
 drivers/phy/broadcom/phy-brcm-sata.c           | 2 +-
 drivers/phy/marvell/phy-pxa-usb.c              | 1 -
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c | 2 --
 drivers/phy/qualcomm/phy-qcom-m31.c            | 2 --
 drivers/phy/qualcomm/phy-qcom-qusb2.c          | 4 +---
 drivers/phy/qualcomm/phy-qcom-snps-eusb2.c     | 2 --
 drivers/phy/st/phy-stih407-usb.c               | 2 --
 drivers/phy/st/phy-stm32-usbphyc.c             | 4 ++--
 drivers/phy/ti/phy-twl4030-usb.c               | 1 -
 12 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/phy/broadcom/phy-bcm-ns2-pcie.c b/drivers/phy/broadcom/phy-bcm-ns2-pcie.c
index 2eaa41f8fc70c..67a6ae5ecba02 100644
--- a/drivers/phy/broadcom/phy-bcm-ns2-pcie.c
+++ b/drivers/phy/broadcom/phy-bcm-ns2-pcie.c
@@ -61,8 +61,6 @@ static int ns2_pci_phy_probe(struct mdio_device *mdiodev)
 		return PTR_ERR(provider);
 	}
 
-	dev_info(dev, "%s PHY registered\n", dev_name(dev));
-
 	return 0;
 }
 
diff --git a/drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c b/drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c
index 36ad02c33ac55..8473fa5745296 100644
--- a/drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c
+++ b/drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c
@@ -395,7 +395,6 @@ static int ns2_drd_phy_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, driver);
 
-	dev_info(dev, "Registered NS2 DRD Phy device\n");
 	queue_delayed_work(system_power_efficient_wq, &driver->wq_extcon,
 			   driver->debounce_jiffies);
 
diff --git a/drivers/phy/broadcom/phy-bcm-sr-pcie.c b/drivers/phy/broadcom/phy-bcm-sr-pcie.c
index 8a4aadf166cf9..c85af65086773 100644
--- a/drivers/phy/broadcom/phy-bcm-sr-pcie.c
+++ b/drivers/phy/broadcom/phy-bcm-sr-pcie.c
@@ -277,8 +277,6 @@ static int sr_pcie_phy_probe(struct platform_device *pdev)
 		return PTR_ERR(provider);
 	}
 
-	dev_info(dev, "Stingray PCIe PHY driver initialized\n");
-
 	return 0;
 }
 
diff --git a/drivers/phy/broadcom/phy-brcm-sata.c b/drivers/phy/broadcom/phy-brcm-sata.c
index ed9e18791ec94..6838cb76e8268 100644
--- a/drivers/phy/broadcom/phy-brcm-sata.c
+++ b/drivers/phy/broadcom/phy-brcm-sata.c
@@ -836,7 +836,7 @@ static int brcm_sata_phy_probe(struct platform_device *pdev)
 		return PTR_ERR(provider);
 	}
 
-	dev_info(dev, "registered %d port(s)\n", count);
+	dev_dbg(dev, "registered %d port(s)\n", count);
 
 	return 0;
 put_child:
diff --git a/drivers/phy/marvell/phy-pxa-usb.c b/drivers/phy/marvell/phy-pxa-usb.c
index 6c98eb9608e9c..c0bb71f80c042 100644
--- a/drivers/phy/marvell/phy-pxa-usb.c
+++ b/drivers/phy/marvell/phy-pxa-usb.c
@@ -325,7 +325,6 @@ static int pxa_usb_phy_probe(struct platform_device *pdev)
 		phy_create_lookup(pxa_usb_phy->phy, "usb", "mv-otg");
 	}
 
-	dev_info(dev, "Marvell PXA USB PHY");
 	return 0;
 }
 
diff --git a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
index a43e20abb10d5..ad7bf049d7263 100644
--- a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
+++ b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
@@ -251,8 +251,6 @@ static int eusb2_repeater_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider))
 		return PTR_ERR(phy_provider);
 
-	dev_info(dev, "Registered Qcom-eUSB2 repeater\n");
-
 	return 0;
 }
 
diff --git a/drivers/phy/qualcomm/phy-qcom-m31.c b/drivers/phy/qualcomm/phy-qcom-m31.c
index a5e60039a264a..116cfa6ddac6f 100644
--- a/drivers/phy/qualcomm/phy-qcom-m31.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31.c
@@ -267,8 +267,6 @@ static int m31usb_phy_probe(struct platform_device *pdev)
 	phy_set_drvdata(qphy->phy, qphy);
 
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	if (!IS_ERR(phy_provider))
-		dev_info(dev, "Registered M31 USB phy\n");
 
 	return PTR_ERR_OR_ZERO(phy_provider);
 }
diff --git a/drivers/phy/qualcomm/phy-qcom-qusb2.c b/drivers/phy/qualcomm/phy-qcom-qusb2.c
index c52655a383cef..531c3860c3160 100644
--- a/drivers/phy/qualcomm/phy-qcom-qusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-qusb2.c
@@ -1084,9 +1084,7 @@ static int qusb2_phy_probe(struct platform_device *pdev)
 	phy_set_drvdata(generic_phy, qphy);
 
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	if (!IS_ERR(phy_provider))
-		dev_info(dev, "Registered Qcom-QUSB2 phy\n");
-	else
+	if (IS_ERR(phy_provider))
 		pm_runtime_disable(dev);
 
 	return PTR_ERR_OR_ZERO(phy_provider);
diff --git a/drivers/phy/qualcomm/phy-qcom-snps-eusb2.c b/drivers/phy/qualcomm/phy-qcom-snps-eusb2.c
index e1b175f481b4e..4a1dfef5ff8ff 100644
--- a/drivers/phy/qualcomm/phy-qcom-snps-eusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-snps-eusb2.c
@@ -418,8 +418,6 @@ static int snps_eusb2_hsphy_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider))
 		return PTR_ERR(phy_provider);
 
-	dev_info(dev, "Registered Snps-eUSB2 phy\n");
-
 	return 0;
 }
 
diff --git a/drivers/phy/st/phy-stih407-usb.c b/drivers/phy/st/phy-stih407-usb.c
index a4ae2cca7f637..02e6117709dca 100644
--- a/drivers/phy/st/phy-stih407-usb.c
+++ b/drivers/phy/st/phy-stih407-usb.c
@@ -149,8 +149,6 @@ static int stih407_usb2_picophy_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider))
 		return PTR_ERR(phy_provider);
 
-	dev_info(dev, "STiH407 USB Generic picoPHY driver probed!");
-
 	return 0;
 }
 
diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index d5e7e44000b56..f8374a7f3a655 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -757,8 +757,8 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 	}
 
 	version = readl_relaxed(usbphyc->base + STM32_USBPHYC_VERSION);
-	dev_info(dev, "registered rev:%lu.%lu\n",
-		 FIELD_GET(MAJREV, version), FIELD_GET(MINREV, version));
+	dev_dbg(dev, "registered rev: %lu.%lu\n",
+		FIELD_GET(MAJREV, version), FIELD_GET(MINREV, version));
 
 	return 0;
 
diff --git a/drivers/phy/ti/phy-twl4030-usb.c b/drivers/phy/ti/phy-twl4030-usb.c
index 6b265992d988f..e5918d3b486cc 100644
--- a/drivers/phy/ti/phy-twl4030-usb.c
+++ b/drivers/phy/ti/phy-twl4030-usb.c
@@ -784,7 +784,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_put_autosuspend(twl->dev);
 
-	dev_info(&pdev->dev, "Initialized TWL4030 USB module\n");
 	return 0;
 }
 
-- 
2.51.0



