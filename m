Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF082D7393;
	Wed, 25 Feb 2026 06:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002686; cv=none; b=KFkbNHKkCw8yGQEFE0Z2XLSNteE6aIVBQ5AbSPxTYeMxbY8D/99xJ/NkdpIbnDtPFBo5vaCc3LCMqhnf4zmzrE2QCMjdnxu/OvvrUc7FLGkDLiopC+22uq9L67hNAJbILeS4bhPqYFw/C6nBWVAsmj7LYz7Ph7nTFijxGYRiaRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002686; c=relaxed/simple;
	bh=lWcjIVpaStuDZ55oJB+z/8ckS1+41InEr415H3HTiCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osiKLW6wacUrcRASvqmORyUXa/82dKTe/69ROtWYZ89SeTWQqhEvTZjskgMUy1y05hYdz5SjMOJjTGvo2Sds/VGI4DSlRyxdb0CfHyItTlUMR08S5tif304NKJqW0aveGmHvwy2rPnahJdpUN3rXy8GBG5NZjVyWW6Pn2pI34QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pt0UVSap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pt0UVSap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C2BC116D0;
	Wed, 25 Feb 2026 06:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002686;
	bh=lWcjIVpaStuDZ55oJB+z/8ckS1+41InEr415H3HTiCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pt0UVSaplLA/NXfLH5dyX022NoI0GocKuUEz/AApjrHsmM2ioeVYHcqKwL2v5y8Xo
	 9KgRF+xR/CAYV/7xhQWhzbVLvKYzRgAmAS8W1wfrJlSQND2KiHorlKvMJ2g3SVugco
	 VQxLZSESJmZah0Drisouc0rTbsp02fYFhed3xZDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Linus Walleij <linusw@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 478/641] mfd: simple-mfd-i2c: Add Delta TN48M CPLD support
Date: Tue, 24 Feb 2026 17:23:24 -0800
Message-ID: <20260225012400.099554182@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit 8f34c1a64c5394d2b51d3fba197947dc4b0b48a0 ]

Delta TN48M switches have a Lattice CPLD that serves
multiple purposes including being a GPIO expander.

So, lets use the simple I2C MFD driver to provide the MFD core.

Also add a virtual symbol which pulls in the simple-mfd-i2c driver and
provide a common symbol on which the subdevice drivers can depend on.

Fixes: b3dcb5de6209 ("gpio: Add Delta TN48M CPLD GPIO driver")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Link: https://lore.kernel.org/20220131133049.77780-2-robert.marko@sartura.hr
Link: https://lore.kernel.org/linux-gpio/20260112064950.3837737-1-rdunlap@infradead.org/
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260112-mfd-tn48m-v11-1-00c798d8cd2a@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig          | 11 +++++++++++
 drivers/mfd/simple-mfd-i2c.c |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6cec1858947bf..55a9fea95195b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -406,6 +406,17 @@ config MFD_CS47L92
 	help
 	  Support for Cirrus Logic CS42L92, CS47L92 and CS47L93 Smart Codecs
 
+config MFD_TN48M_CPLD
+	tristate "Delta Networks TN48M switch CPLD driver"
+	depends on I2C
+	depends on ARCH_MVEBU || COMPILE_TEST
+	select MFD_SIMPLE_MFD_I2C
+	help
+	  Select this option to enable support for Delta Networks TN48M switch
+	  CPLD. It consists of reset and GPIO drivers. CPLD provides GPIOS-s
+	  for the SFP slots as well as power supply related information.
+	  SFP support depends on the GPIO driver being selected.
+
 config PMIC_DA903X
 	bool "Dialog Semiconductor DA9030/DA9034 PMIC Support"
 	depends on I2C=y
diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index 0a607a1e3ca1d..9f911afafc25e 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -110,6 +110,7 @@ static const struct simple_mfd_data spacemit_p1 = {
 };
 
 static const struct of_device_id simple_mfd_i2c_of_match[] = {
+	{ .compatible = "delta,tn48m-cpld" },
 	{ .compatible = "fsl,ls1028aqds-fpga" },
 	{ .compatible = "fsl,lx2160aqds-fpga" },
 	{ .compatible = "fsl,lx2160ardb-fpga" },
-- 
2.51.0



