Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060927;
	b=XkGC4NR8AXWmaciTD5HzzUcPeGc+djE1285fljXlU7A9472NBObDli3wzrfMdo1CeuJD
	 kp00JsVB8gL9cqG9Jy3TkdxDSOdRTucwvat2XImLkUKVAFW/IlSeWx1bu3GrIiSP/Mm/c
	 rdpKqE+vJ6tzLnVHedtOsDgrDUNT4JogoWuVusXMJTUkzbqBvfjUevKJqMnMQnGgz8cP4
	 p93STsAv98CRKAXkBPde1tkrZ/FfAoG4ITVQ4V8WVcUvahQe26W6O3806kR6xRRWFTgbZ
	 pxn3F6yakWXfcj/cETzZudkLpa1JsYyut7+PimoU7lgpctjhDz/+cEI9XcNGHc/uUqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t5xBeI/1+20MElcqS6KSkxb5MgLLTg02XccLDw80NiI=;
	b=IWu0ALvpvgGWvcp27U4IpGrd14KRKarj48xvfCh+mBpY7aVsUmeF4EdyqfqYi1ViEJK0
	 nnkb+qmQbeDF2Yyd6m3ssppJKG7BveAaGdeor6ok7vZVz4Pp3R5wLxD2U8+XvTzlbS84V
	 GUNl68plbLegUm1byWXNCmvB01+QjVZcCsPAYVzkMTb9Lr/X/wQZXF61V4WhqFaRmUsrQ
	 6zMrctK/LL03YcnFlAFhVBVrVhALT7iyWIM6V4+6X0eiYYqqfpHwtOTKIkLsXh5fWK8m7
	 r3V6jue7IDt2eNpGImxYa+fGWFjJnWxff1eJhw4Xdu77fLwA1gZE9fQPfGIAVN3AWKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnRwGAfO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42CC606A325;
	Thu, 19 Nov 2026 04:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnRwGAfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AB41F000C4;
	Thu, 19 Nov 2026 04:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060927;
	bh=t5xBeI/1+20MElcqS6KSkxb5MgLLTg02XccLDw80NiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnRwGAfOtWh4sNo3YkbXa64QlIfvOL5acqxCZ/Gc2FNoUd0zvOHtVUZOk7bp4TqUr
	 7daSFF5dBSn/uXvL4qNDagb8gL3sgyaO5g1KnTDYftZrTJ04MwaQ9DhB08c8uUsf1C
	 YXZVzk2T9RH+9Dq4T0O4wzPMxLzJE6KOp5k7GT+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1332/1848] mfd: intel_quark_i2c_gpio: Dont play dirty trick with const
Date: Wed, 18 Nov 2026 15:56:10 +0100
Message-ID: <20261118150015.503257493@linuxfoundation.org>
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

[ Upstream commit 6dac44c602bef283484ca84591396e65f8d8f1a5 ]

As Linus rightfully noticed, the driver plays dirty trick with const,
i.e. it assigns a place holder data structure to the const field
in the MFD cell and then drops the const by explicit casting. This is
not how it should be.

Assign local pointers of the cell and resource to the respective
non-const place holders in the intel_quark_i2c_setup() and
intel_quark_gpio_setup().

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 14a7cf1a3730 ("mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_quark_i2c_gpio.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
index 083eb205fc300..902db038c930e 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -155,17 +155,16 @@ static void intel_quark_unregister_i2c_clk(struct device *dev)
 	clk_unregister(quark_mfd->i2c_clk);
 }
 
-static int intel_quark_i2c_setup(struct pci_dev *pdev, struct mfd_cell *cell)
+static int intel_quark_i2c_setup(struct pci_dev *pdev)
 {
+	struct mfd_cell *cell = &intel_quark_mfd_cells[MFD_I2C_BAR];
+	struct resource *res = intel_quark_i2c_res;
 	const struct dmi_system_id *dmi_id;
 	struct dw_i2c_platform_data *pdata;
-	struct resource *res = (struct resource *)cell->resources;
 	struct device *dev = &pdev->dev;
 
-	res[INTEL_QUARK_IORES_MEM].start =
-		pci_resource_start(pdev, MFD_I2C_BAR);
-	res[INTEL_QUARK_IORES_MEM].end =
-		pci_resource_end(pdev, MFD_I2C_BAR);
+	res[INTEL_QUARK_IORES_MEM].start = pci_resource_start(pdev, MFD_I2C_BAR);
+	res[INTEL_QUARK_IORES_MEM].end = pci_resource_end(pdev, MFD_I2C_BAR);
 
 	res[INTEL_QUARK_IORES_IRQ].start = pci_irq_vector(pdev, 0);
 	res[INTEL_QUARK_IORES_IRQ].end = pci_irq_vector(pdev, 0);
@@ -187,16 +186,15 @@ static int intel_quark_i2c_setup(struct pci_dev *pdev, struct mfd_cell *cell)
 	return 0;
 }
 
-static int intel_quark_gpio_setup(struct pci_dev *pdev, struct mfd_cell *cell)
+static int intel_quark_gpio_setup(struct pci_dev *pdev)
 {
+	struct mfd_cell *cell = &intel_quark_mfd_cells[MFD_GPIO_BAR];
+	struct resource *res = intel_quark_gpio_res;
 	struct dwapb_platform_data *pdata;
-	struct resource *res = (struct resource *)cell->resources;
 	struct device *dev = &pdev->dev;
 
-	res[INTEL_QUARK_IORES_MEM].start =
-		pci_resource_start(pdev, MFD_GPIO_BAR);
-	res[INTEL_QUARK_IORES_MEM].end =
-		pci_resource_end(pdev, MFD_GPIO_BAR);
+	res[INTEL_QUARK_IORES_MEM].start = pci_resource_start(pdev, MFD_GPIO_BAR);
+	res[INTEL_QUARK_IORES_MEM].end = pci_resource_end(pdev, MFD_GPIO_BAR);
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -251,11 +249,11 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 	if (ret < 0)
 		goto err_unregister_i2c_clk;
 
-	ret = intel_quark_i2c_setup(pdev, &intel_quark_mfd_cells[MFD_I2C_BAR]);
+	ret = intel_quark_i2c_setup(pdev);
 	if (ret)
 		goto err_free_irq_vectors;
 
-	ret = intel_quark_gpio_setup(pdev, &intel_quark_mfd_cells[MFD_GPIO_BAR]);
+	ret = intel_quark_gpio_setup(pdev);
 	if (ret)
 		goto err_free_irq_vectors;
 
-- 
2.53.0



