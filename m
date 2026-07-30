Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B067643F8BF;
	Thu, 30 Jul 2026 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427150; cv=none; b=A+Iev4c5dFvswlgheZT4qcqTSWLFtOiUJuStRfuojsBe+OWLGoEYjdzkscfaBD9+LsV09lrenmyUd8OUBiwFo1vwZ5CJt6jqT6IneQ6J2PfPK3d/qtPoWdbzKxoOhyUslwJh2880uc6fpx3a3a82j9HFnFE32BCvcEsBVxmmRkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427150; c=relaxed/simple;
	bh=Fp+fyhc5l4zhC0LDPuLbD3siokRUACcOo9A4jcIWEEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPIiNC4hssJsmIeqITauPHOVnzVNCZJ6cN+z58GPhlunmbFLIdrQhLjBoK1EFK08+6gRG+++LdQx29ZP+UVCeUINy8O84AD44tuvyq/g56vsqJAH8gnfBpzVMTGygv4BG6nCBU7YL6pzJ50L177h/lDEQmSH2xuQgob5MalYawk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkgojjed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkgojjed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F171F000E9;
	Thu, 30 Jul 2026 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427149;
	bh=OWimsBpdd2BuEcgrAMT1O35ljG/JjMxeh6Tj1Nxoq/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xkgojjedBRQOB7Q6jyoeyjeN7RvrOqnIRSoUKnbaQiqPH5V/sQcKY9driIMiBIRO6
	 Ww00MhmumKZO6/yL+dCi7nZpL4elT4HAuxpIH+gQcILs+52lARkzCoC1+9W4BRViQ0
	 KPWNG/Xh2gtDLVlar2pvbRBebwLe//VeyRF4RZBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/484] ASoC: cs42l43: Correct report for forced microphone jack
Date: Thu, 30 Jul 2026 16:09:25 +0200
Message-ID: <20260730141424.912623789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit f74e6e15485b68b92b2807071e822db6309b7e38 ]

Currently if the jack is forced to the microphone mode, it will report
as line in. Correct the report to microphone.

Fixes: fc918cbe874e ("ASoC: cs42l43: Add support for the cs42l43")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260708103430.1395207-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index ba60acc4b2f094..d0f424d2e32650 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -283,6 +283,7 @@ irqreturn_t cs42l43_bias_detect_clamp(int irq, void *data)
 #define CS42L43_JACK_ABSENT 0x0
 
 #define CS42L43_JACK_OPTICAL (SND_JACK_MECHANICAL | SND_JACK_AVOUT)
+#define CS42L43_JACK_MICROPHONE (SND_JACK_MECHANICAL | SND_JACK_MICROPHONE)
 #define CS42L43_JACK_HEADPHONE (SND_JACK_MECHANICAL | SND_JACK_HEADPHONE)
 #define CS42L43_JACK_HEADSET (SND_JACK_MECHANICAL | SND_JACK_HEADSET)
 #define CS42L43_JACK_LINEOUT (SND_JACK_MECHANICAL | SND_JACK_LINEOUT)
@@ -867,7 +868,7 @@ static const struct cs42l43_jack_override_mode {
 		.hsdet_mode = CS42L43_JACK_3_POLE_SWITCHES,
 		.mic_ctrl = (0x3 << CS42L43_JACK_STEREO_CONFIG_SHIFT) |
 			    CS42L43_HS1_BIAS_EN_MASK | CS42L43_HS2_BIAS_EN_MASK,
-		.report = CS42L43_JACK_LINEIN,
+		.report = CS42L43_JACK_MICROPHONE,
 	},
 	[CS42L43_JACK_RAW_OPTICAL] = {
 		.hsdet_mode = CS42L43_JACK_3_POLE_SWITCHES,
-- 
2.53.0



