Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B0B2417E0;
	Wed, 25 Feb 2026 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983057; cv=none; b=UAeicOZB6LF6EY3w04qshNfcG+JQvhzVnzt0YoV2XvjT0LoFi2uHqJxQxbaK+x3/HgLIYC9hVCVsVw2fUxluTv+sVrYgMngWpJen4DAQkhe7285GvSn3fNaBY9MRUt9PTSu/28/UJt4EUw0P95JzJUYac31MOrCrxt4Lu2dLgdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983057; c=relaxed/simple;
	bh=1S4ysg/DKUevLT1TIItGEihqQf68ZOmCzmd/xATO2js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQa12td4VYg8I1ey4J17af0JanY3Wbr/n6DE4pF7zQSWI3ceNBuxUj3AaRLk+rxXc1GBpM6HfKU/i+Z0HQSOkavk0lANxJaPXIrJjVDEEA9s7afF4w9gDTitd/OYKoQxY452i6DDag3YNv2F8+CDX9Wc7e/COZY1RQA98v2XFR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOZTpcat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOZTpcat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDC4C116D0;
	Wed, 25 Feb 2026 01:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983057;
	bh=1S4ysg/DKUevLT1TIItGEihqQf68ZOmCzmd/xATO2js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOZTpcat6q16H9UTHwElvuvAqs/39cVUZdmDQ1CpobaFlPPrlxhu+7JG0SmdPYHnz
	 /s1GvaJ41rF5UBczQh+TX3XQPE6xoDs1pFW/el+6aPkmRCHCDpVwz9Z7c0cwerCB8z
	 zaVI4fB9G/nPPbTBVB29ivL95Rg5LljcXf6Fd8wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 222/781] ALSA: usx2y: Relax __free() variable declarations
Date: Tue, 24 Feb 2026 17:15:31 -0800
Message-ID: <20260225012405.158359758@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 43cc944c8e28d26f152198278f81cf7f9955ff85 ]

We used to have a variable declaration with __free() initialized with
NULL.  This was to keep the old coding style rule, but recently it's
relaxed and rather recommends to follow the new rule to declare in
place of use for __free() -- which avoids potential deadlocks or UAFs
with nested cleanups.

Although the current code has no bug, per se, let's follow the new
standard and move the declaration to the place of assignment (or
directly assign the allocated result) instead of NULL initializations.

Fixes: 67afec157fe6 ("ALSA: usb-audio: us144mkii: Add MIDI support and mixer controlsj")
Fixes: a2a2210f2c2e ("ALSA: usb-audio: us144mkii: Implement audio playback and feedback")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251216140634.171890-11-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/us144mkii.c          | 4 ++--
 sound/usb/usx2y/us144mkii_controls.c | 4 ++--
 sound/usb/usx2y/us144mkii_pcm.c      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/usb/usx2y/us144mkii.c b/sound/usb/usx2y/us144mkii.c
index f6572a576c150..bc71968df8e2c 100644
--- a/sound/usb/usx2y/us144mkii.c
+++ b/sound/usb/usx2y/us144mkii.c
@@ -412,7 +412,6 @@ static int tascam_probe(struct usb_interface *intf,
 	struct snd_card *card;
 	struct tascam_card *tascam;
 	int err;
-	char *handshake_buf __free(kfree) = NULL;
 
 	if (dev->speed != USB_SPEED_HIGH)
 		dev_info(
@@ -439,7 +438,8 @@ static int tascam_probe(struct usb_interface *intf,
 		return -ENOENT;
 	}
 
-	handshake_buf = kmalloc(1, GFP_KERNEL);
+	char *handshake_buf __free(kfree) =
+		kmalloc(1, GFP_KERNEL);
 	if (!handshake_buf)
 		return -ENOMEM;
 
diff --git a/sound/usb/usx2y/us144mkii_controls.c b/sound/usb/usx2y/us144mkii_controls.c
index 5d69441ef414b..62055fb8e7bac 100644
--- a/sound/usb/usx2y/us144mkii_controls.c
+++ b/sound/usb/usx2y/us144mkii_controls.c
@@ -373,7 +373,6 @@ static int tascam_samplerate_get(struct snd_kcontrol *kcontrol,
 {
 	struct tascam_card *tascam =
 		(struct tascam_card *)snd_kcontrol_chip(kcontrol);
-	u8 *buf __free(kfree) = NULL;
 	int err;
 	u32 rate = 0;
 
@@ -384,7 +383,8 @@ static int tascam_samplerate_get(struct snd_kcontrol *kcontrol,
 		}
 	}
 
-	buf = kmalloc(3, GFP_KERNEL);
+	u8 *buf __free(kfree) =
+		kmalloc(3, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
diff --git a/sound/usb/usx2y/us144mkii_pcm.c b/sound/usb/usx2y/us144mkii_pcm.c
index 0c84304d46246..03dfb1f388012 100644
--- a/sound/usb/usx2y/us144mkii_pcm.c
+++ b/sound/usb/usx2y/us144mkii_pcm.c
@@ -115,7 +115,6 @@ void process_capture_routing_us144mkii(struct tascam_card *tascam,
 int us144mkii_configure_device_for_rate(struct tascam_card *tascam, int rate)
 {
 	struct usb_device *dev = tascam->dev;
-	u8 *rate_payload_buf __free(kfree) = NULL;
 	u16 rate_vendor_wValue;
 	int err = 0;
 	const u8 *current_payload_src;
@@ -148,7 +147,8 @@ int us144mkii_configure_device_for_rate(struct tascam_card *tascam, int rate)
 		return -EINVAL;
 	}
 
-	rate_payload_buf = kmemdup(current_payload_src, 3, GFP_KERNEL);
+	u8 *rate_payload_buf __free(kfree) =
+		kmemdup(current_payload_src, 3, GFP_KERNEL);
 	if (!rate_payload_buf)
 		return -ENOMEM;
 
-- 
2.51.0



