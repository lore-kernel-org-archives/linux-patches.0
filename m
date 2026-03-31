Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF0B2D1F40;
	Tue, 31 Mar 2026 16:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975629; cv=none; b=iBwGorI+lUzaQY4rCAmC/uSndZZCxggXTduAeD/JGprtP2KcO/JCNYHKQkSMaxX2wo+yuA+i86l6u1JqrJPdqCfqgpso3IlYF5/sQkMTVKCy9fDw3qSflwgN59dRvBxZGhFNwpXvNp3y9LsGQZ+sg7ti+R7XP+aqBr3/VOCYFno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975629; c=relaxed/simple;
	bh=YP0Ubqx7qVdaYlzdONZVbPybuGCNuLr7S/3oADgA8nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXuQpWidbDOg5x8VvmA9NBjWzVRfojnJho1GTv32PjsVPmRogk9aBLIN9vqfnoWywF/onvThUINFof1weB/uJ6rGmAH5annJJYKb4+WmuMIMLv2xJxYs6aJxujl//ij1+iEhObKwqWVFExgnfv2VEoZaC99Mb62yNKuPBswLeeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLhvOzf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLhvOzf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF4AC19423;
	Tue, 31 Mar 2026 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975629;
	bh=YP0Ubqx7qVdaYlzdONZVbPybuGCNuLr7S/3oADgA8nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLhvOzf5ggpWqpoWTumDNu7q48IAyys/4KAlkB6Qu+j31fNilI8pidwNil4csNC99
	 xN33umpVM5TbRms9bU5iPcHlppL08mg3Xfm3eiM74E6CFuEJGooODQsesm8s4ENWBR
	 CviGrd5KfKgHprVVt/J4VMksG+/arIDGh/d+N0Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/244] HID: asus: add xg mobile 2023 external hardware support
Date: Tue, 31 Mar 2026 18:19:35 +0200
Message-ID: <20260331161742.633231889@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 377f8e788945d45b012ed9cfc35ca56c02e86cd8 ]

XG mobile stations have the 0x5a endpoint and has to be initialized:
add them to hid-asus.

Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 3 +++
 drivers/hid/hid-ids.h  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index a914b862dbfa4..b2788bb0477f0 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1400,6 +1400,9 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD | QUIRK_ROG_ALLY_XPAD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
+	    USB_DEVICE_ID_ASUSTEK_XGM_2023),
+	},
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD),
 	  QUIRK_ROG_CLAYMORE_II_KEYBOARD },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0a65490dfcb43..25eb5cc7de70e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -225,6 +225,7 @@
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X		0x1b4c
 #define USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD	0x196b
 #define USB_DEVICE_ID_ASUSTEK_FX503VD_KEYBOARD	0x1869
+#define USB_DEVICE_ID_ASUSTEK_XGM_2023	0x1a9a
 
 #define USB_VENDOR_ID_ATEN		0x0557
 #define USB_DEVICE_ID_ATEN_UC100KM	0x2004
-- 
2.51.0



