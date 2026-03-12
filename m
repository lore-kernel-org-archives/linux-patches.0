Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A3F401A38;
	Thu, 12 Mar 2026 20:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346387; cv=none; b=eZI3Aarw5nHtChFReCvhasE7h6QnJO9Tp3I7NMzA0zLnKj5hl+5Q4mN8Fo8Nrh5ePBT+QPGVap1rwWYD5PXASdh0PCzgNRko5wRzMEpYg+jkHc/+o+I+pT61luqX2Hq2DWwkmXNlmjEoft5TWX4B+4MVnXY+mgz2WB1Do6Desgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346387; c=relaxed/simple;
	bh=6jdWoi7xAE56/zMfdLrkZ29zu5HfDQ+jNdPKygLx7QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoBnSRymP3mfCz8tT/XovQoTe1nafQ2ZVbcJlcMzsFZlDmCzfuV4rUkhy7H3JBgbg0JkXbAilao3q9NY+nOnl8fihtYZJzPVxKkHMnEcpNTKRb1cpSXebrre2pa00qC2skBYNHbGVZ0SykNwR3c9cLvz7vy4rBFmFnURY7yjLuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BY6dK0Ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BY6dK0Ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC810C4CEF7;
	Thu, 12 Mar 2026 20:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346387;
	bh=6jdWoi7xAE56/zMfdLrkZ29zu5HfDQ+jNdPKygLx7QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BY6dK0HajziyKp0VaRjzwlp33R0zJdTuJV2ttD7bpw0OmYGidMu1uXIimQWZDYild
	 pfUrqgK9DMB1I6wTPnQ9OCFmJkPoWCeOiZFY8kAKxDtDT14fqx0/ySPamLPaJ8ypwT
	 Mt8WIewQUW/CrbOkX6gqygKjDizjUNSrXMiZRPIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/265] ALSA: pci: hda: use snd_kcontrol_chip()
Date: Thu, 12 Mar 2026 21:06:58 +0100
Message-ID: <20260312201019.313029562@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7823f71012a8a..52d2ddf248323 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -180,7 +180,7 @@ static int cs35l56_hda_mixer_info(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_mixer_get(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned int reg_val;
 	int i;
 
@@ -202,7 +202,7 @@ static int cs35l56_hda_mixer_get(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_mixer_put(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned int item = ucontrol->value.enumerated.item[0];
 	bool changed;
 
@@ -231,7 +231,7 @@ static int cs35l56_hda_posture_info(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_posture_get(struct snd_kcontrol *kcontrol,
 				   struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned int pos;
 	int ret;
 
@@ -249,7 +249,7 @@ static int cs35l56_hda_posture_get(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_posture_put(struct snd_kcontrol *kcontrol,
 				   struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned long pos = ucontrol->value.integer.value[0];
 	bool changed;
 	int ret;
@@ -298,7 +298,7 @@ static int cs35l56_hda_vol_info(struct snd_kcontrol *kcontrol,
 static int cs35l56_hda_vol_get(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *ucontrol)
 {
-	struct cs35l56_hda *cs35l56 = (struct cs35l56_hda *)kcontrol->private_data;
+	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
 	unsigned int raw_vol;
 	int vol;
 	int ret;
@@ -324,7 +324,7 @@ static int cs35l56_hda_vol_get(struct snd_kcontrol *kcontrol,
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



