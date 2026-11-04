Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831359;
	b=JpVRH7hHNUGXFh1+gpTOUAZUBeoVADTztW04q3zVusGXthwPCqtiVUdG5Fnpcijwrr1V
	 mz9WXF1UzRYAGZv822qLspDRU+5SOMFtMu9m/bjHh6NO4WlNgvPbmxAAPi/zwYfm9xi6x
	 zdwo/pgfzYl2lJdhHGT24u8hmxSDHYbUdUlLLTl6pKr3zzQDH/60DteTblUTZXVutChQy
	 fF4Q4NtIr5LqV9mx/1QCbgbDqNv5JmOimDYY1bn3jPyy4YsH7OwpSCf6tzZ61GmPsnGTU
	 2NMi+qXoRM1DLQjj2YAy9SgeGq9I/QwlbwlhsZe5l0qgTCpbQqUHrtvNAFHmd9vxmSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7pVpPiiyLmGI3YhXJqx04csyfjb6bSS2LJSuquNIZGI=;
	b=MTHBmYVi7ZfBHNza/Ck5b9nypr5pWtK+WvwULSLjK83zDwUhfFNZ/9ca3gc6jlTfBiYY
	 TW8elJ5ybAIX9gq7ieoOuEFZQfxc/abZC8rx1UP5051sc4smNK6XsFwL+G4WseT+XwnO/
	 4k69FLL9WBrYfUmHG1Vb+TS26NMPynBMqOWq9N2O2BBky47bwhnAjiHHD6dbuurQiA6M1
	 obcljOw42r4bBbOZpPTQY6tkqvStlAgNCbuqNJ6ZImaaJDyXVyl+ZH0hsgcYPZXYM+Uat
	 5cmVzVlOuQNgDXazjUd3vB05s7R5mNt19Ebth+Es2XeyW3ChcYh9tSl8SyoXxdZIj1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="M7aRpR6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9855606A336;
	Wed,  4 Nov 2026 22:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7aRpR6/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8E21F000C1;
	Wed,  4 Nov 2026 22:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831358;
	bh=7pVpPiiyLmGI3YhXJqx04csyfjb6bSS2LJSuquNIZGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7aRpR6/TiDFY1XYvg7WANrKllIXdmK2nS/mOMf76OSVnIkD4ikiCppzuJTi+WWDw
	 5ANLwYACLrON58TwObppOLz6CMjbfSU8q9Y9kjpJQSWl7LQxQYnmzvxno2DiAboWWG
	 E0MCQcBmIAFEv9ukaNfQ/143JftfAotcCZNL4Ieo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Brangs <erik.brangs@gmx.de>,
	Christoph Zwerschke <cito@online.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0656/1005] Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"
Date: Wed,  4 Nov 2026 16:06:29 -0500
Message-ID: <20261104211102.077034711@linuxfoundation.org>
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

This reverts commit aa7b93fe98ba726971b7d0c68320ce513e68aac2 which is
commit 980084de4d9b25193398d89a1c0430ba3501b683 upstream.

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
 drivers/bluetooth/btusb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index b571918aac953..0b8c2ecf0a64c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -844,10 +844,6 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x37ad, 0x0600), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-	/* Additional Realtek 8761CU Bluetooth devices */
-	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
-
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



