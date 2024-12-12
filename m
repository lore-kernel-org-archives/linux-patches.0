Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189792AF0E;
	Thu, 12 Dec 2024 15:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016944; cv=none; b=bWgokGX2LdvPzTVptjUf9dWBWqflbLvB7MVUBHX1qhs2GCw92HwNIAbvDs4lqMkT6sdC/9LTu+Es34vOX8eecwFrrcZi+34bb9OBcpxWCqTxrGqniWA0tpFyg8RSBYaJDerg4i3tN3E+cwHTalAEkFr1LgJyilXB65PHBcdNHaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016944; c=relaxed/simple;
	bh=E0uzK/boG5F+M4Qjwx5lFBugQg/IjLfT1YSgPxmb7cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRFkdtYWdTKq8Gp/5m1HyPExXo0k8R8B/KjYGsA8ftN3f9ACm977bkzxReDEnUAw2VWWZgnaWljRS7+xmELujSbR0x67kn0ihtq87jCOloJIJfiqnVTKS1kfKJop2m8uo9t16TzAdJIrMvrliSMDdUBFLfFmJ0hiVFqvs0Bb1RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4M/vTTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4M/vTTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF4AC4CECE;
	Thu, 12 Dec 2024 15:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016944;
	bh=E0uzK/boG5F+M4Qjwx5lFBugQg/IjLfT1YSgPxmb7cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4M/vTTcj2HKxtvidvJedKzFCeEgFbWFAGSdIzXJM88BbH9bcjmx6JyEMF7XYVH6X
	 xc6Nu8v2mFMZK7Qi9pkHUZvQyUwazHyeZVaYx/kSVZ8OQa1IbT22mkHarFnfDLRpFY
	 cbxim9OlNZ1baODL1eYIrOxaBOWz2sSn6vnaU9tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hilda Wu <hildawu@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/466] Bluetooth: btusb: Add RTL8852BE device 0489:e123 to device tables
Date: Thu, 12 Dec 2024 15:58:29 +0100
Message-ID: <20241212144320.215030414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hilda Wu <hildawu@realtek.com>

[ Upstream commit 69b84ffce260ff13826dc10aeb3c3e5c2288a552 ]

Add the support ID 0489:e123 to usb_device_id table for
Realtek RTL8852B chip.

The device info from /sys/kernel/debug/usb/devices as below.

T:  Bus=01 Lev=01 Prnt=01 Port=07 Cnt=04 Dev#=  7 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e123 Rev= 0.00
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

Signed-off-by: Hilda Wu <hildawu@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4ccaddb46ddd8..c247fffbd6361 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -524,6 +524,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3591), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe123), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe125), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-- 
2.43.0



