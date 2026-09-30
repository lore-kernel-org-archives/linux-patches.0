Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F413264CE;
	Wed, 30 Sep 2026 15:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782846; cv=none; b=l6Fa3w0gL5jh2HnsqwlfUYILf0U4KtwdkWwjAt15wO9FPgf37jWE1V8XSatJuG2+vd0ovqX6JYTXsqPl1raH8nCKv1vcf2Pewc/iXIvwK/R0MDvbNQhCay3B1+dtXyDSSS04tofXm8fXf+UvVDgLT70ahsKrnzLocaeAVCuVwng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782846; c=relaxed/simple;
	bh=wgIaHqdL7XElduylUacs7k3vLLyWK0beh6qukyeyrdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9UF+M92e9oYlVrDYedarFbCm0pSfOQ0KnAp/a/6Y01ELUwTHsBH6YEHUj4utA+zxnlv59gA9sjwuEEJ4oxNzHfUXiMkSpcNwpjaUeFyblvr4QQdE/KQ+W+UUh6Bg3UtEc7UMDbEezvdfsjmWNMBPr9mWVZxMaIthp/KdV2TvI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIW1CPBh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIW1CPBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E6B1F000FF;
	Wed, 30 Sep 2026 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782840;
	bh=Xqc+MYXA9o7sjLpMMmmMIS+mrh4YpT9IWoJ9gHYdEH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIW1CPBhrYT+Je2OF/Ehn9vygjqaUI6EvkQE/EcU0+LhBGoXujbuojzlngDPWiNA0
	 Lnd1NvOosh3v1rWcD9itiO1InPQRt+ldEWyTOtKkA2RuovfAmJxfdybELk9/L3QwAA
	 QuHBVJtvvcqaXNQ9ndbKm2G7i36VNKKr+jn+mIJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/595] Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"
Date: Wed, 30 Sep 2026 17:21:21 +0200
Message-ID: <20260930152351.785498251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 5b3f64156784e38b93c7cf767e6afa06fe0c8989.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 39dce3ce666bd..132db17170fa5 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -481,10 +481,6 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
-	/* Additional Realtek 8761CU Bluetooth devices */
-	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
-
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



