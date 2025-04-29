Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8852459FE;
	Tue, 29 Apr 2025 17:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948075; cv=none; b=NVXT4U7Cor+5TIYYOHuT3XKruiQ39TAir+/emfTO5TaoYJfPH06HpK5J9S5P17N0NVGe5mqNGOa9/RaJIW1cAFxfxidJJusGdYwN2BvzyzMj7yzoyu7zVRjBTRzFTglW7YEexUhW0HaytaZoBNG/ns9CpLxCfYsLM1rb/Igyuk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948075; c=relaxed/simple;
	bh=o2/FiH52o/YGB3VOOADEgrjkDGlF7WiUL20dEp6xosg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wu1F/9cyLg7s0rsafVJ3xgWzkRajytnlXXkrcPdPLw3Z9odjTdTDjDA08eqhdFoTpDpmagBJHii+jDTqy4zDkhgwGswmgxQG8/8x8xVtJOGOkVsXua1d0Kq7sZImKRbNX2mlv1qXxrOtsTj2ERBYyjTnDqRxiwzXuM8hn1iF0kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESLfKRbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESLfKRbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A8AC4CEE3;
	Tue, 29 Apr 2025 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948075;
	bh=o2/FiH52o/YGB3VOOADEgrjkDGlF7WiUL20dEp6xosg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESLfKRbg6cSuzpwlifsXaMgLT7RmGaBoSht6qLbAUMjU3nyp/mKBK2cI0eamgxFib
	 5uk7fysEfCOK5EZRYLu8mau+cS3xL25GEBd7wwnB418QpA4ETLv4/xJm22hp4gsO2G
	 szhs46S2RZR2xPmJdnLe0pqHJqhCTSAO+2xcvX6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/280] usb: host: xhci-plat: mvebu: use ->quirks instead of ->init_quirk() func
Date: Tue, 29 Apr 2025 18:42:05 +0200
Message-ID: <20250429161122.637059700@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 64eb182d5f7a5ec30227bce4f6922ff663432f44 ]

Compatible "marvell,armada3700-xhci" match data uses the
struct xhci_plat_priv::init_quirk() function pointer to add
XHCI_RESET_ON_RESUME as quirk on XHCI.

Instead, use the struct xhci_plat_priv::quirks field.

Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://lore.kernel.org/r/20250205-s2r-cdns-v7-1-13658a271c3c@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mvebu.c | 10 ----------
 drivers/usb/host/xhci-mvebu.h |  6 ------
 drivers/usb/host/xhci-plat.c  |  2 +-
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
index 87f1597a0e5ab..257e4d79971fd 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -73,13 +73,3 @@ int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd)
 
 	return 0;
 }
-
-int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd)
-{
-	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
-
-	/* Without reset on resume, the HC won't work at all */
-	xhci->quirks |= XHCI_RESET_ON_RESUME;
-
-	return 0;
-}
diff --git a/drivers/usb/host/xhci-mvebu.h b/drivers/usb/host/xhci-mvebu.h
index 3be021793cc8b..9d26e22c48422 100644
--- a/drivers/usb/host/xhci-mvebu.h
+++ b/drivers/usb/host/xhci-mvebu.h
@@ -12,16 +12,10 @@ struct usb_hcd;
 
 #if IS_ENABLED(CONFIG_USB_XHCI_MVEBU)
 int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd);
-int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd);
 #else
 static inline int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd)
 {
 	return 0;
 }
-
-static inline int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd)
-{
-	return 0;
-}
 #endif
 #endif /* __LINUX_XHCI_MVEBU_H */
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index e6660472501e4..2379a67e34e12 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -106,7 +106,7 @@ static const struct xhci_plat_priv xhci_plat_marvell_armada = {
 };
 
 static const struct xhci_plat_priv xhci_plat_marvell_armada3700 = {
-	.init_quirk = xhci_mvebu_a3700_init_quirk,
+	.quirks = XHCI_RESET_ON_RESUME,
 };
 
 static const struct xhci_plat_priv xhci_plat_brcm = {
-- 
2.39.5



