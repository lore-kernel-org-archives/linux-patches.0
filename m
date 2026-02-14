Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CAA3EBF2C;
	Sat, 14 Feb 2026 01:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030971; cv=none; b=CbLTVP0MHWZGLvkThxgme0Fzm7vCDBgJFwXb5306sYM8KJ218jsb0k7O6dCJFDB92SyMfP9pfiup7BxVEM8LEHs8UvsAMvIrrXQL0mdNiIijadqkowQHvsJKlNGaM87/V1i+uOdooxlCq5J3x3r5UnvAHH3HqZj7UD65Dz1vFa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030971; c=relaxed/simple;
	bh=7PqEWqhOrQeQFra4a9fCGifY4cBcKhe9h+vKYUikneU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JISnz5wX18cK1+ZZdn1GIqcM+VHVr4W2sJvuekb14NEdTAwUle0bG4LGwIrQQcYBMx1EvTasaZfpGw6T0APPTSqFlMRu84Ncz6Sjw06Y/jpe+SqaOp++YKRmizSHhppAYUDJ+d4ZXWsNfphB1tKj+eibqShfDANuqVWmX6hVcGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVjEQUo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVjEQUo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372AAC16AAE;
	Sat, 14 Feb 2026 01:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030971;
	bh=7PqEWqhOrQeQFra4a9fCGifY4cBcKhe9h+vKYUikneU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVjEQUo8YeL1BQ1Y7BODdIumTIphsRmjMVbS9T4LDocX1ezMY+XNOex4k6N/pEOme
	 kXUsa2FeqBL6CXb6/XlaDEt6m/QOSsguj19fYTKKUQOAmiISL6J/qFzrKmfBUudSrH
	 co9yJP4M4GH1Y1W2c3kxhWQH0aODMyoQnVSlbDrQ7LnxonoZ93KzmkAlN7DyUZUAFn
	 fHam+6PLcRWhOFLYi5MtNku9yi/yLct1Q5daz/9RK3bLa4v4aYnl+LmlsBKdJm/X14
	 O5/FPd9nyPwO7gXlWfDJcKWqAUTjqbi4fTZn8RfeoWKe6mHHJplAj5tzbobxUTiG3l
	 tJNJV7yBECxDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kuninori.morimoto.gx@renesas.com,
	brgl@kernel.org,
	shengjiu.wang@nxp.com,
	yelangyan@huaqin.corp-partner.google.com,
	tiwai@suse.de,
	patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.19-5.10] ASoC: wm8962: Add WM8962_ADC_MONOMIX to "3D Coefficients" mask
Date: Fri, 13 Feb 2026 19:58:02 -0500
Message-ID: <20260214010245.3671907-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit 66c26346ae30c883eef70acf9cf9054dfdb4fb2f ]

This bit is handled by a separate control.

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260105-wm8962-l5-fixes-v1-1-f4f4eeacf089@puri.sm
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete understanding. Let me compile the analysis.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is concise: "This bit is handled by a separate
control." It's authored by Sebastian Krzyszkowiak from Purism (who works
on the Librem 5 phone, which uses the WM8962 codec), and it's reviewed
by Charles Keepax from Cirrus Logic (the codec manufacturer's software
team). The subject line says "Add WM8962_ADC_MONOMIX to '3D
Coefficients' mask." The patch series name in the link
(`wm8962-l5-fixes`) confirms this is a fix, not a feature.

### 2. CODE CHANGE ANALYSIS — The Bug

**Register layout of `WM8962_THREED1` (R268, 0x10C):**
- Bit 6: `ADC_MONOMIX` (0x0040) — controls ADC mono downmix
- Bit 5: `THREED_SIGN_L` (0x0020)
- Bit 4: `THREED_SIGN_R` (0x0010)
- Bit 2: `THREED_LHPF_MODE` (0x0004)
- Bit 1: `THREED_LHPF_ENA` (0x0002)
- Bit 0: `THREED_ENA` (0x0001)

**Two separate ALSA controls share this register:**

1. **"ADC Monomix Switch"** (line 1707) — a `SOC_SINGLE` control for bit
   6, added in commit `89383a2707e54` (August 2020, merged in
   v5.10-rc3).

2. **"3D Coefficients"** (line 1763) — a `SND_SOC_BYTES_MASK` bulk
   control covering 4 registers starting at `WM8962_THREED1`, added in
   commit `69e5a39f39c37` (February 2012).

**How `SND_SOC_BYTES_MASK` works:** The mask parameter tells
`snd_soc_bytes_put()` which bits in the first register should be
**preserved** (read-modify-write) when userspace writes coefficient
data. Looking at lines 585-628 of `soc-ops.c`:

1. Read the current register value
2. `val &= params->mask` — extract the preserved bits
3. `data[0] &= ~params->mask` — clear the preserved bits in the incoming
   data
4. `data[0] |= val` — restore the preserved bits

**The bug:** Before this fix, the mask was only `WM8962_THREED_ENA`
(0x0001, bit 0). This meant that when userspace wrote "3D Coefficients",
only the `THREED_ENA` bit was preserved. **Bit 6 (`ADC_MONOMIX`) was NOT
preserved** — it would be overwritten with whatever value happened to be
in the userspace data blob at that bit position.

**Consequence:** Writing the "3D Coefficients" control from userspace
would silently and unpredictably clobber the "ADC Monomix Switch"
setting. If a user (or ALSA UCM configuration) had enabled ADC mono
downmix (important for single-speaker devices like the Librem 5 phone),
writing 3D coefficients could randomly disable it, causing audio routing
issues. Conversely, if monomix was off, writing 3D coefficients could
accidentally enable it, causing unexpected mono downmix.

### 3. FIX ANALYSIS

The fix adds `WM8962_ADC_MONOMIX` (0x0040) to the mask:

```c
// Before: mask = 0x0001 (only THREED_ENA preserved)
SND_SOC_BYTES_MASK("3D Coefficients", WM8962_THREED1, 4,
WM8962_THREED_ENA),

// After: mask = 0x0041 (THREED_ENA and ADC_MONOMIX preserved)
SND_SOC_BYTES_MASK("3D Coefficients", WM8962_THREED1, 4,
WM8962_THREED_ENA | WM8962_ADC_MONOMIX),
```

This ensures that when "3D Coefficients" is written, both the 3D enable
bit AND the ADC monomix bit are preserved from the current register
value, preventing one control from clobbering the other.

### 4. SCOPE AND RISK ASSESSMENT

- **Size:** Single character change — adding `| WM8962_ADC_MONOMIX` to a
  mask value. This is the smallest possible fix.
- **Files touched:** 1 file (`sound/soc/codecs/wm8962.c`)
- **Risk:** Essentially zero. The only effect is that one additional bit
  is read-modify-write preserved instead of being overwritten. This is
  strictly a correctness improvement.
- **Could this break something?** No. Before this fix, writing 3D
  coefficients could clobber the monomix bit. After this fix, it cannot.
  There's no scenario where the old (buggy) behavior was desirable.

### 5. USER IMPACT

- **Who is affected:** Anyone using the WM8962 codec (common in
  embedded/mobile devices) who uses both the ADC Monomix and 3D
  enhancement features. The Librem 5 phone is one real-world device
  affected.
- **Severity:** Audio routing bug — the monomix setting is unexpectedly
  changed when 3D coefficients are written, which can cause incorrect
  audio output (mono/stereo confusion).
- **How long has the bug existed:** Since v5.10-rc3 (August 2020), when
  the ADC Monomix switch was added sharing the same register. That's
  about 5.5 years.

### 6. STABILITY INDICATORS

- **Reviewed-by:** Charles Keepax from Cirrus Logic (the codec
  manufacturer) — authoritative review
- **Author:** Sebastian Krzyszkowiak from Purism — someone who actively
  works with this hardware
- **Subsystem maintainer ack:** Mark Brown (ASoC maintainer) applied it

### 7. STABLE TREE APPLICABILITY

- The bug was introduced by `89383a2707e54` which is in stable trees
  5.10, 5.15, 6.1, and newer.
- The fix has zero dependencies on other commits.
- The code context around the change is stable and unchanged across all
  these versions.
- The fix applies cleanly to all affected stable trees.

### 8. CLASSIFICATION

This is a **hardware register clobbering bug fix** — an audio codec
quirk/control fix. It's analogous to audio codec quirks (like
`SND_PCI_QUIRK` entries) in that it fixes incorrect hardware control
behavior. It falls squarely into the "fixes a real bug" category: two
ALSA controls sharing a hardware register were interfering with each
other due to an incomplete bit mask.

### Decision

This is a textbook stable backport candidate:
- **Obviously correct:** The mask was missing a bit that's controlled by
  another control sharing the same register
- **Fixes a real bug:** Audio routing corruption when 3D coefficients
  are written
- **Small and contained:** One-line change adding a bit to a mask
- **No new features:** Purely corrective
- **No risk of regression:** Only makes the read-modify-write preserve
  one additional bit
- **Reviewed by codec manufacturer engineer**
- **Affects real users on real hardware** (Librem 5 and any other
  WM8962-based device)
- **Bug exists in all stable trees from 5.10 onward**

**YES**

 sound/soc/codecs/wm8962.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index e9e317ce68982..1040740fc80f8 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1760,7 +1760,7 @@ SND_SOC_BYTES("EQR Coefficients", WM8962_EQ24, 18),
 
 
 SOC_SINGLE("3D Switch", WM8962_THREED1, 0, 1, 0),
-SND_SOC_BYTES_MASK("3D Coefficients", WM8962_THREED1, 4, WM8962_THREED_ENA),
+SND_SOC_BYTES_MASK("3D Coefficients", WM8962_THREED1, 4, WM8962_THREED_ENA | WM8962_ADC_MONOMIX),
 
 SOC_SINGLE("DF1 Switch", WM8962_DF1, 0, 1, 0),
 SND_SOC_BYTES_MASK("DF1 Coefficients", WM8962_DF1, 7, WM8962_DF1_ENA),
-- 
2.51.0

