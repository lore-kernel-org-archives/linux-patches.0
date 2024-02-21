Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6114A76C99;
	Wed, 21 Feb 2024 13:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522925; cv=none; b=kSsym+2d/ZG3xIWNoOmwF68HCkNZSQCZjVvbN+541a2OLEkEfLTKaD55fUG4+mqMckZhEtvufYHmNPWT810INLOcpvwXzgfj8QIB/3wGrkp6sTZlAOtxurvRW3hyXlKtXpGkcMRFgiih+kLrCxrPlJWTstKikokPFTWZcmRsqTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522925; c=relaxed/simple;
	bh=zKvlXfsPkGzOM68CYtRmao1bhLM4Zw73EBr15CAwLsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pq8zKoev+1B5nvm9K1nyN0AxsmZ3HPn9nNfi6yuKg4aqVTZnoXqVovFNrl/QUbaE+JVkNBYl8HXFmEvZ9xiTDmRoJV90ir+0l4/kW5U4H8Yr3kFRSaKHl3SfehU9baZc2DBj6bo/KLuf384qIe6kS6vaN096BjkWZNGnmIWggx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIYwA2Od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIYwA2Od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE128C433F1;
	Wed, 21 Feb 2024 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522925;
	bh=zKvlXfsPkGzOM68CYtRmao1bhLM4Zw73EBr15CAwLsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIYwA2OdLeAT4qE8OTCPL1M1WxBleZLsTLrEcmnMPHR8K3eqhTFcJ1qflGI1cEiVp
	 opmNsV05cTyT2HlL7h+ul9lQSuixKUQMwnBL2RwUzBYfE9AIz14sYVScqNd0E81sRs
	 RV6tsTbGOjaq6HfFOhR3LOVZKdhg7r1JEUbNdmQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Aseda Aboagye <aaboagye@chromium.org>
Subject: [PATCH 5.15 292/476] HID: apple: Add support for the 2021 Magic Keyboard
Date: Wed, 21 Feb 2024 14:05:43 +0100
Message-ID: <20240221130018.793143844@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -640,6 +640,10 @@ static const struct hid_device_id apple_
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
@@ -174,6 +174,7 @@
 #define USB_DEVICE_ID_APPLE_IRCONTROL3	0x8241
 #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
 #define USB_DEVICE_ID_APPLE_IRCONTROL5	0x8243
+#define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021   0x029c
 
 #define USB_VENDOR_ID_ASUS		0x0486
 #define USB_DEVICE_ID_ASUS_T91MT	0x0185
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -309,6 +309,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021) },
 #endif
 #if IS_ENABLED(CONFIG_HID_APPLEIR)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL) },


