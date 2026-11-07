Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063694;
	b=eJmT0ovbab1X8XogSnL8nkYlA8Qxm2TkxcsTxekM5fxOanvUr7ypMAAQZN0NhVBnAQYZ
	 tgwfvBvDyeWOJCI1aoQtVlnd3CsRQgjGTwzOmlsqym6A9RJxKLczUp1TSWcf0vKjmT0LE
	 FpmR1ql1/dc7vVSy8KNCxVB1IAQPAdP6SjG/yPketrFv9nNMmg6zncYMnbi4JNegjBYqA
	 zJ1hYVc199REiKn9kMK3zGPTfSQIMG8avSgmc2B1cyH47EUi4QpkbvIREarrKbZNXI8Bo
	 iFV1+rxRYZpUEp8Mr9STy4MhX4qM9gLEPmDF+XRqr7Hg1WK+xIRxnmLlmAfVzaJU+EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rKQKEHL968E2si8mDLpfqhFcdgJvGzK7BqGNcq7Lavw=;
	b=Vk1V6dEjARuEQZJQ6JLKMbquPO3RhMGX9t3mkHD+oHkSemP8Vrl9UG6t2vItm9xoGgle
	 gRLljE35iNKOmLq1eHdy1w1l+k+ffE1GTMlDu9aiKwaL04KyJOhUXnPOEhVWPJ4hevoNg
	 E0zrnW8Ju4erXov0B6ayKtTnfrjH7tAaEF8/l54sxfon6juxIuqT1qlTCsCWKNJJeHX1X
	 fOEwY4mT7anaTvDIAJfS5jVkjJuB7Imw732qYuPXHI0eovNjj7VtKqa/3aDvrDLWQDuee
	 0yFgeLU6hEU/3z1pxJ20fi5EfAkHd3uLZ6GdspcL2DjTLwoOh4yl4K2ptltBN+nn4PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JFbDe7/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9AD606A32C;
	Sat,  7 Nov 2026 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFbDe7/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4811F008A1;
	Sat,  7 Nov 2026 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063694;
	bh=rKQKEHL968E2si8mDLpfqhFcdgJvGzK7BqGNcq7Lavw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFbDe7/M47k21pQ87p0Q9acUKm6hog4r+lcszawYR71p9Lqg0+tPMYT811Xn7fQ5w
	 AtFdvW/p0Fm1VDwbhu8S8NIXM9sAy/zeYVDA4ZBqPlAcQOyKwvuOoioHI3ZE5e6KTF
	 ZemxzFAtG8YLEavffNsHzmcTR6nko4nAT/E2etrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 799/869] ALSA: hda: Reject codec reset on ASoC (ext_ops) buses
Date: Sat,  7 Nov 2026 08:58:01 -0500
Message-ID: <20261107134919.922943422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit a4311e9447bbb219044db38897f95be112f46a8a ]

Writing to the reconfig or clear sysfs nodes of a codec handled by ASoC
(SOF via hdac_hda, AVS via codecs/hda) hangs the writer.

snd_hda_codec_reset() sets card->shutdown and calls
device_release_driver(). With ext_ops the driver unbind unregisters the
ASoC component, which unbinds and frees the whole ASoC card:
- snd_card_disconnect() returns early as card->shutdown is already set,
  so the card's child devices are not removed and snd_card_free() waits
  for the card release forever.
- Even without that, freeing the card removes the codec's hwdep device,
  which owns the sysfs node the reset was issued from, deadlocking in
  kernfs while waiting for the active write to finish.

The legacy HDA driver keeps the card across a driver rebind, ASoC does
not, so the reset cannot be supported there. Return -EOPNOTSUPP and skip
the misleading "codec is being used" messages in the callers.

Fixes: 6bae5ea94989 ("ASoC: hdac_hda: add asoc extension for legacy HDA codec drivers")
Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=222182
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261027072835.4796-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/common/codec.c | 6 ++++++
 sound/hda/common/sysfs.c | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index 7869f673894fe..e6548e03a32ce 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -1806,6 +1806,12 @@ int snd_hda_codec_reset(struct hda_codec *codec)
 {
 	struct hda_bus *bus = codec->bus;
 
+	/* ASoC: driver unbind frees the card, incl. the hwdep issuing the reset */
+	if (bus->core.ext_ops) {
+		codec_err(codec, "Codec reset is not supported with ASoC\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (snd_hda_lock_devices(bus) < 0)
 		return -EBUSY;
 
diff --git a/sound/hda/common/sysfs.c b/sound/hda/common/sysfs.c
index f8c8483fd5e5f..121a54ea3150a 100644
--- a/sound/hda/common/sysfs.c
+++ b/sound/hda/common/sysfs.c
@@ -117,6 +117,8 @@ static int clear_codec(struct hda_codec *codec)
 	int err;
 
 	err = snd_hda_codec_reset(codec);
+	if (err == -EOPNOTSUPP)
+		return err;
 	if (err < 0) {
 		codec_err(codec, "The codec is being used, can't free.\n");
 		return err;
@@ -132,6 +134,8 @@ static int reconfig_codec(struct hda_codec *codec)
 	CLASS(snd_hda_power, pm)(codec);
 	codec_info(codec, "hda-codec: reconfiguring\n");
 	err = snd_hda_codec_reset(codec);
+	if (err == -EOPNOTSUPP)
+		return err;
 	if (err < 0) {
 		codec_err(codec,
 			   "The codec is being used, can't reconfigure.\n");
-- 
2.53.0



