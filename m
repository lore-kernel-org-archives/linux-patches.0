Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88AA20409A;
	Thu, 13 Feb 2025 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458545; cv=none; b=HNO6pjlPaw+pHLCeKJYsVOMUjhZ3b78ak6FNdyxjVx3j5Q3CFMJRPUy1B5tORNCDDLCbK3Maf5JcktGvyYZwYaJvh0bA6d0KKbkoflK7SCP5oaBazohx6SgNag9x+hNijh7RAVNsCBIfRpkrFVyBWaFchFjHpYIJOiuXnIe8Q20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458545; c=relaxed/simple;
	bh=lmio6SRjN5XX08xIdf3geap474jZGgTE8U2R2KrNxFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unkbMSMYqHf2uGaMJnF0ti+CAENCKA56WkdO9ICSKbko5l4SWmQRZm6oNF44ZDsJyrwHKcrd5IZqjpUHD603vHotxt56mfs6KXeLSPaaikKME53qyTYoK7Z+VLSxDDPd+hQmypOw/b6IIlq2nToDJPLhXzonh/NzJ/jcGB/8Z2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVdjffq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVdjffq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4799FC4CEE7;
	Thu, 13 Feb 2025 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458545;
	bh=lmio6SRjN5XX08xIdf3geap474jZGgTE8U2R2KrNxFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVdjffq9w81rp5B4lC60mzTII8+raqMrh5bE0oNnpzwqaxYyGK/INCkFLhULQ7BI3
	 NFDrthWPdcO9oXfVPkdaNVwoLSCb91Kg3BXwXDrGnue+he10GViTckVcyya+T7Rvlz
	 Wv3ToWFOWlF0tBvr389w7UMtucYKvZOT9k46H7a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 001/443] irqchip/lan966x-oic: Make CONFIG_LAN966X_OIC depend on CONFIG_MCHP_LAN966X_PCI
Date: Thu, 13 Feb 2025 15:22:46 +0100
Message-ID: <20250213142440.672001045@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit e06c9e3682f58fbeb632b7b866bb4fe66a4a4b42 ]

The Microchip LAN966x outband interrupt controller is only present on
Microchip LAN966x SoCs, and only used in PCI endpoint mode.  Hence add a
dependency on MCHP_LAN966X_PCI, to prevent asking the user about this
driver when configuring a kernel without Microchip LAN966x PCIe support.

Fixes: 3e3a7b35332924c8 ("irqchip: Add support for LAN966x OIC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/all/28e8a605e72ee45e27f0d06b2b71366159a9c782.1737383314.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 9bee02db16439..990674713b863 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -169,6 +169,7 @@ config IXP4XX_IRQ
 
 config LAN966X_OIC
 	tristate "Microchip LAN966x OIC Support"
+	depends on MCHP_LAN966X_PCI || COMPILE_TEST
 	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
 	help
-- 
2.39.5



