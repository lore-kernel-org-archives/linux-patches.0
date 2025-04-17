Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBCA4502F;
	Thu, 17 Apr 2025 18:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915589; cv=none; b=Ul5xnU5Md0asaVVANKNZVenJIqYF5fF/dmiZ3zqzrTH0cRXIVcWzcoqBOmH+i0EgWeqzoI0QogatSAS/JV/pByZ5iVxgXqvUDHIAl6wcLyJ0ON/udIgohKXWyZbTPDaBwq/NtoYf9HyrAbXwn9xA33geMzRy22w6Bt5zjsc5wm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915589; c=relaxed/simple;
	bh=vUTVrSIqpIKAQ+cT7PJjevjKXQIjQhWCoTx9YPEtmj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=if0oDtY0UDQmqX8A6cct8qWTn+5h9QG/ZEOxLwRzzmfGE7/RM+7zFRNzAnTcZfphyaoDxDGW5qVNKZ14odR4lbtv9mYO9ox+S04B/X3mbOl+6jMgjgLyDAXa9UZ2eGP6F/6N1+IPy6bdJ6aOw1ZE35dBHYviPLGifKSXKf/n3Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AW0mw8Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AW0mw8Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0721C4CEE4;
	Thu, 17 Apr 2025 18:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915588;
	bh=vUTVrSIqpIKAQ+cT7PJjevjKXQIjQhWCoTx9YPEtmj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AW0mw8Q+H5EjzRY7g8GSI+MDEAh6iyQBRXzlmD5iZG0YrUKphIL0h88Y/gio5/JcH
	 +dyye5z/3eR3N7Q2sO3VL5lm/eMJ+If4DQWtu66jC9efdx5DfluYhQ9Is6cwlHocsf
	 szRG73NyaSn9KrRUUabz8svumiwDFunl+QGj9UHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/393] HID: pidff: Use macros instead of hardcoded min/max values for shorts
Date: Thu, 17 Apr 2025 19:49:44 +0200
Message-ID: <20250417175114.640395478@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 21755162456902998f8d9897086b8c980c540df5 ]

Makes it obvious these magic values ARE in fact derived from min and
max values for s16 and u16

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 8083eb7684e5e..b21e844f5f3a3 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -21,7 +21,7 @@
 
 
 #define	PID_EFFECTS_MAX		64
-#define	PID_INFINITE		0xffff
+#define	PID_INFINITE		U16_MAX
 
 /* Linux Force Feedback API uses miliseconds as time unit */
 #define FF_TIME_EXPONENT	-3
@@ -226,12 +226,12 @@ static int pidff_rescale(int i, int max, struct hid_field *field)
 }
 
 /*
- * Scale a signed value in range -0x8000..0x7fff for the given field
+ * Scale a signed value in range S16_MIN..S16_MAX for the given field
  */
 static int pidff_rescale_signed(int i, struct hid_field *field)
 {
-	if (i > 0) return i * field->logical_maximum / 0x7fff;
-	if (i < 0) return i * field->logical_minimum / -0x8000;
+	if (i > 0) return i * field->logical_maximum / S16_MAX;
+	if (i < 0) return i * field->logical_minimum / S16_MIN;
 	return 0;
 }
 
@@ -255,7 +255,7 @@ static u32 pidff_rescale_time(u16 time, struct hid_field *field)
 
 static void pidff_set(struct pidff_usage *usage, u16 value)
 {
-	usage->value[0] = pidff_rescale(value, 0xffff, usage->field);
+	usage->value[0] = pidff_rescale(value, U16_MAX, usage->field);
 	pr_debug("calculated from %d to %d\n", value, usage->value[0]);
 }
 
@@ -266,10 +266,10 @@ static void pidff_set_signed(struct pidff_usage *usage, s16 value)
 	else {
 		if (value < 0)
 			usage->value[0] =
-			    pidff_rescale(-value, 0x8000, usage->field);
+			    pidff_rescale(-value, -S16_MIN, usage->field);
 		else
 			usage->value[0] =
-			    pidff_rescale(value, 0x7fff, usage->field);
+			    pidff_rescale(value, S16_MAX, usage->field);
 	}
 	pr_debug("calculated from %d to %d\n", value, usage->value[0]);
 }
@@ -306,11 +306,11 @@ static void pidff_set_envelope_report(struct pidff_device *pidff,
 
 	pidff->set_envelope[PID_ATTACK_LEVEL].value[0] =
 	    pidff_rescale(envelope->attack_level >
-			  0x7fff ? 0x7fff : envelope->attack_level, 0x7fff,
+			  S16_MAX ? S16_MAX : envelope->attack_level, S16_MAX,
 			  pidff->set_envelope[PID_ATTACK_LEVEL].field);
 	pidff->set_envelope[PID_FADE_LEVEL].value[0] =
 	    pidff_rescale(envelope->fade_level >
-			  0x7fff ? 0x7fff : envelope->fade_level, 0x7fff,
+			  S16_MAX ? S16_MAX : envelope->fade_level, S16_MAX,
 			  pidff->set_envelope[PID_FADE_LEVEL].field);
 
 	pidff_set_time(&pidff->set_envelope[PID_ATTACK_TIME],
@@ -399,7 +399,7 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 	pidff->effect_direction->value[0] = pidff_rescale(
 		pidff->quirks & HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION ?
 		PIDFF_FIXED_WHEEL_DIRECTION : effect->direction,
-		0xffff, pidff->effect_direction);
+		U16_MAX, pidff->effect_direction);
 
 	/* Omit setting delay field if it's missing */
 	if (!(pidff->quirks & HID_PIDFF_QUIRK_MISSING_DELAY))
@@ -1366,7 +1366,7 @@ static int pidff_check_autocenter(struct pidff_device *pidff,
 
 	if (pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] ==
 	    pidff->block_load[PID_EFFECT_BLOCK_INDEX].field->logical_minimum + 1) {
-		pidff_autocenter(pidff, 0xffff);
+		pidff_autocenter(pidff, U16_MAX);
 		set_bit(FF_AUTOCENTER, dev->ffbit);
 	} else {
 		hid_notice(pidff->hid,
@@ -1424,7 +1424,7 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, u32 initial_quirks)
 	if (error)
 		goto fail;
 
-	pidff_set_gain_report(pidff, 0xffff);
+	pidff_set_gain_report(pidff, U16_MAX);
 	error = pidff_check_autocenter(pidff, dev);
 	if (error)
 		goto fail;
-- 
2.39.5



