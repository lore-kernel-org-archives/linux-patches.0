Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830873;
	b=J7ljbBL+XCRS+4MIsbzlF/S973oHB316CYwtx6aVqmuoUuIIlD7JPuZ6ro7fs4JOejHw
	 iK04BxIMBdscwIrZAUjfhipcNfHVgGsHnHCqE3hug+putKwOZ9HFUx2vGeDdI/sucwznA
	 tQz1B+IUt4bvMavikTjdofvgblK6c1eSZv+Rx0YS9DK0Q9FZFV/6mWw07+YBxGd1JJV06
	 eTJxZ8ocs8oyxzRO0JkyBpevyJdCWcnBUtDHIXYDTb+3+SX5a4NT10TYZqc1o4I8FrveC
	 4671X1CB4w0b8bEx0AlowA/4GZb4ebmKFcegl3StSiD2rozl7QJ5NPgcs6ESsMWptTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2R23j8B7SK4x0Dik3k3QSESptkx4qG8yyS/n1i8MIa4=;
	b=lEjJDpFt3qvyWOO7nKX9dRWO3W+Bj3Yrw9Wq4gPv5IdH+lg7zq2a3sCf3/5bmgKosNiK
	 ctOfqmv4lG8XhIl6SFOnOGLNBcY6QmQ89bf5tzmYcDYJVRX3nVt7n/fDJK0TNDUtcojzh
	 iqFdFYw/uwBV0yutkuv+piAamfzckZq5kkcWNsXYFOcxayWnqVbe73J9d+nQXwM/KCsQH
	 4IWitdOsdmnFdTuZ6NUW6CPY65s9e+1IRT4X59Uo4fAoUPvt4yuQmWFsQecVXW7jDnSxd
	 QPrlLPKrdwIzSNymTLDlLrUmCzeDyPs1A1BWyLZvzUJtiNcGGzJaHUlrpQ4EfEgsPPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMLampZN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5A0606E81D;
	Wed,  4 Nov 2026 22:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMLampZN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8A41F000C1;
	Wed,  4 Nov 2026 22:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830873;
	bh=2R23j8B7SK4x0Dik3k3QSESptkx4qG8yyS/n1i8MIa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMLampZN5talL51Dq4Fh45VqM3uh1cVSfqUQs6OfqZldvXO2GyBX2CYlqcvlGTzi9
	 U4EbXgxQEHlSjaq4bLfcZNuGKugfnzeU955BJ2z30p3Xj02/9KzD/EXfmn2dSlN5K2
	 5gP7eCxwpQeBN4N80Ng0cbQ4xUajz5lsGpvFNgMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zverev <playximik29@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0346/1005] Bluetooth: btusb: Add support for 1357:c123 Realtek 8852BE device
Date: Wed,  4 Nov 2026 16:01:19 -0500
Message-ID: <20261104211053.665533201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9257341b01399..3c9d5d0976936 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -882,6 +882,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0xc123), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x1357, 0xc123), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-- 
2.53.0



