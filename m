Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8AC276028;
	Mon,  9 Feb 2026 14:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647884; cv=none; b=mjoCw7IB4Ko0ozkvQfIBK97eAqKxd/wma3WB+FBjAbHUKJYhynuUN3vtsev/7lPEF+KTNaCpG9i0PxfhX1MOzu6Z+6nRBfIP/nZCj8QCKPhOueIjkxYUhlOqU4yl8SmW6YanQ0atKQmRCRIqoSvA3SUShmv7klbofEGCZEOPfhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647884; c=relaxed/simple;
	bh=/6DRFLSoc2AzRcqzlgGiZEPsl6xtV3wAaO7ePvvwgoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvEeuJ+tpdP2QQXQZqfrlnuSppoGPTVOdOUQZr2G5pwfy+ZF/r/lTzPuFtbQF2qmTmpfiVAyBICdMs+UspLvSMdMzJzI09bSormzZa+eiTH8UIVO8ia1VlC8InZaE6QCA/jvYsXPuA97VUrSfYpgemQVWciktFYo/fwowO9xFwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikJhWSiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikJhWSiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E22C116C6;
	Mon,  9 Feb 2026 14:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647884;
	bh=/6DRFLSoc2AzRcqzlgGiZEPsl6xtV3wAaO7ePvvwgoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikJhWSiT+Cz9SG4Ha58qRrEUGSKa5J+A/JZCsOUriyAX6YmUaBI2lH4pWHYTc7lQj
	 Sg3d0o9I1ujX3yHBcxBBrvPRgqZiLlu9pfOjSuIgUYjBW6KQ6LoslxWjnO4wyf9jx9
	 7qJ2md76DB5jZ6XFGQjlYvQ2BsapEXNXcKW+Jbe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Marttinen <twelho@welho.tech>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/113] HID: logitech: add HID++ support for Logitech MX Anywhere 3S
Date: Mon,  9 Feb 2026 15:23:24 +0100
Message-ID: <20260209142312.177608826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Dennis Marttinen <twelho@welho.tech>

[ Upstream commit d7f6629bffdcb962d383ef8c9a30afef81e997fe ]

I've acquired a Logitech MX Anywhere 3S mouse, which supports HID++ over
Bluetooth. Adding its PID 0xb037 to the allowlist enables the additional
features, such as high-resolution scrolling. Tested working across multiple
machines, with a mix of Intel and Mediatek Bluetooth chips.

[jkosina@suse.com: standardize shortlog]
Signed-off-by: Dennis Marttinen <twelho@welho.tech>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 7d5bf5991fc6a..c470b4f0e9211 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4689,6 +4689,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb025) },
 	{ /* MX Master 3S mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb034) },
+	{ /* MX Anywhere 3S mouse over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb037) },
 	{ /* MX Anywhere 3SB mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb038) },
 	{}
-- 
2.51.0



