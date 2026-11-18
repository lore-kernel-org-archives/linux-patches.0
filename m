Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017135;
	b=Gli9BO/E9crpKY8EZx0iR46o8m6PmN5drK5IIkJJdVDUP6U+xgMcmBRWCyaugGHI1v/H
	 3vSFmm1lO5fH+jHoAtrlW2EetgpMmEzhFjV2QwjGosiTM9k8Zbwo05bgFoGF1z0bI3OQl
	 3HwsnBHSrqyPgBVx3PU6q/oZ+sDOnew2t6H/xktKAJ5wT+TH4naWViIOST7c1qBULfrP0
	 y+syKdGU6P5yiVK0N1zPvPXK5I+Y+pFJzYC2UUa7pokulVbhI5yXNhUg9EFrUHe0+Br8/
	 PxSQQctYpaDUJdwxOJMoJQ5iR40ZiyZa5GinnsxSPAFJ2pN9DdonPTGoNL/p1zCcr4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n/IB86FcfdBU6npwjUMOm+Vax5T8ZgGnmxm1+YF8Nhs=;
	b=XuWekjoMUHYDpX/Wf1CAacsoWH0Vc5fD9pkUm4vTjCQfiCvY4XhJpdcuNE3I1fSWgWcg
	 F/I5Pefhd5TNCXdkbKjG5ZO3lsStIRsAsT9a5vu2EJB5g/gR5g0wRGekO+dl5VjuPxVao
	 VJoHAcNYQB/DaQ/yMF1M3LVcf1kqmMceVE9j2MM7WEHUtcDbBLPSccoYxNiN1wLG2qeU3
	 s5dWAVwZ7HvCOOWwQduUApWBZswQ7mgeR87p3K3DJlquxa8QN/Em+NvXokyIf/s3q8Jd1
	 94hnH3UfVmlZispF5LWU5fu70iva/YcZF/1X7PXEaddUnDl93soRXS2YkKLt2FMteXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZo8XsYI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F82D606A31C;
	Wed, 18 Nov 2026 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZo8XsYI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A1A1F000C4;
	Wed, 18 Nov 2026 15:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017135;
	bh=n/IB86FcfdBU6npwjUMOm+Vax5T8ZgGnmxm1+YF8Nhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZo8XsYIbXP3dS9BXDZNgIQnIoz5hUCQhFb2s4GimY3K/cU4cICeMtqoPt8V9+ZjX
	 7I4TMo0X7pGV8reFqn/xri1d219sNAdfs7w48jRCTJqC38HmPL3Q1k7ZNXl9cvYNH6
	 5REQzePWy3PGcZRHDY2DYygJ9pgCQr5nvySVZZyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0774/2651] mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock
Date: Wed, 18 Nov 2026 15:33:34 +0100
Message-ID: <20261118150315.755710119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 14a7cf1a3730c7c2393ef5a226e90baf61aa8a9f ]

The I2C clock is allocated by clk_register_fixed_rate(), but cleanup uses
clk_unregister(), leaving the fixed-rate provider allocation behind.

Manage the provider with devm_clk_hw_register_fixed_rate() and its lookup
with devm_clk_hw_register_clkdev(). Managed resources release the lookup
before the provider, after the MFD children have been removed.

Remove the manual clock cleanup and the private structure that only
stored the clock and lookup pointers.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 60ae5b9f5cdd ("mfd: intel_quark_i2c_gpio: Add Intel Quark X1000 I2C-GPIO MFD Driver")
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260912191223.46136-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_quark_i2c_gpio.c | 52 ++++--------------------------
 1 file changed, 6 insertions(+), 46 deletions(-)

diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
index 9b9c76bd067b8..443a1a0cf7778 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -35,11 +35,6 @@
 /* The Quark I2C controller source clock */
 #define INTEL_QUARK_I2C_CLK_HZ	33000000
 
-struct intel_quark_mfd {
-	struct clk		*i2c_clk;
-	struct clk_lookup	*i2c_clk_lookup;
-};
-
 static const struct property_entry intel_quark_i2c_controller_standard_properties[] = {
 	PROPERTY_ENTRY_U32("clock-frequency", I2C_MAX_STANDARD_MODE_FREQ),
 	{ }
@@ -160,37 +155,12 @@ MODULE_DEVICE_TABLE(pci, intel_quark_mfd_ids);
 
 static int intel_quark_register_i2c_clk(struct device *dev)
 {
-	struct intel_quark_mfd *quark_mfd = dev_get_drvdata(dev);
-	struct clk *i2c_clk;
-
-	i2c_clk = clk_register_fixed_rate(dev,
-					  INTEL_QUARK_I2C_CONTROLLER_CLK, NULL,
-					  0, INTEL_QUARK_I2C_CLK_HZ);
-	if (IS_ERR(i2c_clk))
-		return PTR_ERR(i2c_clk);
-
-	quark_mfd->i2c_clk = i2c_clk;
-	quark_mfd->i2c_clk_lookup = clkdev_create(i2c_clk, NULL,
-						INTEL_QUARK_I2C_CONTROLLER_CLK);
-
-	if (!quark_mfd->i2c_clk_lookup) {
-		clk_unregister(quark_mfd->i2c_clk);
-		dev_err(dev, "Fixed clk register failed\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void intel_quark_unregister_i2c_clk(struct device *dev)
-{
-	struct intel_quark_mfd *quark_mfd = dev_get_drvdata(dev);
-
-	if (!quark_mfd->i2c_clk_lookup)
-		return;
+	struct clk_hw *hw;
 
-	clkdev_drop(quark_mfd->i2c_clk_lookup);
-	clk_unregister(quark_mfd->i2c_clk);
+	hw = devm_clk_hw_register_fixed_rate(dev, INTEL_QUARK_I2C_CONTROLLER_CLK,
+					     NULL, 0, INTEL_QUARK_I2C_CLK_HZ);
+	return devm_clk_hw_register_clkdev(dev, hw, NULL,
+					 INTEL_QUARK_I2C_CONTROLLER_CLK);
 }
 
 static int intel_quark_i2c_setup(struct pci_dev *pdev)
@@ -238,19 +208,12 @@ static int intel_quark_gpio_setup(struct pci_dev *pdev)
 static int intel_quark_mfd_probe(struct pci_dev *pdev,
 				 const struct pci_device_id *id)
 {
-	struct intel_quark_mfd *quark_mfd;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
 	if (ret)
 		return ret;
 
-	quark_mfd = devm_kzalloc(&pdev->dev, sizeof(*quark_mfd), GFP_KERNEL);
-	if (!quark_mfd)
-		return -ENOMEM;
-
-	dev_set_drvdata(&pdev->dev, quark_mfd);
-
 	ret = intel_quark_register_i2c_clk(&pdev->dev);
 	if (ret)
 		return ret;
@@ -260,7 +223,7 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 	/* This driver only requires 1 IRQ vector */
 	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
 	if (ret < 0)
-		goto err_unregister_i2c_clk;
+		return ret;
 
 	ret = intel_quark_i2c_setup(pdev);
 	if (ret)
@@ -282,8 +245,6 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 	software_node_unregister_node_group(intel_quark_gpio_node_group);
 err_free_irq_vectors:
 	pci_free_irq_vectors(pdev);
-err_unregister_i2c_clk:
-	intel_quark_unregister_i2c_clk(&pdev->dev);
 	return ret;
 }
 
@@ -292,7 +253,6 @@ static void intel_quark_mfd_remove(struct pci_dev *pdev)
 	mfd_remove_devices(&pdev->dev);
 	software_node_unregister_node_group(intel_quark_gpio_node_group);
 	pci_free_irq_vectors(pdev);
-	intel_quark_unregister_i2c_clk(&pdev->dev);
 }
 
 static struct pci_driver intel_quark_mfd_driver = {
-- 
2.53.0



