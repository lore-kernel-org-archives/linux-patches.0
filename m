Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DF412CDAE;
	Tue, 30 Apr 2024 11:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476273; cv=none; b=jreapMCxlFv2zoBO76V5n55S4GtB4cwtNX7MyL/AhMfrdMVdP4xTT+WQVzUb04FIlr08SFKa42SEQjEB+DG4hZDtqAgn7p3D1WVyizXocTveeqFK95uO6hkpUtzc2anzZL8k0dbFSVLFPyZFvoJpj86yCSFC2aWDx+vHk/zGpck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476273; c=relaxed/simple;
	bh=rMN9/b3K5u7wkK6Ut/XvtAfZwCUvl3TeLY148J+V0OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfrBvAMP8tyzy11LC8HbZzIoFQUdDD0P3/DYtJ3dX7lu6kvhWzvR5AZ4PTB3cC0Vpq8D3AhTEclkeAQpaiYn30v5RjchM0R9uSZcAusG84AXsJUiHaz6hHHV0esh6kzsIGwvwxVcCEGog+suFzTD/q5t9qNh/Ybdl+7uYeHPPGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuvs967H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuvs967H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965C0C2BBFC;
	Tue, 30 Apr 2024 11:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476273;
	bh=rMN9/b3K5u7wkK6Ut/XvtAfZwCUvl3TeLY148J+V0OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuvs967Hki4iKqUoqPCYXNJxsD5ZA+v3u7VU070Xf6gIwMsIwU/nSntpbbBjQbCyc
	 zrmiNgKA83tTWNA57xtGMfOubplzQSrFVPfEFJoeTczAPEwO5pMXGW+A2HIl3QpYFa
	 QWeS+6+Rqo2GV8fRSuWfUbLAv4H3m2FiN9/TKFr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coia Prant <coiaprant@gmail.com>,
	Lars Melin <larsm17@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 040/107] USB: serial: option: add Lonsung U8300/U9300 product
Date: Tue, 30 Apr 2024 12:40:00 +0200
Message-ID: <20240430103045.841121822@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coia Prant <coiaprant@gmail.com>

commit cf16ffa17c398434a77b8a373e69287c95b60de2 upstream.

Update the USB serial option driver to support Longsung U8300/U9300.

For U8300

Interface 4 is used by for QMI interface in stock firmware of U8300, the
router which uses U8300 modem.
Interface 5 is used by for ADB interface in stock firmware of U8300, the
router which uses U8300 modem.

Interface mapping is:
0: unknown (Debug), 1: AT (Modem), 2: AT, 3: PPP (NDIS / Pipe), 4: QMI, 5: ADB

T:  Bus=05 Lev=01 Prnt=03 Port=02 Cnt=01 Dev#=  4 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1c9e ProdID=9b05 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
C:  #Ifs= 6 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

For U9300

Interface 1 is used by for ADB interface in stock firmware of U9300, the
router which uses U9300 modem.
Interface 4 is used by for QMI interface in stock firmware of U9300, the
router which uses U9300 modem.

Interface mapping is:
0: ADB, 1: AT (Modem), 2: AT, 3: PPP (NDIS / Pipe), 4: QMI

Note: Interface 3 of some models of the U9300 series can send AT commands.

T:  Bus=05 Lev=01 Prnt=05 Port=04 Cnt=01 Dev#=  6 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1c9e ProdID=9b3c Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
C:  #Ifs= 5 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=03(Int.) MxPS=   8 Ivl=32ms

Tested successfully using Modem Manager on U9300.
Tested successfully AT commands using If=1, If=2 and If=3 on U9300.

Signed-off-by: Coia Prant <coiaprant@gmail.com>
Reviewed-by: Lars Melin <larsm17@gmail.com>
[ johan: drop product defines, trim commit message ]
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2052,6 +2052,10 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(LONGCHEER_VENDOR_ID, 0x9803, 0xff),
 	  .driver_info = RSVD(4) },
+	{ USB_DEVICE(LONGCHEER_VENDOR_ID, 0x9b05),	/* Longsung U8300 */
+	  .driver_info = RSVD(4) | RSVD(5) },
+	{ USB_DEVICE(LONGCHEER_VENDOR_ID, 0x9b3c),	/* Longsung U9300 */
+	  .driver_info = RSVD(0) | RSVD(4) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },


