Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214805;
	b=TEf/BmkcE197aqTloE0GPqtUyupKwO/fTWcRAvr9eFFp54Gj7LrRTdtl0EzrpTzw4VUi
	 VONE0WyG9mvQzZ4VXWUo3NmQQcKs9585CjYWzPR5tVEV8KBKmtvnH0sUp830aRynssCcY
	 ZRYPqGeQVDS0xJwCwgPFikptr9W73wxB3GYS/ooLoCrsy/R1HL8yxWQMfmu3UmkzmyzHN
	 vcP0PGoEyPwGpdvOoKIY+jqrTNEbbpJlbu97VJQboUIj2sfplIYMj7hYCT0PVYcLK0P43
	 WFFjoP6CxMUSjFTTUG4YSkzhXjS8hWg58LT9tzSywIxlY8De8y6WvlcF2bZ2W3ailcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CgEHp7g0l1b+Xk318RN2PBnjcqg+c7r4a/9QoZkUJEk=;
	b=yNW7LMbYuFGSFtOGylAOG8bEvafH7Q0tL7+UJwP3ZiGaxhaWCvJxmIqG3IqNTtPBbSz2
	 PWfKZ8Ny5BqCobh5xpSoUyvNWyH6LbdNRwbUlGd0fl0bJAumTiW0Frvc0BLRtmNU6L9X9
	 xEiu6ZsJ264TIZbWP+Cpkwx/0sbTgQyvppSvkIHLQAU9hwTYDb1Wq0pXhtKgWcBiweU7n
	 4f8DzO0M9C0zYIuDmaxUZckU0ax2Xmoshv0L82UEtJI2z7EXVpkrrzZxNTXAsBQJ0nx57
	 fdEiUSXm68j9s+lUkhWGRsDkGk7C/CuEq6gwM3/qlmI+h6x1rVY0w15CQj8EMRs2kxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QG6aiiBQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E487606A33A;
	Wed, 28 Oct 2026 19:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QG6aiiBQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6A11F031E0;
	Wed, 28 Oct 2026 19:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214804;
	bh=CgEHp7g0l1b+Xk318RN2PBnjcqg+c7r4a/9QoZkUJEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QG6aiiBQ1y87Goyfmtwn1d46dZ8cV7cp4Kj4DNrPmPIUBR4hM9ESCsla4u7AU7CQG
	 nUo1sfNLl2ffBBWrMt1ii9qZANLDZS4k18nDeirJ1TRV3+6yB3J1gqU9uPx5+e5TxD
	 GXW92QQFYMSvgcnEGRJOELknW4iVk0/Ae3peS8lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0986/1887] ALSA: mixer: oss: Add card disconnect checkpoints
Date: Wed, 28 Oct 2026 17:51:22 +0100
Message-ID: <20261028170521.847990122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 084d5d44418148662365eced3e126ad1a81ee3e2 ]

ALSA OSS mixer layer calls the kcontrol ops rather individually, and
pending calls might be not always caught at disconnecting the device.

For avoiding the potential UAF scenarios, add sanity checks of the
card disconnection at each entry point of OSS mixer accesses.  The
rwsem is taken just before that check, hence the rest context should
be covered by that properly.

Link: https://patch.msgid.link/20260209121212.171430-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/mixer_oss.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index abc99ae333282..ecb4af6709598 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -540,6 +540,10 @@ static void snd_mixer_oss_get_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return;
+	}
 	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
@@ -579,6 +583,10 @@ static void snd_mixer_oss_get_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return;
+	}
 	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
@@ -645,6 +653,10 @@ static void snd_mixer_oss_put_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return;
+	}
 	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
@@ -688,6 +700,10 @@ static void snd_mixer_oss_put_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return;
+	}
 	kctl = snd_ctl_find_numid_locked(card, numid);
 	if (!kctl) {
 		up_read(&card->controls_rwsem);
@@ -833,6 +849,10 @@ static int snd_mixer_oss_get_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 		goto __free_only;
 	}
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		err = -ENODEV;
+		goto __unlock;
+	}
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (! kctl) {
 		err = -ENOENT;
@@ -886,6 +906,10 @@ static int snd_mixer_oss_put_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 		goto __free_only;
 	}
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		err = -ENODEV;
+		goto __unlock;
+	}
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (! kctl) {
 		err = -ENOENT;
@@ -937,6 +961,10 @@ static int snd_mixer_oss_build_test(struct snd_mixer_oss *mixer, struct slot *sl
 	int err;
 
 	down_read(&card->controls_rwsem);
+	if (card->shutdown) {
+		up_read(&card->controls_rwsem);
+		return -ENODEV;
+	}
 	kcontrol = snd_mixer_oss_test_id(mixer, name, index);
 	if (kcontrol == NULL) {
 		up_read(&card->controls_rwsem);
@@ -1069,6 +1097,10 @@ static int snd_mixer_oss_build_input(struct snd_mixer_oss *mixer,
 	if (snd_mixer_oss_build_test_all(mixer, ptr, &slot))
 		return 0;
 	down_read(&mixer->card->controls_rwsem);
+	if (mixer->card->shutdown) {
+		up_read(&mixer->card->controls_rwsem);
+		return -ENODEV;
+	}
 	kctl = NULL;
 	if (!ptr->index)
 		kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
-- 
2.53.0



