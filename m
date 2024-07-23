Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AE742067;
	Tue, 23 Jul 2024 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759600; cv=none; b=JOjLlbICE8Zgy98FnXMdEllrOVwgn0FgOse7AN4dcf1ThrLz5nDq67VZq/hiSk2Q3uoE2hQSVKXoVw47XXu/oZXwRydCYcuUvn9qA1CwfqGTV8dEV8VtxztdKoFsGnu+Gf9T0/BjsDXTY6S81GKSbzS8mL9MLTC4S6JJ8U2xvL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759600; c=relaxed/simple;
	bh=rHuOlTxVgndy27aErhGvuEFE5xqoZEUOazd+Wb4QzEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMaSUwde9Llongl/382j1cX378EHxFRdpkyatfCFt21F49hsN+/yyM0Cif30CG+zFUeWbfbw8bWmBQFkj5GQ2rJz4LULIDCLC6z2myQqmIf6p6G2qZ4dqZr8hGIZ2hyaoPh5atV9XCNlEuTHvYw+5f/ogbiVKYVVOcqd0u6YKV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/GWfxSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/GWfxSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A90C4AF09;
	Tue, 23 Jul 2024 18:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759599;
	bh=rHuOlTxVgndy27aErhGvuEFE5xqoZEUOazd+Wb4QzEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/GWfxSYksu8nWHQIWtnrSNUWZP1to9Dwma8UyyD39ms2+3a2Pe27RwSFcQEwyKPd
	 C5OgwzRRbtHIgl2oRA8vMqb4Sd93ZZK0YjyVHF5sM/6SJOLJkft0Wni5esnbVLNu8y
	 FgyNZRHRlbJ3O+he2j9a261DIkDbsDjnspJoLq1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aseda Aboagye <aaboagye@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/129] input: Add support for "Do Not Disturb"
Date: Tue, 23 Jul 2024 20:23:02 +0200
Message-ID: <20240723180406.107919556@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aseda Aboagye <aaboagye@chromium.org>

[ Upstream commit 22d6d060ac77955291deb43efc2f3f4f9632c6cb ]

HUTRR94 added support for a new usage titled "System Do Not Disturb"
which toggles a system-wide Do Not Disturb setting. This commit simply
adds a new event code for the usage.

Signed-off-by: Aseda Aboagye <aaboagye@chromium.org>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/Zl-gUHE70s7wCAoB@google.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-debug.c                | 1 +
 drivers/hid/hid-input.c                | 8 ++++++++
 include/uapi/linux/input-event-codes.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index c629ab161d5b2..5302bfd527d86 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -975,6 +975,7 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_CAMERA_ACCESS_DISABLE] = "CameraAccessDisable",
 	[KEY_CAMERA_ACCESS_TOGGLE] = "CameraAccessToggle",
 	[KEY_ACCESSIBILITY] = "Accessibility",
+	[KEY_DO_NOT_DISTURB] = "DoNotDisturb",
 	[KEY_DICTATE] = "Dictate",
 	[KEY_MICMUTE] = "MicrophoneMute",
 	[KEY_BRIGHTNESS_MIN] = "BrightnessMin",
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d5a6e89c3086e..8bb16e9b94aa5 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -833,6 +833,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			break;
 		}
 
+		if ((usage->hid & 0xf0) == 0x90) { /* SystemControl*/
+			switch (usage->hid & 0xf) {
+			case 0xb: map_key_clear(KEY_DO_NOT_DISTURB); break;
+			default: goto ignore;
+			}
+			break;
+		}
+
 		if ((usage->hid & 0xf0) == 0xa0) {	/* SystemControl */
 			switch (usage->hid & 0xf) {
 			case 0x9: map_key_clear(KEY_MICMUTE); break;
diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index 39f11ec676fae..a4206723f5033 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -619,6 +619,7 @@
 #define KEY_CAMERA_ACCESS_DISABLE	0x24c	/* Disables programmatic access to camera devices. (HUTRR72) */
 #define KEY_CAMERA_ACCESS_TOGGLE	0x24d	/* Toggles the current state of the camera access control. (HUTRR72) */
 #define KEY_ACCESSIBILITY		0x24e	/* Toggles the system bound accessibility UI/command (HUTRR116) */
+#define KEY_DO_NOT_DISTURB		0x24f	/* Toggles the system-wide "Do Not Disturb" control (HUTRR94)*/
 
 #define KEY_BRIGHTNESS_MIN		0x250	/* Set Brightness to Minimum */
 #define KEY_BRIGHTNESS_MAX		0x251	/* Set Brightness to Maximum */
-- 
2.43.0



