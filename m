Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F253D36EA89;
	Tue, 10 Mar 2026 11:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141072; cv=none; b=hI1+zzhjmdPQreLdPjjR8QCRbGu7uoHopSIm/8JAv1d/SJ2NVay2tU6mXPuYh4iQaVKSO8pKZTh4NBpNoVfEwQDuFlNAjXJIkWQclNFkM5EV9Cq5FrmI58S1iTphJe9MuAVptz9R/qwfFLaPUoIAV8Eu89Ye20vqeZs20d4YEJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141072; c=relaxed/simple;
	bh=Usr0u/7RVGGEjsFzuaOJyyaRuuQjRlQ7RipFGwNUxiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puc/ol/lWeO/pEZIeEstvgZHN1ifB5KrgueVnxKpd1MsCk/FhwgJJBWDdS+iKfLDBaBFNd9yfvXC9z1GEdStlMuHI39+L4vUZE238zvNG0qeMT3uWgPqX8+IC4GPm27tV+CVMu3vyHWu78Ej55qemYytM1AcfGyfykO8i0FaZYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJmsNs0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJmsNs0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318BFC2BCAF;
	Tue, 10 Mar 2026 11:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141071;
	bh=Usr0u/7RVGGEjsFzuaOJyyaRuuQjRlQ7RipFGwNUxiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJmsNs0/3fsTQVgo+Ecsdo3M5PbyIYCkKA9Cs9k77dnWcmoO0uih92x8uAHl7Wsrk
	 xYaI1HYFanV1+l7BwvGuGXWgqdjw4rsfsitBUcOjtDPd0ybNKGZJ0kS8c4sajNFK35
	 dKuCFrVyBuNUqyHFDuMwEW2Mr/nBfjBY4MNaXAkQ3cCyHbtnUI3l2KkfBTBSSxBk23
	 z1QxZs3qVxP3I6SAsV+GCoqflJl/rcvPmVy8G7kiUQolHYO6T8s7mWGJ+aAjdNRs4d
	 C/+HLl33mrU7o1UPMySH4OTofJL+UZ/PbrMfBpN20JpiF7n8wOAxyVnJrUjS5OaZTm
	 zbhpUswi1R+Dw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 071/311] ALSA: hda: cs35l56: Fix signedness error in cs35l56_hda_posture_put()
Date: Tue, 10 Mar 2026 07:01:58 -0400
Message-ID: <91585cf1a084e7a6c18156ea4b5e93990e767c2d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 003ce8c9b2ca28fbb4860651e76fb1c9a91f2ea1 ]

In cs35l56_hda_posture_put() assign ucontrol->value.integer.value[0] to
a long instead of an unsigned long. ucontrol->value.integer.value[0] is
a long.

This fixes the sparse warning:

sound/hda/codecs/side-codecs/cs35l56_hda.c:256:20: warning: unsigned value
that used to be signed checked against zero?
sound/hda/codecs/side-codecs/cs35l56_hda.c:252:29: signed value source

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 73cfbfa9caea8 ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Link: https://patch.msgid.link/20260226111728.1700431-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l56_hda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.c b/sound/hda/codecs/side-codecs/cs35l56_hda.c
index f7ba92e119578..32d734bf2fdf8 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -249,7 +249,7 @@ static int cs35l56_hda_posture_put(struct snd_kcontrol *kcontrol,
 				   struct snd_ctl_elem_value *ucontrol)
 {
 	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
-	unsigned long pos = ucontrol->value.integer.value[0];
+	long pos = ucontrol->value.integer.value[0];
 	bool changed;
 	int ret;
 
-- 
2.51.0

