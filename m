Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA9230BF62;
	Tue, 19 Aug 2025 17:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624928; cv=none; b=SRRrpUsxnylLgCg10/030bdSm5rXB893zrOylgAiNsgSOVQeXPsDc8W2cFwbwkD4oiSJSksBnBCC2ZORWWJFFa2XogVdhpuPQTvNOGr40ft7CMAbPx/wVgiXUqnNWzET+X4DU+49tfsbLqxBAKFriv17/h4IUcMtEDkhsux4gs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624928; c=relaxed/simple;
	bh=33B4vKhlM8DX9M1JyJ/uF6QfPrZIMVU63QOqkyuahWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WY0q1uoAgo1D4hW268k2hxYTShTrcKNY1ZBD5sP3m1gRTK0iUwD/KWse31HeCFr9c8T4jCEEpNpd4eohK/cSbia0LZBs2n021hUmTJrbt1Ee6bscX+4AhvNZifXv/Q2xmCjjit3GWwQA34HUyG1Jn/qmHoaRU9Ie5wBK4JsyPJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jyv8bSou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jyv8bSou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B3EC4CEF4;
	Tue, 19 Aug 2025 17:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755624928;
	bh=33B4vKhlM8DX9M1JyJ/uF6QfPrZIMVU63QOqkyuahWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyv8bSouQGmmmpuZCuGu74xXpkThesxQ2Ki0c73equ5pe2n59Ncgrc1GWKM3oWt6Z
	 ANoJb8OexQxjBARqM4Ot1bqPc2mNA72wWCILQ3M+5LB8TGqQ3Cr3oB24gx0p9a/l+4
	 xf4poebjS8iU9/umAE1PGw5/TckA5fh53o0xFXGoc2Cy9cQo97GgjMhpZz/PYaCtGx
	 SDPyGktQ8PMrW1FBe0sVJcicgE3l9Su/Bq+kdhxxhukhXCgWiAsKT9Ujys0kjmj8S1
	 2VZs+rC+fNbtddjc9RH79Y/N9I1wQCYZg8l/1LpMH33/zE+G8ttlkq+rheTEVSdGTX
	 aBpGS0en4r9TQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com
Subject: [PATCH AUTOSEL 6.16] ASoC: rt721: fix FU33 Boost Volume control not working
Date: Tue, 19 Aug 2025 13:35:15 -0400
Message-ID: <20250819173521.1079913-5-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 633e391d45bda3fc848d26bee6bbe57ef2935713 ]

This patch fixed FU33 Boost Volume control not working.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250808055706.1110766-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Commit

### 1. Nature of the Fix
The commit fixes a broken user-facing audio control - "FU33 Boost Volume
control not working". This is a clear functional bug where a volume
control that should work is non-functional. The fix adds a single
register write during the jack preset initialization:

```c
rt_sdca_index_write(rt721->mbq_regmap, RT721_BOOST_CTRL,
    RT721_BST_4CH_TOP_GATING_CTRL1, 0x002a);
```

### 2. Impact on Users
- **User-visible bug**: The FU33 Boost Volume control is exposed to
  userspace through ALSA controls (as seen in line 712:
  `SOC_DOUBLE_R_EXT_TLV("FU33 Boost Volume",`). When this control
  doesn't work, users cannot adjust the boost gain for their microphone
  input, affecting audio recording quality.
- **Affects real hardware**: The RT721 is a real audio codec used in
  actual devices, meaning this bug affects real users.

### 3. Fix Characteristics
- **Minimal and contained**: The fix adds exactly 2 lines of code (one
  register write + one new #define)
- **Low risk**: The change only writes to a specific boost control
  register during initialization, following the same pattern as other
  register writes in the function
- **No architectural changes**: This is a simple hardware configuration
  fix, not a design change
- **Subsystem-confined**: The change is entirely within the RT721 codec
  driver

### 4. Related Context
Looking at the git history, there was a recent related fix
(`ff21a6ec0f27` - "fix boost gain calculation error") that specifically
addressed FU33 Boost Volume calculations. This current commit appears to
be completing that fix by ensuring the hardware is properly configured
to enable the boost functionality.

### 5. Code Safety
- The new register write follows the established pattern in
  `rt721_sdca_jack_preset()`
- It's placed logically with other control register configurations
- The register address (`RT721_BST_4CH_TOP_GATING_CTRL1`) and value
  (`0x002a`) appear to be enabling/configuring gating control for the
  boost circuit

### 6. Stable Tree Criteria Met
✓ **Fixes a real bug** - Non-functional volume control
✓ **Minimal change** - 2 lines added
✓ **No new features** - Only fixes existing functionality
✓ **Low regression risk** - Single register write in initialization
✓ **Hardware enablement** - Makes existing hardware work correctly
✓ **Clear user impact** - Broken audio control affects recording quality

The commit message could be more descriptive, but the fix itself is
exactly the type that should be backported to stable - it restores
broken functionality with minimal risk.

 sound/soc/codecs/rt721-sdca.c | 2 ++
 sound/soc/codecs/rt721-sdca.h | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/sound/soc/codecs/rt721-sdca.c b/sound/soc/codecs/rt721-sdca.c
index ba080957e933..98d8ebc6607f 100644
--- a/sound/soc/codecs/rt721-sdca.c
+++ b/sound/soc/codecs/rt721-sdca.c
@@ -278,6 +278,8 @@ static void rt721_sdca_jack_preset(struct rt721_sdca_priv *rt721)
 		RT721_ENT_FLOAT_CTL1, 0x4040);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_HDA_SDCA_FLOAT,
 		RT721_ENT_FLOAT_CTL4, 0x1201);
+	rt_sdca_index_write(rt721->mbq_regmap, RT721_BOOST_CTRL,
+		RT721_BST_4CH_TOP_GATING_CTRL1, 0x002a);
 	regmap_write(rt721->regmap, 0x2f58, 0x07);
 }
 
diff --git a/sound/soc/codecs/rt721-sdca.h b/sound/soc/codecs/rt721-sdca.h
index 0a82c107b19a..71fac9cd8739 100644
--- a/sound/soc/codecs/rt721-sdca.h
+++ b/sound/soc/codecs/rt721-sdca.h
@@ -56,6 +56,7 @@ struct rt721_sdca_dmic_kctrl_priv {
 #define RT721_CBJ_CTRL				0x0a
 #define RT721_CAP_PORT_CTRL			0x0c
 #define RT721_CLASD_AMP_CTRL			0x0d
+#define RT721_BOOST_CTRL			0x0f
 #define RT721_VENDOR_REG			0x20
 #define RT721_RC_CALIB_CTRL			0x40
 #define RT721_VENDOR_EQ_L			0x53
@@ -93,6 +94,9 @@ struct rt721_sdca_dmic_kctrl_priv {
 /* Index (NID:0dh) */
 #define RT721_CLASD_AMP_2CH_CAL			0x14
 
+/* Index (NID:0fh) */
+#define RT721_BST_4CH_TOP_GATING_CTRL1		0x05
+
 /* Index (NID:20h) */
 #define RT721_JD_PRODUCT_NUM			0x00
 #define RT721_ANALOG_BIAS_CTL3			0x04
-- 
2.50.1

