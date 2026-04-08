Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AD9324B1F;
	Wed,  8 Apr 2026 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672862; cv=none; b=QvwD+PhObFWgugsHiRXY+SbMxCozxSZwjNtBBMYS9jJKdiwx69PXvMV0Z8bOaXJnrICLFzYiOmnUw3mEN9iWEsdYVhpls8cMNG9kine0k0rt+nGJx25qmLHtaUm88sHsCf2+yDuKPRS9LLowRr1mKEoO0ZMtGP9dl20ei/G0UkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672862; c=relaxed/simple;
	bh=O/Cr1B7TSn8rhgV2fmeD2asi8YTCD8Exx1g7JqSikZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCDeAIN5nanj5drNEF58F2tIuprNOqEFr7LmjGVKyH9N9R1CiDDBlHh1OQX3pFnn6rxv/tI/CvLslypKQUDpatBdPTY5bvcvqKTnl7SqmmOj7kAB3V9yAmBNB+oNxJiSr5r3cTKeRfAuReAo26BVX+JuztyQN6b/rW2Ei+QJuto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaoZ7Vm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaoZ7Vm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F829C19421;
	Wed,  8 Apr 2026 18:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672862;
	bh=O/Cr1B7TSn8rhgV2fmeD2asi8YTCD8Exx1g7JqSikZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaoZ7Vm0DAsgXjW6TIt+bHX6TLzWQmKDkL+ukb+3EjzQQarNYocCiJi0FDxajW30z
	 5p883611Fnj6i25Imu7hkeqxwsrHHmfDUO23V2WuaS+iKjWwYi0hYgy/vdM2wwSqrY
	 bV3UmE7sH/REo5ITKl4UFZQgPmcwzYKuEv/9cOHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Freund <adrian@freund.io>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/277] HID: logitech-hidpp: Enable MX Master 4 over bluetooth
Date: Wed,  8 Apr 2026 19:59:47 +0200
Message-ID: <20260408175933.933485251@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Adrian Freund <adrian@freund.io>

[ Upstream commit 70031e70ca15ede6a39db4d978e53a6cc720d454 ]

The Logitech MX Master 4 can be connected over bluetooth or through a
Logitech Bolt receiver. This change adds support for non-standard HID
features, such as high resolution scrolling when the mouse is connected
over bluetooth.
Because no Logitech Bolt receiver driver exists yet those features
won't be available when the mouse is connected through the receiver.

Signed-off-by: Adrian Freund <adrian@freund.io>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 6b463ce112a3c..3522e69da78d7 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4667,6 +4667,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb038) },
 	{ /* Slim Solar+ K980 Keyboard over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb391) },
+	{ /* MX Master 4 mouse over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb042) },
 	{}
 };
 
-- 
2.53.0



