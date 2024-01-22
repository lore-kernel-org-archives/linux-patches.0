Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD796025E;
	Tue, 23 Jan 2024 01:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974698; cv=none; b=mYb4+IQDJfJAxK04fEklu2aldNUFTWmCWS8fzvZa+Zh5bK1ZMMzHBBp0GZ0uWfeEiMELeo1oQjIh+zwDP8Smd0MQkytiva0F8EZUNxtKKobYfU5JVi8Kn/NQUXat0DVaAGaqbeVDRz5L+dm+J+rSoN3IEY0U8XlMgG8yAhXB6b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974698; c=relaxed/simple;
	bh=NleCEMcPphWq0pbzd5QRPVd+KKmhQDyEaq1XgFycVPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gDtjltkFg8R1gE9APwulKcME597hJNd3FLbW2dVHC2QDWfrWmN0/nze5BYlvbHrXoRDDwgH6d9xuQfUUDnKlXupxoqphgAKqvRKI7cfxcwuTZraoRxv8fE0XEXC9zew5eOCTdObgXQIXM5Ne2q8vlFQEqVXH6Z0JjlyyczapucA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1H8QHYet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1H8QHYet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DDCC433A6;
	Tue, 23 Jan 2024 01:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974697;
	bh=NleCEMcPphWq0pbzd5QRPVd+KKmhQDyEaq1XgFycVPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1H8QHYett8k3mhcpe6SGHS2jsP7x6zxpvXM2t6AdIas88SXmqOFooJdRDrCi8wix0
	 47Ff33KbpoKqf+KMzqJU6v/fT3bfMi2GrHb4atqx5zhIO+gCta898bWawaM6jRQiRr
	 P2n2zed7DJ4uv8MjUmbcJxFWriY3ONu4+qua6XEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 255/374] Revert "usb: dwc3: Soft reset phy on probe for host"
Date: Mon, 22 Jan 2024 15:58:31 -0800
Message-ID: <20240122235753.640500041@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 7059fbebcb00554c3f31e5b5d93ef6d2d96dc7b4 upstream.

This reverts commit 8bea147dfdf823eaa8d3baeccc7aeb041b41944b.

The phy soft reset GUSB2PHYCFG.PHYSOFTRST only applies to UTMI phy, not
ULPI. This fix is incomplete.

Cc:  <stable@vger.kernel.org>
Fixes: 8bea147dfdf8 ("usb: dwc3: Soft reset phy on probe for host")
Reported-by: Köry Maincent <kory.maincent@bootlin.com>
Closes: https://lore.kernel.org/linux-usb/20231205151959.5236c231@kmaincent-XPS-13-7390
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/29a26593a60eba727de872a3e580a674807b3339.1703282469.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -277,46 +277,9 @@ int dwc3_core_soft_reset(struct dwc3 *dw
 	 * XHCI driver will reset the host block. If dwc3 was configured for
 	 * host-only mode or current role is host, then we can return early.
 	 */
-	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
+	if (dwc->dr_mode == USB_DR_MODE_HOST || dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
 		return 0;
 
-	/*
-	 * If the dr_mode is host and the dwc->current_dr_role is not the
-	 * corresponding DWC3_GCTL_PRTCAP_HOST, then the dwc3_core_init_mode
-	 * isn't executed yet. Ensure the phy is ready before the controller
-	 * updates the GCTL.PRTCAPDIR or other settings by soft-resetting
-	 * the phy.
-	 *
-	 * Note: GUSB3PIPECTL[n] and GUSB2PHYCFG[n] are port settings where n
-	 * is port index. If this is a multiport host, then we need to reset
-	 * all active ports.
-	 */
-	if (dwc->dr_mode == USB_DR_MODE_HOST) {
-		u32 usb3_port;
-		u32 usb2_port;
-
-		usb3_port = dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0));
-		usb3_port |= DWC3_GUSB3PIPECTL_PHYSOFTRST;
-		dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), usb3_port);
-
-		usb2_port = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
-		usb2_port |= DWC3_GUSB2PHYCFG_PHYSOFTRST;
-		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), usb2_port);
-
-		/* Small delay for phy reset assertion */
-		usleep_range(1000, 2000);
-
-		usb3_port &= ~DWC3_GUSB3PIPECTL_PHYSOFTRST;
-		dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), usb3_port);
-
-		usb2_port &= ~DWC3_GUSB2PHYCFG_PHYSOFTRST;
-		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), usb2_port);
-
-		/* Wait for clock synchronization */
-		msleep(50);
-		return 0;
-	}
-
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg |= DWC3_DCTL_CSFTRST;
 	reg &= ~DWC3_DCTL_RUN_STOP;


