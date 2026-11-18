Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060910;
	b=MKwvVAANrkW3mMIq4FR8MdnzvSiV0zR+ucM5UmenzvAzdjq9g9h/EpmJ/CkbWW55Lr/l
	 2QiXWC//2owHVu+yTNJUleGFf9n97t9tFAyN3t0uTDKcYdaSsjOLRO5fU+NIaQA1odn6y
	 Z6pOslnMaiPD2iPn+F1Ar3SnhYELeo+ZLo0bHDFW9SuFnWokYYPT3kvY4ESPEmVDWT2/r
	 7FVsd3wSPrZ1CuyjrVXszGZYLklRGq0tqFSq9KTZlpWWP/QP/pGxD9BboupnS3tbsRRTa
	 6LUvZ7zgFt4Jm1h5LMYASovLyrKR3DXjo1hrU7Sn3SHDM4aYEcXjx5hL/0KUd9kGbkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dLMtY3Q9NHy8aSVilDLeVP46y7AaYEJ5ROSRo3PtuSM=;
	b=h4pINOTyi8Qvv7bKWe+HMFdGqxRjO6MWE561Vxj6ZO6wK1QCBUC8Rknzat33P/j1bsRm
	 DFjNQ/LzpYsOqdz+757hQRZsIUg7CZupxq0WT/QZsPMFPxhatleIZA0mqqnfLiFydOjny
	 KMipn6Auo8g7g5aDv3lJyD8DIa4rSQpTwFBoBcpDh4654T8xclW8hAgROTznSPkkx+RAh
	 Xu7+tMCELRR5l/rgnLtd+A2bNNhhyk38AzA2soS4B+oAEHeZXd5Q6ofPCN8aEo9K6kl68
	 l3xG7Jbb3oHbZ+YznoQyKjkgD/eLPSjKA3HB8o+poUqOv5fG6dIuGb+E7PERoLjl0fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSTwzrud;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D932A606A32C;
	Thu, 19 Nov 2026 04:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSTwzrud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3392E1F000C4;
	Thu, 19 Nov 2026 04:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060910;
	bh=dLMtY3Q9NHy8aSVilDLeVP46y7AaYEJ5ROSRo3PtuSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSTwzrudOTaELOXFlCMdZXYHq5KCDGofp7KzqrXmNOKlQ95R98quEW9daX14m1Ckr
	 r6eLZgyPzWF/N+mgG4G+XFE3p7s3BG7BlNZPHw7HdcmzeTyApCzfSiisNlCB/rzUy6
	 FaENwSJBT7tq+n9/kfplMb+hJsQT5u8Dc1hKqpg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1331/1848] mfd: intel_quark_i2c_gpio: Enable MSI interrupt
Date: Wed, 18 Nov 2026 15:56:09 +0100
Message-ID: <20261118150015.466601055@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 91076ebb3e2204cbb81aa2d6930f2a88638e4bb0 ]

Allow interrupts to be MSI if supported by hardware.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 14a7cf1a3730 ("mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_quark_i2c_gpio.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
index 66bee47ba69f3..083eb205fc300 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -167,8 +167,8 @@ static int intel_quark_i2c_setup(struct pci_dev *pdev, struct mfd_cell *cell)
 	res[INTEL_QUARK_IORES_MEM].end =
 		pci_resource_end(pdev, MFD_I2C_BAR);
 
-	res[INTEL_QUARK_IORES_IRQ].start = pdev->irq;
-	res[INTEL_QUARK_IORES_IRQ].end = pdev->irq;
+	res[INTEL_QUARK_IORES_IRQ].start = pci_irq_vector(pdev, 0);
+	res[INTEL_QUARK_IORES_IRQ].end = pci_irq_vector(pdev, 0);
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -215,7 +215,7 @@ static int intel_quark_gpio_setup(struct pci_dev *pdev, struct mfd_cell *cell)
 	pdata->properties->idx		= 0;
 	pdata->properties->ngpio	= INTEL_QUARK_MFD_NGPIO;
 	pdata->properties->gpio_base	= INTEL_QUARK_MFD_GPIO_BASE;
-	pdata->properties->irq[0]	= pdev->irq;
+	pdata->properties->irq[0]	= pci_irq_vector(pdev, 0);
 	pdata->properties->irq_shared	= true;
 
 	cell->platform_data = pdata;
@@ -244,22 +244,31 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
+	pci_set_master(pdev);
+
+	/* This driver only requires 1 IRQ vector */
+	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (ret < 0)
+		goto err_unregister_i2c_clk;
+
 	ret = intel_quark_i2c_setup(pdev, &intel_quark_mfd_cells[MFD_I2C_BAR]);
 	if (ret)
-		goto err_unregister_i2c_clk;
+		goto err_free_irq_vectors;
 
 	ret = intel_quark_gpio_setup(pdev, &intel_quark_mfd_cells[MFD_GPIO_BAR]);
 	if (ret)
-		goto err_unregister_i2c_clk;
+		goto err_free_irq_vectors;
 
 	ret = mfd_add_devices(&pdev->dev, 0, intel_quark_mfd_cells,
 			      ARRAY_SIZE(intel_quark_mfd_cells), NULL, 0,
 			      NULL);
 	if (ret)
-		goto err_unregister_i2c_clk;
+		goto err_free_irq_vectors;
 
 	return 0;
 
+err_free_irq_vectors:
+	pci_free_irq_vectors(pdev);
 err_unregister_i2c_clk:
 	intel_quark_unregister_i2c_clk(&pdev->dev);
 	return ret;
@@ -268,6 +277,7 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 static void intel_quark_mfd_remove(struct pci_dev *pdev)
 {
 	mfd_remove_devices(&pdev->dev);
+	pci_free_irq_vectors(pdev);
 	intel_quark_unregister_i2c_clk(&pdev->dev);
 }
 
-- 
2.53.0



