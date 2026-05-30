Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9AB3191D0;
	Sat, 30 May 2026 18:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164236; cv=none; b=gKzAhbkOTPQ3QAuaQ+RTiG0sYmEPFmLuBR27/Qhuy1RKl5Wn4OBYjLSHEJMZOO526tMCkTgE357Y7JvIfKx6T9V+9dfkD60dAOn9RdAruLPMctTrufY99mBFmhThz7LKDLyHsM8ktZIF8e41vqdE4gbANq0Kd/h/e4l6GAyQmqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164236; c=relaxed/simple;
	bh=hvWr3AESKeqXc9WJpkUtG/tyTT926mF4EXCOFaK8ONk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMHmQ4EtvFLZw1jmxRJH82dIWLlWhPzGzo7T4ud6Ildc3rTBDRgNchnuXPja/MZ0vOor3K0nIyuXCSDFfz9mRY83O07tSZZfihyvsolBTssyrUSmEbrRb//EM6KYpGHPg+PRPQ/7Q8w315E2+TZZE7o4CPOwX350UFA5tYvLGbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skqa1WtY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skqa1WtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1601F00893;
	Sat, 30 May 2026 18:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164235;
	bh=VRYk8rW6oveD88Hor8d1SWvBvjHAANizMcazCU9fWvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skqa1WtYM7t1h4s4DUAHIuATfay96ZlcjZgVJTkIHRBKz5zaoo4dwRa78jdnTFly7
	 vLFmI0l1EkJvMkhaAdUQB4BEHSx6ZEZd0hydE20z3SYQoQLlh3tEihAJvSTAAR1EIm
	 fUwRqk/gceNwKHwV0NhX4NWtg9BUOVRJ9peUvNlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 465/776] ASoC: fsl_easrc: Fix value type in fsl_easrc_iec958_get_bits()
Date: Sat, 30 May 2026 18:02:59 +0200
Message-ID: <20260530160252.372727607@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit aa21fe4a81458cf469c2615b08cbde5997dde25a ]

The value type of controls "Context 0 IEC958 Bits Per Sample" should be
integer, not enumerated, the issue is found by the mixer-test.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-11-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index c144f99927705..5c83642f29826 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -73,7 +73,7 @@ static int fsl_easrc_iec958_get_bits(struct snd_kcontrol *kcontrol,
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
 
-	ucontrol->value.enumerated.item[0] = easrc_priv->bps_iec958[mc->regbase];
+	ucontrol->value.integer.value[0] = easrc_priv->bps_iec958[mc->regbase];
 
 	return 0;
 }
-- 
2.53.0



