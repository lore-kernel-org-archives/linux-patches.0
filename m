Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B603976BA;
	Sat, 17 Oct 2026 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253310; cv=none; b=DbBPm96p3iU9nTKQBRdFOr+XKwYHYAaXU3AuFUdxrcACk+uWt5JHm/VxzHJNSsXc/qPGNM6WoS3F32Eeh888HierVDvLz1/fVhTkcWON1/3fw3SZG03Z8YK3DOnKX0pZHt3ehGz57SLJDFwFKXxf0ndtGInLXqheYaV9pNzh+oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253310; c=relaxed/simple;
	bh=+cf4ZKt4vvrbttWoLTRG3izkN/CiINN1cVyVyJVfxd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b3xMwOoQc9Fz5vaotRX4MMJXhNlMLdrQSfoS3K1qJo/f5e43fxTmHE2cBfJJK6Q9FDeF03B+b8CmUQOCpn42JDHd1058sS1lop2jObXDt2S7ovjizS6mueR3euEJsSm5gcuvwr8x7CrNm67ebeB2QgraTc454KbB+0wUB1mC04I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQ4cYLHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQ4cYLHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A6B1F000C4;
	Sat, 17 Oct 2026 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253305;
	bh=KioDB5qW+J+gcDm4IbRfwDJ+ifP+udo8VJWeZcjdjhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQ4cYLHR50BvkqkVa/uiUUNyBs7Y4O2MggKz8rb2z4sIt4bfC9IiTuhG2CBcqcYqd
	 NpLQzCus9X6YPoX8l9Dn6WAlym1H6J+7dMKRQ0kzUdctL81BZzSjirtjH1WqJ86G6M
	 rRDDXuI4PPkKJshIfkp+WSWnNeB2CbGHsyl8At5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/869] PCI/pwrctl: Use of_platform_device_create() to create pwrctl devices
Date: Sat, 17 Oct 2026 17:48:37 +0200
Message-ID: <20261017160038.974684936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 7582fe07f4ca4c560eb47800b640997f06a8baa2 ]

The of_platform_populate() API creates platform devices by descending
through the children of the parent node. But it provides no control over
the child nodes, which makes it difficult to add checks for the child
nodes in the future.

Use of_platform_device_create() and for_each_child_of_node_scoped() to make
it possible to add checks for each node before creating the platform
device.

Link: https://lore.kernel.org/r/20241025-pci-pwrctl-rework-v2-1-568756156cbe@linaro.org
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Tested-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 8b926f237743 ("PCI/pwrctrl: Cancel outstanding rescan work when unregistering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/bus.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index bdb3e10f947a1..aa11262857166 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -13,6 +13,7 @@
 #include <linux/ioport.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/platform_device.h>
 #include <linux/proc_fs.h>
 #include <linux/slab.h>
 
@@ -329,6 +330,7 @@ void __weak pcibios_bus_add_device(struct pci_dev *pdev) { }
 void pci_bus_add_device(struct pci_dev *dev)
 {
 	struct device_node *dn = dev->dev.of_node;
+	struct platform_device *pdev;
 	int retval;
 
 	/*
@@ -354,11 +356,11 @@ void pci_bus_add_device(struct pci_dev *dev)
 	pci_dev_assign_added(dev, true);
 
 	if (dev_of_node(&dev->dev) && pci_is_bridge(dev)) {
-		retval = of_platform_populate(dev_of_node(&dev->dev), NULL, NULL,
-					      &dev->dev);
-		if (retval)
-			pci_err(dev, "failed to populate child OF nodes (%d)\n",
-				retval);
+		for_each_available_child_of_node_scoped(dn, child) {
+			pdev = of_platform_device_create(child, NULL, &dev->dev);
+			if (!pdev)
+				pci_err(dev, "failed to create OF node: %s\n", child->name);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
-- 
2.53.0



