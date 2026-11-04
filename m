Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829290;
	b=JXUW7awnT4slgQIFzmU04RoDnAfMJZxf/4wEpW9u7FJzm+rpDP+/rCaejAK/cVf43IiC
	 ky4tRau09MVpcTWQ7Xzs3x7LXNzaF9Sk3sdrPL6eCV/9vDty3U0+9gok/EoPluTPZNxeq
	 65FBehzmYWXe8UBPt3tNhgxFRtWKAVpWwR9o0BQcVQ/cOFvMEaHNEKbycg+xvRR916+8o
	 IhLGn/QcK5ujqZ9/l+KLCg/yVNwJ38BZ2YZORwECwdI/FCCH5CRHpEc+8nfsWnPEkTwIz
	 eyFsnLA7wgG1Rnqes33v5DP5zMgx/8SQf5Amvvhb2Us4eoABdeOOMCBQJgwdr2QHytw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JjX5zaRSGu5gDUaklQFAYW0oiJEP9/h8QK6rBQjfgyc=;
	b=RsRWWl5pf11HECQZv3uwWSLTf1LMT+poOTpkZRP0lVxeWeNnVwakOr7ko5Is0QkiyH72
	 IbwiHbVUCAv0gW8sfOYm3k416HTZtfyotacldz8oNgN5tCKYd+Zp1lTR4ae3a8LvPUxSx
	 dJic91LZ+m9YpYN5mCXIbduIsnj15JuCF6lU0JyRs/Rxr7yk01vIiG8fqs+YflM6Fi9v/
	 T7w3y547lRxPwbjdF51eJIRE59co9rYKihsa7qSSHLzsS1XRQMLknP/Fz+voP3KhsYt6u
	 mTvE4BQC56n01ZVpS509DhNoH2+cI1qainOk4/4tj/fqR0pX9z/lS1UG4pU6J2rD6hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtBvpr3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D438607353D;
	Wed,  4 Nov 2026 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtBvpr3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087E31F000C1;
	Wed,  4 Nov 2026 21:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829290;
	bh=JjX5zaRSGu5gDUaklQFAYW0oiJEP9/h8QK6rBQjfgyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtBvpr3DnmkXwl5B03sxg8bYNbXZCj+oHLo8OAh6HCML+LOuK2mE6AdN85PjFz3LA
	 oXI9TRL97sJay/FV0q8ERHRqejaNRdVjsdCDtmKWMfKJzgBo5J5iZdVl46yRb5vzKk
	 y5fV4D93AESPP3r2pscKhAkfOLGT10HeJd0rVhfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0032/1005] ALSA: usb-audio: Release components on probe errors
Date: Wed,  4 Nov 2026 15:56:05 -0500
Message-ID: <20261104211044.460796689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 3213bf9885e3356fff12ac18b12d4c2fb4687734 ]

usb_audio_probe() can create USB-audio component resources before the
first interface is recorded in chip->num_interfaces.  If a later probe
step fails, the error path drops chip->active and frees the card directly
when no interfaces have been registered.

Normal disconnect first releases USB-audio components in a fixed order
before the card is freed.  The first-interface probe error path skipped
that sequence, so partially initialized PCM, endpoint, MIDI, media, or
mixer resources could be left for the card private_free path without their
disconnect handling having run.

Move the existing normal-disconnect component release sequence into a
helper and call it from the zero-interface probe error path before
snd_card_free().  Keep the normal disconnect ordering unchanged: PCM
streams, endpoint resources, MIDI 1.0 resources, MIDI 2.0 resources, media
device cleanup, then mixer resources.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260618170026.192212-1-zzzccc427@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c | 70 ++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 85249606a6b18..d8e096f71412a 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -904,6 +904,40 @@ static int try_to_register_card(struct snd_usb_audio *chip, int ifnum)
 	return 0;
 }
 
+static void usb_audio_disconnect_components(struct snd_usb_audio *chip)
+{
+	struct snd_usb_stream *as;
+	struct snd_usb_endpoint *ep;
+	struct usb_mixer_interface *mixer;
+	struct list_head *p;
+
+	/* release the pcm resources */
+	list_for_each_entry(as, &chip->pcm_list, list) {
+		snd_usb_stream_disconnect(as);
+	}
+	/* release the endpoint resources */
+	list_for_each_entry(ep, &chip->ep_list, list) {
+		snd_usb_endpoint_release(ep);
+	}
+	/* release the midi resources */
+	list_for_each(p, &chip->midi_list) {
+		snd_usbmidi_disconnect(p);
+	}
+	snd_usb_midi_v2_disconnect_all(chip);
+	/*
+	 * Nice to check quirk && quirk->shares_media_device and
+	 * then call the snd_media_device_delete(). Don't have
+	 * access to the quirk here. snd_media_device_delete()
+	 * accesses mixer_list
+	 */
+	snd_media_device_delete(chip);
+
+	/* release mixer resources */
+	list_for_each_entry(mixer, &chip->mixer_list, list) {
+		snd_usb_mixer_disconnect(mixer);
+	}
+}
+
 /*
  * probe the active usb device
  *
@@ -1076,8 +1110,10 @@ static int usb_audio_probe(struct usb_interface *intf,
 		 * decrement before memory is possibly returned.
 		 */
 		atomic_dec(&chip->active);
-		if (!chip->num_interfaces)
+		if (!chip->num_interfaces) {
+			usb_audio_disconnect_components(chip);
 			snd_card_free(chip->card);
+		}
 	}
 	return err;
 }
@@ -1090,49 +1126,19 @@ static bool __usb_audio_disconnect(struct usb_interface *intf,
 				   struct snd_usb_audio *chip,
 				   struct snd_card *card)
 {
-	struct list_head *p;
-
 	guard(mutex)(&register_mutex);
 
 	if (platform_ops && platform_ops->disconnect_cb)
 		platform_ops->disconnect_cb(chip);
 
 	if (atomic_inc_return(&chip->shutdown) == 1) {
-		struct snd_usb_stream *as;
-		struct snd_usb_endpoint *ep;
-		struct usb_mixer_interface *mixer;
-
 		/* wait until all pending tasks done;
 		 * they are protected by snd_usb_lock_shutdown()
 		 */
 		wait_event(chip->shutdown_wait,
 			   !atomic_read(&chip->usage_count));
 		snd_card_disconnect(card);
-		/* release the pcm resources */
-		list_for_each_entry(as, &chip->pcm_list, list) {
-			snd_usb_stream_disconnect(as);
-		}
-		/* release the endpoint resources */
-		list_for_each_entry(ep, &chip->ep_list, list) {
-			snd_usb_endpoint_release(ep);
-		}
-		/* release the midi resources */
-		list_for_each(p, &chip->midi_list) {
-			snd_usbmidi_disconnect(p);
-		}
-		snd_usb_midi_v2_disconnect_all(chip);
-		/*
-		 * Nice to check quirk && quirk->shares_media_device and
-		 * then call the snd_media_device_delete(). Don't have
-		 * access to the quirk here. snd_media_device_delete()
-		 * accesses mixer_list
-		 */
-		snd_media_device_delete(chip);
-
-		/* release mixer resources */
-		list_for_each_entry(mixer, &chip->mixer_list, list) {
-			snd_usb_mixer_disconnect(mixer);
-		}
+		usb_audio_disconnect_components(chip);
 	}
 
 	if (chip->quirk_flags & QUIRK_FLAG_DISABLE_AUTOSUSPEND)
-- 
2.53.0



