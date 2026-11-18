Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045840;
	b=E1vUzA1a+5Ir4tTT3kPUIEH9Lv/jgdUwEZvp17iDfsFEy3gVSlV9uYTer/yogZZ2sk5O
	 Jc50kQHpJRfK6ZVe0h+dto+6M7aJWR9/p+cnnh8DV8SFZ9XaxzKRdsT2vbVyPCMCPlQw7
	 LwRv2EQ7DoFyhnsZ0ZSBSII7uUWW0F9m1bs19GThtM8H6G8vU3icJ2VFNVeX1t7YOzKV9
	 C7L/pLvh8aPK1escCPLtg6JxrUcYxfcR71ISvzwafenzdkAhvOt9MLH45vvikJpBMZea9
	 3jdVLOXIn61usnCM7RrEeD1rR2xCuAR3wkeFAi4kGFyHmuD4Hodj2gR6U43vsUgIseQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ee7Z5c3ua8a7f2jAQ3IitSqhPxrdjS5w8JLKYW1a/A=;
	b=pJIM6Awl7IhoBBxcyHgNN60GI64IQR8i3djbz8Wq7TadhZ/K/d07vR1zb2XznZz7Mz36
	 Xuu8n0nzh25r5MNjWN5Qvz3Z5Q3tTMBssYEggYWFkImuETWcsSBlqIkco+GItsFBueZRp
	 wrTzj7amBw9EgBFGrU+jxYPrNMzawwR0K8zJp4RyK5Ms4x4lrMgZ1fsbSLpc11fYLayDD
	 qRtJZuN8TltPZABZbfC8RZEUpl4ba0sC13aLPmSr9yHOskT9ftPWefjK72O3Rri3H+7/U
	 AY70hS1x/yTG0iWBBtqtP2OULHLlxI5pOHr8tYctM/nHvSZ0TYzkyLZFSR6enJ+m/sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oyI9/tgl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9CF606A320;
	Wed, 18 Nov 2026 23:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oyI9/tgl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1261F000C4;
	Wed, 18 Nov 2026 23:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045840;
	bh=9ee7Z5c3ua8a7f2jAQ3IitSqhPxrdjS5w8JLKYW1a/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyI9/tglKg4I3EAqHUpZoQlZxS18wIUyYuVdgVDUco4cAGSoxpBmqsik963oYzpmg
	 24ABNEPe4IEGIeIhJGqj/h8+YRjZxmXZWgMkH5sY2z84q57Eo2QRvzIBY/fbnB+Cv1
	 VnG3c0uRaaBQU3pG+Viqyp11b+V6CU5qAF6T+GG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1066/2857] ALSA: hda: Reject codec reset on ASoC (ext_ops) buses
Date: Wed, 18 Nov 2026 15:35:00 +0100
Message-ID: <20261118150239.983284713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 498bc523ba08d..1a448981545d5 100644
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
index 5d95f24135dc1..bd3686d60555e 100644
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



