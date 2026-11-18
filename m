Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034043;
	b=HFe5c3a94aRw0PBF0psM1+8TkuWYXan2blY09SiyozLJQ+1aJnCNdnWZUooXH0DtAAJP
	 GqGnAbvvhF2TBcychY5eIgSWdwlDRBDUSQcpGwRKThn4ceGYv/dZHMNgDZJdyGzCbILQF
	 hg6b2pZOIZDCT1Q3t5x0e2ZO4C3HLo4ywdzMgsLWRnVcic73t7BWp6t5oXoqrpBs716Kr
	 feZMKunOfoQqKtdYXBfxSoNptEzPb+/JVVHJk6aKnNAq+TaLdmPjae1qHyylTrnh3WHoh
	 RKSPOkEHhxJm0ztD05DbGeF9Q+bw8yFDScas13lTcNCxLVrFra91fQCQ5w6lyrSV86g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FoU8gFX0ecxPihsHTVszLYZFbEteSgNJJEx3WUv/LMU=;
	b=bdNhg6f5m2mhxaPhZxBHrxHntzklzfPneZF/FVRsBIrAQDbR/9wk9+8dnUhNgIdYAs9j
	 0gdlRa0lAnNvKwI4TkpwnKTat/l/Bcw+2FG8jeow6GxZqQEMJCXqGVIgPcDZvnXCjVtCy
	 OaPnu8QxR9+wju0oBzGenaayFoqP3dO5GWuroQdq0oeu0kRdR3GkOHJcF1EazaIPs/noj
	 DnoJuIZ/Yxb6wis92fBwrCmBZZR+v1P9bUB1PI5Azd/B4qm5jQzJHDrNzYODy7mCWTB5D
	 fYMNGimNXcIaYjWiAyYvNGsS98Alv6cEXF+Cu96cttdy8XScniPkXsyEiuxDQFEklBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/CKCFfl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331B6606A320;
	Wed, 18 Nov 2026 20:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/CKCFfl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0331F000C6;
	Wed, 18 Nov 2026 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034042;
	bh=FoU8gFX0ecxPihsHTVszLYZFbEteSgNJJEx3WUv/LMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/CKCFfl6xdfYdXIKzV+Iku27r4FGN/Ib+ghssyKh0hdx+roL9Ug5h04FL78vI7sJ
	 Xmg1BnCHMtor7Upe+1NlyqsPA7WBUCh89ykigMnz1o7bYtBllxJHOMI91vZ2lHRNbj
	 RKtT2Uuu8RCm5W+ud5k5JoQPhmRAFB0oojofvAZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0229/3318] net: usb: cdc_ether: add quirk for AMI BMC stale link events
Date: Wed, 18 Nov 2026 15:14:11 +0100
Message-ID: <20261118150321.928677523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a04f758b3ba07..748720033cc52 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -531,6 +531,16 @@ static const struct driver_info	cdc_info = {
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
@@ -939,6 +949,12 @@ static const struct usb_device_id	products[] = {
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



