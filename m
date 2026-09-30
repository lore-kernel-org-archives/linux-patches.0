Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1735012A5;
	Wed, 30 Sep 2026 16:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784897; cv=none; b=PX11lJRjJgB8sFD57snTdpg61mUSxiH+97rsnWFXdiDAegDnZxMIhu6MOvv5wvftwktmoMa55h/WBDEIzdGiblLb/S0Vn2lGNEJFtqfcsagSlG92eB6+f3BSxzHujVn0AqFU9S4jr2OfB+aM5R3y2PYQZgKbeZXuN4L/0zLJfso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784897; c=relaxed/simple;
	bh=TcJfd7pXLgV8Lm0FV6gGLxbsQQKPoMz5IZGiOBOvN7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUG0lL9xaCQ5oP5MYyHVuoeinwUm4ago6DU4PcPmqXlpaL9a1h1Y3XsA7H+GPHGFJCrbYJTbMU7whxKK5XvbxDwVvJ9bFabZayWQ9uf07ICPIv91w7q+ODnVHdu/6QQ3lPAQMo77I7zWRT1QcSnkyf9LC0EBx+joZC7gktY/IwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4Q81HTo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4Q81HTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C661F000FF;
	Wed, 30 Sep 2026 16:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784892;
	bh=26puEHyUolYVzfBJhwA4zCdoj078oJqfxFwe+5vPCqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4Q81HToJ0qrWNagRyUzknWMnQiT2dJzPhA8e+zvdhW4SVzhcn/3y4vJ3MiATvzNN
	 vm1ltEZYpLZ8ABwpmlb+rqI09ezM7w1FLfQ+96QrJKqjF9H/5HAj8EoWA5YrcGA2qU
	 LdpbYlKkKPTz7NHRRHbwb+4ZprLKjK8IOKIiHNSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 317/982] Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"
Date: Wed, 30 Sep 2026 17:17:33 +0200
Message-ID: <20260930152423.629012055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 128aa24b355690e76babcaa463c29618b20a4ac9.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 153b9fbc73f19..e545cf1abd0ea 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -674,10 +674,6 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x7392, 0xc611), .driver_info = BTUSB_REALTEK |
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



