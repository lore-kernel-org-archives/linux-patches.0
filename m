Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908EC243376;
	Wed, 25 Feb 2026 01:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983475; cv=none; b=QQpgvlINknO5Wq8FRwb52xbIfnMjhHcFHR9SO3yzp2i0b4hqfDF5XeN99PZR4HcgoJXJbRo8JCW35KEjDt3RdskKj5SWNc4N/sR9Ov6lB+gKFcQf6OxuKnQHaxUXnxcnASUvqa7jXdKZ8FmyWlcXZMv/NCNaFoubEWw6LNzdAB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983475; c=relaxed/simple;
	bh=h/BYX8CzUARk4vyZv9XKm6XyvCAEDmy4pErxDmbxBRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiWxOHHEkpwvIPRLIS5G060hABMj5X7BSoJYVK5KInoIlz9aBBYJpLXzI+f8jmOobXkxpiIWhkomkzyMsFwD38SKz5p1KN38H07NIDToHOTm4I588aYEDY3b0KSFRzjRVpK+53Ai4eJWCFVq6ve6f2jHbozWe5saGar1WAUzMPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jilOxmgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jilOxmgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48481C116D0;
	Wed, 25 Feb 2026 01:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983475;
	bh=h/BYX8CzUARk4vyZv9XKm6XyvCAEDmy4pErxDmbxBRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jilOxmgQm2F9IZSqftrrJwb5NGtBupJribvPfOwFzTb+yBFxaQ/P58TyT7xKS/RS+
	 FqnkWz/0Zu18e5JfKrtG4rhMxRCNzCBWKeCn3CgzfqIJH6CbzDTQkRxCeZlZCdFowI
	 EUe/DRiEMMCI0oYJgsJYguy3rCj4j50giqfCNl4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Linus Walleij <linusw@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 590/781] mfd: simple-mfd-i2c: Add Delta TN48M CPLD support
Date: Tue, 24 Feb 2026 17:21:39 -0800
Message-ID: <20260225012414.267681469@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index aace5766b38aa..f7f12a0428aa2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -407,6 +407,17 @@ config MFD_CS47L92
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
index 8b751d8e3b5ae..7315fad618e44 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -116,6 +116,7 @@ static const struct simple_mfd_data spacemit_p1 = {
 };
 
 static const struct of_device_id simple_mfd_i2c_of_match[] = {
+	{ .compatible = "delta,tn48m-cpld" },
 	{ .compatible = "fsl,ls1028aqds-fpga" },
 	{ .compatible = "fsl,lx2160aqds-fpga" },
 	{ .compatible = "fsl,lx2160ardb-fpga" },
-- 
2.51.0



