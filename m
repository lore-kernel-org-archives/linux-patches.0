Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B56B2E285C;
	Wed, 30 Sep 2026 18:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794442; cv=none; b=b34d4i4VKjSYT54aCoWz1zjSsTSTOa1rIlJvtJjNHIRBD4qlRlI62gQk0URQqEpkV/quZWTITVrfZZye+HmAqSjpWgBm13aYFo8heCmTBBIRCTLKo9KvUaIbz9/MNZrs4HOErHunDMYWGr5cDM5B5qTb72/JPvUwd+TFpl3lMH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794442; c=relaxed/simple;
	bh=EhzyN/5Svx6bryUygayCFziS7IE6RZINsWkzMDNKCgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sryee63/ELn2vBCRwirxq+3iV3SbvNon9pKdME1SsGaaeTT3EdThcYLAbCeECmMjXoZFIcS1BDWoAcgLnJ880XG8o0/VuQ8qebTKFbpMvZuBFpJhGVesuvdoN4ckELE7rwM5/6VGfrG6gaMVd2oU+ERvZdOYCO/lHloAXO6JxG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwcGsZp0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwcGsZp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67DA1F000FF;
	Wed, 30 Sep 2026 18:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794441;
	bh=w4pqIrEyLC8iDEnS2c55JSV3g2U3sJyBfNNUSvs0/7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwcGsZp0uN9IpqdRQ+AtyKBkJgsaJ9Sj+pLVlf3RAmh2qCenOIycb5FSdCtX78vPS
	 +XGRpaXT7QJIxzgJYNKUN0QWXn4qEFNPZe2p0BKutQrlDvxudAxnpwJFhQ57fW6hTC
	 Z4y3fkS6YBCimr6t4i3ezmMH0H1sJy0hMV8FTiqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Cris <cxs1494089474@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0212/1193] Bluetooth: btusb: Add support for TP-Link TL-UB250
Date: Wed, 30 Sep 2026 17:14:56 +0200
Message-ID: <20260930152438.914256442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cris <cxs1494089474@gmail.com>

[ Upstream commit ea77debfe443f505a4edbb7f21340a583a8a143f ]

Add USB ID 2357:0607 for TP-Link TL-UB250.

This is a Realtek RTL8761BUV based Bluetooth adapter.

Without this entry the device is picked up by the generic Bluetooth USB
class match and exposes hci0, but the Realtek setup path is not used and
rtl8761bu firmware/config are not loaded.

The controller reports Realtek Semiconductor Corporation as the
manufacturer and LMP subversion 0x8761. With this entry added, btusb
loads rtl_bt/rtl8761bu_fw.bin and rtl_bt/rtl8761bu_config.bin
successfully.

Relevant part of /sys/kernel/debug/usb/devices:

T:  Bus=01 Lev=02 Prnt=06 Port=00 Cnt=01 Dev#=  9 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2357 ProdID=0607 Rev= 2.00
S:  Product=TP-Link TL-UB250 Adapter
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Use the same flags as the existing TP-Link 2357:0604 entry.

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Cris <cxs1494089474@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 973f222e8fb85..39fd747740f5f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -734,6 +734,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2357, 0x0604), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x2357, 0x0607), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
 	  					     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2550, 0x8761), .driver_info = BTUSB_REALTEK |
-- 
2.53.0



