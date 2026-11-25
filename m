Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622326;
	b=LeRgbgc3OvkgAXEpuyEt7649+4hFBq9K2MlEidlGz1f/zYfvjSgQYkVSyW7W0Fvftile
	 1+pV28QjmorvZ2EcuFGDk82aSLmnrrmhj0gNPLvn72JTR2lm4CeScn0AaK2nnHtV+czx8
	 pjEpnGCjVd90N8igX3cM1D9EuIrlVlhdBoC9AOBTEn1w4L9HEBUDdgiEaOiaiu65i5cd0
	 WfHRgR/NUobgZr4AsxSwQbYrvFzviWugUyiGwlxC1GLIjS6JkNkBi86ADckBrNQkpOeMY
	 uWkjy1td+NVabLw06YoNEvMZlJEbyvTvfkjN0YLe7K1YpwswW/ag2IJZpVVJgjiMFmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VXVsYy+IzT+mOz5N3HAYvxr7/NXjkcqexQHrgPIKYh0=;
	b=sUmAi8mlrNOG+zsu1G/1oktoc2OadvnTf1aC0deRUYmwjfgsZ25k2+3DmkMB47jq6ZoZ
	 Ehe54ZnYxQ4yw4C/YguKy0RDafZiDYOgtDe8I/w1YAYdSwkzC+s1/m6Iqfz0ag5S2NBlM
	 uHho8K6BxMumm3RPo/Unwv2Upzd1o2ySn/uWhaqaVv5zv1SmAsTu6/LWu0w+q0kV0nlTV
	 ey7nDM4SFUJ0GUkAzd5JM1oaEo8Gj71ZDAUmqkgvJdyzYhz7MfNgQjvp4Xs79xuzjLjlY
	 DbHbjDuzw+Lq3VQFBeT++e4Z1pPkOF2YaWLPycCqAYJ+LtdN3B00tuW2JpAEv0LWf7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVoa2yfA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D205606A330;
	Wed, 25 Nov 2026 15:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVoa2yfA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B491F000C6;
	Wed, 25 Nov 2026 15:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622326;
	bh=VXVsYy+IzT+mOz5N3HAYvxr7/NXjkcqexQHrgPIKYh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVoa2yfASvOWsQ5ungb7k4HX3xMODh/EM3hSBSHtJVhuPbYwZO0d0I+0498f4cbeT
	 mg/xm5ybPUWH1pDPYlz/jmoEuDHPG6CSp/gxDGJWgqV9fZdBsQISa/FlVeeUXZDOSr
	 A5E+ZmLAtN21+BInBoW1BDC6Ex8S3x+k/5jWMqhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiangCheng Wang <zaq14760@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 447/990] ASoC: max98090: keep the MIC boost across mic input power-up
Date: Wed, 25 Nov 2026 15:30:14 +0100
Message-ID: <20261125143832.564198679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: LiangCheng Wang <zaq14760@gmail.com>

[ Upstream commit 58d51fa6ff1d21e79c3c340bfb3155dfa3025ca3 ]

PA1EN/PA2EN select both the MIC1/MIC2 preamp enable and its gain
(0 = off, 1 = 0 dB, 2 = +20 dB, 3 = +30 dB). "MICn Boost Volume" keeps
the selected gain in max98090->pa1en/pa2en while the input is off, and
max98090_micinput_event() writes it to the field when the "MICn Input"
widget powers up.

The event handler also reads the field back to keep the stored gain in
sync ("Update for volatile"), but it does so on POST_PMU and POST_PMD.
The widget drives PA1EN/PA2EN as a single enable bit, the low bit of
the field, so at both points DAPM has just rewritten it:

  - POST_PMU: DAPM has set the field to 1, so the read-back stores
    0 dB and the handler then restores 0 dB.
  - POST_PMD: DAPM has cleared the low bit, so a +30 dB (3) gain reads
    back as +20 dB (2).

As a result every capture starts at 0 dB: a boost set while the input is
powered down, e.g. restored by alsactl or an audio HAL at boot, never
takes effect, and one changed during capture is lost at the next
power-up.

Read the field back on PRE_PMD instead, while it still holds the active
gain, and only restore the stored gain on POST_PMU.

Tested on i.MX95 with a MAX98090 headset mic on MIC1, running NXP's
6.18.38 vendor kernel (max98090_micinput_event() is the same as in
mainline): with MIC1 Boost Volume set to 2 (+30 dB) before capture,
register 0x10 reads 0x20 (0 dB) during capture without this change and
0x60 (+30 dB) with it, and a boost changed during capture is kept for
the next capture.

Fixes: 685e42154dcf ("ASoC: Replace max98090 Device Driver")
Signed-off-by: LiangCheng Wang <zaq14760@gmail.com>
Link: https://patch.msgid.link/20261111-max98090-mic-boost-v1-1-20b9bd8816db@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 830caf62d0fa8..f686f80b2c522 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -743,14 +743,6 @@ static int max98090_micinput_event(struct snd_soc_dapm_widget *w,
 	else
 		val = (val & M98090_MIC_PA2EN_MASK) >> M98090_MIC_PA2EN_SHIFT;
 
-	if (val >= 1) {
-		if (w->reg == M98090_REG_MIC1_INPUT_LEVEL) {
-			max98090->pa1en = val - 1; /* Update for volatile */
-		} else {
-			max98090->pa2en = val - 1; /* Update for volatile */
-		}
-	}
-
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
 		/* If turning on, set to most recently selected volume */
@@ -759,6 +751,14 @@ static int max98090_micinput_event(struct snd_soc_dapm_widget *w,
 		else
 			val = max98090->pa2en + 1;
 		break;
+	case SND_SOC_DAPM_PRE_PMD:
+		if (val >= 1) {
+			if (w->reg == M98090_REG_MIC1_INPUT_LEVEL)
+				max98090->pa1en = val - 1;
+			else
+				max98090->pa2en = val - 1;
+		}
+		return 0;
 	case SND_SOC_DAPM_POST_PMD:
 		/* If turning off, turn off */
 		val = 0;
@@ -1108,11 +1108,13 @@ static const struct snd_soc_dapm_widget max98090_dapm_widgets[] = {
 
 	SND_SOC_DAPM_PGA_E("MIC1 Input", M98090_REG_MIC1_INPUT_LEVEL,
 		M98090_MIC_PA1EN_SHIFT, 0, NULL, 0, max98090_micinput_event,
-		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD |
+		SND_SOC_DAPM_POST_PMD),
 
 	SND_SOC_DAPM_PGA_E("MIC2 Input", M98090_REG_MIC2_INPUT_LEVEL,
 		M98090_MIC_PA2EN_SHIFT, 0, NULL, 0, max98090_micinput_event,
-		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD |
+		SND_SOC_DAPM_POST_PMD),
 
 	SND_SOC_DAPM_MIXER("LINEA Mixer", SND_SOC_NOPM, 0, 0,
 		&max98090_linea_mixer_controls[0],
-- 
2.53.0



