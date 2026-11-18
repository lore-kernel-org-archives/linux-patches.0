Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055329;
	b=oyNCUShhloU0F2y+nndDY9CyCYJoopXrQxhUcjDKuWk5vAlvMFBeotCq4qITjnbT0jaO
	 uxHQO9X9o6tre9CHb0sl5qsWovjNnu8zhPfKx1ji7ff/rwa0t0bq8OBT1WIlJc4yeBT2P
	 u373+Gq1KITyIjtzzR9OClm5RfWNVndIwyiwot7DbMDQ8T0eAauSqYKMhDc8+XiNMswE9
	 f0lYKmhfolpz1AwHQJGpxJMBQCetcEYAh7j296uL9Dsor49xbnsjOoFKPRusNLtc9Qndk
	 35Vac+z+TtwzKuA4WaVCPDiglJEgaP8RHhPTLLP1984N2u2mF+J/eQkAo7g38TmYobw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yl9LsCxoSHeUC5OPAq9mj5zTolbBA5njdDjJ+uBrLak=;
	b=dW7ovThVtZUrL4k7I7XsyOTX6hvwM/v1oFPzv1izu8g8EwsjsgolrxjaZhjGUYNl8a/y
	 l2KSVYw1vlmQp1g8dekKhgUIomtSr+Q/sgOK+EvekvBhZiX+ovgu2wBsVSCLcGMPeI5MY
	 uWFi+nVVgsceyvNjvHBC4SiRfLD9bcr9yHTKfmV8mwScTM2/5CWC5vbXAe963LoYlBp9l
	 N+fIkmxyJ+DsHooHTcZbuYSBvRNJg4c7cjlPEXMPysDg8M9nQVS38RSoljNY4RbGulHUL
	 ZA2pmFaRgy1+VjVR2/zJhC7x0VH+Xf7ijojS3RDEW1Ps48Tvz3WnpvCuD6W1Ijy+ERA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cubCUY4Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA03D606A336;
	Thu, 19 Nov 2026 02:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cubCUY4Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55F41F000C7;
	Thu, 19 Nov 2026 02:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055329;
	bh=Yl9LsCxoSHeUC5OPAq9mj5zTolbBA5njdDjJ+uBrLak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cubCUY4Y0LDaoNSHFPvbD0k0L35pUspTFO6Xi7qiYsRTQX9xXW4N0DyqXGq1AAe5a
	 btETj2zh+S7afZupemM4SW2z+oODqO/QoVWr4+LCACBBDzkeAlxlXbvoGWfTi+tQ3Q
	 6YrpNFlA5VBLTG03JY2m2FaDxlovsarcFtliaHxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1590/2214] mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock
Date: Wed, 18 Nov 2026 15:54:26 +0100
Message-ID: <20261118150115.593878270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



