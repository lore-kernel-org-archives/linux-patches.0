Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38A13B27D9;
	Mon, 23 Mar 2026 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275208; cv=none; b=ulE3NaRljqw2oklN0vBAO5SBqsUZA6bDHPht0xHk1n0s5dtPMAR7z8x8sAQEjAtI+0d8rSS+5/7Hx1i0Ks13JuwuBiVKX2VhERZrpFKYpWDSHFe+V7L9fCRp2zTtIHp+3oggD2CJi4xUribfT04ER0PCozFS93uZf1YfdP69Emo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275208; c=relaxed/simple;
	bh=af06i7TCsEVswL2s/XTS9+GdL5QQyVhXhW1mnrmr98U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdNeX7Z56rhltiJpMncpYshNcfjEOYgiGjkU2dPnyvpEgSoomBLtABOEhx+TSfI3LCYPbouiiLaUQAJg6yGT1YJWfqJ/TlNZDeGFKlW0Czytd79iKGm6cK3z9ksBeolLCeRjBs4Q3K1aqZGr5yQO+kL2dE9INAQwfNQFzKq2e/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilvOa/ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilvOa/ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAA7C4CEF7;
	Mon, 23 Mar 2026 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275207;
	bh=af06i7TCsEVswL2s/XTS9+GdL5QQyVhXhW1mnrmr98U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilvOa/ovDriz4fibVrH/BchZudgKnM8FMv6rJPZcb6QEaulZEeIQI6TY+c+2XvMq4
	 zJDps6G/FJsoxel1hVCFRjXER5Uk5yQeMYwZFxjxlywu1ZKlKskdy2VstNvo2wl0tf
	 wb9diLTHxlNGmI6rq+HPQZMlPtk6Tv2FO9s/qa9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/567] ALSA: pci: hda: use snd_kcontrol_chip()
Date: Mon, 23 Mar 2026 14:38:53 +0100
Message-ID: <20260323134534.089968635@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 483dd12dbe34c6d4e71d4d543bcb1292bcb62d08 ]

We can use snd_kcontrol_chip(). Let's use it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/87plglauda.wl-kuninori.morimoto.gx@renesas.com
Stable-dep-of: 003ce8c9b2ca ("ALSA: hda: cs35l56: Fix signedness error in cs35l56_hda_posture_put()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index b84f3b3eb1409..03b2a6a919b4d 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -174,7 +174,7 @@ static int cs35l56_hda_mixer_info(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_mixer_get(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned int reg_val;
 	int i;
 
@@ -194,7 +194,7 @@ static int cs35l56_hda_mixer_get(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_mixer_put(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned int item = ucontrol->value.enumerated.item[0];
 	bool changed;
 
@@ -221,7 +221,7 @@ static int cs35l56_hda_posture_info(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_posture_get(struct snd_kcontrol *kcontrol,
 				   struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned int pos;
 	int ret;
 
@@ -237,7 +237,7 @@ static int cs35l56_hda_posture_get(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_posture_put(struct snd_kcontrol *kcontrol,
 				   struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned long pos = ucontrol->value.integer.value[0];
 	bool changed;
 	int ret;
@@ -284,7 +284,7 @@ static int cs35l56_hda_vol_info(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_vol_get(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned int raw_vol;
 	int vol;
 	int ret;
@@ -308,7 +308,7 @@ static int cs35l56_hda_vol_get(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_vol_put(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	long vol = ucontrol->value.integer.value[0];
 	unsigned int raw_vol;
 	bool changed;
-- 
2.51.0



