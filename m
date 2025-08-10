Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B7A25A33F;
	Sun, 10 Aug 2025 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844754; cv=none; b=qjCEf1/SXhLtFOChFqk8+trp11/4I0EDq3sW1xRIlX4VwanPPIfpOXRDSyUUvwr8xX2c+JhNfPgZmLoG+/EHB407jGgUzs+r/q3x46qMZq6vM64RF4jy7c+SVTE/wctgAuqbz778vNEywZ/59I6c21pHSIfaT53PI9QJjlAA47w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844754; c=relaxed/simple;
	bh=rBzUwhenI+n09cbRZheI4PXmhLTa4L9oOkW6C5OZSpw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eJwjJ+nlxiuXBj6kKKOKKaBVEpbtF0gHD73UtKiF6kccXkmZwqY6BCeEhJa8e1whaFjq4/Lxg/2ca/BQh1CXUZAEtRtYdPYmAgVVS4gaMKzfI/LvYu2hxJWE0/zAFAt94ePD/L0cS1xstUSjd9RJqb2ZeFNb7ynfK3dtO7miXEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBD2WHC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBD2WHC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48ACC4CEEB;
	Sun, 10 Aug 2025 16:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844753;
	bh=rBzUwhenI+n09cbRZheI4PXmhLTa4L9oOkW6C5OZSpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBD2WHC8N09vHWATB01WsqsZ9dVVheAwiUpYoHJERDdPl29G603poPWKWKsY68j0s
	 QWFG5WqbBIMXjQaLsA9XcEweg+61tdfQQkuSQqiuM6noqL38+XbAX1SAMBS/IRQUWN
	 66OmfRrh8A4SK582AnR4mjeYfQR4vn0V1Jnb/aBQj0wfD8RG7AXRnkCeHs4k0aMxO1
	 jmr3QPeoi2wiEvUttNYm+JBmim2xQDbW8SPj3cK8orITf1bro5KcH0WTuJLnFJdTgH
	 V+2XOMOcvFwMWlXDfKwyFO1KkDmd6vtpWa+oaALaekH2QGVwUMTHnOOQoEUg5u6yWb
	 501JmcoJbMfQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Jakubek <peterjakubek@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	liam.r.girdwood@intel.com,
	peter.ujfalusi@linux.intel.com,
	ranjani.sridharan@linux.intel.com,
	Vijendar.Mukunda@amd.com,
	ckeepax@opensource.cirrus.com,
	simont@opensource.cirrus.com,
	rf@opensource.cirrus.com,
	mstrozek@opensource.cirrus.com,
	deep_harsora@dell.com
Subject: [PATCH AUTOSEL 6.16-6.15] ASoC: Intel: sof_sdw: Add quirk for Alienware Area 51 (2025) 0CCC SKU
Date: Sun, 10 Aug 2025 12:51:52 -0400
Message-Id: <20250810165158.1888206-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810165158.1888206-1-sashal@kernel.org>
References: <20250810165158.1888206-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Peter Jakubek <peterjakubek@gmail.com>

[ Upstream commit 1b03391d073dad748636a1ad9668b837cce58265 ]

Add DMI quirk entry for Alienware systems with SKU "0CCC" to enable
proper speaker codec configuration (SOC_SDW_CODEC_SPKR).

This system requires the same audio configuration as some existing Dell systems.
Without this patch, the laptop's speakers and microphone will not work.

Signed-off-by: Peter Jakubek <peterjakubek@gmail.com>
Link: https://patch.msgid.link/20250731172104.2009007-1-peterjakubek@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now, let me analyze the commit for backport suitability:

**Backport Status: YES**

## Extensive Analysis:

This commit should be backported to stable kernel trees based on the
following detailed analysis:

### 1. **Hardware Enablement Fix**
The commit adds a DMI quirk entry for the Alienware Area 51 (2025) with
SKU "0CCC" to enable proper speaker codec configuration. The commit
message explicitly states: "Without this patch, the laptop's speakers
and microphone will not work." This is a clear hardware functionality
fix where audio devices are completely non-functional without this
patch.

### 2. **Minimal and Contained Change**
The code change is extremely minimal - it adds exactly 8 lines to the
`sof_sdw_quirk_table[]` array:
```c
+       {
+               .callback = sof_sdw_quirk_cb,
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+                       DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0CCC")
+               },
+               .driver_data = (void *)(SOC_SDW_CODEC_SPKR),
+       },
```

### 3. **Follows Established Pattern**
The change follows the exact same pattern as numerous other
Dell/Alienware system quirks already in the file. Looking at lines
694-742 in the same file, we can see identical entries for Dell systems
with different SKUs (0CF1, 0CF3, 0CF4, 0CF5, etc.), all using the same
`SOC_SDW_CODEC_SPKR` flag.

### 4. **Zero Risk of Regression**
The quirk only activates when the DMI system matches exactly "Alienware"
vendor and SKU "0CCC". This makes it impossible to affect any other
systems. The `SOC_SDW_CODEC_SPKR` flag (defined in
`/home/sasha/linux/include/sound/soc_sdw_utils.h` as BIT(15)) enables
codec internal speaker support, which is a well-tested configuration
used by many other systems.

### 5. **Similar Commits Are Routinely Backported**
Recent git history shows numerous similar quirk additions for Dell and
Lenovo systems (commits like d859923faeca, af23d38caae5, 60f1c71ec874)
that add DMI quirks for audio hardware enablement. These types of
hardware enablement fixes are regularly accepted into stable trees.

### 6. **User Impact**
Without this patch, users of the Alienware Area 51 (2025) laptop have
completely non-functional audio (no speakers, no microphone). This
severely impacts the usability of the device and would force users to
use external audio devices or compile custom kernels.

### 7. **No Architectural Changes**
The commit makes no architectural changes, adds no new features, and
simply extends an existing quirk table with a new hardware ID. It uses
existing, well-tested infrastructure (DMI matching and
SOC_SDW_CODEC_SPKR flag).

### Conclusion:
This is a textbook example of a commit that should be backported to
stable kernels. It fixes a real hardware issue (non-functional audio),
has zero regression risk due to exact DMI matching, follows established
patterns, and is minimal in scope. The fix enables basic functionality
for affected hardware without any possibility of impacting other
systems.

 sound/soc/intel/boards/sof_sdw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 504887505e68..c576ec5527f9 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -741,6 +741,14 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0CCC")
+		},
+		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
+	},
 	/* Pantherlake devices*/
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.39.5

