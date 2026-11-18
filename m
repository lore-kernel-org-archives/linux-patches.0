Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043431;
	b=5HwlXjCGI/FqWivDxKDdn7lKRGh+XOfVML8EqJB6tfd21Kt2VJjgphVKfLGkeK+p4CN9
	 2ubDUiT7DNXwKRMgRCdlylFPJuKlGz4O1fpXYShVmNbw/5GdyaLMyst7dyRt35K5Xt5Da
	 ZZxMCIDPdvtDHaLp2gRWfBLDfPrN8Wa/1MLjziGBgSeoAauQ691ar0WgOeA5s39lsI7xf
	 5H4dBoUMMVj9j5NFYw+q8ouzuu4JXbPzNH07zPUdnRf53VkQWnSLTVZqSFCxlmsq5Bn5f
	 2FKT1DX9Re0swW+n7DMbttYLJvRI9iPSJDzuimFNEMK7DSH/retclmwYwKY/E7mkGeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PTULOm8w0iySYv12LRybq41QwMdVTEJV1I9zC87S3S8=;
	b=3lz9PIMhgoyf9NCi3Yi6TvGGTYAt7LVNBFbtJSBrQxhcwDp8y6Ww8/cAg5Savyrliy/8
	 3170mBFjHUe25oaGga2t5zQXbSbbkzSF1LcLSxNCTdiCLsZPy0aAxIM51LvXAln/eDNmu
	 jjhwNbThUdBryEHD3Hr0gBngwGybyjlhfuYDy4TSQi0iIhBEt7gaLR2gRRMfCAB0AkVRV
	 oJ6ghPj/QobgxV0ikTAoBKqLOiRnB80D8P68FZOxGuY4Yhm10v6+PULwnGoW25TEQeL6B
	 T2DBqshMbw+Hu63uWiLwGqhxYTAEr5l1TfCp1gTz3eGb+PcKsGY9jhUUUTbyoKhKfKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GOW5urdE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0114060A2606;
	Wed, 18 Nov 2026 23:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GOW5urdE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B661F000CF;
	Wed, 18 Nov 2026 23:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043430;
	bh=PTULOm8w0iySYv12LRybq41QwMdVTEJV1I9zC87S3S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GOW5urdEoY7t55Mu5XisBbJTC8tymoPxkO+KtN+wjqNZCiFUSycfA1fQQ1lF3iMRF
	 92u8gXocq5neeaPdNIwlsfRmjlJ68KM2296VHYUyghk3zdLYzPJzWDRbzvXa/mPqtr
	 Rp1AOAGExOedBeO+ms3bVFA1nIlXnZjRRVfYTSeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zverev <playximik29@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0209/2857] Bluetooth: btusb: Add support for 1357:c123 Realtek 8852BE device
Date: Wed, 18 Nov 2026 15:20:43 +0100
Message-ID: <20261118150208.882608813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5196731ce892e..4702ab9aa9ca3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -725,6 +725,8 @@ static const struct usb_device_id blacklist_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0xc123), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x1357, 0xc123), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-- 
2.53.0



