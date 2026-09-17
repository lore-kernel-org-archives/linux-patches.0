Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BD54D179F;
	Thu, 17 Sep 2026 17:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664625; cv=none; b=idHcy59BpT0kfwRRdooypwvLoWz/H1cvGsn19IPggLbMj5/S1vpsvWNxbC8rUzvlEyKZ+yUJHHuRoq4WfskFdSYaLiQFTEgD5r2FdY2v8nWxSz0Qyy41H1JdVYvzGPDXQmihG3DE3Rv+xtqwCEmz8lD06HmHWaduXMn3NNLdJzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664625; c=relaxed/simple;
	bh=bRTqX6bUcDAbcS8gN6wNsNQm+UPwCR0hPtBSswjP30I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aq2Df2cMaLgcWtHXK8agZhnh1NLMAI1Xw/9qte05MvM4V0826BKUOXabTsP7Ch6kszt9yCrNqwGSB64y57dEzWN3EOoI6Sdc6oy2tkKhogHR28U6b0swLywWyatpmJzmZ+B7L18prGesk9ZO0YAW1kSrOxiz0MbRvvR2LN2U+Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7CwmiTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7CwmiTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3B71F000FF;
	Thu, 17 Sep 2026 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664624;
	bh=Nk1FUC2BTSca5USmE8Wa5Vw9KOzGBBuihQq0TP1Ex7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7CwmiTMaJ1ZPaFKScYkvCW3RPG08zIZ33eGwxBfYY6n/d6tOXa7GQ+OEROoBnrFW
	 EV6U0tuWSrLXHbL0c2qSaJ3EAkwgRmbjqCSZj1Pe/KZw7BywefUza1lg8GtWqUI7Ts
	 +k9uvhhLOROGSFV+Q6l6tnUAONNh3ozwHZYWTvBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrvoje Nuic <hrvoje.nuic@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0395/1250] Bluetooth: btusb: Add Mercusys MA530 for Realtek RTL8761BUV
Date: Thu, 17 Sep 2026 16:03:10 +0100
Message-ID: <20260917151602.737729710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 481988d27f707..0d2a205528b9d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -796,6 +796,8 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
 	/* Additional Realtek 8761BUV Bluetooth devices */
+	{ USB_DEVICE(0x2c4e, 0x0115), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2357, 0x0604), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
-- 
2.53.0



