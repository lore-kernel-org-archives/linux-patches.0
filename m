Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FE025A321;
	Wed,  8 Apr 2026 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674211; cv=none; b=jVvzDzvnwRavHeFfHylOXvqJONnLy2y9XuwN+8quGKBtPPmqzM5DvT23rBlsn2guWqaYx7/Ga3QikyiWf/XGpIGn/iMucRbh980yVsc5ZWcXY4Szb926v7rct/ODY8j37RcgsefXlmnEYcHTe4Rb7aeiyo8VpA/OxEL7GDyq2IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674211; c=relaxed/simple;
	bh=q9fxxSGLlCWieFjAXxkAmoPGjq8NBa2k49qpV21s8tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKg7vqpbZ5dbGeLhZsmiDdR3kfvsbENMXuAiHJSkKUsbkw2tX80yUpyFQ5XCHrVOTtd10pPLRAcFGdRr1FADRdiOb/tr+yLqnLG+XlblzlQsT4lqv44ccev4pBoHmRU9FCSKDpg/g3Xu62XBIY+d8Ht5x+3Z12oahnwBjYIVeVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my3MQeoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my3MQeoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0432CC19421;
	Wed,  8 Apr 2026 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674211;
	bh=q9fxxSGLlCWieFjAXxkAmoPGjq8NBa2k49qpV21s8tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=my3MQeoWrv6CoCPra/TSnkvFfoBwRncMa3pypOQ3I6+Z6NaL71daZdMi1E2laow0O
	 CVhQp5dg+n7g2K0wAyclHUyNzZdeF7mnznejDMXuBNDsZ3dpoFBXMASvfbSaUl/Esa
	 7dENYBkrDwlAkuw5fFGudHMCNzq5RkhdrDZo564Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Freund <adrian@freund.io>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 010/311] HID: logitech-hidpp: Enable MX Master 4 over bluetooth
Date: Wed,  8 Apr 2026 20:00:10 +0200
Message-ID: <20260408175939.796726496@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 02d83c3bd73d4..c3d53250a7604 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4668,6 +4668,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb038) },
 	{ /* Slim Solar+ K980 Keyboard over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb391) },
+	{ /* MX Master 4 mouse over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb042) },
 	{}
 };
 
-- 
2.53.0



