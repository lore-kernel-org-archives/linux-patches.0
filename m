Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100A54746AD;
	Sat, 12 Sep 2026 11:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212659; cv=none; b=iumcjArLeqZ0Lx672m+y2aWi7gBqkTSsM+O/MGkl6ZdIomv+NVOhCen7UzfmPt7fAM0kOmpeSPmQEYxvJBF5P6qPfAmPPd+OR8QkhAElOmrEtahmKDnQgQRMb2OH4LgeKW7rq7wRuT97gAA46hers5Fo/8oRnEWkW3SLyRBEWs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212659; c=relaxed/simple;
	bh=FZ4JkhPHYo8BRKN6/QtbXiMByKU+rKNs/gK1yvAVCFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKEyfz5oYctRaNrLvyWih6iwleuThGJNHB6n7BEokq/PyNOrL9UfbEiW7wKnxAv7IrbrdYRp8idSujDVuu0l10SK73y3eNEMk8eKB7lVItdO1WNYpgN1crHenb4QeTj7OBmgCEs7LoJKWa9RPki/DfEFnwR2BEuy7tpzahRtPQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxbMeQDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxbMeQDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA691F000FF;
	Sat, 12 Sep 2026 11:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212657;
	bh=l6LM15qTI11HGf6ZAqR+Cda2uTqHds2QceoP5qPCJeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxbMeQDhcTSuhsP0vszRU5iRclCAg4k56K9O6IyH/prevEKLDrkF6W5XrmGbeDBTp
	 4rO6cx0XOqkf/9dWKD89UW3yE47XfwohX9nFpYBOQZ3gLESp36NB3FMJ/BP8KOicTf
	 Fxo11n+9NHGs60caPGnlQu0HXs8zcsJtPJKNXl4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1482/1518] phy: renesas: rcar-gen3-usb2: add regulator dependency
Date: Sat, 12 Sep 2026 09:00:51 +0200
Message-ID: <20260912065657.085943102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3a03a0e47cf2e0ec7ce7ca9e0bf4c59ec537ad09 ]

The driver start registering a regulator, but can still be
enabled even when it is unable to call into the regulator
subsystem:

aarch64-linux-ld: drivers/phy/renesas/phy-rcar-gen3-usb2.o: in function `rcar_gen3_phy_usb2_probe':
phy-rcar-gen3-usb2.c:(.text+0x2884): undefined reference to `devm_regulator_register'

Add a Kconfig dependency to avoid this configuration.

Fixes: b6d7dd157763 ("phy: renesas: rcar-gen3-usb2: Add regulator for OTG VBUS control")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260202095118.1233046-1-arnd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/renesas/Kconfig b/drivers/phy/renesas/Kconfig
index e342eef0640b7..e128b9c177a51 100644
--- a/drivers/phy/renesas/Kconfig
+++ b/drivers/phy/renesas/Kconfig
@@ -29,6 +29,7 @@ config PHY_RCAR_GEN3_USB2
 	depends on ARCH_RENESAS
 	depends on EXTCON || !EXTCON # if EXTCON=m, this cannot be built-in
 	depends on USB_SUPPORT
+	depends on REGULATOR
 	select GENERIC_PHY
 	select USB_COMMON
 	help
-- 
2.53.0



