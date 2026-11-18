Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022451;
	b=v/jXZdqU+6BhpmvWYnYcp3JZP4fr10h2GC0yqT0juGXRrAywhgku2AwIz6N40nfVLVlb
	 2hynL/QjQ5e4sUIcuw9rRJ+Jqxr6zzuE0cRSMfnJnNUAMRDCG6fTo98tA/y9GUpW5UZAV
	 fZhmqdL951BMOgjFj9P1pF8c4ukKAMRL0a6kyiEwrO6o71FYuMfo1LDa7B0GrJ9bWIwGv
	 OvixeVE/n5cFMRRlZq12g1jOIcdx+wFDgy4PRuePcuEvJn+oQix70eRKagHMMnkc+7Trn
	 rrrxgKi0yzHX760uIIZPOOTXSYaCYFhjrGTnu+qIfEiMSD0iqneUsMYjDDlASXPohVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7WU8FzFEmXTY9nu4baZnTShp2PCm0nB0WkcTnfH+IXg=;
	b=MeXHrvUKdX/CwwvTj3CLWZODG/n4p/tOGuaUccuQbYy7eDUOzQOWfoZj2zQGo1ER2Sds
	 wW1SNns2+uiNVGNkvZeJr3MLeNKt39d3+lgS0a9Y3d5xrIyFHYvuEQd4ORb/cA+6YUnd4
	 blNpOeqLRdJ1KpE11Gqf3DlaiMYOvcAnQuxTbVLzrXE/ABBdo5BbgHzifhA+vd70t9VDV
	 kzJS3J4jBE/MGb+vhDGZAbFoE9w1pLDuzlp0Xk8ItOwZTUeNV7SkFRqjzGStN4uXnkV5U
	 Xry0veledKh8Dvugmbx4FZuGeYHwus6SP6gst43uodSxvqxBLsaCUQ57JxixejuGLiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gi043qoG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0273460A2606;
	Wed, 18 Nov 2026 17:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gi043qoG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4C91F000C4;
	Wed, 18 Nov 2026 17:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022450;
	bh=7WU8FzFEmXTY9nu4baZnTShp2PCm0nB0WkcTnfH+IXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gi043qoGwvNGjc6as66oInmhTjceqyPQZqw1w1GoAbtpX/SZO/F83KU3acx2/O0vn
	 yCpgiLRno3JZ/c1yiuK/6RFCmTWpIo7sE4i8s4QIqSN7PkaoKnrpi/f+0BKvaWtLQ/
	 9XxmuPFgE93CAqcDtF/mnf72IXbGVEC0JbP5dd/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0018/2151] PCI/pwrctrl: slot: Rename private struct and pointers for consistency
Date: Wed, 18 Nov 2026 15:29:13 +0100
Message-ID: <20261118150122.309792469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit e40d16e6c23994b28894179b87f9747edd63062a ]

Previously the pwrseq, tc9563, and slot pwrctrl drivers used different
naming conventions for their private data structs and pointers to them,
which makes patches hard to read.

Rename structs, variables, and functions to reduce boiler-plate and start
with "slot":

  struct pci_pwrctrl_slot_data      -> struct slot_pwrctrl
  struct pci_pwrctrl ctx            -> struct pci_pwrctrl pwrctrl
  pci_pwrctrl_slot_probe()          -> slot_pwrctrl_probe()
  pci_pwrctrl_slot_of_match[]       -> slot_pwrctrl_of_match[]
  pci_pwrctrl_slot_driver           -> slot_pwrctrl_driver
  devm_pci_pwrctrl_slot_power_off() -> devm_slot_pwrctrl_power_off()

No functional change intended.

[bhelgaas: move "slot" to beginning, also rename functions, etc]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260115-pci-pwrctrl-rework-v5-2-9d26da3ce903@oss.qualcomm.com
Stable-dep-of: ee450e3a2d33 ("PCI/pwrctrl: generic: Fix leaking array from of_regulator_bulk_get_all()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/slot.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/pwrctrl/slot.c b/drivers/pci/pwrctrl/slot.c
index 3320494b62d89..51de1eecdb26b 100644
--- a/drivers/pci/pwrctrl/slot.c
+++ b/drivers/pci/pwrctrl/slot.c
@@ -13,23 +13,23 @@
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 
-struct pci_pwrctrl_slot_data {
-	struct pci_pwrctrl ctx;
+struct slot_pwrctrl {
+	struct pci_pwrctrl pwrctrl;
 	struct regulator_bulk_data *supplies;
 	int num_supplies;
 };
 
-static void devm_pci_pwrctrl_slot_power_off(void *data)
+static void devm_slot_pwrctrl_power_off(void *data)
 {
-	struct pci_pwrctrl_slot_data *slot = data;
+	struct slot_pwrctrl *slot = data;
 
 	regulator_bulk_disable(slot->num_supplies, slot->supplies);
 	regulator_bulk_free(slot->num_supplies, slot->supplies);
 }
 
-static int pci_pwrctrl_slot_probe(struct platform_device *pdev)
+static int slot_pwrctrl_probe(struct platform_device *pdev)
 {
-	struct pci_pwrctrl_slot_data *slot;
+	struct slot_pwrctrl *slot;
 	struct device *dev = &pdev->dev;
 	struct clk *clk;
 	int ret;
@@ -53,7 +53,7 @@ static int pci_pwrctrl_slot_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = devm_add_action_or_reset(dev, devm_pci_pwrctrl_slot_power_off,
+	ret = devm_add_action_or_reset(dev, devm_slot_pwrctrl_power_off,
 				       slot);
 	if (ret)
 		return ret;
@@ -64,31 +64,31 @@ static int pci_pwrctrl_slot_probe(struct platform_device *pdev)
 				     "Failed to enable slot clock\n");
 	}
 
-	pci_pwrctrl_init(&slot->ctx, dev);
+	pci_pwrctrl_init(&slot->pwrctrl, dev);
 
-	ret = devm_pci_pwrctrl_device_set_ready(dev, &slot->ctx);
+	ret = devm_pci_pwrctrl_device_set_ready(dev, &slot->pwrctrl);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to register pwrctrl driver\n");
 
 	return 0;
 }
 
-static const struct of_device_id pci_pwrctrl_slot_of_match[] = {
+static const struct of_device_id slot_pwrctrl_of_match[] = {
 	{
 		.compatible = "pciclass,0604",
 	},
 	{ }
 };
-MODULE_DEVICE_TABLE(of, pci_pwrctrl_slot_of_match);
+MODULE_DEVICE_TABLE(of, slot_pwrctrl_of_match);
 
-static struct platform_driver pci_pwrctrl_slot_driver = {
+static struct platform_driver slot_pwrctrl_driver = {
 	.driver = {
 		.name = "pci-pwrctrl-slot",
-		.of_match_table = pci_pwrctrl_slot_of_match,
+		.of_match_table = slot_pwrctrl_of_match,
 	},
-	.probe = pci_pwrctrl_slot_probe,
+	.probe = slot_pwrctrl_probe,
 };
-module_platform_driver(pci_pwrctrl_slot_driver);
+module_platform_driver(slot_pwrctrl_driver);
 
 MODULE_AUTHOR("Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>");
 MODULE_DESCRIPTION("Generic PCI Power Control driver for PCI Slots");
-- 
2.53.0



