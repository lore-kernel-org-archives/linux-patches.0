Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052901;
	b=XGA8Fen1Fe5c+i3Ic7PN4roaTEtJ9I6ZJqzSRG1yY/BizdgwfDJaecT2dCnBXCjzOQME
	 sk+jYJYppzYYV6mIFV0c2kCQgk0lG9Mbuppj/jN1g8ZwVe8PnpZaG2mAwrPuzXNZj8rD5
	 fw1ieT0mzfQiM3YUT0B4UY4FcnqTHAtqxjYrDw5QswKIy7lM2a2jHTS6tkJB3NLRerUfg
	 BLZ+adh7ziXlDe4MzZ5RibKq6QhSEZguwA0LBANBnfzpfK0NZKCSMub6AIpMimUNViUfx
	 5ZGLRlrlSHqzGqbozfRJijir8QKqhAjwJsNzq20RNWTCbiTpGLRMW3kAod7f3gkMbjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fDATHDGBNLJS3sig1s37nGRjM1EADOqf5W9H/UwQPlQ=;
	b=dX+/0VbiRI6lvkRiXMY46zw9iKKlXHbuDlwfXB+Wpe9uUh6vgFHKJG1Gg2YAlnyjU/yB
	 UC5K7FSf2hRZgNoG0s9b8F3Zpf2eQBoyc3+k4JyAIhH4uGqLcPcd1NUFuBLP/TcFOA41X
	 jd8F67x04Yb9Lacu7T3y3t0BqQnakq08FiQNsM0sI9uNt0SoMTbT62JHYj8klwyYfD54T
	 P+iBjpd5uMKRq5sjlVLtfZ/TnvZD3xEsLNZz2opHQb4B8k3662GcFvSKrOZB7s+iuImqy
	 d3PM9gaJqUYWmFTOnozYC/M9UYwZCjZZxJ+k9taq0YpeWXtp/VEOhaLpbBqVkysR/Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYkt0PhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE729606A32A;
	Thu, 19 Nov 2026 01:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYkt0PhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101F71F000C5;
	Thu, 19 Nov 2026 01:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052901;
	bh=fDATHDGBNLJS3sig1s37nGRjM1EADOqf5W9H/UwQPlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYkt0PhRgVZTciGmYGQZ3Z7RNS1SHrb9FQy/SjKU1BcqdIE3ofCyxv5XCn+RA0pXk
	 IoSqY1WN2yjJjgsYtNbPGoSYHWhxVzTzTFgiDHTyiwbhA9hK2v3ePTpvbgD7r6RuVq
	 aD4n2ve5nfjhC+C82b9LTN1b5UrUcavT3asBnY3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0726/2214] ALSA: hda: Reject codec reset on ASoC (ext_ops) buses
Date: Wed, 18 Nov 2026 15:40:02 +0100
Message-ID: <20261118150040.812478392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 19be60bb57810..5c900a797f257 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1812,6 +1812,12 @@ int snd_hda_codec_reset(struct hda_codec *codec)
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



