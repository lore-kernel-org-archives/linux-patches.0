Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694ED365A10;
	Mon, 23 Feb 2026 12:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850263; cv=none; b=QVFzd6LPwCX3wnQPY9dN5NYVzjX7HKelbibf/fJ9MR6JluZJ9tGgtZ72YOMKy3oBOpmmLVAMVvQP2FLQW3j9oV4o+OWNKAjUzlyx4URJiShzTOASdA7+ZSgh+mLwv6z9dRKT9UrKv6Z33kCW56vYF+wMloLW42MXj9bVJGYaBSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850263; c=relaxed/simple;
	bh=cmBEOxL+2zmKFz8FHKFKGqZbxxPol4dDEm8peiC6tYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkLBuqTWX0+q1q9XjTsYnQ+gW6PO+EqSLzQKBkQCVu9E3vTP6Re8b5U8DGcJoP30L+fGtisWCf4tDe8qkhApUrorGJivPtH1ZCrBOoJers71oodY5zqKjqllHoSvx+12zJ5myYBIVq/ZuqOOIIm7yYG22NW47gqQI9mQ3fWGYhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oV4wLXV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oV4wLXV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B22C116D0;
	Mon, 23 Feb 2026 12:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850263;
	bh=cmBEOxL+2zmKFz8FHKFKGqZbxxPol4dDEm8peiC6tYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV4wLXV/X9UIHWcLg0w30lgL/47y4t60mRMO0jG8GPf5msEqV5oX2G73NIjE4aQGt
	 tZd7SLCXY3g9VORBtvUZR7D+FeEVxDeJza5GTfRb7dF4yY+3rzNEkUFfOlJNtqGJew
	 fWl7C6UE5FrigvrOwH4CUA26wlh+IyrLQQdb8ZGJgT2LpYpSM6XwdlSaOQGPJrZwg1
	 xERkzkhWeaRz8AIR9/+6a8m1J9+lVwl+BpFrsIu253Uh0CAIOZpczUGzU3ktsFgeus
	 DMhX1d4q+FFQcKNPZtxQWC8TxrClrvIjJvdB0SuF/ceAz7JETZGhFZQWMyKdiB5CSw
	 s2JDoPHkOXfMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ASoC: rt721-sdca: Fix issue of fail to detect OMTP jack type
Date: Mon, 23 Feb 2026 07:37:07 -0500
Message-ID: <20260223123738.1532940-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 5578da7d957fbaf91f6c39ba2363c2d2e4273183 ]

Add related HP-JD settings to fix issue of fail to detect
OMTP jack type.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://patch.msgid.link/20260210074335.2337830-1-jack.yu@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### 1. Commit Message Analysis

The commit subject is explicitly a **fix**: "Fix issue of fail to detect
OMTP jack type." OMTP is a widely-used headphone jack standard (with
reversed mic/ground pins compared to CTIA). Failure to detect OMTP jacks
means users with OMTP headsets won't get proper microphone functionality
— the mic won't work or audio will be misrouted.

The author is **Jack Yu from Realtek** — the vendor engineer who wrote
the original driver. The commit was reviewed and merged by **Mark
Brown**, the ASoC subsystem maintainer.

### 2. Code Change Analysis

The fix modifies exactly **two register preset values** in
`rt721_sdca_jack_preset()`:

1. **Line 248**: `RT721_CBJ_A0_GAT_CTRL1` value changed from `0x2a02` to
   `0x2205` — This is a combo jack (CBJ) gate control register that
   governs jack type detection logic.
2. **Line 253**: Register `0x310400` value changed from `0x3023` to
   `0x3043` — This is an HP-JD (Headphone Jack Detect) setting register.

These are pure hardware register tuning changes — no control flow, no
new code paths, no new features. The function `rt721_sdca_jack_preset`
is a hardware initialization sequence that writes preset values to
configure the codec's jack detection circuitry.

### 3. Classification

This is a **hardware quirk/workaround** — correcting register values so
the codec properly detects a standard jack type. It falls squarely in
the "quirks and workarounds" exception category for stable. It's
analogous to audio codec quirks (`SND_PCI_QUIRK` entries) that are
routinely backported.

### 4. Scope and Risk Assessment

- **Extremely small change**: Only 2 register values modified (2 lines)
- **Zero structural change**: No new functions, no new control flow, no
  API changes
- **Confined scope**: Only affects rt721 SDCA codec users
- **Low regression risk**: These register values only affect the OMTP
  detection path; the worst case is that the values are still wrong (but
  CTIA detection should be unaffected since these are jack detect preset
  parameters set by the vendor)
- **Vendor-provided values**: Realtek knows their hardware — these
  register values come from the vendor's hardware team

### 5. User Impact

Users with RT721-SDCA codec (present in modern laptops using SoundWire)
who plug in OMTP headsets would find the microphone not working. This is
a real-world usability issue affecting actual hardware users.

### 6. Stable Tree Applicability

The rt721-sdca driver was introduced in commit `86ce355c1f9ab` which
first appeared in **v6.13-rc1**. This means the fix is applicable to
stable trees **6.13.y** and later (6.14.y, etc.). It would NOT apply to
6.12.y or earlier since the driver doesn't exist there.

### 7. Dependencies

The fix modifies only preset register values in an existing function. It
has **no dependencies** on other commits — it's a standalone two-line
value change.

### Verification

- **git log** confirmed `rt721-sdca.c` was introduced in commit
  `86ce355c1f9ab` (Oct 2024)
- **git tag --contains** confirmed the driver first appeared in
  v6.13-rc1
- **Read of the file** confirmed the function `rt721_sdca_jack_preset()`
  at lines 211-288 is a pure hardware register initialization sequence
- **Exploration** confirmed Jack Yu (jack.yu@realtek.com) from Realtek
  is the original author and continues to maintain the driver
- **Stable branches** confirmed `linux-6.13.y` exists as a target for
  backport
- The change is exactly 2 register values being modified, verified by
  reading the diff

### Conclusion

This is a small, surgical, vendor-provided hardware fix from the codec
manufacturer. It corrects register preset values to fix OMTP jack type
detection on RT721-SDCA codecs. The change is:
- Obviously correct (vendor-provided register values)
- Fixes a real bug (OMTP headsets don't work)
- Small and contained (2 register value changes)
- Does not introduce new features or APIs
- Has minimal regression risk

**YES**

 sound/soc/codecs/rt721-sdca.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt721-sdca.c b/sound/soc/codecs/rt721-sdca.c
index 8233532a1752a..35960c2252249 100644
--- a/sound/soc/codecs/rt721-sdca.c
+++ b/sound/soc/codecs/rt721-sdca.c
@@ -245,12 +245,12 @@ static void rt721_sdca_jack_preset(struct rt721_sdca_priv *rt721)
 	regmap_write(rt721->mbq_regmap, 0x5b10007, 0x2000);
 	regmap_write(rt721->mbq_regmap, 0x5B10017, 0x1b0f);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_CBJ_CTRL,
-		RT721_CBJ_A0_GAT_CTRL1, 0x2a02);
+		RT721_CBJ_A0_GAT_CTRL1, 0x2205);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_CAP_PORT_CTRL,
 		RT721_HP_AMP_2CH_CAL4, 0xa105);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_VENDOR_ANA_CTL,
 		RT721_UAJ_TOP_TCON14, 0x3b33);
-	regmap_write(rt721->mbq_regmap, 0x310400, 0x3023);
+	regmap_write(rt721->mbq_regmap, 0x310400, 0x3043);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_VENDOR_ANA_CTL,
 		RT721_UAJ_TOP_TCON14, 0x3f33);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_VENDOR_ANA_CTL,
-- 
2.51.0

