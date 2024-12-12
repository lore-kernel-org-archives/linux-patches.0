Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C8D22652A;
	Thu, 12 Dec 2024 16:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020600; cv=none; b=bN5DGSCB8EJwNpyTBk8ijspPkYdPo7x3v8qVftZ3kcz+g71T7MkB1o4VfpFGrm6tVuy0f6wbM84cKrWH8RrPG1Dzx1i7AJaCPVxZdXo+cKJgBb1H5zvKZIPc5m4n9o0pXvyf++E+XzqELmqI/U5dhm7aD8yxqgnz2cU6mL4Fsao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020600; c=relaxed/simple;
	bh=oqgEjLu5hwZ/5F9Ucbi4X2mrFPWdpk+buaQXhq5o6/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1lVAhLLEyKVsZUf3cP8BmO5LU3/BlI+mZ5qpWY0iHOqEVqXv0LPYZjR/wrZZ9xo58uusUHEpCjtOui4mpgQc2Nk7qxSIdIM4OgqymEsaqHFqiCzEPZEPikWgoQsvPUasQyrykHsAuA6ugB9KR0P9RjmC39BSyRRCSRXU/BgGGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzOI+OD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzOI+OD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7495C4CECE;
	Thu, 12 Dec 2024 16:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020600;
	bh=oqgEjLu5hwZ/5F9Ucbi4X2mrFPWdpk+buaQXhq5o6/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzOI+OD8GCfq+BX/fMHDWCceiw0GKSk1KybfO9Lp7QoBWoHbzZKFxm+yck/ludp7K
	 lbtmS9PPMU8AQTaHQOiyo81MXrXIdvfvvb7PrBmcUmIth3dlPoG1Ew4dTmqOSLEQ8R
	 FBep1fAtr1khbIU00sBGlAjNeSXAX2FlR40eC584=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 510/772] can: gs_usb: remove leading space from goto labels
Date: Thu, 12 Dec 2024 15:57:35 +0100
Message-ID: <20241212144411.026316788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit f1a14714bf48f87fa8e774f415ea9815daf3750d ]

Remove leading spaces from goto labels in accordance with the kernel
encoding style.

Link: https://lore.kernel.org/all/20230718-gs_usb-cleanups-v1-1-c3b9154ec605@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 889b2ae9139a ("can: gs_usb: add usb endpoint address detection at driver probe step")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 264a0f764e011..1d089c9b46410 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -639,7 +639,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		netif_rx(skb);
 	}
 
- resubmit_urb:
+resubmit_urb:
 	usb_fill_bulk_urb(urb, usbcan->udev,
 			  usb_rcvbulkpipe(usbcan->udev, GS_USB_ENDPOINT_IN),
 			  hf, dev->parent->hf_size_rx,
@@ -649,7 +649,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 
 	/* USB failure take down all interfaces */
 	if (rc == -ENODEV) {
- device_detach:
+device_detach:
 		for (rc = 0; rc < GS_MAX_INTF; rc++) {
 			if (usbcan->canch[rc])
 				netif_device_detach(usbcan->canch[rc]->netdev);
@@ -814,12 +814,12 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 
 	return NETDEV_TX_OK;
 
- badidx:
+badidx:
 	kfree(hf);
- nomem_hf:
+nomem_hf:
 	usb_free_urb(urb);
 
- nomem_urb:
+nomem_urb:
 	gs_free_tx_context(txc);
 	dev_kfree_skb(skb);
 	stats->tx_dropped++;
@@ -1311,7 +1311,7 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	return dev;
 
- out_free_candev:
+out_free_candev:
 	free_candev(dev->netdev);
 	return ERR_PTR(rc);
 }
-- 
2.43.0



