Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6251E36C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302231; cv=none; b=U50ScHIOl8vWSmt6/NpqBNFJyRgDcK+th1KXnYCOEmrudQT4mGlMkALaw59njSDxTDWAQMVM7O5iLptppThhXljjmV/uU7ZO+H/XIcgNm0HojQtWiXOAZWOXoLAjTsFul6v9VBt1jPhsDAJL8v0axvonUcv6C7eqgch4ykzV+5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302231; c=relaxed/simple;
	bh=1RpFLqxZprTSb8+MWIzcWVAxEt58CwYLY6kLNF8FOWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXszuCWXAgxvNm0rhlKemMODWAV0mXh/UT2C5wXCW+bKuBUVAMoXKD02Y04u2CMEViFR6kl3A6JAs/5EvaSZnac3TGn7Cf78PU76Yi1d2dP+EHi9zQJtBf08d3MLGEpWXlaPZ8XDeLkwly8tYBi3CE3/+O4lZ8jLYgAXyNr2/UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OT4VIc+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OT4VIc+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ADCC19424;
	Sat, 28 Feb 2026 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302231;
	bh=1RpFLqxZprTSb8+MWIzcWVAxEt58CwYLY6kLNF8FOWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT4VIc+WrsRVriKMrf7nqHw/uMViLOkqpULbf4RM21j3mRuBFzuRryIK1Yta2Jeff
	 J44BBplx02pz2/2iYk21EOWe09++IaRMNlo0qTuo6xFXIlRs43rg0Z3E9dl+DcofeZ
	 W41j1qqqPuzi5D56WmtnvXr0XGiM5Jkwy/K62yGGSLKpZ1YxpXwT+c0qnsgkYiEjcK
	 kFnhGw5m26/FTCwhT1GmBZEglDAEP2dyQbcEMr70jb6Sc2UEngWBjEjEl2SiH2t1vO
	 GdEW1s3vtebWp+9GYHOdmtxYREizNrLFcPj2QrJiGYbYv7s2O/WdGVaqtCNmPIxjsb
	 M2Yr7lh5Vnv1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Robert Marko <robert.marko@sartura.hr>,
	Linus Walleij <linusw@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/283] mfd: simple-mfd-i2c: Add Delta TN48M CPLD support
Date: Sat, 28 Feb 2026 13:06:23 -0500
Message-ID: <20260228180709.1583486-241-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 45e0447d3b414..cfb22fb7b238b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -335,6 +335,17 @@ config MFD_CS47L92
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

