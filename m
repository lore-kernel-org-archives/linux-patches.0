Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831357;
	b=AprdGjyVLJuQ5amLZk/16ZiuQ9fgxuQswrw29sE71SvWabQvoeVAnHDhtrtye6swQP7p
	 yqpBGeHaJMGD+Auf9vAUxDuGRX1NjdySP2VCueyNdY5k508CJxtFCkyriI7und3YULTxA
	 wabVlkcBVD1rR2Sm5DAzPt3+FPweVAJgmVnNr3WzaHfqR4jSQGw+7M8DZEpUnkzCRnEId
	 0wZ8Xjlql4q6tW9lmb6n5ujS0xhuD5WaLFhpYZ0Th2mMOOIecfZIM5Q6i/bJnqE/hKmNM
	 tk/VleqMV+6x3NVXTac4RhSGCZd7r4qHx7lzl5xjyWgAnBxpAsj0h/DcfUm7ks+uedw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cr1yXMm4Dp/8XRqbpCXTr6L3IjLzzB0zq8k5R3IKDCQ=;
	b=W4CtRbAZ7aE76oGnBmnoS0Z9JLyPrSmfMh9kUFgmQCow3lLwHZ20sUBGHRC04RZ3DtgS
	 fpKcWSNQQzP2C4AJDSyqyVoGLApkxSAG8oyRlyf/iDioa68qkld87dHvgc2PPK9BVpo2k
	 dv9OsYZDgN0akSUohC4ngerDSHzBvcuuwzk7Qzf4VvaB9NR4NF1liPkNHR3BSngjTLvQp
	 6/BE0c7BjXo7lSxLaeb9cU70O+FNUQK5dQJJSqkRVu3BBYlGoCqJGFhuc+brGr5NLrMhb
	 v8pYknZKw8r3fKUE1f/LRhsECDDPTdwnLoNTQA7WUYyI1n8QyD8pOUO+a1IEvd1wsGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGdGGpRW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FACB606A336;
	Wed,  4 Nov 2026 22:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGdGGpRW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0D71F00919;
	Wed,  4 Nov 2026 22:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831356;
	bh=Cr1yXMm4Dp/8XRqbpCXTr6L3IjLzzB0zq8k5R3IKDCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGdGGpRW+wLGOYr1i6B9kVFjcOhqg/TM/BsNgMqteluzN4IwErWy8R6wvQHDSIqCJ
	 /7ZgAPQqWS52qyipvc1LY8522o/eka0k0mVrmXCb+J/h3sKd11+2hTMCBkPmB2H1kc
	 Y3zvSmnO7/fHcNTfKasYEIIXcI/qBNn0MlLnUohg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Brangs <erik.brangs@gmx.de>,
	Christoph Zwerschke <cito@online.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0655/1005] Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"
Date: Wed,  4 Nov 2026 16:06:28 -0500
Message-ID: <20261104211102.052626862@linuxfoundation.org>
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

From: Christoph Zwerschke <cito@online.de>

This reverts commit bce588b4ca081833ed8fc62062291f71d4218278 which is
commit 6f0624b4427e38c3bb63a951c536cf8adaee1238 upstream.

With the device ID in the table, the adapter is handed over to btrtl,
which in this tree, together with the backport of commit 4a23ce935f74
("Bluetooth: btrtl: Add the support for RTL8761CUV"), now requires
rtl_bt/rtl8761cu_fw.bin. That file is only shipped by linux-firmware
since 20251111. On systems with older firmware packages, such as
Debian trixie, the adapter no longer initializes. Without the ID entry
it binds via the generic Bluetooth class and works on its ROM firmware,
as it did before the backport.

Mainline keeps the ID entry, so this revert is for 6.18.y only, as agreed
in the regression thread.

Reported-by: Erik Brangs <erik.brangs@gmx.de>
Closes: https://bugs.debian.org/1149377
Link: https://lore.kernel.org/all/179104011040.2214689.5921682013387867802@eldamar.lan/
Signed-off-by: Christoph Zwerschke <cito@online.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3c9d5d0976936..b571918aac953 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -847,8 +847,6 @@ static const struct usb_device_id quirks_table[] = {
 	/* Additional Realtek 8761CU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-	{ USB_DEVICE(0x0b05, 0x1d70), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



