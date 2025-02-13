Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A949281360;
	Thu, 13 Feb 2025 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457070; cv=none; b=rjKMdNnkmgm236SHtDpBP37myDffAnGt/lHM91Vj0y5PLyqP3iimHMnPSMYPA7fkNHy/eWU7y8DOggExolzOZtPa2CRfloYiXj6qg5LnidDCkQVAF+QdSsMDknufVJQE78oZjWix1MV4GWTxDfWo7gG2hOVbN8z68NDdxgQjzCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457070; c=relaxed/simple;
	bh=Chy1+f2YB1i1E9fauegN/2NzDH+rlhxiay3CNQ8Qk/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrY2newjxQVud4acz3vxUeTng00WV5lWMtXtdld/rJ1KtfZxltdeP5QYN5gVEEGiYEOHP5DyyhgXQpDmgtTDOuS7ikny24KABZ81LhOwRS52RDNzAHRrlWvzNbHC32Y2l8QR7BXiXb8Rqpe9IEpgGkzL6Qm3q2VPiSBZafhZCxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fj9W7Phr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fj9W7Phr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D696C4CED1;
	Thu, 13 Feb 2025 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457069;
	bh=Chy1+f2YB1i1E9fauegN/2NzDH+rlhxiay3CNQ8Qk/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fj9W7PhrmIf0aMKbYZZlUKVY9bfTi3vQ7Lpha6ZVGvdfuTO43jVqJNQqixyGTu/13
	 LJ9LPCT8bnOGARZ7KWlawDMuxrhH7pzrQ+c+nmt/TqefPeE2Ptv9daqHwAQZ106PRi
	 y6RzT5QT24gbf0ESzdgKRsgQqWv1wF1re0V943sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/422] irqchip/lan966x-oic: Make CONFIG_LAN966X_OIC depend on CONFIG_MCHP_LAN966X_PCI
Date: Thu, 13 Feb 2025 15:22:30 +0100
Message-ID: <20250213142436.472887649@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 66ce15027f28d..c1f3048360085 100644
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



