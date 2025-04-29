Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B596440C03;
	Tue, 29 Apr 2025 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949966; cv=none; b=Lvf8vfHYYx6+F1seSRdaQoubRNW8iq3/82g31Jy/Yca4tFSVtvycG0Zg8Qf8V0caAJnhoh7c/h48Ya+LVUbDPgYjIeCO9mBcRomlCq+8fJQSOCX10w3Yoiwy1BOTFGHY/dmRMr3mLRfiLpYcDNbh7Oh2enmC60XzwYeIsK9oXJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949966; c=relaxed/simple;
	bh=hzSuneYZEYtAWCwfmAjVXH6NGRv3qkHYSe9T5d5q/Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nBW1SRBclvMEkjXj+DoQysdxqbblMvpAiOCSiAcc6TZB7LRjjMEHvXFJD0bUev5myr39p0UAnQ+MZ+k8QA0q9HouCLqBjxvOGqnq+bytZA+5te6t0rQCG8pRAbyR8d9xCSjAVxVqT3Fih/6vjAHGdTZrFxkYZAcvPoMoMK4x13M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XICz9tB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XICz9tB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23869C4CEE3;
	Tue, 29 Apr 2025 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949966;
	bh=hzSuneYZEYtAWCwfmAjVXH6NGRv3qkHYSe9T5d5q/Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XICz9tB8CFY2bF6j6Q5Coi+CcmI6KkntYHwG1sv6fqoCvazNelFVZAwU52lIp4TR9
	 2kAJqIBV6VIMLxrlTPzwNi/TaQLSp6EeNko5EmMXSt4o50SH4h+miSz57V73iTAovD
	 k37fLd3v8aLlN8emgCJ66EB1u24zslCCp3UQsQb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/167] usb: host: xhci-plat: mvebu: use ->quirks instead of ->init_quirk() func
Date: Tue, 29 Apr 2025 18:43:41 +0200
Message-ID: <20250429161056.311420069@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b387d39bfb81d..59f1cb68e6579 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -111,7 +111,7 @@ static const struct xhci_plat_priv xhci_plat_marvell_armada = {
 };
 
 static const struct xhci_plat_priv xhci_plat_marvell_armada3700 = {
-	.init_quirk = xhci_mvebu_a3700_init_quirk,
+	.quirks = XHCI_RESET_ON_RESUME,
 };
 
 static const struct xhci_plat_priv xhci_plat_renesas_rcar_gen2 = {
-- 
2.39.5



