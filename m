Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A4D5208C0;
	Wed, 30 Sep 2026 18:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791236; cv=none; b=VIC6xj09UqmOMyfI7rvUx9KpcLVKRH8HaxDhlTpJcRNTjkEO3fzqIV4Fiaj0+qEZosmc0iOc2D8L+c9dxlV0xJMxkiRWBnI0ayX+QDXrWxAbgNN9EwfQ1I1shL2iti4BKRhajJQSRdO+t8nEvTlF89SvxGVfpOlJHGodtOLDDWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791236; c=relaxed/simple;
	bh=DYxtkwLv7/HzETlZ+Qz3jLVdgOpgnUe1h2GklCBHZ64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCEiqoJPFdCipxdWFlYBp+ew/O4inW1vt6yOqIEUXTquWteKsB5UJO9QAuS3+9qDBBnujuQlTtwcVzaVRrWshxF3jFpxsXyIevxOLHRHJN4QhLpJdp+6S/TmjyU6Vt0tUxTyOjhUERCmxSlrrka7+T7dL2+rQEGslGY7zNJjlVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNF2mi9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNF2mi9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6B41F000FF;
	Wed, 30 Sep 2026 18:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791235;
	bh=hqz/8jCAgckh+T2hQBfizjaoxYjGR9FqoXtIDAsvCzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNF2mi9Fmdy+28XVH5vYYlvYkuKcPkNSIuD+lfnrmYeBhYVRluGAp4qJ5zf7ypQot
	 ymKZlmHxu4jx4fhcHT5eiEnHQJvIp4y/HGSBTARsOrKwdMyLD2ZjT6M/Ya6Flu6EaI
	 UHAPmywN5PaTekRYaW9kchXffPnxIJAq1Pfm9Woo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/752] Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"
Date: Wed, 30 Sep 2026 17:21:42 +0200
Message-ID: <20260930152403.284907151@linuxfoundation.org>
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

This reverts commit 6f54e3e62b7641ce1210795f49e02dbcf94886e1.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 84e783f9f8752..2583457243760 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -531,8 +531,6 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Additional Realtek 8761CU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-	{ USB_DEVICE(0x0b05, 0x1d70), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



