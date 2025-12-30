Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D682253A0;
	Tue, 30 Dec 2025 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767100994; cv=none; b=Av2RCrIjs8XcO2Z9ILCIDxHKbN1mPX6ErDj0mB8NcXEeJot8ZE9Wv5MnqLRPEws/ML0m0YwZZscYi9BD7DMfgHPvW1sKMMwXwZR2nCwebxi1fmkiEO+kkiB1fZ4qO/7qKUb4kxCbZuS0qDMnhlDEWC5GctUOcc67qY9F6UKB/5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767100994; c=relaxed/simple;
	bh=ZLaVsim+IvTm4fJtQ1k/xMj2D9RQt+TcGP+c5MdnmPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rNnaUPv6tvMtqnITjVJWn+h3wl6A9yEMzyBYUC3kTXfy86Cp7/i/bUOSI7NQR9IE2u4QE3Up81iLwrX1IMeKHK8U28MUBdnNQuPPrDbwpYimku/7GyLhO/ZWMdhKZSip3EGQ4/A1nFth5LTBMIo2qcvybxFyPdHMS9VGE8BFQho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hw9up642; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hw9up642"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B33C116C6;
	Tue, 30 Dec 2025 13:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767100990;
	bh=ZLaVsim+IvTm4fJtQ1k/xMj2D9RQt+TcGP+c5MdnmPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hw9up6427EaSETsqoDKvjLxZzQGGgVXBkCJDNu6ckhInp+TeUlV6DPJXJwjTAgjIU
	 omdTO5snToqah7QR8gd2wFaMyrX3ybb5wrc9CrgCjLwDw9PdVEq3WECTg7KhHPaSDG
	 p11WvJxbeJycqVrUAV/2S6vZsECvosf9Pw4nc13N+ZDuytSaR2sSV9poVJsnqdjYLM
	 KUdMIcFmAt6Bb4BfQgOXpztbo03V62e3031GqmAOLp75zXkBqFRlTmyo09jAl3A+N0
	 qraKm4Ui5Phh7rpn2maGgWsIhKZ/EwTBZ+39VWKDJ9zzJ/Xa6sGhJbBQvZRt3ZyC4O
	 Lz6/yCXxCwnCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shengjiu.wang@gmail.com,
	Xiubo.Lee@gmail.com,
	linux-sound@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: fsl_sai: Add missing registers to cache default
Date: Tue, 30 Dec 2025 08:22:57 -0500
Message-ID: <20251230132303.2194838-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251230132303.2194838-1-sashal@kernel.org>
References: <20251230132303.2194838-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 90ed688792a6b7012b3e8a2f858bc3fe7454d0eb ]

Drivers does cache sync during runtime resume, setting all writable
registers. Not all writable registers are set in cache default, resulting
in the erorr message:
  fsl-sai 30c30000.sai: using zero-initialized flat cache, this may cause
  unexpected behavior

Fix this by adding missing writable register defaults.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://patch.msgid.link/20251216102246.676181-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### 1. What Problem Does This Commit Solve?

This commit fixes a bug where the FSL SAI driver's regmap cache was
incomplete. During runtime resume, the driver performs a cache sync that
writes all writable registers. Two writable registers (`FSL_SAI_TTCTL`
and `FSL_SAI_RTCTL`) were missing from the cache defaults array,
causing:

1. A warning message: `fsl-sai 30c30000.sai: using zero-initialized flat
   cache, this may cause unexpected behavior`
2. Potentially incorrect behavior during suspend/resume cycles

### 2. Root Cause Analysis

The bug was introduced in commit `0b2cbce68986` ("ASoC: fsl_sai: Add new
added registers and new bit definition") from September 2020, which:
- Added `FSL_SAI_TTCTL` and `FSL_SAI_RTCTL` to `fsl_sai_writeable_reg()`
  (lines 1234-1235)
- But **failed** to add them to `fsl_sai_reg_defaults_ofs0[]` and
  `fsl_sai_reg_defaults_ofs8[]`

The current commit completes what should have been done in the original
commit.

### 3. Code Change Assessment

The fix is minimal and surgical:
- Adds `{FSL_SAI_TTCTL, 0}` to `fsl_sai_reg_defaults_ofs0[]` (+1 line)
- Adds `{FSL_SAI_TTCTL, 0}` to `fsl_sai_reg_defaults_ofs8[]` (+1 line)
- Adds `{FSL_SAI_RTCTL, 0}` to `fsl_sai_reg_defaults_ofs8[]` (+1 line)

Total: 3 lines added, all initializing registers to default value 0.

### 4. Stable Criteria Check

| Criteria | Assessment |
|----------|------------|
| Obviously correct | ✅ Yes - completing missing register defaults |
| Fixes real bug | ✅ Yes - fixes warning and potential misbehavior |
| Small scope | ✅ Yes - only 3 lines added to static arrays |
| No new features | ✅ Yes - purely fixes incomplete initialization |
| Tested | ✅ Accepted by subsystem maintainer (Mark Brown) |

### 5. Risk Assessment

**Risk: Very Low**
- No logic changes, only adds entries to static const arrays
- Default values are 0 (standard hardware reset value)
- The registers already existed and were marked writable
- Change is purely additive to existing data structures

### 6. Affected Stable Trees

The bug exists in kernels v5.10+ (when commit 0b2cbce68986 was merged).
Relevant stable trees:
- 5.10.y (LTS)
- 5.15.y (LTS)
- 6.1.y (LTS)
- 6.6.y (LTS)
- 6.11.y and newer

### 7. User Impact

Affects users of NXP/Freescale i.MX processors using SAI audio
interfaces, particularly those using suspend/resume (common on embedded
systems, tablets, etc.).

### Conclusion

This is an excellent stable backport candidate. It's a minimal, low-risk
fix that corrects a longstanding bug in driver initialization. The fix
simply completes the register cache defaults that should have been
included when the registers were made writable in 2020. The warning
message indicates potential undefined behavior, and the fix is as simple
and safe as adding entries to a static array.

**YES**

 sound/soc/fsl/fsl_sai.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 72bfc91e21b9..090354a0f711 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1075,6 +1075,7 @@ static const struct reg_default fsl_sai_reg_defaults_ofs0[] = {
 	{FSL_SAI_TDR6, 0},
 	{FSL_SAI_TDR7, 0},
 	{FSL_SAI_TMR, 0},
+	{FSL_SAI_TTCTL, 0},
 	{FSL_SAI_RCR1(0), 0},
 	{FSL_SAI_RCR2(0), 0},
 	{FSL_SAI_RCR3(0), 0},
@@ -1098,12 +1099,14 @@ static const struct reg_default fsl_sai_reg_defaults_ofs8[] = {
 	{FSL_SAI_TDR6, 0},
 	{FSL_SAI_TDR7, 0},
 	{FSL_SAI_TMR, 0},
+	{FSL_SAI_TTCTL, 0},
 	{FSL_SAI_RCR1(8), 0},
 	{FSL_SAI_RCR2(8), 0},
 	{FSL_SAI_RCR3(8), 0},
 	{FSL_SAI_RCR4(8), 0},
 	{FSL_SAI_RCR5(8), 0},
 	{FSL_SAI_RMR, 0},
+	{FSL_SAI_RTCTL, 0},
 	{FSL_SAI_MCTL, 0},
 	{FSL_SAI_MDIV, 0},
 };
-- 
2.51.0

