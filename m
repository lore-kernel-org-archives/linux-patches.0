Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF222E7386;
	Wed, 30 Sep 2026 18:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794439; cv=none; b=oSvj8+L25aasMvdJL7HOhNvWOJV6L9Suu9NEHCoDH3sCrl2L/thqfCTmTHVx0kzWfhKrWFJNiJiVyvfcdP5IRCTA1r+7z0tziIwWkObG42NtYycFp4F/RWpfAfmE/6WD/5CRIU8NneTBZ6KWtixIU59+WjmV0E3pRrSlfWGTfi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794439; c=relaxed/simple;
	bh=TJKuTv7n9ZUE90D67r87Fcp4CIFbB363RJN3q2446mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdK6MhnJohk9RGghI7+5vwh1Q/8Zu4PL4iMlSss35kJ6s2/83OMy8cgAdafPZBB0qcdhnw05aCngD73ake/gKR79m8gjW1ebwq2hbvBSEZrCm1qwQLpYKaCNxgOlyY8RzWchXcg//iDzpokduQ1loE/w4QH7pOROgV5Owsrpxqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=De4A5AZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="De4A5AZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17A31F000FF;
	Wed, 30 Sep 2026 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794438;
	bh=gSw/BkSmrw4MVdVx1vYl36LsiJ8jwfP9EzLUwy2v0EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=De4A5AZFYHtAkbC02pDXXC5eQyC0CvRBvOV4ucbdfPN8eNZtVUsCPbIDLdb6lojO6
	 Q6LRVLCBMFcEVGYxWHaSUnd61BANfbVNzIpYMt0oyZfzUeB1MxKp4vVt3CRVnSz4we
	 usqdpdGcahPZQIDBxfj9sZqbUtvQjIkbk16d99Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrvoje Nuic <hrvoje.nuic@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0211/1193] Bluetooth: btusb: Add Mercusys MA530 for Realtek RTL8761BUV
Date: Wed, 30 Sep 2026 17:14:55 +0200
Message-ID: <20260930152438.891444091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hrvoje Nuic <hrvoje.nuic@gmail.com>

[ Upstream commit ce21a5cf3d1fd92b84ea9ad2b7c7240aff2162d2 ]

Add the USB ID for the Mercusys MA530 Bluetooth adapter. The device uses
a Realtek RTL8761BUV controller and works with the existing Realtek setup
path.

The device reports vendor ID 0x2c4e and product ID 0x0115, and loads the
rtl_bt/rtl8761bu_fw.bin firmware successfully with this quirk.

Signed-off-by: Hrvoje Nuic <hrvoje.nuic@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1edf8674dd108..973f222e8fb85 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -730,6 +730,8 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
 	/* Additional Realtek 8761BUV Bluetooth devices */
+	{ USB_DEVICE(0x2c4e, 0x0115), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2357, 0x0604), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
-- 
2.53.0



