Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801D71F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E74C433C8;
	Fri, 21 Jul 2023 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955747;
	bh=KYPHXWNuv1mS6wM8NpUYnoYg8mTyBPR4TFEk5SF6KAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPndplNKkf+GNyLnqjwn5450RDbEGpOs7QE7L0uPLUgYpv9YGrRrKceTk8MHeDSYP
	 ILvoxpbvEqUW3TOgFWvkUctfu9nYek3AINBl7MU0JYfIxanDToN94sc2eZVBBGX8+N
	 dx1sWJKXYR9nPUQElXYTF2/itNkbTa/t+NBbJ+TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.4 003/292] HID: input: fix mapping for camera access keys
Date: Fri, 21 Jul 2023 18:01:52 +0200
Message-ID: <20230721160528.958662509@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit e3ea6467f623b80906ff0c93b58755ab903ce12f upstream.

Commit 9f4211bf7f81 ("HID: add mapping for camera access keys") added
mapping for the camera access keys, but unfortunately used wrong usage
codes for them. HUTRR72[1] specifies that camera access controls use 0x76,
0x077 and 0x78 usages in the consumer control page. Previously mapped 0xd5,
0xd6 and 0xd7 usages are actually defined in HUTRR64[2] as game recording
controls.

[1] https://www.usb.org/sites/default/files/hutrr72_-_usages_to_control_camera_access_0.pdf
[2] https://www.usb.org/sites/default/files/hutrr64b_-_game_recording_controllers_0.pdf

Fixes: 9f4211bf7f81 ("HID: add mapping for camera access keys")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/ZJtd/fMXRUgq20TW@google.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-input.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index a1d2690a1a0d..851ee86eff32 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1093,6 +1093,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x074: map_key_clear(KEY_BRIGHTNESS_MAX);		break;
 		case 0x075: map_key_clear(KEY_BRIGHTNESS_AUTO);		break;
 
+		case 0x076: map_key_clear(KEY_CAMERA_ACCESS_ENABLE);	break;
+		case 0x077: map_key_clear(KEY_CAMERA_ACCESS_DISABLE);	break;
+		case 0x078: map_key_clear(KEY_CAMERA_ACCESS_TOGGLE);	break;
+
 		case 0x079: map_key_clear(KEY_KBDILLUMUP);	break;
 		case 0x07a: map_key_clear(KEY_KBDILLUMDOWN);	break;
 		case 0x07c: map_key_clear(KEY_KBDILLUMTOGGLE);	break;
@@ -1139,9 +1143,6 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x0cd: map_key_clear(KEY_PLAYPAUSE);	break;
 		case 0x0cf: map_key_clear(KEY_VOICECOMMAND);	break;
 
-		case 0x0d5: map_key_clear(KEY_CAMERA_ACCESS_ENABLE);		break;
-		case 0x0d6: map_key_clear(KEY_CAMERA_ACCESS_DISABLE);		break;
-		case 0x0d7: map_key_clear(KEY_CAMERA_ACCESS_TOGGLE);		break;
 		case 0x0d8: map_key_clear(KEY_DICTATE);		break;
 		case 0x0d9: map_key_clear(KEY_EMOJI_PICKER);	break;
 
-- 
2.41.0



