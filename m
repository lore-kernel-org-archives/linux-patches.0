Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061502;
	b=eta6rWLrU3+1RkZOnJX4RaLc2MuPZ1ePlA6O+o6TiAJoW5s+y+pRz9TtEsJ/GbFcFlXD
	 0/QxVc3/oEvsViwrT04R8grYJF/CBSEneAC54Tsd5B8ZN/Cn6wUQjOuX7pZi3IMegbnMi
	 u+yeCYLFoEPhvCBQkh3+qVJkOHHlku77ML/gsYVRpPmsV0xeRtb7d9kBaMmafsSFA5i3r
	 mTK+zjGHwRuOSg2PiraU1Bf7JkFlzgFw/D3FI8hhXo8Yk6GO5Dl7CIo1U5VgKb5zv37wf
	 k/2+l9j2rto3m9mLpZ6rOsxnZJJI/h6PaoC+MOj3k8jgud3t5ZCaNl4Qu5JHFFEO/Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YZ4UPY8kZ44ynHtGiRkzKebqLsj0vJkEHqY5F98AzfY=;
	b=dMainN3/M+NHG/DSTOk+F5M43pJAc2k6yRj2jVWMkJ7TWnuaFIkITL/81V5gFKd6dILl
	 llj3oj2uNbXYSkX5e7OlGBfgFMInn4OxWTm2/5pD/JJqcyRtX8ykTN0p4IhdujNosbTiA
	 bIawUZpNVEhy7Ycs5NRHzaKhe4krc70Xh/j1uAb6fXjpQ8KFPCXKgH5W4FcPMbJ3fsCtL
	 Y/TfzshUlXpSbPl+fDz7AtBplRmVeCF25kCrXtMGeLTH0JYTWynoVHbqS1W/OeXRfTE5G
	 bPD/SYwWiv4qQn6eIT3LONfsvpfbjrOajFdViZlx/sUhtMrxrh6nXdsnvdCEr6IkwAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzuEmu5l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9C9606A331;
	Sat,  7 Nov 2026 14:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzuEmu5l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4996E1F0089F;
	Sat,  7 Nov 2026 14:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061502;
	bh=YZ4UPY8kZ44ynHtGiRkzKebqLsj0vJkEHqY5F98AzfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzuEmu5lU9y62hoAdhAUVXLOFCYhl3mTO4LH5MUVscPGeiM3ZdqXNzF9PJdNRipx5
	 YN0ykjiudbsbXNwv1+36LN3HEUued/YAkbz8hDnrxd/pahajYxQaXoDsIXggJshV3Q
	 5eLtj6bv22KyvC2Ts+G8S/Ed9zJevKtsDUMN2dQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Brangs <erik.brangs@gmx.de>,
	Christoph Zwerschke <cito@online.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0597/1536] Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"
Date: Sat,  7 Nov 2026 08:43:33 -0500
Message-ID: <20261107135014.311202175@linuxfoundation.org>
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

From: Christoph Zwerschke <cito@online.de>

This reverts commit f05baf6e0680d8c10d2fbbc5953848fc3e3db957 which is
commit 980084de4d9b25193398d89a1c0430ba3501b683 upstream.

With the device ID in the table, the adapter is handed over to btrtl,
which in this tree, together with the backport of commit 4a23ce935f74
("Bluetooth: btrtl: Add the support for RTL8761CUV"), now requires
rtl_bt/rtl8761cu_fw.bin. That file is only shipped by linux-firmware
since 20251111. On systems with older firmware packages, such as
Debian trixie, the adapter no longer initializes. Without the ID entry
it binds via the generic Bluetooth class and works on its ROM firmware,
as it did before the backport.

Mainline keeps the ID entry, so this revert is for 6.12.y only, as agreed
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
index 9fc1e3d2dded6..32465e6736d2a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -817,10 +817,6 @@ static const struct usb_device_id quirks_table[] = {
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



