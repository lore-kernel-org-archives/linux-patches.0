Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5166151B19D;
	Wed, 30 Sep 2026 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789060; cv=none; b=lIHd/Yc6QP/VW2CPavdk6XtPNfIzFHZneZqHPGiQKvAhSONfWSlsoE7cOs6puzmG8g3Fn9HnocHcVhFSQl8pGXC5RK6u2RvCG1Zpwd/OM6h2zs/f2ZQWyeZirjgp2EtD8lMCIRHsPDaSZs2uM6GiiSlBWOUQi26q8YWPjz2GhiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789060; c=relaxed/simple;
	bh=+8BYCUqcLGbjF7Jj3azj4/biz57P4NbiKCa6/cQj9Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRlrpVC7Gwn7ehUB7N6c5uM5sgDhIqiEdYDX/aVoCvtFWC5N/9xE81reAN0wqFrUuY9uMjKOdwxEdTTpuLb8CvjroJRKzg3uWluzVx2o+9R9G+3YYs+1O+OGuiNSdRSIznCdLjWfKCKT4ugg5WfyGqpVMUGJm706XzKugMD1OHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fM3U8kNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fM3U8kNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C5F1F00898;
	Wed, 30 Sep 2026 17:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789059;
	bh=0tAqMyBJIxRrdK18RO/2tRxy5W4ekEeAAJt6Nh6NG0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fM3U8kNlmJ77p+uhEscIXJnQbUKPoMjKCtsAO56D2+1ONH1A+dHXH7wYEbcQDjFk6
	 kG6RO/jquPKPQMitsI9/Qf7qqRxhkpcDBj0vCyMmZbu8hQ1Mj084Tu9q31eWzojnFT
	 mVf9Y/ji/OXOKbvnnl9gyWfPldnZWrhzaSEze8KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Priego Verdugo <oscar.priegov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/877] HID: elecom: fix bus type for M-XGL20DLBK
Date: Wed, 30 Sep 2026 17:20:18 +0200
Message-ID: <20260930152421.322426610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 39d81777cb7e2..2f086ac897605 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -416,7 +416,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
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



