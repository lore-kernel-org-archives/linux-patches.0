Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D2022DA18;
	Tue,  6 May 2025 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567419; cv=none; b=WAudcWQ/j8g2E57tuWVOQXk01kOp4teNkHkx6hLdggmvQeXLxEQrTsUyBSR74TT1rXjkr9I6V5RZYJj4gPjMiWJbXYvJDxXbAeWjFJ/wD43D5crqEPATACIxySrZLGiSR3fHoZlvmQnfXw9Eb4poTcOnGM+i0/6KNAkW6FPTG34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567419; c=relaxed/simple;
	bh=ez9u/BuWJEg0RHfSW99LzmyCIqgTW3VTc2VfAMJgvqU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J92SERAgcqxYnfYWZkw+RnUGjAPw9fwdiYVc83Wk5olmLlf0Kft0r4fPQLxDFe+cHGc8UELQMzPhbHcifzKXfo0U2Sy+wgvKBwDh5oIAz8CcSTHyvXchGSuwSRvQx8PzayDi4TvlHmFJFB4UejwHsxuE35ZvNzdN2UUJ0AVgXds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgaYUqw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgaYUqw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FFCC4CEEF;
	Tue,  6 May 2025 21:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567419;
	bh=ez9u/BuWJEg0RHfSW99LzmyCIqgTW3VTc2VfAMJgvqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgaYUqw+L6QXbv3FiqKa6QFyJLt5gR/zdsqhCdhrQ5NmU/JzlLWdgLy3m9In6lENP
	 AOPub9MmUeBlDqzmA9HuvFYefY2WMhRvH90NrgKd+91gBhb7ahTe3BAyu+rNC0e1ZF
	 HOK7CHYqN2+VWTyOPx9cy/e6gV8PhQUwWaUfoB5aW0Ck3lWPlXUWAA0ENObqOMOUcs
	 WfEIRIeR6GYZdY/pnDvd/H8hd9SgBodZR8wPIVS0m/tTRKLo1ruLSyhrpYyWhTLVk2
	 c3WP/LFz+ikGOHXcakSx8lQKe/FzYo2xRHdFHUkpoPUgqngge5ZlK39ZVeRwaAaZ5i
	 DoHTznVwPztuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	david.rhodes@cirrus.com,
	rf@opensource.cirrus.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 04/12] ASoC: cs42l43: Disable headphone clamps during type detection
Date: Tue,  6 May 2025 17:36:39 -0400
Message-Id: <20250506213647.2983356-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213647.2983356-1-sashal@kernel.org>
References: <20250506213647.2983356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 70ad2e6bd180f94be030aef56e59693e36d945f3 ]

The headphone clamps cause fairly loud pops during type detect
because they sink current from the detection process itself. Disable
the clamps whilst the type detect runs, to improve the detection
pop performance.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250423090944.1504538-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index 0b8e88b19888e..6d8455c1bee6d 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -642,6 +642,10 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 
 	reinit_completion(&priv->type_detect);
 
+	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CLAMP_CTRL,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK);
+
 	cs42l43_start_hs_bias(priv, true);
 	regmap_update_bits(cs42l43->regmap, CS42L43_HS2,
 			   CS42L43_HSDET_MODE_MASK, 0x3 << CS42L43_HSDET_MODE_SHIFT);
@@ -653,6 +657,9 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 			   CS42L43_HSDET_MODE_MASK, 0x2 << CS42L43_HSDET_MODE_SHIFT);
 	cs42l43_stop_hs_bias(priv);
 
+	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CLAMP_CTRL,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK, 0);
+
 	if (!time_left)
 		return -ETIMEDOUT;
 
-- 
2.39.5

