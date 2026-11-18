Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060933;
	b=G6R1mbh+xe8EtUNl80azuhLoO7NSblotRNyVYkgGkCSyo16pPLjeM57y1kqVX0gm+Joy
	 bMhomRNhLPiAXRxL3PvMZb6H5Uil6q3BqqAs7rH/oOZsCkJE4lvY6bW/es1ixNCiozpw2
	 iy34eiVjs52NRQXifiDnTf4AmKl1At1OUKW2agRalCndAHuInU+SntaFzy4Bdtpm7hrMO
	 1xz/mx4aCwhKgSfDS5YR4sSG7JyVfpgtQKyAPjgxUb6KtWvimqlNf9SqHEZUhpLbbjsSw
	 b4AN1J/e+fXnJm3Rr3m83aVepQXOa2fyxeIAEQHQ4ZIhwB6R8DtglJZ1KU0tjalN93A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J94Z8SEkfLtTNNcrltfA4LOZ4V5L1p2pJnTjrJwTUbw=;
	b=ebBxkoVg1AZC7vaEC1E1rCxZEnAPPdaiNy6hw+Yz2Va9kyZJbpznRxIIVGn69/Ofc2MM
	 1axSbAC8PyMKviut79WBEn7vmHlMQfGwyABTW1cEhQt/62qPRW+OJ+lFMsaSIlra2FHe9
	 X36UES7t7y7DeFVwnoCE2Y65mNDHRm/fWU+G2HTYaqAiHM5DzIEs2fX0lretQwDTaCJJs
	 pyK958P7Bfp7NYksE9OhEBhZbSciknZ14xZkzQeArysrArTM5W0wzQa82GiNqM/fJH//O
	 7X9Vr0X0MPZ4ZKCaWgKkOWdGgstAzrS+YYKGCiLeOOG241t2cKCMPHNH7QfVGTymACg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b1ehQloI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFA8606A320;
	Thu, 19 Nov 2026 04:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b1ehQloI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846B21F000C4;
	Thu, 19 Nov 2026 04:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060933;
	bh=J94Z8SEkfLtTNNcrltfA4LOZ4V5L1p2pJnTjrJwTUbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1ehQloIoSB57L1oulEM7uMSk4kp+1Us+TyfqV5bFqfa7WL64wpJUYD44uW8ppT/1
	 ogNwL2OYRYUIvuIhCPBasb524nW6TPCsviLmzQlpLSsnTi1HQTQ3rRjMarbwKL/yX3
	 4byzwS7aacTllvergBAGDlysJtmNRORb5Ls7pRe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1334/1848] mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock
Date: Wed, 18 Nov 2026 15:56:12 +0100
Message-ID: <20261118150015.578055454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7db74ec622613..fea85efe7ab44 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -45,11 +45,6 @@
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
@@ -142,37 +137,12 @@ MODULE_DEVICE_TABLE(pci, intel_quark_mfd_ids);
 
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
+	struct clk_hw *hw;
 
-	return 0;
-}
-
-static void intel_quark_unregister_i2c_clk(struct device *dev)
-{
-	struct intel_quark_mfd *quark_mfd = dev_get_drvdata(dev);
-
-	if (!quark_mfd->i2c_clk_lookup)
-		return;
-
-	clkdev_drop(quark_mfd->i2c_clk_lookup);
-	clk_unregister(quark_mfd->i2c_clk);
+	hw = devm_clk_hw_register_fixed_rate(dev, INTEL_QUARK_I2C_CONTROLLER_CLK,
+					     NULL, 0, INTEL_QUARK_I2C_CLK_HZ);
+	return devm_clk_hw_register_clkdev(dev, hw, NULL,
+					 INTEL_QUARK_I2C_CONTROLLER_CLK);
 }
 
 static int intel_quark_i2c_setup(struct pci_dev *pdev)
@@ -236,19 +206,12 @@ static int intel_quark_gpio_setup(struct pci_dev *pdev)
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
@@ -258,7 +221,7 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 	/* This driver only requires 1 IRQ vector */
 	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
 	if (ret < 0)
-		goto err_unregister_i2c_clk;
+		return ret;
 
 	ret = intel_quark_i2c_setup(pdev);
 	if (ret)
@@ -278,8 +241,6 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 
 err_free_irq_vectors:
 	pci_free_irq_vectors(pdev);
-err_unregister_i2c_clk:
-	intel_quark_unregister_i2c_clk(&pdev->dev);
 	return ret;
 }
 
@@ -287,7 +248,6 @@ static void intel_quark_mfd_remove(struct pci_dev *pdev)
 {
 	mfd_remove_devices(&pdev->dev);
 	pci_free_irq_vectors(pdev);
-	intel_quark_unregister_i2c_clk(&pdev->dev);
 }
 
 static struct pci_driver intel_quark_mfd_driver = {
-- 
2.53.0



