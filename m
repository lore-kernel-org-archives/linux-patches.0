Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F40E5013A9;
	Wed, 30 Sep 2026 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784893; cv=none; b=PxmTGSyb1sQZZ9PdsUDxHe0wbgaQJs+zDUGDhdE6qIVL6ijK8gOo6tRDnXs4/iRzsliWQWomjXyPkreVlKgO5YZP1TwQRYY6pJk29Dw9BPWnfbfhZivDdSFWhjEPFTZfzUqG1hqo24zRfHxW5JqpqKQvMMOSn3dB6brZxLNF+SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784893; c=relaxed/simple;
	bh=Rn/YJfOVSu7UkiqJrGkLhLzbJHb7Eb0R6emhPSvaXmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ld4fUkaeXBBOgJtpbJd6jAYdkOVfXBAQMNavTPbdKaOMT7s9MvgIRmLnlQ1BWHAFkn9jNxZb6lipZJnm1hLEcUDrk0/VESD8LdBIdoN+Nad3ZYj8kyinypU7s8JXZ6RxehvOp2HZrvI6YorP3YgD5Yzof5VC98fW9ZeUgGgrzuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdtvTg5a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdtvTg5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465D11F00898;
	Wed, 30 Sep 2026 16:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784889;
	bh=PgunCDGIcngoPYIFS83C7nPFQGFD/kLkfBmHX95qpW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdtvTg5azfoWPc0vBE4jQKOGN4+zWwAkwVw/CLTZ7N13id95kXD/RydjafSkDoaa3
	 1oDlCgnSBxf0v9rhND1bJg6zUEVyutu6jtTW0aPU1WhKBrSRvAgJRkzmDpfxAtgfdn
	 Q/AZ2n+RXGdiJXoXYbnd6wGys+ie/Aa7VuSSOiA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 316/982] Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"
Date: Wed, 30 Sep 2026 17:17:32 +0200
Message-ID: <20260930152423.606933074@linuxfoundation.org>
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

This reverts commit 566d0ed699a17e4a52e5ba18a73a548c343fa748.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 795a6b3de900d..153b9fbc73f19 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -677,8 +677,6 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Additional Realtek 8761CU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-	{ USB_DEVICE(0x0b05, 0x1d70), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



