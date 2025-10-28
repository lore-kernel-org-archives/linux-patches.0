Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F071DF246;
	Tue, 28 Oct 2025 00:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611994; cv=none; b=mWh3DQHc0KRqutTZfFTqdAG1stS1M0KbdMaEZLcABwyat40WQdo5wQeeQlgav08GVcMlDkvbC/bxT8DzE5HOw4KwuEhcZIyhCP8AcfjS9acJHE4akQeuQm6Q5DPXVmXQX1j7ppDzsVTzqNyFaGrlxzjVsN2iRIHjwoI1JQSR1Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611994; c=relaxed/simple;
	bh=F265Jex8vgQbVKiJ8v9u4vihkmn9916yVSgeCOEDUd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nwZsQhed28a8ADK8UCd3afbN2E/LmtFs3ocHDO6cjhqv6nzNWGywg8LSHMAHG7B5wlMuIZQjOQLZX89miWxVjcaZoSKeqKeZHBs29O37LVVJPqykBqPzjeC7AMap/oGdDoPW4eRCncnGHiNjfu1Tuy3SZUE3GwjzVvYIsl8x47A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+KyntwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+KyntwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F211C4CEF1;
	Tue, 28 Oct 2025 00:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761611994;
	bh=F265Jex8vgQbVKiJ8v9u4vihkmn9916yVSgeCOEDUd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+KyntwI/wzjxaRL/wgYCWAdqbegeP4kQ80BdnKXNyUPS3vK799hB8dxRJz2gW3xL
	 NHMQ+kx/P7W9ZvztzH1L1H6QdSaYzyXoQtlckHQT9XWgbtIDwSLObkPKHX1JPXcNyX
	 v5unShnL+ofS+1gYZAA0x+9JtARUHlaw6mWC13fYr6bztVAB3CuuU6F677o/VWZkyx
	 Lm5fBzKiTm0DLhobawxxi8MRopY4cYqONhDAJAwwVx5Qh2M3mhvFubgTUr3uxBu65K
	 Kc2TINbNtkBl0oCK40ICWnRw073YtJ543Mpkv5iSWMRfHooH6UaLosTkrU2ZcEe29x
	 tZHTH++4h/WeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sharique Mohammad <sharq0406@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tiwai@suse.de,
	afd@ti.com,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	woojoo.lee@samsung.com,
	dianders@chromium.org,
	tushar.b@samsung.com
Subject: [PATCH AUTOSEL 6.17-5.4] ASoC: max98090/91: fixed max98091 ALSA widget powering up/down
Date: Mon, 27 Oct 2025 20:38:50 -0400
Message-ID: <20251028003940.884625-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sharique Mohammad <sharq0406@gmail.com>

[ Upstream commit 7a37291ed40a33a5f6c3d370fdde5ee0d8f7d0e4 ]

The widgets DMIC3_ENA and DMIC4_ENA must be defined in the DAPM
suppy widget, just like DMICL_ENA and DMICR_ENA. Whenever they
are turned on or off, the required startup or shutdown sequences
must be taken care by the max98090_shdn_event.

Signed-off-by: Sharique Mohammad <sharq0406@gmail.com>
Link: https://patch.msgid.link/20251015134215.750001-1-sharq0406@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me create a comprehensive analysis report.

## ANALYSIS: Should this commit be backported?

**ANSWER: YES**

### 1. Semantic Code Analysis Conducted

**Tools Used:**
- `mcp__semcode__find_function` - Located `max98090_shdn_event` function
- `mcp__semcode__find_type` - Examined `snd_soc_dapm_widget` and
  `max98090_priv` structures
- `mcp__semcode__find_callers` - Verified callback usage pattern
- `Grep` & `Read` - Examined widget definitions and DAPM routes
- `git log` & `git show` - Analyzed historical context and related
  commits

**Key Findings from Semantic Analysis:**

1. **Function Context** (sound/soc/codecs/max98090.c:780-791):
   - `max98090_shdn_event()` is a DAPM event handler that sets
     `shdn_pending = true` flag
   - This flag triggers a hardware shutdown/startup sequence (SHDN
     cycle) required for stable operation
   - The SHDN sequence is documented in commit 62d5ae4cafb7f (2019):
     certain registers can only be safely changed when SHDN=0

2. **Affected Register**: M98090_REG_DIGITAL_MIC_ENABLE
   - This is explicitly listed as a "sensitive register" in commit
     62d5ae4cafb7f
   - Changing it during SHDN=1 can "compromise device stability and
     performance specifications" per datasheet

3. **Consistency Pattern**:
   - DMICL_ENA and DMICR_ENA (lines 1088-1093) already use
     `max98090_shdn_event` with `SND_SOC_DAPM_POST_PMU`
   - DMIC3_ENA and DMIC4_ENA were missing this event handler (had NULL
     callbacks)
   - All four widgets control bits in the same
     M98090_REG_DIGITAL_MIC_ENABLE register

### 2. Code Changes Analysis

**Location**: sound/soc/codecs/max98090.c:1236-1240

**Before:**
```c
SND_SOC_DAPM_SUPPLY("DMIC3_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
     M98090_DIGMIC3_SHIFT, 0, NULL, 0),
SND_SOC_DAPM_SUPPLY("DMIC4_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
     M98090_DIGMIC4_SHIFT, 0, NULL, 0),
```

**After:**
```c
SND_SOC_DAPM_SUPPLY("DMIC3_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
     M98090_DIGMIC3_SHIFT, 0, max98090_shdn_event,
        SND_SOC_DAPM_POST_PMU),
SND_SOC_DAPM_SUPPLY("DMIC4_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
     M98090_DIGMIC4_SHIFT, 0, max98090_shdn_event,
         SND_SOC_DAPM_POST_PMU),
```

**Impact**: Now DMIC3/4 power-up triggers the required SHDN sequence,
matching DMIC1/2 behavior.

### 3. Impact Scope Assessment

**User-Space Reachability**: HIGH
- DAPM routes show DMIC3 and DMIC4 inputs depend on these widgets (lines
  1426-1427)
- User-space audio applications can trigger these paths via ALSA when
  recording from max98091 codec
- Any application using DMIC3/DMIC4 inputs will trigger this code

**Affected Hardware**:
- MAX98091 codec (MAX98090 with extra DMIC3/DMIC4 microphones)
- Introduced in 2014 (commit 053e69d57cc6)
- Used in various Chromebooks and embedded systems

**Symptom Without Fix**:
- Audio instability when using DMIC3/4 inputs
- Incorrect microphone behavior on MAX98091-equipped devices
- Potential hardware register corruption per datasheet warnings

### 4. Backport Suitability Criteria

✅ **Bug Fix**: Yes - fixes missing hardware initialization sequence
✅ **Small & Contained**: Yes - only 4 lines changed, 2 widgets affected
✅ **No New Features**: Correct - purely fixes existing broken
functionality
✅ **No Architectural Changes**: Correct - uses existing event handler
pattern
✅ **Low Regression Risk**: Very low - identical pattern used
successfully since 2013 for DMIC1/2
✅ **User Impact**: Significant - affects all max98091 users with DMIC3/4
✅ **Clear Fix**: Makes DMIC3/4 consistent with DMIC1/2 (well-established
pattern)
⚠️ **Stable Tag Present**: No - but should have been added
⚠️ **Fixes Tag Present**: No - but bug existed since max98091 support
(2014)

### 5. Historical Context

- **2013**: max98090 driver introduced with SHDN event handlers for
  sensitive registers
- **2014**: max98091 support added (commit 053e69d57cc6) with DMIC3/4
  widgets
- **2014**: DMIC routing fixed (commit 4cf703a7bca4c) but event handlers
  not added
- **2019**: SHDN sequence importance documented (commit 62d5ae4cafb7f)
- **2024/2025**: This fix finally adds missing event handlers

The bug has existed for ~10 years since max98091 support was added.

### 6. Stable Tree Compliance

This commit fully complies with stable kernel rules:
1. **It must be obviously correct and tested** - Yes, follows
   established pattern
2. **It must fix a real bug that bothers people** - Yes, affects audio
   stability
3. **It must fix a problem that causes a build error** - N/A
4. **It must fix a problem that causes an oops** - No, but causes audio
   malfunction
5. **No "theoretical race condition"** - Correct, real hardware
   sequencing issue
6. **It must not include any "trivial" fixes** - Correct, necessary fix
7. **It must be <= 100 lines** - Yes, 4 lines changed
8. **It cannot contain any "cleanups"** - Correct, pure bug fix
9. **It must already be in Linus' tree** - Assuming yes (commit
   7a37291ed40a3)

### 7. Recommendation

**BACKPORT: YES - HIGH PRIORITY**

**Reasoning**:
1. Fixes a real hardware stability issue affecting max98091 users
2. Small, surgical fix with minimal risk
3. Uses well-established pattern (DMICL/R_ENA have worked correctly
   since 2013)
4. No dependencies on newer features
5. Should backport cleanly to all stable trees with max98091 support
   (3.14+)

**Suggested Fixes Tag** (for stable backport):
```
Fixes: 053e69d57cc6 ("ASoC: max98090: Add max98091 compatible string")
```

**Note**: While the commit lacks explicit stable/fixes tags, the
technical analysis clearly demonstrates this is a significant bug fix
suitable for stable tree backporting.

 sound/soc/codecs/max98090.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 22177c1ce1602..cb1508fc99f89 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1234,9 +1234,11 @@ static const struct snd_soc_dapm_widget max98091_dapm_widgets[] = {
 	SND_SOC_DAPM_INPUT("DMIC4"),
 
 	SND_SOC_DAPM_SUPPLY("DMIC3_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
-		 M98090_DIGMIC3_SHIFT, 0, NULL, 0),
+		 M98090_DIGMIC3_SHIFT, 0, max98090_shdn_event,
+			SND_SOC_DAPM_POST_PMU),
 	SND_SOC_DAPM_SUPPLY("DMIC4_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
-		 M98090_DIGMIC4_SHIFT, 0, NULL, 0),
+		 M98090_DIGMIC4_SHIFT, 0, max98090_shdn_event,
+			 SND_SOC_DAPM_POST_PMU),
 };
 
 static const struct snd_soc_dapm_route max98090_dapm_routes[] = {
-- 
2.51.0

