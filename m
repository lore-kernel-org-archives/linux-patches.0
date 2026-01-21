Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0003337E2E6;
	Wed, 21 Jan 2026 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019697; cv=none; b=NxEVAos8/kje0DhTNGTNeprT79HrPF+Iqmz2mZKv+emvx5Vo6yjHT33c0JXFtJNtYvkhtoiW0hbkkmHfsSf469EsYL9hzYRTVlDChMAj4HvmyiXqc5zjnEMLsDNjpl01wOdZwevpvjPni42Q22n6nXRmDZR777IUHgthGPad+ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019697; c=relaxed/simple;
	bh=2iBRq65kJ+qSPufBqa6Gze0QAHoxFVy9+vmtWFX9oy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FN5xgjdy/1CwY4XlxK3VWtIBNiey+GCg31GHXqmTa3jLj4zU+ZNj0oRoJO9RPRuPWkcffXsogWZywnEc3GGxOihf1KhrZqz/m31IYqBKmTp58UlI337Mj2GnbljuP1nXrpiEb9JvacL7wEPhNoT4zcnrpXtW57wjyT7eK1BcSLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNq51rGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNq51rGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3161FC4CEF1;
	Wed, 21 Jan 2026 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019696;
	bh=2iBRq65kJ+qSPufBqa6Gze0QAHoxFVy9+vmtWFX9oy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNq51rGOTMoCWkYAngxlshJt1JVHAKyhwT20rqgWnIXVmVW/I8L09ECWKZ8R9BQE/
	 CAOV3FczJ691SojtuSR69+5PqVZRYiH4FrrIejIyo1QvcjrYlOJefIn+IJOHMmkcwE
	 bggj9/+sWiAe43J1+nPZsaV48IMwPXB53LYEQx60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulrich Mohr <u.mohr@semex-engcon.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 081/139] USB: serial: option: add Telit LE910 MBIM composition
Date: Wed, 21 Jan 2026 19:15:29 +0100
Message-ID: <20260121181414.366689217@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Mohr <u.mohr@semex-engcon.com>

commit 8af4274ab5999831f4757dfd5bd11665ba3b1569 upstream.

Add support for Telit LE910 module when operating in MBIM composition
with additional ttys. This USB product ID is used by the module
when AT#USBCFG is set to 7.

0x1252: MBIM + tty(NMEA) + tty(MODEM) + tty(MODEM) + SAP

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1bc7 ProdID=1252 Rev=03.18
S:  Manufacturer=Android
S:  Product=LE910C1-EU
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8a(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Signed-off-by: Ulrich Mohr <u.mohr@semex-engcon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1505,6 +1505,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1231, 0xff),	/* Telit LE910Cx (RNDIS) */
 	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x1250, 0xff, 0x00, 0x00) },	/* Telit LE910Cx (rmnet) */
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1252, 0xff) },	/* Telit LE910Cx (MBIM) */
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1260),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1261),


