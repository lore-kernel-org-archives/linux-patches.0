Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062669;
	b=hV4Xc2NxOOOrNewXwiUFl8wvhhiQjL2v/HFAa7YSoOpmZ3FDwhhEZA1y0BCClKVRWbTW
	 VZodQewmu0UQC+KGh53FfcpEdVLhFF7MeJzUadvRb+d8LEoGKt7AN2ihIBYoP3LRHbzn2
	 w5zCMIm/iymQOf82xBakq7je1pa6yXuoA8u6SQ1tEye+2CPBQcjR6tb7obTGCFuxS00Nb
	 5fyygUi4+F3Vh20za5E/aCEAY2/8cULo99iB/8QbxLTwlGSOBG0XFK+BcAqIuSJtwqaXY
	 BKLp+ajBT191XqkMxA0uBj4e+yailAdpUd2jpG81NPvfuc3l8uHYYuNi/AJKtaib5Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A4q5mmeezCMISi92D/fMxiTgSnyhsI4RA0f7ZlGh0LI=;
	b=O0c4tWEfaSnLX9IA0tcjm+TdcjJfwkKvDOCjzoo7OSPzs58oMyW8OuusmVvn7WYzdSbp
	 AQtvPwF9nkbenWq9B3zJpUVquLCzpSb9CpYhLGBexfo2hKC6zqx243/ZMW6EFQIyT6os5
	 o+DiWz/6X7q2cjUxkQkM0YLvA+hPMTzbJidHrvoQ6TzB8yh7T9guYs6xrithNVWYZTLCr
	 FUJF9YukskSxPiXozsodHTsfRXkJKm40S1oBgV+kkUnwrl0Q5s5iA+Xgn2oj7CJHBtWSl
	 Q7DFyaaO8cUHGWIc/5Cl5FN8PEqXLT2ovKgsf8xp0QhKnCxzUJNSb8duNROgvUsLl+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="M/XNxvY1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856D6606A32C;
	Sat,  7 Nov 2026 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M/XNxvY1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D251F0089F;
	Sat,  7 Nov 2026 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062669;
	bh=A4q5mmeezCMISi92D/fMxiTgSnyhsI4RA0f7ZlGh0LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/XNxvY1qqG9fv6D27UwCwvTZw8d8+3wjDH4f2pVLh4OuVQHzv/xfuOu1YG9KL4Ei
	 1Ul9dI7yXrC1+TMmdeBXeEqRfxhUPHQqcHmKe18tnw0il7ra0KTqQ9u9KD+cmOriav
	 9kIx7DhUrcLAy8zpG99tdBvKU9fFhz07Tjam7aDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1483/1536] ALSA: hda: Reject codec reset on ASoC (ext_ops) buses
Date: Sat,  7 Nov 2026 08:58:19 -0500
Message-ID: <20261107135039.506248197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/hda_codec.c | 6 ++++++
 sound/pci/hda/hda_sysfs.c | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 24ecb1101504c..1a7291ddee570 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1849,6 +1849,12 @@ int snd_hda_codec_reset(struct hda_codec *codec)
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
 
diff --git a/sound/pci/hda/hda_sysfs.c b/sound/pci/hda/hda_sysfs.c
index dc7dfda2847cd..c6081f3c1ccd8 100644
--- a/sound/pci/hda/hda_sysfs.c
+++ b/sound/pci/hda/hda_sysfs.c
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



