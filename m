Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E146933A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301910; cv=none; b=hybL2SH+KOStcGugibjpKJNCI/FrkAnQikVPL9qPOcEGMjEQbjNxTQ9ezHezgcXzaIwpZvtov0MK7ZdT0jp3EGpkWsg9YXz1Niio46aMv5TXAUiJBCa/F8SV/wdZcpznrnBZTxpzwwq6VDRJr57m0rbBin5IQt+1rKXb6sBgNgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301910; c=relaxed/simple;
	bh=yNvBxkuLJGxpOqurxMb/UwEM7cYpfiRNsz73zoAdm/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIpHJyshsAltcHF0uS/I/eBH4+fFppu49vfZwmPpdPJJeuZy85xDX80soCgbQlmW+PqIarobrXZ53bFD4K6I7Y/h3XvdVdO0yQ63Ty1HmBVn7kiXp5VHdajDAJp4BsXHAYeX6e5Nwiyc3y2D6F0+y//Vj5hK14kY5j5Qs13NPb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayAP77nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayAP77nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356AFC116D0;
	Sat, 28 Feb 2026 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301909;
	bh=yNvBxkuLJGxpOqurxMb/UwEM7cYpfiRNsz73zoAdm/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayAP77nzl7AbXUyiENMdUn/94RMvdKHJirCjgWjqRHFXFBhkHtgAQxyiA/76pG8ks
	 iBOapbjihDPEaThQKnkDeRoLEfv6JNAG11tlnojzdETrqEIT8InxDLGJEbi7peIJ7Z
	 vKkrRY5vn+KFA4E2ChP4wpLiK7YNJmTooXXjlb3U8xwaxN2uxe5Gpvt3eOT6IrA+1R
	 TI55K0V8nUZBN4PYiAhvua//DHL8ofalojUL//ac1x2eU3DiA/M5UFs8AXNEMLmHdb
	 cso7BV5t74VZBxL7I+D2fc1aFK91TXxYx0ipI09Z2TwQZ81MLeJyO7Cy6b9chBPoS5
	 czCvKDMaWsG0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Robert Marko <robert.marko@sartura.hr>,
	Linus Walleij <linusw@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/385] mfd: simple-mfd-i2c: Add Delta TN48M CPLD support
Date: Sat, 28 Feb 2026 12:59:23 -0500
Message-ID: <20260228180011.1568201-341-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 4c56330b15eda..f08b8009eeea0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -347,6 +347,17 @@ config MFD_CS47L92
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
index 0cca7a9044cd4..908eae338fee0 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -110,6 +110,7 @@ static const struct simple_mfd_data spacemit_p1 = {
 };
 
 static const struct of_device_id simple_mfd_i2c_of_match[] = {
+	{ .compatible = "delta,tn48m-cpld" },
 	{ .compatible = "fsl,ls1028aqds-fpga" },
 	{ .compatible = "fsl,lx2160aqds-fpga" },
 	{ .compatible = "kontron,sl28cpld" },
-- 
2.51.0

