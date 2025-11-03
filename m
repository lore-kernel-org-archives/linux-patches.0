Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE3331BCAA;
	Mon,  3 Nov 2025 18:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762192988; cv=none; b=TEctKro+OklS+J6Nx0ggvQuka04OkEGJjwgMUH03ctbSYR+3yzAuHRcoc4m7768k6Yf5KB9D9N8YHV1XxEJeGVp2n0Bqg5tI8zjpaZQT5V/iSlfO6lzttCeNKI06X/m0bx0wGDgclmX/2RzEKEVybQeW4IphcCpeysKUXJqTkmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762192988; c=relaxed/simple;
	bh=mH6RrjzoBq7Te0HvW0AkY7mLUqDTTD1o9kx8+e5Tl7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bayu7Jm8up7z0buZlZCmicNtDymlOp0aDNt7ukE114YoxFBY/n8p0NHrLKcTOWl5u3S3Whk5ROFDN5RkbC3gsr3Y8gm5Xzh3FhPvozXN8IoIskhAMJuajE9JJaSxzIyRRWmKBLyBBILiayQX+1KwFMPWUzI943cbyHOlUOrHkvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=prbeFDxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="prbeFDxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D96C113D0;
	Mon,  3 Nov 2025 18:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762192988;
	bh=mH6RrjzoBq7Te0HvW0AkY7mLUqDTTD1o9kx8+e5Tl7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prbeFDxCr2URg6EgWD9MnMmdS8BXkJ49ECO6P+HzUSJEa2tcmjOGPxWnyhW5s/Nxn
	 TX10tdQpV4VDNorWNIvZhzNC9nAyu6IfI5+DS7gGVIP3lyeXslPg8OT85QUne+dfyb
	 cnI8m8gqi3CJ582lp3ai8aOwQXbHRcNqYx6VAdMGmp2iAMUW0iodm0qyrUE//oBrp/
	 lMtp126K/7gmhkVqpFsDoabyy9Csesb+NMaJlJLmdXWFHaJQxY9Wzntxtbz2laqs8L
	 +KvtCETBavpSwnyqa/jY0DHvHzxNmyEbn9xPVnoDnoUi66s32e9VM0z4D4CldycEPe
	 Y42y9xH4LMQyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com
Subject: [PATCH AUTOSEL 6.17] ASoC: rt721: fix prepare clock stop failed
Date: Mon,  3 Nov 2025 13:02:24 -0500
Message-ID: <20251103180246.4097432-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180246.4097432-1-sashal@kernel.org>
References: <20251103180246.4097432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit d914ec6f07548f7c13a231a4f526e043e736e82e ]

This patch adds settings to prevent the 'prepare clock stop failed' error.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20251027103333.38353-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Analysis Result

**Answer: YES**

### Analysis Summary

I performed comprehensive semantic code analysis of this commit using
multiple tools. Here are my findings:

### 1. Semantic Code Analysis Tools Used

- **mcp__semcode__find_function**: Located the modified function
  `rt721_sdca_jack_preset()` and `rt721_sdca_jack_init()`
- **mcp__semcode__find_callers**: Traced the call graph to understand
  impact scope
- **mcp__semcode__diff_functions**: Analyzed the semantic nature of
  changes
- **git history analysis**: Investigated driver history and related
  commits

### 2. Code Change Analysis

**Modified Function**: `rt721_sdca_jack_preset()`
(sound/soc/codecs/rt721-sdca.c:211-284)

**Changes Made**:
```c
+ regmap_write(rt721->regmap, 0x2f51, 0x00);
+ rt_sdca_index_write(rt721->mbq_regmap, RT721_HDA_SDCA_FLOAT,
+     RT721_MISC_CTL, 0x0004);
```

The commit adds exactly **2 register writes** at the end of the hardware
preset initialization function, plus 1 new constant definition
(RT721_MISC_CTL = 0x07) in the header file.

### 3. Impact Scope Assessment

**Call Chain Analysis**:
```
SoundWire driver ops callback
  └─> rt721_sdca_update_status()      [1 caller, no other callers found]
       └─> rt721_sdca_io_init()        [1 caller]
            └─> rt721_sdca_jack_preset()  [1 caller - modified function]
```

**Impact Scope**:
- **Very Limited**: Only affects RT721 SDCA codec hardware
- **Initialization path**: Changes occur during device
  initialization/preset configuration
- **Not in critical data path**: This is setup code, not runtime audio
  processing
- **User exposure**: Only users with RT721 hardware are affected

### 4. Root Cause Analysis

Using grep analysis of the SoundWire subsystem, I found the error
message "prepare clock stop failed" originates from:
- `drivers/soundwire/qcom.c:1742`
- `drivers/soundwire/amd_manager.c:1099`
- `drivers/soundwire/cadence_master.c:1733`

The error occurs when `sdw_bus_prep_clk_stop()` fails during **power
management operations** (suspend/clock stop sequence). The fix adds
missing vendor-specific register initialization to ensure the codec
properly prepares for clock stop.

### 5. Driver Context

- **Driver age**: RT721 driver was added in **commit 86ce355c1f9ab on
  2024-10-01**
- **First appeared**: Kernel **v6.13-rc1**
- **Present in tags**: v6.13, v6.13-rc1, p-6.15, p-6.16, p-6.17
- **Backport status**: Already backported as commit 20e9900b3c3fe
  (references upstream d914ec6f07548)

### 6. Backport Suitability Evaluation

✅ **POSITIVE INDICATORS**:
1. **Fixes real bug**: Prevents "prepare clock stop failed" errors
   affecting power management
2. **Small, contained change**: Only 2 register writes added
3. **Low regression risk**: Hardware-specific initialization, doesn't
   change logic flow
4. **Hardware errata style fix**: Vendor-recommended settings for proper
   operation
5. **Stable tree compliant**: Bug fix, not new feature, no architectural
   changes
6. **Already being backported**: Evidence shows autosel has picked this
   up

❌ **LIMITATIONS**:
1. **New driver**: Only relevant for kernels v6.13+ (where rt721 driver
   exists)
2. **No explicit stable tag**: Missing "Cc: stable@vger.kernel.org" in
   original commit
3. **Limited hardware exposure**: Only affects RT721 codec users
   (relatively new hardware)

### 7. Change Type Classification

Using semantic diff analysis, this is classified as:
- ✅ **Bug fix**: YES - fixes initialization failure
- ❌ **New feature**: NO - just completes existing initialization
- ❌ **Architectural change**: NO - adds register writes to existing
  function
- ❌ **Performance optimization**: NO - correctness fix

### 8. Risk Assessment

**Risk Level**: **LOW**

- Contained to single driver (rt721)
- Hardware-specific register values (unlikely to affect other systems)
- Added at end of preset function (won't disrupt existing init sequence)
- No behavior change to existing functionality, only adds missing setup

### Recommendation

**YES - Backport to stable kernels 6.13+** where the RT721 driver is
present. This is a legitimate bug fix that:
- Resolves power management failures (clock stop preparation)
- Has minimal regression risk
- Follows stable kernel rules (obvious, small bug fix)
- Improves user experience for RT721 hardware owners

For stable kernels **older than 6.13**, this commit is **NOT
APPLICABLE** as the driver doesn't exist.

 sound/soc/codecs/rt721-sdca.c | 4 ++++
 sound/soc/codecs/rt721-sdca.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/sound/soc/codecs/rt721-sdca.c b/sound/soc/codecs/rt721-sdca.c
index a4bd29d7220b8..5f7b505d54147 100644
--- a/sound/soc/codecs/rt721-sdca.c
+++ b/sound/soc/codecs/rt721-sdca.c
@@ -281,6 +281,10 @@ static void rt721_sdca_jack_preset(struct rt721_sdca_priv *rt721)
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_BOOST_CTRL,
 		RT721_BST_4CH_TOP_GATING_CTRL1, 0x002a);
 	regmap_write(rt721->regmap, 0x2f58, 0x07);
+
+	regmap_write(rt721->regmap, 0x2f51, 0x00);
+	rt_sdca_index_write(rt721->mbq_regmap, RT721_HDA_SDCA_FLOAT,
+		RT721_MISC_CTL, 0x0004);
 }
 
 static void rt721_sdca_jack_init(struct rt721_sdca_priv *rt721)
diff --git a/sound/soc/codecs/rt721-sdca.h b/sound/soc/codecs/rt721-sdca.h
index 71fac9cd87394..24ce188562baf 100644
--- a/sound/soc/codecs/rt721-sdca.h
+++ b/sound/soc/codecs/rt721-sdca.h
@@ -137,6 +137,7 @@ struct rt721_sdca_dmic_kctrl_priv {
 #define RT721_HDA_LEGACY_UAJ_CTL		0x02
 #define RT721_HDA_LEGACY_CTL1			0x05
 #define RT721_HDA_LEGACY_RESET_CTL		0x06
+#define RT721_MISC_CTL				0x07
 #define RT721_XU_REL_CTRL			0x0c
 #define RT721_GE_REL_CTRL1			0x0d
 #define RT721_HDA_LEGACY_GPIO_WAKE_EN_CTL	0x0e
-- 
2.51.0

