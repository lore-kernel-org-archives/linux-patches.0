Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDC0335BBF;
	Mon, 18 Aug 2025 13:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525275; cv=none; b=RvWSnGC0MWoMvyUMvFOhJFHAsl6Lk9G7abEajS1RIb9i2MlIf7N/AWoRqBivStGNV76S/hZc/FIGEuOKnT5k5CyUvHoZ/mFcek14Pie3HWINVeIx/7o70upt4yZcgJiwpLQzSpLIeif8FsV0ipUOmYV4LX6b3ukEW2aZor3d2MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525275; c=relaxed/simple;
	bh=+SM4+PgOoyHNgpS3pSqOjEtVnvF6K2rDyG9TkU33TNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N85OtjWTv1KQL4fzbPqUNB4u46z3aB7/YQLgOlw9wwZ93RN6HLh4nFeMnJQpObYorZsKjeEjvc4QHhGN0WxslyQwVSB6llZhBF7AqvhxvMfGeyb+k3XuSzgSECIWM8wmstaA0CX0Zsav3mUPq4hr9Z+1s/uVgyVtTQiBaWgKN4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eq3FULrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eq3FULrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7653C4CEEB;
	Mon, 18 Aug 2025 13:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525275;
	bh=+SM4+PgOoyHNgpS3pSqOjEtVnvF6K2rDyG9TkU33TNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eq3FULrXijNQO/yPtu4Gwp6Lei6TCcZwnnxhSWjN9z2gcJS26AWSl3rlKTCBolbMK
	 hFdXt/FcJpsrk2u9a+58pIheB/mQPR0/RqCjfCMu2qkjXDbVmEfc9XTIz+vKGZCLzu
	 EhQX1BL1jwOIjlFh/+ak/cN/SjZOyw2agZoCPZno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shdeb <shdeb3000000@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 213/570] Bluetooth: btusb: Add support for variant of RTL8851BE (USB ID 13d3:3601)
Date: Mon, 18 Aug 2025 14:43:20 +0200
Message-ID: <20250818124514.006648342@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index e608355f8349..9efdd111baf5 100644
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



