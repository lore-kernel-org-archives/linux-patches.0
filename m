Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051443;
	b=1MOXT3JS1V5bwz+ld2cVh4MWAltrUs7DOgJLCyuowpHk4m8QLVAxXmrYOdvGBXIerF4U
	 TnZTf6AqNcTw79YvQnwljaY7GBWGm3s4nXVgfIJcis2XAddJZfQpVbkOXOEMt5gm4wOgD
	 Vp9JOZFbcFFsC2FxRbxofDpe9Ycw4fhnkiife7GqFGUrUSDANTOtbVDqo/yI387vP1p8O
	 9TRgb/H0vQXt5MrRAnJkyxqh1rKyOmoFJozJwuHtWDDFTKJyWkkWhjzjzTvJ8MXPjMoMU
	 mGnHmk/DjU1adqbFuVsXJG6LHZPqrifm3qFECkGrukmtA/UiRfjGJr8wu3bZUTSND7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RCr60fqxegy6gvkYh4Efj9iDQPJlX+TTAYqyO3EZ2H8=;
	b=GJf0fbS8zKME417GDbWTuv/lALHFVCw8QY2SseoNnHwpXD0VNf8vWd+x39ZkJTcvDdt8
	 OnSpAK16lik22E+sbpXOfGU/Rj0MyRA+4GCRSBvWltWnODm2LxCRXwMWEbGKrAUrlYH3F
	 d3jCt5jY+1gV37WqRnrDXfRKJP25vZNygsb/B38pc/iKdqOuReRT6lXmMRH2iVvG+dQx8
	 ISqbWpACbP4BexzftFDKPgxMyGHMnwyDSBSiC7LEF3HrbWmNY8e+Dc/c0fehO9baqPsMB
	 xcYWO69PUHZpi0VKO0YHAT9LD8NTDOZOBCcAzAKAaWZS0hfsoAiW4b6gISrrv6T6Kvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KumeLs7e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A45606A31C;
	Thu, 19 Nov 2026 01:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KumeLs7e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319A51F000C4;
	Thu, 19 Nov 2026 01:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051443;
	bh=RCr60fqxegy6gvkYh4Efj9iDQPJlX+TTAYqyO3EZ2H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KumeLs7eWZAb0O6DaCM7LP4oPaU9UQe5uDkJ7pe5m7XuvhBiWUcTHEljHcnEjyoBH
	 E5BvMqtxEpNUrixNApXTS4v291Pkh6+j5NY7WxOrCYJLb4qP8he5Yy2u2yx1zcvD/c
	 MhHYsa5QofcWsM12+MWvfBWWvR+nboBSa0qXWazo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0176/2214] net: usb: cdc_ether: add quirk for AMI BMC stale link events
Date: Wed, 18 Nov 2026 15:30:52 +0100
Message-ID: <20261118150017.096247969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit 089ca284afb0f3b2870a5ce41524cbc91ed350d4 ]

On AMD Genoa/Turin platforms the BMC-provided USB-Ethernet gadget
(American Megatrends, VID 0x046b PID 0xffb0) intermittently fails to
respond to ARP after AC cold boot.  usbmon captures a stale
NETWORK_CONNECTION(off) immediately followed by
NETWORK_CONNECTION(on) on the interrupt endpoint (~130us apart)
after enumeration.  Because alloc_netdev() leaves
__LINK_STATE_NOCARRIER cleared, netif_carrier_ok() returns true
when the spurious OFF arrives, so usbnet_cdc_status() cannot
recognise it as redundant and schedules EVENT_LINK_CHANGE.
__handle_link_change() then calls unlink_urbs(), killing ~60 rx
URBs whose payload has already been DMA'd into memory — xHCI trace
confirms them completing as -ECONNRESET with non-zero residual
length.  rx_complete() drops these unconditionally.  The following
ON restores the carrier and re-submits URBs, but the ARP reply is
already lost; the interface looks "up but silent" until ifdown/ifup.

Fix this by adding a device-specific quirk with FLAG_LINK_INTR set,
which makes usbnet_probe() call netif_carrier_off() after bind.
With initial carrier == OFF, usbnet_cdc_status() recognises the
spurious OFF as matching the current state and drops it; the
subsequent ON is the first real event and brings the link up
cleanly without ever tearing down the rx queue.  The scheduled
link-change kevent is harmless because EVENT_DEV_OPEN is not yet
set at probe time.

This is applied as a device-specific quirk rather than a change to
the shared cdc_info driver_info because some CDC devices never
send NETWORK_CONNECTION notifications; forcing carrier off for
them would leave the link permanently DOWN.  Restricting the change
to this VID/PID keeps that class of device untouched.

Tested on Genoa and Turin across 100+ AC cold boot cycles; ping
first-packet success rate went from intermittent to 100%.

Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Link: https://patch.msgid.link/20260730051341.24930-1-guojinhui.liam@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ether.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 695e4efdc0114..ec72fc24e2335 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -530,6 +530,16 @@ static const struct driver_info	cdc_info = {
 	.manage_power =	usbnet_manage_power,
 };
 
+static const struct driver_info ami_bmc_info = {
+	.description =	"AMI BMC USB Ethernet",
+	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_LINK_INTR,
+	.bind =		usbnet_cdc_bind,
+	.unbind =	usbnet_cdc_unbind,
+	.status =	usbnet_cdc_status,
+	.set_rx_mode =	usbnet_cdc_update_filter,
+	.manage_power =	usbnet_manage_power,
+};
+
 static const struct driver_info	zte_cdc_info = {
 	.description =	"ZTE CDC Ethernet Device",
 	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT,
@@ -1033,6 +1043,12 @@ static const struct usb_device_id	products[] = {
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
+}, {
+	/* AMI BMC gadget */
+	USB_DEVICE_AND_INTERFACE_INFO(0x046b, 0xffb0, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET,
+				      USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long)&ami_bmc_info,
 }, {
 	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ETHERNET,
 			USB_CDC_PROTO_NONE),
-- 
2.53.0



