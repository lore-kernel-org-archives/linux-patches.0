Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49255320CDB;
	Mon, 18 Aug 2025 13:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523521; cv=none; b=D1qjxgQ9kYcnoCb8uDuA3twN6EMLuxq8bwYDJtZWQiu+hxZwBMZuTVrmfMhpHHjorhU3zN/x0N8w0lS3G+8X8gdM1WMPCOnMX3QE28vSHyaFcaNY7m9rVc8FwvcPM7e78SmW/OM79OflDETotP6pO+F2K1l0zcdf8lJrg3Z09GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523521; c=relaxed/simple;
	bh=q2R+UZR25tIAuDAMTvpr8tHLnBj8GEgPFv0xLWtB9Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDLHcEiQQT715GzxCgba1hrkDogR/pE2o1uzjY9MUwC2rAPuo9cX4LLblMkt9+zzzVqBWFfjMl9SdzyLDCUBVPc6r5ZXt7YdOGeKg7AhPk6Ief/BnmsAGg1eqQBn7macHKhCd5HZxmTPmrjiZE1T9/CN46FKJDVSnQngudIyr+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+DdR8+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+DdR8+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F36C4CEEB;
	Mon, 18 Aug 2025 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523521;
	bh=q2R+UZR25tIAuDAMTvpr8tHLnBj8GEgPFv0xLWtB9Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+DdR8+U+NI1Yao3yN2hNxEIbncltKWhdnqhaCpFzk55VO+YImC2zA6PFCnf4n2wt
	 M7E2gvV9NPUz73wjgBsdi8PAtExs4qoEPSgJiw7TRp/IJCi3QxFgK1eQ7kqXK5h8bB
	 2P7Gd9eCS5P0Lf4zZQ7GL88r5kPZh6Mn8UbdKhgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shdeb <shdeb3000000@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 197/515] Bluetooth: btusb: Add support for variant of RTL8851BE (USB ID 13d3:3601)
Date: Mon, 18 Aug 2025 14:43:03 +0200
Message-ID: <20250818124505.954611300@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <ukleinek@debian.org>

[ Upstream commit 65b0dca6f9f2c912a77a6ad6cf56f60a895a496b ]

Teach the btusb driver to recognize another variant of the RTL8851BE
bluetooth radio.

/sys/kernel/debug/usb/devices reports for that device:

	T:  Bus=03 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
	D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
	P:  Vendor=13d3 ProdID=3601 Rev= 0.00
	S:  Manufacturer=Realtek
	S:  Product=Bluetooth Radio
	S:  SerialNumber=00e04c000001
	C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
	I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
	E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
	E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
	E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
	I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
	E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
	E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
	I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
	E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
	E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
	I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
	E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
	E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
	I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
	E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
	E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
	I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
	E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
	E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
	I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
	E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
	E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
	I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
	E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
	E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms

Reported-by: shdeb <shdeb3000000@gmail.com>
Link: https://bugs.debian.org/1106386
Signed-off-by: Uwe Kleine-König <ukleinek@debian.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 338f426e92e2..c83de1772fdd 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -515,6 +515,7 @@ static const struct usb_device_id quirks_table[] = {
 	/* Realtek 8851BE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xb850), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3600), .driver_info = BTUSB_REALTEK },
+	{ USB_DEVICE(0x13d3, 0x3601), .driver_info = BTUSB_REALTEK },
 
 	/* Realtek 8851BU Bluetooth devices */
 	{ USB_DEVICE(0x3625, 0x010b), .driver_info = BTUSB_REALTEK |
-- 
2.39.5



