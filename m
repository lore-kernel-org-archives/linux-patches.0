Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A9F14A091;
	Tue, 25 Jun 2024 09:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308303; cv=none; b=KoCcZb80XbgGR2Tki3bHEVdZqzINWsEC+HBL+SNQo4wq8HqqWYrJvNMwM3/JDybMha35EskS1njH7LbE5jsev+9SWKT7TsBVvNwFVAZTLpE/Uedq9ReVitHqlbpNVdbGpPmfk51PwG36FJShRwibjt5uxycipTF0kSv4oEcxjJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308303; c=relaxed/simple;
	bh=NgvyxTvLHBG0BjcLUIxdtmnBmgcIN/5kkKS93PBX4Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUxqhbGkWcjSdQcNDBNSkEMplN4Jup54buDjhnRRlxi/yQoK0hH1ENopvuzdbg8vJ7nT8s+jme2G34Vpc3J6exgNfelM0JLT/Dk8mn80iBzzGVQesgsJE7/tKMs2bEBc3kd+H/le7WYApPWJXpa2dv/GWBBqh38KOKfAAVK4hRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxZ9LnJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxZ9LnJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319AEC32786;
	Tue, 25 Jun 2024 09:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308303;
	bh=NgvyxTvLHBG0BjcLUIxdtmnBmgcIN/5kkKS93PBX4Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxZ9LnJCwAF4k1Ye9XXsXaYKVATtsaGhOnWYXSSiiu43tM7bTOoZA3Lb9bCCmhbuz
	 uLfqd5hQ1nMWbbHyyXVx9JRGgC/th8FOHYB8hoDHxqw2cqwCwZugZItKKdvZsX2BKd
	 8VhiNmKhk4hViYJ38VJhN4o0K1a3jLIfFzrRvbZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 076/250] usb: dwc3: pci: Dont set "linux,phy_charger_detect" property on Lenovo Yoga Tab2 1380
Date: Tue, 25 Jun 2024 11:30:34 +0200
Message-ID: <20240625085550.983183543@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0fb782b5d5c462b2518b3b4fe7d652114c28d613 ]

The Lenovo Yoga Tablet 2 Pro 1380 model is the exception to the rule that
devices which use the Crystal Cove PMIC without using ACPI for battery and
AC power_supply class support use the USB-phy for charger detection.

Unlike the Lenovo Yoga Tablet 2 830 / 1050 models this model has an extra
LC824206XA Micro USB switch which does the charger detection.

Add a DMI quirk to not set the "linux,phy_charger_detect" property on
the 1380 model. This quirk matches on the BIOS version to differentiate
the 1380 model from the 830 and 1050 models which otherwise have
the same DMI strings.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240406140127.17885-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 497deed38c0c1..9ef821ca2fc71 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -8,6 +8,7 @@
  *	    Sebastian Andrzej Siewior <bigeasy@linutronix.de>
  */
 
+#include <linux/dmi.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -220,6 +221,7 @@ static int dwc3_pci_quirks(struct dwc3_pci *dwc,
 
 		if (pdev->device == PCI_DEVICE_ID_INTEL_BYT) {
 			struct gpio_desc *gpio;
+			const char *bios_ver;
 			int ret;
 
 			/* On BYT the FW does not always enable the refclock */
@@ -277,8 +279,12 @@ static int dwc3_pci_quirks(struct dwc3_pci *dwc,
 			 * detection. These can be identified by them _not_
 			 * using the standard ACPI battery and ac drivers.
 			 */
+			bios_ver = dmi_get_system_info(DMI_BIOS_VERSION);
 			if (acpi_dev_present("INT33FD", "1", 2) &&
-			    acpi_quirk_skip_acpi_ac_and_battery()) {
+			    acpi_quirk_skip_acpi_ac_and_battery() &&
+			    /* Lenovo Yoga Tablet 2 Pro 1380 uses LC824206XA instead */
+			    !(bios_ver &&
+			      strstarts(bios_ver, "BLADE_21.X64.0005.R00.1504101516"))) {
 				dev_info(&pdev->dev, "Using TUSB1211 phy for charger detection\n");
 				swnode = &dwc3_pci_intel_phy_charger_detect_swnode;
 			}
-- 
2.43.0



