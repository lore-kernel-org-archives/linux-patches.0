Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EA63D0A1;
	Wed, 21 Feb 2024 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525491; cv=none; b=PLieeee/X5bftRGhRQ8jCUa6bKJ0DOgc9hnHlWS0b8vezL0ob2JN1yjss2L4E7G3HzGIhATNrbSwxV2JOTnw11WND58RELOetY/IS+ObE/DgoSxQ5m4CyS0pC1gTcbFSWsH7hOUvQxN37G8w8a59XZK6Qo4Na0UxkgeBWMxaLLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525491; c=relaxed/simple;
	bh=E3tCCEkVQksYd4+bYBx2BnfdKdYVVURnZ5rVG1NpvXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELqDP5II+h2bxroTOFYJWn6IZkdG6rQZsK2sK6ACjgYpJR5ad3dfko1lcEqmOT7kHCjrUiO3pKARyYE2VIcUtRzfuhiZ0pp1/zxdf92qF70ShJylXqSIT08t0Spn/0F8pW4hm4QoHpIkYo685XC9x7x3JbBp7qagZGtMyzauLOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9cgBlIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9cgBlIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C95C433F1;
	Wed, 21 Feb 2024 14:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525491;
	bh=E3tCCEkVQksYd4+bYBx2BnfdKdYVVURnZ5rVG1NpvXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9cgBlIooGIJ/GLqpam7PLf8pq7JOxO5K3bGv/j//rKQUxqWu/MU29wtj0aasXPxX
	 XyqakvW1UoUFn0Agd+ZuL/dINiek+t3ZdlRmopFsIh6qav3XKLoAn5mhbfWCmmXpXm
	 Lfm0XD6HjpqPgbdUGpOzNP6DaGXjlWJFhM+rZCsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Aseda Aboagye <aaboagye@chromium.org>
Subject: [PATCH 5.4 172/267] HID: apple: Add support for the 2021 Magic Keyboard
Date: Wed, 21 Feb 2024 14:08:33 +0100
Message-ID: <20240221125945.534322057@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Henrie <alexhenrie24@gmail.com>

commit 0cd3be51733febb4f8acb92bcf55b75fe824dd05 upstream.

Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Aseda Aboagye <aaboagye@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c  |    4 ++++
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 3 files changed, 6 insertions(+)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -596,6 +596,10 @@ static const struct hid_device_id apple_
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021),
+		.driver_data = APPLE_HAS_FN },
 
 	{ }
 };
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -175,6 +175,7 @@
 #define USB_DEVICE_ID_APPLE_IRCONTROL3	0x8241
 #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
 #define USB_DEVICE_ID_APPLE_IRCONTROL5	0x8243
+#define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021   0x029c
 
 #define USB_VENDOR_ID_ASUS		0x0486
 #define USB_DEVICE_ID_ASUS_T91MT	0x0185
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -308,6 +308,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021) },
 #endif
 #if IS_ENABLED(CONFIG_HID_APPLEIR)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL) },


