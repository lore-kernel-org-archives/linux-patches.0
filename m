Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461C23043C2;
	Tue, 19 Aug 2025 17:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624929; cv=none; b=hF3yWjYUmm++ePvt5Ph25FNQlnGWjHr5eqkJtVyLH5BNpWyghI6fO+hr1eI9iDtUYY+7/08R4+kENOCvHxvhOpzW/oUA5r7lfjCTE6d+RdxLea0vUw4E21LUSJdHeSq5zPRdWuzjRQ+Hzr6IAHmN1+hbLtZkawChwCEy0gDV+PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624929; c=relaxed/simple;
	bh=oj7f5eOPJ31NSJwfBglz/BbyEzWWrcLkU+lSYYNwoa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMT7Htg/si3nYDVbTzMDrAiAfdgAz6uAGwPXZR5mqkRbLwncPKNJJA/mIMM+7MiRT0CQSyCrf+hE08jxyUgWTFQSbw3jeG8aCFABWTV3NG/T/ogVBSe+DUlKNraviXcvV5Lx2SvBU3PxCrRe3HcYNux+IHwBTHzSAk30NRRjN50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tAFlFp02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tAFlFp02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C95C16AAE;
	Tue, 19 Aug 2025 17:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755624928;
	bh=oj7f5eOPJ31NSJwfBglz/BbyEzWWrcLkU+lSYYNwoa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAFlFp02Jd9jmfQr8KHEEt/i4qz0+k9iWWNAu/V90vHSEfxX7WiPMiDH94ogFx4hN
	 xx4K9HwDbQ2sl2OZUjOv/en+DqxgDPxTjxyQjq2nPMhn3Rl+fIiXNn9uUXULvdBIH+
	 m3irhNYoiFvs5W6Ik8xFzQkSWcTo+JI+lb77a15FInuCoxddZzPZb2Xf0NLmnYhIYU
	 EWZSdoLeKklCX3UTe7vrdHdFORbOg9DHJEW85HeIx8sWGyDQugGWGbiu7JnOFUBcuA
	 PTbfenz7zRMBWbsaH8V/RB5cfPhxCkkCOq8At3oTsGCNbm1165PROCjvupL0n3ukss
	 XHVoL+rsJPmVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com
Subject: [PATCH AUTOSEL 6.16] ASoC: rt1320: fix random cycle mute issue
Date: Tue, 19 Aug 2025 13:35:16 -0400
Message-ID: <20250819173521.1079913-6-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250819173521.1079913-1-sashal@kernel.org>
References: <20250819173521.1079913-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.1
Content-Transfer-Encoding: 8bit

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit f48d7a1b0bf11d16d8c9f77a5b9c80a82272f625 ]

This patch fixed the random cycle mute issue that occurs during long-time playback.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250807092432.997989-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the surrounding code context,
here is my assessment:

**Backport Status: YES**

## Extensive Explanation:

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **Clear Bug Fix for User-Impacting Issue**
The commit explicitly fixes a "random cycle mute issue that occurs
during long-time playback." This is a real bug that affects users during
normal audio playback operations. Audio randomly muting during playback
is a significant quality issue that degrades user experience.

### 2. **Minimal and Contained Changes**
The code changes are extremely minimal and low-risk:
- In `rt1320_blind_write[]`: Adds one new register write `{ 0xd478, 0xff
  }`
- In `rt1320_vc_blind_write[]`: Changes existing register value from
  `0x64` to `0xff` for register `0xd478`

These are simple register value modifications in initialization
sequences ("blind writes") that are executed during device setup. The
changes only affect register `0xd478` with a value change to `0xff`.

### 3. **Hardware-Specific Fix with No Architectural Changes**
This is a hardware-specific fix for the Realtek RT1320 audio codec. The
changes are confined to:
- Hardware initialization sequences
- Only affects RT1320 hardware users
- No changes to core kernel subsystems or APIs
- No structural changes to the driver itself

### 4. **Low Risk of Regression**
The changes pose minimal regression risk because:
- They only modify initialization register values for specific hardware
- The register `0xd478` appears to be related to audio path
  configuration
- Setting it to `0xff` (all bits set) likely enables or properly
  configures audio paths to prevent muting
- These "blind write" sequences are vendor-provided initialization
  values

### 5. **Recent Driver with Active Bug Fixes**
Looking at the commit history, the RT1320 driver is relatively new
(added in 2024) and has had several bug fixes:
- "fix speaker noise when volume bar is 100%"
- "fix the range of patch code address"
- This mute issue fix

This indicates the driver is still stabilizing, and important fixes like
this should be backported to ensure stable kernel users get a properly
functioning driver.

### 6. **Clear Problem Description**
The commit message clearly describes the problem (random cycle mute
during long playback) and the solution is straightforward (adjust
register initialization values). This makes it easy for stable
maintainers to understand the fix's purpose and validate its
correctness.

The commit meets all the stable kernel criteria: it fixes a real bug, is
small and contained, has minimal risk, and improves hardware
functionality without introducing new features or architectural changes.

 sound/soc/codecs/rt1320-sdw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index 015cc710e6dc..d6d54168cccd 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -109,6 +109,7 @@ static const struct reg_sequence rt1320_blind_write[] = {
 	{ 0x0000d540, 0x01 },
 	{ 0xd172, 0x2a },
 	{ 0xc5d6, 0x01 },
+	{ 0xd478, 0xff },
 };
 
 static const struct reg_sequence rt1320_vc_blind_write[] = {
@@ -159,7 +160,7 @@ static const struct reg_sequence rt1320_vc_blind_write[] = {
 	{ 0xd471, 0x3a },
 	{ 0xd474, 0x11 },
 	{ 0xd475, 0x32 },
-	{ 0xd478, 0x64 },
+	{ 0xd478, 0xff },
 	{ 0xd479, 0x20 },
 	{ 0xd47a, 0x10 },
 	{ 0xd47c, 0xff },
-- 
2.50.1

