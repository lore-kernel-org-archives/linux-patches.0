Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58085208C5;
	Wed, 30 Sep 2026 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791240; cv=none; b=msxMvRvM7HtA2fou8NSz8Lmz6357EH17Lm06parOybVPxCroftOv2g3gvUx5wDTD9Ng2tr6cEj6OvHihSz8v4evdUsbjQqSnxXAsMCTEBU9+hg4NzLLiozfm7Vrr75X1P0lJI7B0Y/PA+nNcYEDnk4sX8yUj8CezTw2w3k+LjJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791240; c=relaxed/simple;
	bh=nlm4dbqtojWyw5p4laJ208elDEmlcVpSyaC7BvQ5zdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMyJXYAceTdm/Qe6nCY8hznGPKnC4p62HNQ3kaz7lYIXRuNIgFhIjG+QIAoRzl5HhiiESI3mUDzeHtJKCV/LcGJ9hMzPc8dtAzwCXDiFlyAbZ2L04n+q25rTcoY+m8ktBYq4kXmQl3eYJNtvbZFeD5KVXWoSdYQhbBNcwj0Xt/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHop/Ray; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHop/Ray"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAA71F000FF;
	Wed, 30 Sep 2026 18:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791238;
	bh=otGCqe2pM2j/atOLqyYPmdfRyfzvptQWK3rT+IA665o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yHop/Ray5YdFoG6ag9PObahOMOyUYa7Oi9z74hl8D2iJcp25o0J0DqhtYEgypMOIA
	 RWZEH3xuOJTBR74ChAgmXmR0j0kt59cpw/vspr2g2zAjWByvgUcdSOskv73ub0cREc
	 hdxko06mHPvHvLf5zRerexrzr6cBFZx1rSwP09dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/752] Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"
Date: Wed, 30 Sep 2026 17:21:43 +0200
Message-ID: <20260930152403.306566672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 2d3d600a360f46287ca9afc92cc62f84f867ca42.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2583457243760..9a79df627c531 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -528,10 +528,6 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x2550, 0x8761), .driver_info = BTUSB_REALTEK |
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



