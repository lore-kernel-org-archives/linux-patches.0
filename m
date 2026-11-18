Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019411;
	b=y1h+bwcjgcdLIaAIKW+MMGOhNcbvE30mju3+Ly4W7UHaTiBHAfxGsFCdj44quZl4AW+q
	 WLsRrebqu3uBY5TbsexbiGOC8COg38/qY2sZZ99f3lnojUiQxI5rbdhCShnYpVX2IDR4C
	 +8XqUTrud1T5Gt3vi3f5UagSD7Pw3wZt62fJ8YpjY9xe/Mkq/0+Zoit7jIzInHW7tiagj
	 bwLpENbW+mXGev48Kl3PTOnVlN5cGIt3vf4TJk4Z8Y7P+pvfn1loYtAsL9yWvAzqwekAd
	 w6QoG1BoI7zEK8Y+hxUGsZO7BhGFd38BG0+dSlQNlNGwruFXQqEGoErd/Cul3MupSyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RfWFHqNC9PpOTKTMKtLLl1X1l3Cw6iSo8kYVkZ3EGCI=;
	b=VlsuXOYb95tT3BJKBRGpQyqLkO1bb7l83SKf0rgtxNJsFDGLc0NGqZjcnJOCrBceHYrc
	 A91Vw+AHuUpqtavqRSE33fPQ5II3UW23u3Eme5lDSEY2ZyVvYgB5TkZft4Jl+rMzNrOkk
	 +RjTTVrI7ME275x+k/o9ruuyDYxa6KV2dcdGZ865KaPQyS3KeZWdie1g8h1fyiF3gzPqZ
	 SXXSw/e8yMaAi/zmphD+H8WQIhMincvJEmS+5cqAB8V0VfYQPXK7d4ArqFPGgv3X//Oq/
	 qDfbk0u5XDozRXul2wEx90BynBi1VSFgKH+O5wrIj9iVgwWoCe+W40H61WaC7TUd8Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xn73UPZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6063D60A5BC7;
	Wed, 18 Nov 2026 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xn73UPZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891961F00935;
	Wed, 18 Nov 2026 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019411;
	bh=RfWFHqNC9PpOTKTMKtLLl1X1l3Cw6iSo8kYVkZ3EGCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xn73UPZjHIhZzB0xs8GOwqfqMFyqU9bWxp9P/w1Ad9mo7drcFnIrr3emkZX7SYqAp
	 u3IC0szdjfWAzKXgbKvxWCIsCd9oBZJlR23rFYfLsFH5NR3gMlxg8jXKFhr4kcOAJ9
	 KYykEqVgWZHyDhiq7sxTqp3rU8pr/FtlTiQ3P5Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1587/2651] ALSA: hda: Stop unsol events and jack polling before codec unbind
Date: Wed, 18 Nov 2026 15:47:07 +0100
Message-ID: <20261118150345.045932717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f3607b6952ca9a5638eeef4f301daa7933ce24b1 ]

At unbinding a codec driver, hda_codec_driver_remove() calls the
codec's remove callback that releases the driver resources, followed
by snd_hda_codec_cleanup_for_unbind().  Meanwhile, the unsolicited
events are processed asynchronously in bus->unsol_work, and
snd_hdac_bus_process_unsol_events() checks only codec->registered flag
before calling the driver's unsol_event callback without the lock.
Since codec->registered is cleared only in
snd_hda_codec_cleanup_for_unbind(), and there is no flush of the unsol
work at unbinding, the unsol event handler may run concurrently during
the running remove callback, which may lead to a UAF.  The same
problem applies to the jack polling work, which is canceled only after
the remove callback.

For addressing those races, introduce a new flag unsol_disabled to
hdac_device, to be checked it in the unsol event worker, while a new
helper snd_hdac_device_disable_unsol() sets this flag and flushes the
pending unsol work.  The helper is called at hda_codec_driver_remove()
together with the cancel of jackpoll_work to assure that no
asynchronous jack handling can run.  The flag is cleared again at
probing the codec driver, while the events are still blocked by the
registered flag until the codec gets registered.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007215650.159871-2-tiwai@suse.de
Stable-dep-of: 7a78c18bffc6 ("ALSA: hda: Disable unsol event handling at error and shutdown paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio.h |  2 ++
 sound/hda/common/bind.c |  7 +++++++
 sound/hda/core/bus.c    | 21 ++++++++++++++++++++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index aa994d6e6d35f..6da4cf4076542 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -97,6 +97,7 @@ struct hdac_device {
 	bool caps_overwriting:1; /* caps overwrite being in process */
 	bool cache_coef:1;	/* cache COEF read/write too */
 	unsigned int registered:1; /* codec was registered */
+	bool unsol_disabled;	/* unsol events blocked; protected by bus->reg_lock */
 };
 
 /* device/driver type used for matching */
@@ -123,6 +124,7 @@ int snd_hdac_device_init(struct hdac_device *dev, struct hdac_bus *bus,
 			 const char *name, unsigned int addr);
 void snd_hdac_device_exit(struct hdac_device *dev);
 int snd_hdac_device_register(struct hdac_device *codec);
+void snd_hdac_device_disable_unsol(struct hdac_device *codec);
 void snd_hdac_device_unregister(struct hdac_device *codec);
 int snd_hdac_device_set_chip_name(struct hdac_device *codec, const char *name);
 int snd_hdac_codec_modalias(const struct hdac_device *hdac, char *buf, size_t size);
diff --git a/sound/hda/common/bind.c b/sound/hda/common/bind.c
index 6a728a7735560..4772ca154a290 100644
--- a/sound/hda/common/bind.c
+++ b/sound/hda/common/bind.c
@@ -100,6 +100,9 @@ static int hda_codec_driver_probe(struct device *dev)
 	if (WARN_ON(!codec->preset))
 		return -EINVAL;
 
+	/* unsol events are still blocked until registered */
+	codec->core.unsol_disabled = false;
+
 	err = snd_hda_codec_set_name(codec, codec->preset->name);
 	if (err < 0)
 		goto error;
@@ -160,6 +163,10 @@ static int hda_codec_driver_remove(struct device *dev)
 		return codec->bus->core.ext_ops->hdev_detach(&codec->core);
 	}
 
+	/* stop asynchronous jack handling before freeing driver resources */
+	snd_hdac_device_disable_unsol(&codec->core);
+	cancel_delayed_work_sync(&codec->jackpoll_work);
+
 	snd_hda_codec_disconnect_pcms(codec);
 	snd_hda_jack_tbl_disconnect(codec);
 	snd_refcount_sync(&codec->pcm_ref);
diff --git a/sound/hda/core/bus.c b/sound/hda/core/bus.c
index 81498f1e413e2..9613cd46bd2fe 100644
--- a/sound/hda/core/bus.c
+++ b/sound/hda/core/bus.c
@@ -180,7 +180,7 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
 		if (!(caddr & (1 << 4))) /* no unsolicited event? */
 			continue;
 		codec = bus->caddr_tbl[caddr & 0x0f];
-		if (!codec || !codec->registered)
+		if (!codec || !codec->registered || codec->unsol_disabled)
 			continue;
 		spin_unlock_irq(&bus->reg_lock);
 		drv = drv_to_hdac_driver(codec->dev.driver);
@@ -191,6 +191,25 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
 	spin_unlock_irq(&bus->reg_lock);
 }
 
+/**
+ * snd_hdac_device_disable_unsol - block and flush unsol events for the codec
+ * @codec: the HDA core device
+ *
+ * Stop dispatching the unsolicited events to the given codec, and wait for
+ * the pending unsol event handler to finish.  Called at unbinding the codec
+ * driver before releasing the driver resources.
+ */
+void snd_hdac_device_disable_unsol(struct hdac_device *codec)
+{
+	struct hdac_bus *bus = codec->bus;
+
+	spin_lock_irq(&bus->reg_lock);
+	codec->unsol_disabled = true;
+	spin_unlock_irq(&bus->reg_lock);
+	flush_work(&bus->unsol_work);
+}
+EXPORT_SYMBOL_GPL(snd_hdac_device_disable_unsol);
+
 /**
  * snd_hdac_bus_add_device - Add a codec to bus
  * @bus: HDA core bus
-- 
2.53.0



