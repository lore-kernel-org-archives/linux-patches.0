Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026096;
	b=z8oJ0hwD6KS3l0BSZW3u5mECyqYK6Ns1/aj6ptZ7uIUk4qyQ/5N3eaJdMLWqOLCk4Md2
	 /Tbvn7xC1CBy6O7KSmtN69C1q+eG35vDkUdPZPAVbb7+i2+fAF7vbUvm1J1Kzp8ATeOsX
	 KMZ9qn1i9fAcTEc7Jzw7qFnWJ+Opk9gXxYLyj4KfrL14MqZaZnKliIGOe05DSXEIuk29a
	 oQcyEuyKe/ugGAERaJaSWI/7qMZ0c3jQ4yhMch7sww3lrjdE/uUKGHItffdpDKJihSi73
	 kKjXfNV1pmHYAa2tMELvmzpU191d/bpEcxhhM5NJqDj24bf3UspRMW1aSRD0SB1Tlug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3KFI3wP7jSf5J7qjTciKH8hms0AWQzgQqi9GHbn5WE=;
	b=ZDJXyxX33jSnaGfeelhBEO8fF3EPHLrh6Iwxp+8RF6F7s/Ma3xDctK6k5a0NSOOdEPoS
	 S9sY6Nis6njqWr5Et4dTlRY70MfSKzWBhUAvGSpl2Eq95yknwIUGvdp7mSHk0IVfr8lTP
	 qiktL0V36TwIGZGzWgeOXc0gG2tl9FRz34PHAHQu45Us0dFj62x/gcWVZJW08Vw5N7yRo
	 k8IA9eJFrshRSqrYrw/9Mg21DFmyRkwClRwCj4ImWz/XaN2ZNMehFcFASp8Aplas+0hiz
	 PdNoMQ2fg3hDlj69DOUOGtcL1OX4c9pCPq4P3Wxw83Qoyjti9oq5sjdVrHMfNX4XFZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+PP4KcB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE459606A31C;
	Wed, 18 Nov 2026 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+PP4KcB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB691F000C5;
	Wed, 18 Nov 2026 18:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026096;
	bh=b3KFI3wP7jSf5J7qjTciKH8hms0AWQzgQqi9GHbn5WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+PP4KcBvmHe0vUUsfBbgqnOk7a/7QZ8EP8U/mHpQaWnVyVmVMHbjGO4LliQux7Qb
	 Mcd2qdJDSeOjxa79it7VAliH8FNQicDNF7RGmeXGpZZsOWpXM5aCBMdPfvAbOQewTB
	 1TqwZCma41ao8+JWMB/7kU8lxdIHTGRCUvdn3/7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1313/2151] ALSA: hda: Disable unsol event handling at error and shutdown paths
Date: Wed, 18 Nov 2026 15:50:48 +0100
Message-ID: <20261118150209.931350237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7a78c18bffc6e09016720681d791b799feb61783 ]

When the HD-audio controller driver probe fails, it still leaves the
unsolicited event handling and jackpoll work active, hence if they are
pending, they might fire up later after the resource gets released,
which may lead to a UAF.  A similar problem may be seen at shutdown,
too.

Add the recently added helper to disable unsol events and the cancel
of jackpoll_work at the appropriate places.  We need the workaround in
the error path before driver->ops->remove, too.  As unsol events and
jack polling may have been already enabled during the probe callback,
the driver->ops->remove call is done (more) conditionally now.

Fixes: c3ec8ac82105 ("ASoC: hdac_hda: fix memleak on module unload")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261009133341.440917-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/common/bind.c  | 8 ++++++--
 sound/hda/common/codec.c | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/hda/common/bind.c b/sound/hda/common/bind.c
index c264d7c3f5460..3e9bde54cf0f2 100644
--- a/sound/hda/common/bind.c
+++ b/sound/hda/common/bind.c
@@ -89,6 +89,7 @@ static int hda_codec_driver_probe(struct device *dev)
 	struct hda_codec *codec = dev_to_hda_codec(dev);
 	struct module *owner = dev->driver->owner;
 	struct hda_codec_driver *driver = hda_codec_to_driver(codec);
+	bool probed = false;
 	int err;
 
 	if (codec->bus->core.ext_ops) {
@@ -122,7 +123,8 @@ static int hda_codec_driver_probe(struct device *dev)
 
 	err = driver->ops->probe(codec, codec->preset);
 	if (err < 0)
-		goto error_module_put;
+		goto error_module;
+	probed = true;
 	err = snd_hda_codec_build_pcms(codec);
 	if (err < 0)
 		goto error_module;
@@ -141,7 +143,9 @@ static int hda_codec_driver_probe(struct device *dev)
 	return 0;
 
  error_module:
-	if (driver->ops->remove)
+	snd_hdac_device_disable_unsol(&codec->core);
+	cancel_delayed_work_sync(&codec->jackpoll_work);
+	if (probed && driver->ops->remove)
 		driver->ops->remove(codec);
  error_module_put:
 	module_put(owner);
diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index 7528839bed706..1c7ad515157bd 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -3025,6 +3025,7 @@ void snd_hda_codec_shutdown(struct hda_codec *codec)
 
 	codec->jackpoll_interval = 0; /* don't poll any longer */
 	cancel_delayed_work_sync(&codec->jackpoll_work);
+	snd_hdac_device_disable_unsol(&codec->core);
 	list_for_each_entry(cpcm, &codec->pcm_list_head, list)
 		snd_pcm_suspend_all(cpcm->pcm);
 
-- 
2.53.0



