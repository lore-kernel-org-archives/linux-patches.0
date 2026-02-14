Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFFC17B506;
	Sat, 14 Feb 2026 01:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031012; cv=none; b=LrdT1s74U2TjnGs8861bjRIvyfBWXw66xcPOcczstFfkLtc60D6xSIwrHK+YJj0Jya6AAJl1H+cCY4Cha468mTGPaDuAdzW0fUfIc7zxYabnsw0OQI70Jyek+DLFk+m2lZk/chufxf4O9VFjW6ugED/30uVVTvV2uhfUsOAuU8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031012; c=relaxed/simple;
	bh=DYXq2qY0dD/StwAInwWhC+76+C/ziRXYzOIGNBCGnsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ka1dI67tlP/vy3i500duagcKp6WlqA4GtS9TFu0emQkUttfxtyhilCZJzJhWkKiuXS43KkrhWnnBEKXK5eLwKc6QGDGwbqVk4jwhpJROPHR1LCq58NlczszpEWqCUfenejey1nYgVdeGfQkqCCbT65Vu2b0mTNR/TBMOVNIFjno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pgq7ZYYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pgq7ZYYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467BBC116C6;
	Sat, 14 Feb 2026 01:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031012;
	bh=DYXq2qY0dD/StwAInwWhC+76+C/ziRXYzOIGNBCGnsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pgq7ZYYLUX4g+qhl3GF+ap16DPznNREkZiJOzVVHzi2G+FwFUzCNTCecuTQyPO2JP
	 hIhiX/5u+DY0VjBvWBk9BEF6YrDKJCWZsDeLkSIeib881RD9dIpFmeFyEHyFXV9R9j
	 cxbEmmYRJ7ynUjGlcjmv0xDVUTFGlSvL/AwmrNkJR0YMaQaYnOA7PK3L5rnezkLo82
	 HAXUFBSfQquzZkx9CyA8UPGluGo+13dxvh/csMJL2PyPt9rCEcNcL9C/xKc1A75fBz
	 fZ9eHB1uZe3lb7psor0xUgTq/M5KZokwfatXAgM9UOco+lKIkqQsz6/qT7d5UGePGj
	 UEfUe8/vGnVfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ranjani.sridharan@linux.intel.com,
	shumingf@realtek.com,
	niranjan.hy@ti.com,
	yelangyan@huaqin.corp-partner.google.com,
	linmq006@gmail.com
Subject: [PATCH AUTOSEL 6.19] ASoC: sdw_utils: remove dai registered check
Date: Fri, 13 Feb 2026 19:58:23 -0500
Message-ID: <20260214010245.3671907-23-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 8d38c275f7ffe257d21bea224d4288eef183817d ]

Checking for a registered DAI for non-existing endpoints causes the
following error. The driver will always return -EPROBE_DEFER if the
codec driver doesn't register the DAI of the unexist endpoint.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260120065658.1806027-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of ASoC: sdw_utils: remove dai registered check

### Commit Message Analysis

The commit message describes a bug where checking for a registered DAI
for **non-existing endpoints** causes the driver to always return
`-EPROBE_DEFER` if the codec driver doesn't register the DAI of a non-
existent endpoint. This means the system enters an infinite probe
deferral loop — the device will never successfully probe because it's
waiting for a DAI that will never be registered (since the endpoint
doesn't exist).

### Code Change Analysis

The change removes a block of code from `is_sdca_endpoint_present()`
that:

1. Allocated a `snd_soc_dai_link_component` (dlc)
2. Looked up the DAI name from `dai_info`
3. Called `snd_soc_find_dai_with_mutex()` to check if the codec DAI was
   registered
4. If not found, returned `-EPROBE_DEFER`
5. Freed the dlc

**The bug mechanism:** The function `is_sdca_endpoint_present()` is
supposed to determine if an endpoint is present (returns 1) or not
(returns 0). However, for endpoints that don't actually exist on the
hardware, the codec driver will never register their DAIs. The removed
code would find that the DAI isn't registered and return
`-EPROBE_DEFER`, causing the probe to be deferred indefinitely. This
creates an infinite deferral loop — the system keeps retrying probe but
the DAI will never appear because the endpoint doesn't exist.

The rest of the function (which remains) properly handles endpoint
presence detection by checking the SoundWire slave's SDCA data and
function properties — this is the correct way to determine if an
endpoint is present.

### Classification

This is a **bug fix** — it fixes a probe failure (infinite
`-EPROBE_DEFER` loop) that prevents SoundWire audio devices from
initializing properly. Users with affected hardware would have no audio
functionality.

### Scope and Risk Assessment

- **Lines changed:** Removes ~15 lines of code (the DAI registration
  check and associated allocation/free)
- **Files touched:** 1 file (`sound/soc/sdw_utils/soc_sdw_utils.c`)
- **Risk:** LOW — the code being removed was performing an unnecessary
  check that was actively harmful. The remaining code in the function is
  the correct logic for determining endpoint presence.
- **Side effects:** The removal also eliminates a memory allocation
  (`kzalloc`/`kfree`) making the function simpler and more efficient.

### User Impact

- **Who is affected:** Users with SoundWire-based audio hardware (Intel
  platforms with SoundWire codecs, which is increasingly common in
  modern laptops)
- **Severity:** HIGH — Without this fix, affected systems have
  completely non-functional audio because the probe never completes
- **Trigger:** The bug triggers whenever the ACPI tables describe
  endpoints that don't physically exist on the hardware, which can
  happen in normal configurations

### Stability Indicators

- **Reviewed-by:** Three reviewers (Péter Ujfalusi, Liam Girdwood,
  Charles Keepax) — all well-known ASoC developers
- **Author:** Bard Liao (Intel SoundWire maintainer) — deeply familiar
  with this subsystem
- **Applied by:** Mark Brown (ASoC maintainer)

### Dependency Check

The change is self-contained — it only removes code, so there are no
forward dependencies. The function and surrounding code should exist in
recent stable trees that include SoundWire SDCA support.

### Conclusion

This is a clear bug fix that resolves an infinite probe deferral loop
for SoundWire audio devices. The fix is small (pure code removal), well-
reviewed by multiple subsystem experts, low risk, and addresses a real
user-visible issue (no audio on affected hardware). It meets all stable
kernel criteria: obviously correct, fixes a real bug, small and
contained, no new features.

**YES**

 sound/soc/sdw_utils/soc_sdw_utils.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index ccf149f949e8f..d03072cd13cb9 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1421,29 +1421,14 @@ static int is_sdca_endpoint_present(struct device *dev,
 	const struct snd_soc_acpi_adr_device *adr_dev = &adr_link->adr_d[adr_index];
 	const struct snd_soc_acpi_endpoint *adr_end;
 	const struct asoc_sdw_dai_info *dai_info;
-	struct snd_soc_dai_link_component *dlc;
-	struct snd_soc_dai *codec_dai;
 	struct sdw_slave *slave;
 	struct device *sdw_dev;
 	const char *sdw_codec_name;
 	int ret, i;
 
-	dlc = kzalloc(sizeof(*dlc), GFP_KERNEL);
-	if (!dlc)
-		return -ENOMEM;
-
 	adr_end = &adr_dev->endpoints[end_index];
 	dai_info = &codec_info->dais[adr_end->num];
 
-	dlc->dai_name = dai_info->dai_name;
-	codec_dai = snd_soc_find_dai_with_mutex(dlc);
-	if (!codec_dai) {
-		dev_warn(dev, "codec dai %s not registered yet\n", dlc->dai_name);
-		kfree(dlc);
-		return -EPROBE_DEFER;
-	}
-	kfree(dlc);
-
 	sdw_codec_name = _asoc_sdw_get_codec_name(dev, adr_link, adr_index);
 	if (!sdw_codec_name)
 		return -ENOMEM;
-- 
2.51.0

