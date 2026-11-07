Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061501;
	b=llyDxPli5H+bLflz1M0+tGzZxTwI218owMhW/MiKGN7Rcs1xEEXx86dikCxTqoU4bVOt
	 R3rQh+I1QUIaGYbHUvO/zTAI25IT+QwULqCTWXR6REdg7rO1UbnQvwwAS7W1yq8nLm1TM
	 /NHwqnkuAVwIL8gpd+qiVdrTw2jBMfk+4YyDmcVHSm2wF6v4EQaakgQUk9TNWMqeROOSV
	 69zaAzPujpGXy9W5q+DnacHMjW9VSNDPo1OGf/SVl7a3digYsivl3cq1x5Fr96iMY2kIY
	 vp2gffeE9bRuE8vvNRHuhZV2YLDhy7iW8vCPIfApiHQ4/YHsOaCPnUGus7aL4qrfKAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MGHFdZ2O002Ihlh4o1C+vfiSPRuTBo2OgeCnHnFCjBg=;
	b=XngvQHelXY6w5E6x78o6leuIODVXmIzGv97rehK5gAfG7TknrGLNALL6foYfHxkF7p4W
	 WcdSzmztzcaMCFuu2gTD4pIfb4bHzkAsz8Y0nzKTFNVH+rlnyaaI4PjEs6xUBynJcAtHX
	 REUtI8tOpntPlWXM7rTMtE2RTIJvqygwYD0KA8zwd4npqn64QqMTH1SqnHQSodXfgCeJB
	 6byMxDPzuPaV+oMl/7Bagnf4/M5NjWwgJF3JbX13voWIhS2jf0xissGSCmoSaHVnYD7/y
	 4xsPckOVAdHEBRDz+D6NSOQZiM/A2x3QISv7F8XqqAor7NUo2uwyBNujc5/e3CxXI0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoxqcwAz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64812606A331;
	Sat,  7 Nov 2026 14:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoxqcwAz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6231F008A1;
	Sat,  7 Nov 2026 14:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061501;
	bh=MGHFdZ2O002Ihlh4o1C+vfiSPRuTBo2OgeCnHnFCjBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoxqcwAzxqED5kKdSw6UCBHBYzWLhMhXSNnNdBkurz9RH7pOxoVLsPROTbQIjE7XE
	 agUj3T47xjkBbRvd+zQpbHz2CL8crJm4Vap10TqDbTo/SZazBb4+sH103crFJNBp0z
	 1c8AEDiZAO4FdRDbM0BdL7A1JMHuda9rrR/PvCYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Brangs <erik.brangs@gmx.de>,
	Christoph Zwerschke <cito@online.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0596/1536] Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"
Date: Sat,  7 Nov 2026 08:43:32 -0500
Message-ID: <20261107135014.282258661@linuxfoundation.org>
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

This reverts commit 32412aff8d11d00672053cb10750869f2de94a1f which is
commit 6f0624b4427e38c3bb63a951c536cf8adaee1238 upstream.

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
 drivers/bluetooth/btusb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 84238687ff653..9fc1e3d2dded6 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -820,8 +820,6 @@ static const struct usb_device_id quirks_table[] = {
 	/* Additional Realtek 8761CU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-	{ USB_DEVICE(0x0b05, 0x1d70), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



