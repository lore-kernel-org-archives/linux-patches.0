Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACB081728;
	Mon,  6 Jan 2025 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179174; cv=none; b=BYy4a3nAjTnjoEvFR5sn0ie+xAXaI5pzolia8xxgzDNNmcBLQSxDXZ61uEd9h36KScxg25sz2lHE3DqVPqLULF5gJRN8+w5PBeUHnjaaEQj8nKxcyf0FVLWFqjNhijgAdVWGl9AxnirIbz8q0kPI5fL1du0QXKW7mzBy+nerEkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179174; c=relaxed/simple;
	bh=xp3eF2H2sfnkG3R4udk94QHSlgQs4pW5C56etR+oIPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urw4NvX2rEFU8mjScZjS65PAAq6ulZRu67bJK2Jjd/Do0NuKEZtr7cggmD6acF8wNAZv+g1ooszaYttOEkjXghE0i5rw7aEWoztqLImd69HpgDKXKp3z+Ilsvm8RhfWCyuhDWGZdVJpkuC4xHVtk9+//03dHtNBYH2wSRJB0UsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx+fadNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx+fadNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390A6C4CED2;
	Mon,  6 Jan 2025 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179174;
	bh=xp3eF2H2sfnkG3R4udk94QHSlgQs4pW5C56etR+oIPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx+fadNmEYQHUqv+3GPs4MI8AvBbvXssZ3GdseOSdjEScnoJNKwC6wQ9CviaoIr75
	 4O/pEb57DObqvylUhwQd91tMll8VV0QsNkf7o6l63WqRPSp0/cja+wxlSPKA9W07Iz
	 xcreuAg41lOIc/avukO20aZbgkxj1iHyXGJWkIIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Swanemar <d.swanemar@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 19/93] USB: serial: option: add TCL IK512 MBIM & ECM
Date: Mon,  6 Jan 2025 16:16:55 +0100
Message-ID: <20250106151129.429038861@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniel Swanemar <d.swanemar@gmail.com>

commit fdad4fb7c506bea8b419f70ff2163d99962e8ede upstream.

Add the following TCL IK512 compositions:

0x0530: Modem + Diag + AT + MBIM
T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=10000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=1bbb ProdID=0530 Rev=05.04
S:  Manufacturer=TCL
S:  Product=TCL 5G USB Dongle
S:  SerialNumber=3136b91a
C:  #Ifs= 5 Cfg#= 1 Atr=80 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=82(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=86(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 4 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

0x0640: ECM + Modem + Diag + AT
T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=10000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=1bbb ProdID=0640 Rev=05.04
S:  Manufacturer=TCL
S:  Product=TCL 5G USB Dongle
S:  SerialNumber=3136b91a
C:  #Ifs= 5 Cfg#= 1 Atr=80 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=06 Prot=00 Driver=cdc_ether
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_ether
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Signed-off-by: Daniel Swanemar <d.swanemar@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2385,6 +2385,10 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x60) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1bbb, 0x0530, 0xff),			/* TCL IK512 MBIM */
+	  .driver_info = NCTRL(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1bbb, 0x0640, 0xff),			/* TCL IK512 ECM */
+	  .driver_info = NCTRL(3) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


