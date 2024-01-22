Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF89157E8A;
	Tue, 23 Jan 2024 00:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969733; cv=none; b=WAQSCxt4KM1mktIItKTBHIQok8a4RLbY2EdUh3nSny2jam+hYWV08Tgoy8YneTBzt5oL1O6uWzMyPfwd6u3bdB/BOSR/QXmLyQrQVc1fGxRF3U7/aCFxG9790VnQQukDpD2F5gzmLmKDm5wZN4L9lJS4EaTMdaezZDrgFltlHFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969733; c=relaxed/simple;
	bh=X7Y6hHm5AZgVsfL83JpCQDmLJCEVR5LoNvZ5EZQ3HlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMzFUd8VQKJKnf61Vb9T1I/nIgB+1sXmFLukGvH8PFJDtCeH1J/buDNXSvWYJ8+zVgWSl+0fomK1uf04pQPkcPSCyXjpBRqjk+UT5V+v4aGycAheZhOVUtkYYZsqzHYTol1Q+7s4I/wyMjYkWEEG0UsMNWb8QrWgR60fZ1D1+eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rfba29E7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rfba29E7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ACBC433F1;
	Tue, 23 Jan 2024 00:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969733;
	bh=X7Y6hHm5AZgVsfL83JpCQDmLJCEVR5LoNvZ5EZQ3HlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rfba29E7V/N9lfx7FaFPWG68NOtV4xlUH2BfIzQN2w8SAewxo7PKUlltOyKgxoJt5
	 EvGHcP/g9lTJ6UFm6Qk0K36VGqDMZ8hQSxDO+jjAsmHaTDQN2y3N1yFLGGOee0kKLu
	 yGwj9vi0fSRiqb+N/vgXyf8ZqKVKLH+AWA2sveAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.7 399/641] Revert "usb: dwc3: Soft reset phy on probe for host"
Date: Mon, 22 Jan 2024 15:55:03 -0800
Message-ID: <20240122235830.456715914@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -279,46 +279,9 @@ int dwc3_core_soft_reset(struct dwc3 *dw
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


