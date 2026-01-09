Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CD035A941;
	Fri,  9 Jan 2026 12:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960522; cv=none; b=BFcQf9jYCF8ZI/fpuKjphC9/8ALvKX9l0RFhW48Of/oFQ0FpHOZQMMcybcOhf13PpCZVVSUC+IAsWjmiD8YHIS6XqnTHmotz+R/Xb060P5Sc0x5gJBSlldbRx53x5GD8ZpdUpjpfdv3ho7TvqH1EiinuMDccJ7dmlTzUJImPjbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960522; c=relaxed/simple;
	bh=iHRBpsgarRXnnDpZFPg5KWvonWmmEGo7jibjqzhDVcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FRBHkkUBVf1mgCq09JKGb3vPp0D4frKODu+brl5dsOgSh8lsQuXa/N5rSpdkPqUc+2uEDODo0GXe+IWeX2RNUb7+lTx78wsWG9+GZPEVbW6ViEx0Mqj52qBNmrqwl4sDFvbEtLKJW/pbe8JG7pSS5MeSK7sYi2lFLCqp6pjDLYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSyZw1vX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSyZw1vX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1911C16AAE;
	Fri,  9 Jan 2026 12:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960522;
	bh=iHRBpsgarRXnnDpZFPg5KWvonWmmEGo7jibjqzhDVcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSyZw1vXExDXQP9zFE0Oi6ZJ3cuQ184cmVhYxui3GH4XQq2YPWUfepZEG/ZLtmkEK
	 KLaaHDrEoF42ReBCwlpYVREgJrWMTAaCickVXwZwzAu9i5qRQ8r2Rn/bP+4xl1pUJA
	 IjqRZBIE6wKKJ6z3WMTYWq15aWnXQjCPx996x//s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 434/737] phy: broadcom: bcm63xx-usbh: fix section mismatches
Date: Fri,  9 Jan 2026 12:39:33 +0100
Message-ID: <20260109112150.318619129@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 356d1924b9a6bc2164ce2bf1fad147b0c37ae085 upstream.

Platform drivers can be probed after their init sections have been
discarded (e.g. on probe deferral or manual rebind through sysfs) so the
probe function and match table must not live in init.

Fixes: 783f6d3dcf35 ("phy: bcm63xx-usbh: Add BCM63xx USBH driver")
Cc: stable@vger.kernel.org	# 5.9
Cc: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251017054537.6884-1-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-bcm63xx-usbh.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/phy/broadcom/phy-bcm63xx-usbh.c
+++ b/drivers/phy/broadcom/phy-bcm63xx-usbh.c
@@ -375,7 +375,7 @@ static struct phy *bcm63xx_usbh_phy_xlat
 	return of_phy_simple_xlate(dev, args);
 }
 
-static int __init bcm63xx_usbh_phy_probe(struct platform_device *pdev)
+static int bcm63xx_usbh_phy_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct bcm63xx_usbh_phy	*usbh;
@@ -432,7 +432,7 @@ static int __init bcm63xx_usbh_phy_probe
 	return 0;
 }
 
-static const struct of_device_id bcm63xx_usbh_phy_ids[] __initconst = {
+static const struct of_device_id bcm63xx_usbh_phy_ids[] = {
 	{ .compatible = "brcm,bcm6318-usbh-phy", .data = &usbh_bcm6318 },
 	{ .compatible = "brcm,bcm6328-usbh-phy", .data = &usbh_bcm6328 },
 	{ .compatible = "brcm,bcm6358-usbh-phy", .data = &usbh_bcm6358 },
@@ -443,7 +443,7 @@ static const struct of_device_id bcm63xx
 };
 MODULE_DEVICE_TABLE(of, bcm63xx_usbh_phy_ids);
 
-static struct platform_driver bcm63xx_usbh_phy_driver __refdata = {
+static struct platform_driver bcm63xx_usbh_phy_driver = {
 	.driver	= {
 		.name = "bcm63xx-usbh-phy",
 		.of_match_table = bcm63xx_usbh_phy_ids,


