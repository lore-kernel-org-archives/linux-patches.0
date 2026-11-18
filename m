Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058728;
	b=RYw4ai7JM6xeoiDVdu8fWG5HYlvGN4mKhQGO/dBi5ZTfulBk29FWVoi2IXdGA5Zdwa8Q
	 HqEDH76gSrS/Nqp5DdEUYvoHzFzxq48PJBA/27ac4o1g/TRMIRVYwK3NeUekSD7Pfc1sY
	 YzGCNxjDAZhTMnENkrjpWaPKpddv83iCjHZXKuUP9Sx+YZ/JRPWiCX9kB5M7sNFR34Xr/
	 P53llLzeW3Tbn++qngQ/CBeJFQv/rHeLHa2V0Z6Zgm/1eKBitLrYOqbmBcF3VD0jw4eRz
	 XEEbGuQbTfJJY7gTj2xjpp0Y9vv7VTGgTteSKecd0WRzkmBON2r3Z85ppsExtanaBdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2YyELCSYU1qviYcblmPSryZgsDbErGZDPhrjXpGsO+4=;
	b=4+nyliig0LmxPllXSsy8o+rIwyJchggKc/d2rfF94GnHtfLwvl2qgZ7UL5zf1whKRJrq
	 c+2o79tGPjsImhQz+LkZ62dTL8+oLowbLd4rFDhE5iNJHCJ/G5iw3AAAQVUFTW776lXqC
	 bynSB2VUCrzIfI8Vy8nmirxjn8jD41w4ASBPKiH025mjzml8FrQ38s+UrPAEXAaSr9K9s
	 eWLe72kURnZuRPEwtn0YLLXb/wNdb9e3OGnfnTTuWCvJQNF1nT1U67wIcr9eyHJszUijM
	 y0UMsrePH0ZI9G41PfX5GKpaIHfch/m+Sh70ig9zCfr+WpOfrrGEBqoqP6Fp1wi4bjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+QndIb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4C5606A320;
	Thu, 19 Nov 2026 03:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+QndIb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2021F000C4;
	Thu, 19 Nov 2026 03:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058728;
	bh=2YyELCSYU1qviYcblmPSryZgsDbErGZDPhrjXpGsO+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+QndIb7YEywLNCc0muBLImk/04+iZGCXwou2RL4WFtA/xZ+L9jK/7dtVvUql1VSA
	 Ir8+sTRfjSKkDPOKeITk9sP960UNAbjUz0YRd867Zs005WeoU8cfn0nt0MkIMJSyyx
	 bO39g6NM+cx7Skn1Fc4hdlR/HMkuuS+q93LfbuO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0590/1848] ALSA: hda: Reject codec reset on ASoC (ext_ops) buses
Date: Wed, 18 Nov 2026 15:43:48 +0100
Message-ID: <20261118145940.121776897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fc4a64a83ff2f..8801d866c9bfe 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1802,6 +1802,12 @@ int snd_hda_codec_reset(struct hda_codec *codec)
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
index d5ffcba794e50..7f04d43afc55d 100644
--- a/sound/pci/hda/hda_sysfs.c
+++ b/sound/pci/hda/hda_sysfs.c
@@ -119,6 +119,8 @@ static int clear_codec(struct hda_codec *codec)
 	int err;
 
 	err = snd_hda_codec_reset(codec);
+	if (err == -EOPNOTSUPP)
+		return err;
 	if (err < 0) {
 		codec_err(codec, "The codec is being used, can't free.\n");
 		return err;
@@ -134,6 +136,8 @@ static int reconfig_codec(struct hda_codec *codec)
 	snd_hda_power_up(codec);
 	codec_info(codec, "hda-codec: reconfiguring\n");
 	err = snd_hda_codec_reset(codec);
+	if (err == -EOPNOTSUPP)
+		return err;
 	if (err < 0) {
 		codec_err(codec,
 			   "The codec is being used, can't reconfigure.\n");
-- 
2.53.0



