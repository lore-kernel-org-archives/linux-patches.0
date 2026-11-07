Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065462;
	b=xI5bCyfkcOgGedSk8OdyTMxpL4RaoRx/p+EzhcAgVHEXc6dLRvCGn90bbD93zu6+kSgZ
	 S7TSIaDelznuXc0rVMSnWrp5Kq+JNcqi2948/IxHCAnO9RUcBhc9sRC69l8rV+aldXWGB
	 /0LzmNkSd9mpWDwLKWBJeE6dgR3hXrVzGuYSw94+afrtEdjoOp4PLWwmJpQ2PaC/sH1kC
	 /ZyFhWAObq42GR1GHrghq1Q4nY13bt7IZvQiRVipRdwrW2ryqwdFYwZAe/ZWW0nl/XMVe
	 IqTt29lFKXUtBCf44XfjdYSvkH8gaGlt2nHIUFao4HKsNIr8EY/aYMKJN76hEgxxYhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5oXBRh6hsS5oLv7yc/eXXgSsXahx44Y3ceEzoySJ8ss=;
	b=burhrsaYjo3MrrMLTT0MUsPDeJd6aCTIU5LzLPwu/BjInMBVkQY8zekzSI+J3Fq1nHMW
	 gSms5cpCAlx/bmaWY+1mB+UpGO9Ekq9NImekMy0uj1SLR6SM04KTxsTGvin5aTFz+6Zxy
	 js6ok/+Isj2pxBDELg34ZyfayF5a1y7txkiZlF9D9MOB9A3SjnGGV4KD7Q/cRZuCydHyp
	 /Zb6xpNn+K9FJ3cgOdUOc7o0swRj1rpiai5sVyUYOMQcdUPhv9+LB3PuuX0s/avsTDLvv
	 GG3TXTX3twXYJ4K4oMa3vRYK6tSsud4AVYqdJJcR9MYFAizol8SG13zUt6txoOAr2eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFwDbWmF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A828C606A32C;
	Sat,  7 Nov 2026 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFwDbWmF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612B61F0089F;
	Sat,  7 Nov 2026 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065461;
	bh=5oXBRh6hsS5oLv7yc/eXXgSsXahx44Y3ceEzoySJ8ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFwDbWmFiZpopT223BMe3Y1wPZxJk7nYapU+P9+Uz+9nE8/5SdmAB3IAiMRViZCia
	 K7H/KNqX6dp2U8Yxc2Blzf6rhHPG0cJ6rOorJmbCLRvw60ZOCCa5cnTzU2tdHTPqzh
	 WerLRyQpYvvPDYm+ZnBz0+wMQ4rKOs+bvgrp7KME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1159/1257] ALSA: hda: Reject codec reset on ASoC (ext_ops) buses
Date: Sat,  7 Nov 2026 08:57:35 -0500
Message-ID: <20261107135011.209511884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 5d9b53bd64ea0..7c2b967aebe95 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -1800,6 +1800,12 @@ int snd_hda_codec_reset(struct hda_codec *codec)
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
index bedf10b308850..bf65223fde10d 100644
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



