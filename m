Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D325172F0;
	Wed, 30 Sep 2026 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786846; cv=none; b=dv76+FVNF9pTd0VDJ6eztLmqMGHx+6/OiPcGVz3j+8CwLn5ouAAXAcJ3JY8SBB14cN4KNh2l+GAxVj3e82V4R4t7Ofwf03dOL1JygG8V+SB6pks/kKuhkVXWHSVNgAUBULJV2/dfAEySDgyJxl6HDUV6urfEGGZWqPGMDn5S71o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786846; c=relaxed/simple;
	bh=t95w67subIz1Fr9iAwCoEwZZW8VqI2p4DF30oJXFaKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfZclo79X7CtzHal6ON5B7qmGsNz/CinVn0Dfpzep59JIwkLpx2pSQLxehfztUCLugSB1PYM/MxXfIpdlr+581ezAjqudR2Sjcss7/cTqS8DiKzMJE/qGGdrYSUhTGBg3iReSUDCGgHO65IdFvQpovzeToZIyfWBCOwi1et2ytQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ri5QVMCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ri5QVMCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07AE1F000FF;
	Wed, 30 Sep 2026 16:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786844;
	bh=Rz6mfCbFRQjkk+sT04rup0NinZJZNlc91dg9kZ1Hatc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ri5QVMCLGqPpqcFhRwT3diibYyU5v8eCWoWpjYPD7XwJw8JnBikWEWfbmD0lMUw5y
	 Wn4slnQPYJtWj6C4S+J62m8ffOrLI/NRGWQpq5PiFtr/0WG/99m5Dua0VoaF+ffi/N
	 v+KPhTtSsrrMrDQzj5W5bQJQftKPXyY9wNiO3cJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Priego Verdugo <oscar.priegov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 023/457] HID: elecom: fix bus type for M-XGL20DLBK
Date: Wed, 30 Sep 2026 17:22:08 +0200
Message-ID: <20260930152346.530914271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 57d8efdd9b890..0ad8ca20cb9d1 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -422,7 +422,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
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



