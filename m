Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060918;
	b=EH7YnA4/CwtkrOcVqnnXpp4ncfbxI71HxjGyAVmJWhIZNU73cNV2YUWZlI0vBmXKrQhs
	 h/BZMWEy04sS9JypDEEiz5i+KNGrc7iU7+XZXnXqF1SPntCDyG4NcFyck6ZnoMPf2nUgu
	 3xExoF91A16ZfcVwj2a+REUFUA5GiOW9mmMkgzRCyLPCc0/fSy9xuw93mgIK2ev9WJ6i6
	 uK7zIzK5Bt2WdHKc6B6mwudyfuZUUNbKs3TkecvM5KXOuwmy+a4E84/XKEGbUgk4txLGw
	 iE7/xmYaJMaydjBkQ6S8Ubzz1aasy92DTztYjUP1iHJC3iEFUrdJOD1AKn4zRRYUo7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0BOHHwvYmYYqpqKyMFt0oWdURV35rsZqYV06Qpkr++Y=;
	b=vaeevD41/d6JshAX/bn9QXJ94Y5qLJIA2lnpwgClStE+jJ27gtoKLfPiYkTF0OlWIPjQ
	 HzJlW+ZBjVZWUceA3ksF/Ca+PqHykvqx3Yf7894fplFn9B5l3yTVRrngNI/5rj8Xb4rEF
	 uvppNLirEa7yvPvh0EqzrH6YgqUkH0EcfyAbfyNX4ViWm2HuPyaUbmz7hAmOBAXWOwUOX
	 DXsjnnn+AyJGurzncbSE+L0LjbrvfZ7VqEqu+c27aMFv5L9VRCLpR+h1Jyk8cmzFXwBrr
	 nETJePvarH5EC/MxYxgHGWTiSvxBwGEUAntLrmgc+ScFVC/bLJu2xB1c95txQLi6rBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ecdVon/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB4D606A33A;
	Sat,  7 Nov 2026 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecdVon/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D18B1F0089F;
	Sat,  7 Nov 2026 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060918;
	bh=0BOHHwvYmYYqpqKyMFt0oWdURV35rsZqYV06Qpkr++Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecdVon/MJlJ4X8uiZtoOAQebnfPNEFAcSKipXO6p26YV+sfSHjcGhWNUfxRai997w
	 FnKdxiGVYx7JjsSr5JzpjzBreEihpyeZT3CuA2/sk+yzU1FAKuCU00noUZ7O2gEYpP
	 l9rKDpo8euHTG9dRLd17TaHhpaagLhT1QWMVadNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zverev <playximik29@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0286/1536] Bluetooth: btusb: Add support for 1357:c123 Realtek 8852BE device
Date: Sat,  7 Nov 2026 08:38:22 -0500
Message-ID: <20261107135005.691719116@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Zverev <playximik29@gmail.com>

[ Upstream commit 335d7bd554a20f33acf762655cafe1089f7f5822 ]

Wiko Hi MateBook 14 Ryzen 200 laptops (DMI system-product-name
"MNCA-XX", board "M1060") are equipped with an RTL8852BE Wi-Fi/BT
combo chip (rtw89_8852be), whose Bluetooth radio enumerates as
1357:c123 instead of one of the already-supported 1358:c123 / 0bda:c123
identifiers, presumably due to OEM rebranding. Without a matching
entry it only matches the generic USB Bluetooth class fallback, so the
Realtek firmware/config (rtl8852btu_fw.bin / rtl8852btu_config.bin) is
never loaded and the adapter cannot discover or connect to any device,
even though hciconfig reports it as powered and scanning.

Device descriptor:
  idVendor           0x1357
  idProduct          0xc123
  bcdDevice            0.00
  iManufacturer           1 Realtek
  iProduct                2 Bluetooth Radio
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth

Adding the same BTUSB_REALTEK | BTUSB_WIDEBAND_SPEECH quirk already
used for 1358:c123 and 0bda:c123 fixes firmware loading and normal
operation.

Signed-off-by: Pavel Zverev <playximik29@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 00aa0fffd0c94..84238687ff653 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -855,6 +855,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0xc123), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x1357, 0xc123), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-- 
2.53.0



