Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060880;
	b=kuVVPTtme7FdUPfJjy9UCJGN44FSE5oXOGAfREI4Dgw2Y2cu1alxXLd/jSsVS8TI2KXs
	 GnHg2wdmAeT1HH1oYzP+a/BBiSTjH653irHZE2EQVajJL8kyuhstSR6BW2vmDh0K2icVK
	 MgpP98g5nTlveFIcCJzG5BMDmvqn216Pt3+NhDnGlsGObUe6yig285A+LwhMiwuZ2ByI7
	 BkxSAAKfgxUAgLuXvlK9u8kzCVwiN4bQJltjzS/FfcR0m45fJrQWYcszew7MMIyDoAViJ
	 Ks1oFooanQi4uBFN3p90EPRtCuzhb4MX/GrYHpBnnGFxrp7mvGV892ZaqV1o2G4u1aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gTUSCYSZAnhdd2yUkEdZ4xBJvDujorOxLMHd+DgIYlg=;
	b=Xy4uONOs5CcnpcsyQ1PA2XWArWjV5hh76Le8nu5F8VKvhLbHBuS5S0CXDR9G0k70Aiw3
	 AU6sOIVGnaH6ab5XiTTeNqqEVcafTgA7jL18LP0cmfdtHnfuIr8dssFP1mJ8WVV21Zfc1
	 45mmb0FNGxZfWsjS8Osr0DvvymPg6spTJ11joqilUJ5Y8BldpXoP/dgX2DIDRPYRyUPAV
	 r4bwuRKUEFJLjp3MTKyQSrhDiOauCgVh0tKMbHmyOD8p6p6t4j/N4GGZBdTLr95nVX1Tk
	 OWJvDGjcTTTJ+n/WeewgEyQfyIx9vzmMGpTI5kzIX4aFXr2pEGRfve5JBjtmTXmxGAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vg/NPezv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22441606A325;
	Thu, 19 Nov 2026 04:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vg/NPezv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D15F1F000C4;
	Thu, 19 Nov 2026 04:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060880;
	bh=gTUSCYSZAnhdd2yUkEdZ4xBJvDujorOxLMHd+DgIYlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vg/NPezvBGPJfxX9ccHgrRZpTfGYdhrOyZGWat0CyQQxcggbeAXpiyzzvbury6cZz
	 CbHzL/zvzpQH6B596Qf/rT17RRSEwkVjX9bZbPZbsg15AXebHD1fPVct2h8f9mAQ0o
	 DNAqrdy1GW/OMN8LF/tQnmMzawdSC9KWWazbxaEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1330/1848] mfd: intel_quark_i2c_gpio: Reuse BAR definitions for MFD cell indexing
Date: Wed, 18 Nov 2026 15:56:08 +0100
Message-ID: <20261118150015.432330343@linuxfoundation.org>
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

[ Upstream commit 98d6e7fce6b0174c701dc596539dc7bc1e96f8ce ]

It's convenient and less error prone to use definitions to address
different cells in an array. For this purpose we may reuse existing
BAR definitions.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 14a7cf1a3730 ("mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_quark_i2c_gpio.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
index b0e1b1e0df256..66bee47ba69f3 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -96,15 +96,7 @@ static struct mfd_cell_acpi_match intel_quark_acpi_match_gpio = {
 };
 
 static struct mfd_cell intel_quark_mfd_cells[] = {
-	{
-		.id = MFD_GPIO_BAR,
-		.name = "gpio-dwapb",
-		.acpi_match = &intel_quark_acpi_match_gpio,
-		.num_resources = ARRAY_SIZE(intel_quark_gpio_res),
-		.resources = intel_quark_gpio_res,
-		.ignore_resource_conflicts = true,
-	},
-	{
+	[MFD_I2C_BAR] = {
 		.id = MFD_I2C_BAR,
 		.name = "i2c_designware",
 		.acpi_match = &intel_quark_acpi_match_i2c,
@@ -112,6 +104,14 @@ static struct mfd_cell intel_quark_mfd_cells[] = {
 		.resources = intel_quark_i2c_res,
 		.ignore_resource_conflicts = true,
 	},
+	[MFD_GPIO_BAR] = {
+		.id = MFD_GPIO_BAR,
+		.name = "gpio-dwapb",
+		.acpi_match = &intel_quark_acpi_match_gpio,
+		.num_resources = ARRAY_SIZE(intel_quark_gpio_res),
+		.resources = intel_quark_gpio_res,
+		.ignore_resource_conflicts = true,
+	},
 };
 
 static const struct pci_device_id intel_quark_mfd_ids[] = {
@@ -244,11 +244,11 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
-	ret = intel_quark_i2c_setup(pdev, &intel_quark_mfd_cells[1]);
+	ret = intel_quark_i2c_setup(pdev, &intel_quark_mfd_cells[MFD_I2C_BAR]);
 	if (ret)
 		goto err_unregister_i2c_clk;
 
-	ret = intel_quark_gpio_setup(pdev, &intel_quark_mfd_cells[0]);
+	ret = intel_quark_gpio_setup(pdev, &intel_quark_mfd_cells[MFD_GPIO_BAR]);
 	if (ret)
 		goto err_unregister_i2c_clk;
 
-- 
2.53.0



