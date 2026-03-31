Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B262EE262;
	Tue, 31 Mar 2026 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974271; cv=none; b=E9wudvub1CvAZno9LGST3sKePrd8QUoQrH+yQixWLDOWqsR+Mft1jqpQOsxJsMp/haxHIr4rOHPKaLzzz3Hnvok7fOAsviAUvxrb4VcCbfdXJwDdpck/QdAs+4FcZwcBkXW1JNM6JjJpx43BBtpR6JLT7GL/5VM3g3tqPchBZvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974271; c=relaxed/simple;
	bh=PO0TTyLrEQxpoCQLbC2bBK0Znc3DoqMSKdQS7eBfrrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiemwtIgvo52EdEceby6ClLUEVOhNvXGJqGyocOTzkTKKUXroyTa8hwdhUYeRLNuTzxS8UmOuXvZ8bQvqQhJNeQEs19mBcOhAv3+KUyodMqt2/XvJwYbBtrzvbXoUQPgwpyxssYbDtY+XVBgZR29AlcE97nhT8USCJjPRl64344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odpsebC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odpsebC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72B5C19423;
	Tue, 31 Mar 2026 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974271;
	bh=PO0TTyLrEQxpoCQLbC2bBK0Znc3DoqMSKdQS7eBfrrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odpsebC6z3EhooDqlhNAxBM2sVqI6s2f6WQPV1VqAAZHwM7OCjGz139pQ+9zqScXz
	 6+mEjZhdzU2n0z8X+VuFQLgoRJs290lmWstTZ4JrXpG/9QuwqG6o0Ey3weSfO5v7an
	 6s/qw7y+uG4IVZd+42eKWWi3LZYk5Jkl43py7wD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/175] HID: asus: add xg mobile 2023 external hardware support
Date: Tue, 31 Mar 2026 18:20:05 +0200
Message-ID: <20260331161730.561505732@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
index 529b23b67ec4b..544b74eda284a 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1298,6 +1298,9 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
+	    USB_DEVICE_ID_ASUSTEK_XGM_2023),
+	},
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD),
 	  QUIRK_ROG_CLAYMORE_II_KEYBOARD },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index a1910e12f7e05..2057546b26823 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -219,6 +219,7 @@
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X		0x1b4c
 #define USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD	0x196b
 #define USB_DEVICE_ID_ASUSTEK_FX503VD_KEYBOARD	0x1869
+#define USB_DEVICE_ID_ASUSTEK_XGM_2023	0x1a9a
 
 #define USB_VENDOR_ID_ATEN		0x0557
 #define USB_DEVICE_ID_ATEN_UC100KM	0x2004
-- 
2.51.0



