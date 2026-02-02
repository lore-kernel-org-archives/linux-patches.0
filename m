Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2A326FDAC;
	Mon,  2 Feb 2026 21:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068824; cv=none; b=GnFUDxI2hGsCAcyNQ5aRjDPzDdmvm5baww5pXn6NWyeuzufpwWadWPnOQ4y2Cqw9YegWBEwm8cqY1Mt0uLtD0/q4/jQ0oZ5QFJqa1FDUX62buIMGjgpqIrLFxvv8r44h6G+O7h6zGF9o0ey+/cvNpefPG8ofnPVw4XfWYQLq0ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068824; c=relaxed/simple;
	bh=+6iROAG5/9Xm34mS31BAd6t3JchO9wLqj3VtDUs1EWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rYjSmV8RXt5Ean9HM1iMMYCkhxHCIjDHYha8qpJqWFeC7DOSb/3W4SCWq9qx+ekEp8epvOB0/SO9o3y4xFoZhlq3hNBszSiZjlC9grSKIx9kvHAuBdvQajucGs+AzYyYmJuX17XmGMeXvBBcv1dwH9YSYO57yi7f2ymCimzl+sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjJ2IhtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjJ2IhtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CDFC19425;
	Mon,  2 Feb 2026 21:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068824;
	bh=+6iROAG5/9Xm34mS31BAd6t3JchO9wLqj3VtDUs1EWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjJ2IhtJf1GHcCQMfbXwAksuSLmnCOtrMqgaUuW7ckxK4M+t50H2OxVu/7QEAkKom
	 ZYV1rknkE/NqImbd9scT0yxS/MNkNBrd3Nb1hWKfIE7jQhKrMrtc1YA34ZW66Je6P/
	 a/gfLy42OPf3mvZss7s9frwSbZyLDnMfVQCIEecYvbfgjXn/OLQNA1QY1eIJzpddAN
	 G48rzC9w9hP1UWf+DsQvzkkZaXYWaJrrGbo/lMYTYbefnXL0NhR9kWStkKSgVo8zkB
	 homvsVTDj8i9hapQP5omFjCJvQtcAfPkx4Q7zxrRIqbv2GUWGmgA0BdE7eESMNFatt
	 3OwL/AznFC+7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	david.rhodes@cirrus.com,
	rf@opensource.cirrus.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: cs35l45: Corrects ASP_TX5 DAPM widget channel
Date: Mon,  2 Feb 2026 16:46:04 -0500
Message-ID: <20260202214643.212290-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>

[ Upstream commit 6dd0fdc908c02318c28ec2c0979661846ee0a9f7 ]

ASP_TX5 was incorrectly mapped to a channel value of 3 corrects,
the channel value of 4.

Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
Link: https://patch.msgid.link/20260115192523.1335742-2-rriveram@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of ASoC: cs35l45 DAPM Widget Channel Fix

### 1. COMMIT MESSAGE ANALYSIS

The commit message is straightforward: it corrects the ASP_TX5 DAPM
widget channel value from 3 to 4. The message explicitly states this is
a correction of an incorrect mapping. Key observations:
- Uses the word "Corrects" indicating this is a bug fix
- Has a "Reviewed-by:" tag from Charles Keepax (Cirrus Logic engineer)
- No Fixes: tag or Cc: stable tag (expected for commits under review)

### 2. CODE CHANGE ANALYSIS

The change is a single-character fix:
```c
- SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 3, CS35L45_ASP_ENABLES1,
  CS35L45_ASP_TX5_EN_SHIFT, 0),
+ SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 4, CS35L45_ASP_ENABLES1,
CS35L45_ASP_TX5_EN_SHIFT, 0),
```

Looking at the context, the third parameter in `SND_SOC_DAPM_AIF_OUT`
represents the channel number. The pattern in the code is clear:
- ASP_TX1: channel 0
- ASP_TX2: channel 1
- ASP_TX3: channel 2
- ASP_TX4: channel 3
- ASP_TX5: was 3 (duplicate!), should be 4

This is an obvious copy-paste error where ASP_TX5 was accidentally given
the same channel number (3) as ASP_TX4. Each TX widget should have a
unique, sequential channel number.

### 3. CLASSIFICATION

**Bug Fix**: This is clearly fixing an incorrect configuration value,
not adding a feature. The channel parameter is used by the ALSA/ASoC
framework to route audio data correctly. Having two TX widgets with the
same channel number would cause incorrect audio routing behavior.

**Type of Bug**: Data/configuration corruption - audio data intended for
channel 5 would be misrouted.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1 line
- **Files changed**: 1 file (sound/soc/codecs/cs35l45.c)
- **Complexity**: Trivially simple - changing a single integer constant
- **Risk**: Extremely low - this is correcting an obviously wrong value
  to an obviously correct value
- **Subsystem**: ASoC codec driver for Cirrus Logic CS35L45 (audio
  amplifier IC)

The fix cannot introduce any new bugs because:
1. It's correcting a clearly wrong value (duplicate channel number)
2. The correct value (4) follows the obvious sequential pattern
3. No logic changes, just a constant correction

### 5. USER IMPACT

The CS35L45 is an audio amplifier commonly used in:
- Laptops
- Smartphones
- Tablets
- Other mobile/embedded devices

Users with CS35L45 hardware who use ASP_TX5 would experience:
- Incorrect audio routing
- Audio data corruption or loss on channel 5
- Potentially broken audio capture/monitoring functionality

While this may not affect all users of the driver (only those using all
5 TX channels), those who do use TX5 would definitely hit this bug.

### 6. STABILITY INDICATORS

- **Reviewed-by**: Charles Keepax (Cirrus Logic kernel engineer) -
  indicates the fix was reviewed by a domain expert
- **Maintainer sign-off**: Mark Brown (ASoC maintainer) accepted the
  patch
- The fix is trivially correct by inspection

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The cs35l45 driver exists in stable kernels
- The fix applies to the same code structure that has existed since the
  driver was introduced

### 8. STABLE KERNEL CRITERIA EVALUATION

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Yes - sequential channel numbering is obvious |
| Fixes a real bug | ✅ Yes - duplicate channel causes audio routing
issues |
| Important issue | ✅ Moderate - affects audio functionality for
affected users |
| Small and contained | ✅ Yes - 1 line change |
| No new features | ✅ Correct - just fixes misconfiguration |
| No new APIs | ✅ Correct |

### CONCLUSION

This is an ideal stable backport candidate:
1. **Trivially simple**: Single character change (3 → 4)
2. **Obviously correct**: The sequential pattern makes the error and fix
   self-evident
3. **Real bug**: Duplicate channel numbers cause actual audio routing
   problems
4. **Zero risk**: Cannot introduce regressions - it's correcting an
   obvious typo
5. **Well-reviewed**: Has review from Cirrus Logic engineer and ASoC
   maintainer
6. **Self-contained**: No dependencies, applies cleanly

The fix is small, surgical, and meets all stable kernel criteria.

**YES**

 sound/soc/codecs/cs35l45.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l45.c b/sound/soc/codecs/cs35l45.c
index d4dcdf37bb709..9b1eff4e9bb71 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -455,7 +455,7 @@ static const struct snd_soc_dapm_widget cs35l45_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_OUT("ASP_TX2", NULL, 1, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX2_EN_SHIFT, 0),
 	SND_SOC_DAPM_AIF_OUT("ASP_TX3", NULL, 2, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX3_EN_SHIFT, 0),
 	SND_SOC_DAPM_AIF_OUT("ASP_TX4", NULL, 3, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX4_EN_SHIFT, 0),
-	SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 3, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX5_EN_SHIFT, 0),
+	SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 4, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX5_EN_SHIFT, 0),
 
 	SND_SOC_DAPM_MUX("ASP_TX1 Source", SND_SOC_NOPM, 0, 0, &cs35l45_asp_muxes[0]),
 	SND_SOC_DAPM_MUX("ASP_TX2 Source", SND_SOC_NOPM, 0, 0, &cs35l45_asp_muxes[1]),
-- 
2.51.0

