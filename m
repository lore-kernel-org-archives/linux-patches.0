Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E68C1F4622;
	Tue, 20 May 2025 14:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749736; cv=none; b=kWohKVlEPL6Zm3AnINEZer02QraTQp+0W1D7NGswLhM6JP6JmRvGKIpolPzYcCco6F+wlnzz7yUv0ogz7JUAzz4ZemBOaRyrJQzkEnRATacfcqpgcFLQ0tTiiET7QjpDo8rScew3usr1IvL4cxrg0R/fRcu6RyYEntxGShm8vpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749736; c=relaxed/simple;
	bh=uB8peaiDoh0VApPeckSFkDQFR6JyQYvTfRvvBqBH0Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWeoIDeRE04Eh6ehX/IhdlGWPnQzby4tjokQTX3VAICtDxcgXoNiOXkNMiwqOkZYRQ/HXAhLSGzezdNed9fU2L/E5yxBRibU+P7MYyFtV4OE92BL+MW4+P6e05H/Yu3qiAg+ajnyKNhYLOfhOmURriQp3xiBxLha1HvPWB3nsCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyf+B6BQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyf+B6BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E360BC4CEE9;
	Tue, 20 May 2025 14:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749736;
	bh=uB8peaiDoh0VApPeckSFkDQFR6JyQYvTfRvvBqBH0Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyf+B6BQ+dhIcfYGRFwiX7TypOm4mE/bAniRKsO5HPS6EIVbkwiHk0YxpFZCgjtIt
	 3sJNmhvzQIqzKrf5+gFYBngtZDRNHgZyq630bvkDyCCqPkEtqiA4ZIuuLk4eKgxkhD
	 LNNiyEtAi2slcvwPQXB44CNcfqHGYbFK1qczKfw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/117] ALSA: ump: Fix a typo of snd_ump_stream_msg_device_info
Date: Tue, 20 May 2025 15:50:08 +0200
Message-ID: <20250520125805.697436066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit dd33993a9721ab1dae38bd37c9f665987d554239 ]

s/devince/device/

It's used only internally, so no any behavior changes.

Fixes: 37e0e14128e0 ("ALSA: ump: Support UMP Endpoint and Function Block parsing")
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20250511141147.10246-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_midi2.c | 2 +-
 include/sound/ump_msg.h               | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_midi2.c b/drivers/usb/gadget/function/f_midi2.c
index b7dada064890b..90536f47906c3 100644
--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -475,7 +475,7 @@ static void reply_ump_stream_ep_info(struct f_midi2_ep *ep)
 /* reply a UMP EP device info */
 static void reply_ump_stream_ep_device(struct f_midi2_ep *ep)
 {
-	struct snd_ump_stream_msg_devince_info rep = {
+	struct snd_ump_stream_msg_device_info rep = {
 		.type = UMP_MSG_TYPE_STREAM,
 		.status = UMP_STREAM_MSG_STATUS_DEVICE_INFO,
 		.manufacture_id = ep->info.manufacturer,
diff --git a/include/sound/ump_msg.h b/include/sound/ump_msg.h
index 72f60ddfea753..9556b4755a1ed 100644
--- a/include/sound/ump_msg.h
+++ b/include/sound/ump_msg.h
@@ -604,7 +604,7 @@ struct snd_ump_stream_msg_ep_info {
 } __packed;
 
 /* UMP Stream Message: Device Info Notification (128bit) */
-struct snd_ump_stream_msg_devince_info {
+struct snd_ump_stream_msg_device_info {
 #ifdef __BIG_ENDIAN_BITFIELD
 	/* 0 */
 	u32 type:4;
@@ -754,7 +754,7 @@ struct snd_ump_stream_msg_fb_name {
 union snd_ump_stream_msg {
 	struct snd_ump_stream_msg_ep_discovery ep_discovery;
 	struct snd_ump_stream_msg_ep_info ep_info;
-	struct snd_ump_stream_msg_devince_info device_info;
+	struct snd_ump_stream_msg_device_info device_info;
 	struct snd_ump_stream_msg_stream_cfg stream_cfg;
 	struct snd_ump_stream_msg_fb_discovery fb_discovery;
 	struct snd_ump_stream_msg_fb_info fb_info;
-- 
2.39.5



