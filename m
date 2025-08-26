Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD0D1EDA2C;
	Tue, 26 Aug 2025 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212824; cv=none; b=oClpIHCq8owTN1fkuw1J7NQ598GRA6oB4cfQmWjvorszyrf/4TYLW7V+s2W/ICYCRiiirm0AMmQklbpStJv+ka172Xvk2HghUKvICacJkp9QTzRYQgGD0jh9gUNKP10i8ZwwV1gr7eIIYbLk8NQc75o9MmM8YLRio6q41kVA5ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212824; c=relaxed/simple;
	bh=kM+2dw4keRJqEHUsb2QMlO+GC8RvFBQkTCL9KU3E03Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jURLfAAO4UA307gL8HDsmW43jIBHe06rADCSO+KY+DAHk482LC7aeDBo6OspQZvjlI9XvgOoVjQ+Y1JHPD0ms4HtH0fP/2A3qDhZ8ljdpf29CfLdOWxKPRw42GVXkv8w37/J8kWu15phfZWSqnbQDtYCquvkNvuI7d8L8VCdVHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXP+VOp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXP+VOp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E707C4CEF1;
	Tue, 26 Aug 2025 12:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212824;
	bh=kM+2dw4keRJqEHUsb2QMlO+GC8RvFBQkTCL9KU3E03Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXP+VOp0KPkRmVAaA8hKQ5yO9FJYWbbGAICoiBlnt9ED33t2xvPZchY8RqhTDlqED
	 KgGfgf8XloDE95XyCDF8ngU/68JTYPMvbneFWCUd9DGyNAY60YkUvZEpxkG4YwnBEd
	 soERFyU9ky5GWpOezClW3crzKRlnx0AnIXNYCvuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/587] reset: brcmstb: Enable reset drivers for ARCH_BCM2835
Date: Tue, 26 Aug 2025 13:04:25 +0200
Message-ID: <20250826110955.921038956@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 1d99f92f71b6b4b2eee776562c991428490f71ef ]

The BRCMSTB and BRCMSTB_RESCAL reset drivers are also
used in the BCM2712, AKA the RPi5. The RPi platforms
have typically used the ARCH_BCM2835, and the PCIe
support for this SoC can use this config which depends
on these drivers so enable building them when just that
arch option is enabled to ensure the platform works as
expected.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20250630175301.846082-1-pbrobinson@gmail.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index ccd59ddd7610..9f25eb3aec25 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -51,8 +51,8 @@ config RESET_BERLIN
 
 config RESET_BRCMSTB
 	tristate "Broadcom STB reset controller"
-	depends on ARCH_BRCMSTB || COMPILE_TEST
-	default ARCH_BRCMSTB
+	depends on ARCH_BRCMSTB || ARCH_BCM2835 || COMPILE_TEST
+	default ARCH_BRCMSTB || ARCH_BCM2835
 	help
 	  This enables the reset controller driver for Broadcom STB SoCs using
 	  a SUN_TOP_CTRL_SW_INIT style controller.
@@ -60,11 +60,11 @@ config RESET_BRCMSTB
 config RESET_BRCMSTB_RESCAL
 	tristate "Broadcom STB RESCAL reset controller"
 	depends on HAS_IOMEM
-	depends on ARCH_BRCMSTB || COMPILE_TEST
-	default ARCH_BRCMSTB
+	depends on ARCH_BRCMSTB || ARCH_BCM2835 || COMPILE_TEST
+	default ARCH_BRCMSTB || ARCH_BCM2835
 	help
 	  This enables the RESCAL reset controller for SATA, PCIe0, or PCIe1 on
-	  BCM7216.
+	  BCM7216 or the BCM2712.
 
 config RESET_HSDK
 	bool "Synopsys HSDK Reset Driver"
-- 
2.39.5



