Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D0243CEEA;
	Tue, 10 Mar 2026 09:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133316; cv=none; b=m6I3HM+iEPD27LJpV+LmabHldoe7P2BBnLqVG+R3pxtvJ5S1ORewaOtl2akRGAf0Rc58WbY6Z0Yg8g0ZeFOEyADblte7/ENE+kI3cGkHrZs0ybjxCgzMr+M0l54lb5rUGs+JpZbS0Nn3jFRoWG724QRyeJyCYDY6CMfrtQUp2NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133316; c=relaxed/simple;
	bh=0y7pePMiKjtG4s8II6vL3wSpGu+6QoNp5FvL6Tug0e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIdJsEkN4DEaU2yIKQB39GG5p0MjHrUwe+BnS2VN5Hbl78m+K747mJOR27pr7XixEx5VRo2dFsdcsLdq0u2b5ze0Wtf+hwYKGTxplnkv199YKqvDZ/7vj0R/xi4vp5axZZCOSD8WJWbmtdw0/48IHtf2MYE3Hopya8Q09I6uOHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avAMOXuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avAMOXuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A688C2BC87;
	Tue, 10 Mar 2026 09:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133315;
	bh=0y7pePMiKjtG4s8II6vL3wSpGu+6QoNp5FvL6Tug0e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avAMOXuIbG+7TL5yqKGhjcwOKEYlPFjR1xFZpJm2EZvYeHRbwRYxLi7NzSorXe0gm
	 fpLEnsF3bQxFK5SlMGzk+nxOqqSJGwp4K1NRwbEX5YI+dm+iG+h8H0PY2Ez6Au6GgF
	 fbKm9BGZDnborJHytsCVTiW9EJvdexwCclhBWc4j9dJejQlBC3DbhxkVJAoa3cJ+Z9
	 byIrKfCQnPEseqJ5h0t4NeuJikkLoHkokZgPB7oKBBHVC9/LM9yZZhXnC2oA1xmlah
	 c14crjSWnGN+hloquEmYDeHe/u3AqghzXsBa8NQ594caV6LQHRabMYIjPc3qCRjDmE
	 P/reofocQH/UA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shengjiu.wang@gmail.com,
	Xiubo.Lee@gmail.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_set_reg()
Date: Tue, 10 Mar 2026 05:01:06 -0400
Message-ID: <20260310090145.2709021-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 31ddc62c1cd92e51b9db61d7954b85ae2ec224da ]

ALSA controls should return 1 if the value in the control changed but the
control put operation fsl_easrc_set_reg() only returns 0 or a negative
error code, causing ALSA to not generate any change events. Add a suitable
check by using regmap_update_bits_check() with the underlying regmap, this
is more clearly and simply correct than trying to verify that one of the
generic ops is exactly equivalent to this one.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260205-asoc-fsl-easrc-fix-events-v1-2-39d4c766918b@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The driver has been present since 2020 (v5.8 timeframe), so it exists in
all current stable trees.

## Analysis

**What the commit fixes:**
The `fsl_easrc_set_reg()` function is an ALSA control `.put` callback.
Per ALSA API contract, `.put` callbacks must return 1 if the value
changed, 0 if unchanged, or negative on error. The original code always
returned 0 on success (via `snd_soc_component_write()`), never returning
1, which means ALSA never generated change notification events to
userspace when the control value was updated.

**The fix:**
Replaces `snd_soc_component_write()` with `regmap_update_bits_check()`
which provides a `changed` boolean output. The function now returns
`changed` (0 or 1) on success, correctly implementing the ALSA control
API.

**Stable criteria assessment:**
1. **Obviously correct and tested**: Yes - authored and signed off by
   Mark Brown (ASoC maintainer). The pattern is well-established across
   many similar fixes in ASoC (I found 15+ similar "Fix event
   generation" commits).
2. **Fixes a real bug**: Yes - missing change events means userspace
   applications (e.g., PulseAudio, PipeWire, ALSA mixer tools) won't be
   notified of control changes, causing incorrect UI state or behavior.
3. **Small and contained**: Yes - changes only a few lines in a single
   function, in a single file.
4. **No new features**: Correct - this is purely a bug fix restoring
   proper API semantics.
5. **Risk**: Very low - the `regmap_update_bits_check()` API has been
   available for a long time, and the change is a well-understood
   pattern used across many ASoC drivers.

**Scope**: The change is surgical - it replaces
`snd_soc_component_write()` with `regmap_update_bits_check()` and
adjusts the return value logic. The semantic behavior is the same
(writing the register value) but now it also detects whether the value
actually changed.

**Verification:**
- Read the current file at lines 93-110: confirmed the fix is applied
  and is as described in the diff.
- `git log` on the file: the driver was introduced in commit
  955ac624058f9 (2020-04-16), present in all current LTS trees (5.15+,
  6.1+, 6.6+).
- Searched for similar "Fix event generation" commits in ASoC: found 15+
  similar commits following the exact same pattern, indicating this is a
  well-established class of bug fix that has been widely backported
  before.
- The commit is authored by Mark Brown, the ASoC subsystem maintainer,
  lending high confidence in correctness.
- The `regmap_update_bits_check()` API has been available since at least
  v3.x, so no dependency issues for stable trees.
- Could not verify if the companion commit 8f8d0defdb1a3 (fixing
  `fsl_easrc_iec958_put_bits()`) would also need backporting - it's a
  separate but related fix for the same class of bug in the same file.

**YES** - This is a small, surgical bug fix by the ASoC maintainer that
corrects incorrect ALSA control API behavior (missing change events).
The pattern is well-established across many ASoC drivers, carries
minimal risk, and the driver has existed in stable trees since 2020.

**YES**

 sound/soc/fsl/fsl_easrc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index e64a0d97afd0c..733374121196e 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -93,14 +93,17 @@ static int fsl_easrc_set_reg(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
+	struct fsl_asrc *easrc = snd_soc_component_get_drvdata(component);
 	unsigned int regval = ucontrol->value.integer.value[0];
+	bool changed;
 	int ret;
 
-	ret = snd_soc_component_write(component, mc->regbase, regval);
-	if (ret < 0)
+	ret = regmap_update_bits_check(easrc->regmap, mc->regbase,
+				       GENMASK(31, 0), regval, &changed);
+	if (ret != 0)
 		return ret;
 
-	return 0;
+	return changed;
 }
 
 #define SOC_SINGLE_REG_RW(xname, xreg) \
-- 
2.51.0

