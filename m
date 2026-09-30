Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D19511E90;
	Wed, 30 Sep 2026 18:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792283; cv=none; b=fCofGlHVRilLLI2Mt+WGzC2j0JLfDvEryJWOwI5LMQlS8BlXxmIVS/9CStKMYnxx4TQ6vsbTARikknqeZYrxFIMendd85RHMOrEeijRcWjKfhoi1a/PvxBShkzu0oNwXXxg5CR8mBxg4Bx/SbQ10YFy1nfsF07aSUzU6rRMVFIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792283; c=relaxed/simple;
	bh=ijfZvZVsg8tc7yDrFY9Zu55eyBFEouhP7pvyP+QrXC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7hRUSur9+lvEzFXqjckG73Zi9CSQBb4h/qX9yNBj11KJIs/taet7d3fjC148CBw1AV0Q9s3nZztLCY5VQkE+7K8dHFb9IXT2jeCTJm4EUMj6XKcXmIsEgRlV8ja4y3egJFy8fu8FxUTqQ5AYMa7N44x4YbPr5Tjg0QJPiV+WbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dy3n8Xaw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dy3n8Xaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B9F1F00898;
	Wed, 30 Sep 2026 18:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792282;
	bh=JWX9nKm/t2A1fU/JkqwxISuwlvrQWvNUF6Sun+xEFtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dy3n8XawRUPyTuspWOZoW/1k+A6MTSKI3Kmiyv/B21RqPpvqH66Q7Z0ACo8mo2o/H
	 G3PNCBZh4X2v2asq4NXMO65KtGKIVBX/nDaXsNL3pCACptbfckWGlmmFOROKLlCm92
	 hzOAFfy7L4ShLRONiDM7It1xwkVTXUTLU2C/v07A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Priego Verdugo <oscar.priegov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 598/752] HID: elecom: fix bus type for M-XGL20DLBK
Date: Wed, 30 Sep 2026 17:27:48 +0200
Message-ID: <20260930152411.225282461@linuxfoundation.org>
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

From: Oscar Priego Verdugo <oscar.priegov@gmail.com>

[ Upstream commit 8e2a4b458ad25e13422bb059758c30a6562aa9cf ]

The M-XGL20DLBK is matched as a USB device by hid-elecom, but
its entry in hid_have_special_driver[] uses HID_BLUETOOTH_DEVICE.

This prevents the special-driver quirk entry from matching the USB
device handled by hid-elecom. Use HID_USB_DEVICE there as well.

Fixes: 55633e681afb ("HID: elecom: add support for EX-G M-XGL20DLBK wireless mouse")
Signed-off-by: Oscar Priego Verdugo <oscar.priegov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 6e9501fe1a281..6ad1c67ea4a1b 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -392,7 +392,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 #endif
 #if IS_ENABLED(CONFIG_HID_ELECOM)
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
-	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
-- 
2.53.0



