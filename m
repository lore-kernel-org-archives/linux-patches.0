Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E730156C5F;
	Mon, 16 Sep 2024 12:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488173; cv=none; b=B4GuHLRyyMAPM3N2oIAnc/5inw5C9p0lro5BSK1JGfhRVBnwfg2U4u4HFpJ2CVnq286IqEfLu/Hu2BYRdIfwT4s1vpjZmpaKKsWpp1y1mwMoHOzPlTHxCR4KnUZRTQYRD9N69rxmilO0int9Cl0ZucnCZcztMYKcJe/KqPRcbb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488173; c=relaxed/simple;
	bh=zQnLSZ76TIkuXr7OYoE1vKGUMxPX/ithrRgMohicgwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSWJpenRhJkSGT7Dw4MQWFx6Qyo1L9Ezw6mXpFvyY22ZPPKRVeYtZHuIFIVimgypYI7aq8rBI0xcJf8qUpeAWZwvBc2/MITVXdjkWFyOslhswOeXIf6QcE6vGrrM2EWdiMraliRuw1+uMofeREFyGJ2gjYx2Lt0OVnqkEx4311o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcF0PHyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcF0PHyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF03CC4CEC4;
	Mon, 16 Sep 2024 12:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488173;
	bh=zQnLSZ76TIkuXr7OYoE1vKGUMxPX/ithrRgMohicgwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcF0PHyKHo4dqPg0alNvuWPqwmn9kE7ECbFc3ifl5BkuLoUHLchIYjwTY2HoAajgi
	 iDmlsImCQOuJ+5zT3VjJiE8d4o0YekcwUrrDB6TW1i026TfchBw0CXDdtM42qcbXZy
	 jbzVXo6bB9bjQKJRa66Wubj8zBmNNhI7YaoEFG58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 021/121] hid-asus: add ROG Ally X prod ID to quirk list
Date: Mon, 16 Sep 2024 13:43:15 +0200
Message-ID: <20240916114229.658254748@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit d1aa95e86f178dc597e80228cd9bd81fc3510f34 ]

The new ASUS ROG Ally X functions almost exactly the same as the previous
model, so we can use the same quirks.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 3 +++
 drivers/hid/hid-ids.h  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 37e6d25593c2..a282388b7aa5 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1248,6 +1248,9 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
+	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X),
+	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD),
 	  QUIRK_ROG_CLAYMORE_II_KEYBOARD },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 72d56ee7ce1b..6e3223389080 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -210,6 +210,7 @@
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD3	0x1a30
 #define USB_DEVICE_ID_ASUSTEK_ROG_Z13_LIGHTBAR		0x18c6
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY		0x1abe
+#define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X		0x1b4c
 #define USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD	0x196b
 #define USB_DEVICE_ID_ASUSTEK_FX503VD_KEYBOARD	0x1869
 
-- 
2.43.0



