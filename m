Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060898;
	b=algCKTW+2s/RBTcT2mFt+nqcA+SCPNJ6JO2fBmeobJYJT0yQ+nU7YokWEEtkx14Lw0P1
	 nCuav/PzLPdrJz6A4Rqeq+FVUzv354S2XKgoBkqgNdas/O7ML8jEweRuFjvm9L3UtHH8q
	 lklIrDzamUJinGRc49bMW81Fq7p650wyMRHkMClLgKmxjJdkSuvfZuqIhk89z0F3l9ACB
	 EMEGg7cIfTVUafVEwRDSKDO6Escjb2Ebs43DBO1Oz3liednwFL+SunM1iMqEAczj4LenK
	 im9LU+KBKy7FNatrtTAq1vUFregLPbtCr4h6wHJIp+5jrd0nK/LW64cI/knS4TOJVYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wjG5ux0YCgMXTFogWk3LN+N9nCwNwn0K4wilkTuOP6I=;
	b=q5GnUefyKOU3+jVal21fdughKBBWCuPkHw0Jfh0MgPQsdeTmQd0XlD+0n2zlDyWF988t
	 FtsOA74IyhxqRorr9Ne70rsaIKLYW6WbbDYx4WrAfoID/d+Mtcr6e1fXgGomqHc8kDtmM
	 YEhWaO8tozxDlwx7ivT1U27SRHO8Cq2I4/EsryDHya4r9LzuYrobrUV8kHKyZinAynEGc
	 Nsdur6FXWxF8wMCDJj/o3u77SsiXM4VWkZaOmntNa669i67yO0d5+bky11lRv6LTqQj2E
	 IYRtToXoqgtOO5TnhYinZHxWm0L4tXdWHqKTkw738k+uB6AT2yv8OCMPZpNrJWHZNDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dRY5yb/E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB802606A338;
	Sat,  7 Nov 2026 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRY5yb/E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954521F0089F;
	Sat,  7 Nov 2026 14:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060897;
	bh=wjG5ux0YCgMXTFogWk3LN+N9nCwNwn0K4wilkTuOP6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRY5yb/E0WYCcAkwxfOAFJpowd3MPQPDX3iRk2ChNSOfWs2qxyGs2jfnWLZ3CImna
	 4YEoecGTXPoi2d2o7A2VKbPPHGIdqhoH0ZD4RVWMAHYNdAH6gAZmeJ460PjXBc4Kw/
	 Xqf6eL+lva6eB8gH3B3uxZtQ47nbCc0f102qVldo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0272/1536] net: usb: cdc_ether: add quirk for AMI BMC stale link events
Date: Sat,  7 Nov 2026 08:38:08 -0500
Message-ID: <20261107135005.316323644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a032c1ded4063..05e625a461b49 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -532,6 +532,16 @@ static const struct driver_info	cdc_info = {
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
@@ -940,6 +950,12 @@ static const struct usb_device_id	products[] = {
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



