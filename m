Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034085;
	b=PZTXt1qn7KqaW9Tqg66+KtcO2YlR2xsFQOP+Dh/+5IY0bpnftKzlqfUNV30BhYdbfXpx
	 VOid3Nj6oRNSUqR0kN0PqwvscMrjLBK6sW2H80NHNK/9Ward70h510vPNNaVrxADZ9+bQ
	 7yBPDPmcHDvrxpC3iYBJQE3nCTROLsAonzZ3MrDyMeg35MMdpqqqire+d5QeSLGICM63y
	 HodGt+CyOZoWQ8WwTUpqCnMD+XQuF7IxKPMGLnFBZ5MHSjBSBy9vuuAOH2CKqo3/ZkZp7
	 GCPAEKciIC+J6R19Hytu1H/au8Uy6KSEPYJuaub5uu4EPZp4brqMMLlcQEnW87ZtDKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R8OfiOoCfhGAj38CqIdMqFLYIpe3VNfc6QtXh7034nQ=;
	b=2sc4jpzPODEY2UU5FxudfnFeb71a2XNSN7okOL6TuLtpEQu9C7e+IlUMb+2YyZb03qI0
	 ncCDYmy+JVy3/jmlrJ/SdyUqt4Ox2U24SCIVv51At0rbp/4osEWbM2YJbw3n9vy6TTtfx
	 q/AJn9pqD42hgBbD9egB651JLBYbYB+a1bGvPI+6z3Phh8j2VBnePNnMf/JvSHiEnaOQI
	 PkXVEF4oBKtohhL0yfWEQcaiNXRuMtWmuUgPYn2plaFLEPiMYzNxskyuJ/7Cb8iuYS/R/
	 JqDAZ2+Upw1wn51Uay0no5qST//oBnMlFLwqtb8//L4s6GuqnggvaT7/X1C9ZbQftjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgjHXI7Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0757E606A32A;
	Wed, 18 Nov 2026 20:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgjHXI7Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279B61F000C4;
	Wed, 18 Nov 2026 20:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034084;
	bh=R8OfiOoCfhGAj38CqIdMqFLYIpe3VNfc6QtXh7034nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgjHXI7ZI2YcUz2eYcZKN5VRg1zk3K0lOydqxjow2K8Cue5/eU10ky65olYfPQEM3
	 45KAOYFJJ2Hcl5irTT3u8AcSnu+merfSJmP5h9jiN8edH45EWYGm6ZFct3mx2Z71pC
	 JQ5tYzslJes1uzeS8PKWRNFCcRm/eGh7DLyWsRgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zverev <playximik29@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0242/3318] Bluetooth: btusb: Add support for 1357:c123 Realtek 8852BE device
Date: Wed, 18 Nov 2026 15:14:24 +0100
Message-ID: <20261118150322.400274794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 95becfdb0d2e9..a5a7cd41e0ae9 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -804,6 +804,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0xc123), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x1357, 0xc123), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-- 
2.53.0



