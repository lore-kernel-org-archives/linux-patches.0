Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1A03876D7;
	Tue, 10 Mar 2026 11:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141929; cv=none; b=flujc/rDkQ+wFmkfmgb2i48Yjm7nYgr93D1R9eY0cI3SBYxBsyhKFeQvR9cx8Fv7C6OBEV8vfFldouwBpFHntCyBmKsQ7cL1BpL7E6YOYRbDkqK4mo9kHnHMU6OyUCYhoX/26PSKXW/6eCM9kiq+EGSFMmd3tH1XLj0gzcDhV+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141929; c=relaxed/simple;
	bh=z3K33gy7bGGJFiBvmzMQ11TIATyLRUHn0H/Ab75KBLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ns5lDjv3KFb56FuRTKBxRmscSomW+Gd55xWU0835x6kcuj5sCGuxGg1j6jzuXc56a2A3Hb1IvW7l7eZHTzxPfcm6hyEmdaqrJxhCDeYy3yebG//47UgSCPpA7Y4UK/1WxeNqGiWb+m2E/EgYtEyVAqr7JEjZlu4RANcwtbBMpQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ul7sgmNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ul7sgmNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C055C2BC86;
	Tue, 10 Mar 2026 11:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141928;
	bh=z3K33gy7bGGJFiBvmzMQ11TIATyLRUHn0H/Ab75KBLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ul7sgmNHFWKsBialzpH93sQXWNX8yTQoto2OE8vM/P35OCalH+hbtHuGtSu8VC5NK
	 3+tp1VYudDH/nRHro+KCXY28VxX6I/gMpWxag+8kQD8NGSF+xsxyjYBq5g3TgyZHVU
	 FZt9hFPf41ggv4um2HrU5xX7hGtQZztHHSqqFGEKnPrKVgyH8KXuH7qasTMz+Rq/LN
	 EesKMBMZxqYwBcji5MRV6YfvZy69uw5qhJJBfNwAAoxZr6SLLzKWJIUvMm2d9VLWAH
	 WL8ZyiYpYnNuQBXE4zMbR7yfaKoG1Grke828/mvSjmWfuDnyHmadV70BrzI6IxFiQP
	 W9xcdoZAmwBIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/314] ALSA: hda: cs35l56: Fix signedness error in cs35l56_hda_posture_put()
Date: Tue, 10 Mar 2026 07:15:11 -0400
Message-ID: <88b847d055cf0aa28754df51ff07fc35377de10a.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 5bb1c4ebeaf3c..acbacd0766064 100644
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

