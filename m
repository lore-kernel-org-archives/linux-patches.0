Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3617A303CA8;
	Sat, 25 Oct 2025 16:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408888; cv=none; b=u4V8y6RtPlLca4M+eRxZgFKiMVFOK9ngYyeqqMEtpzlswhyaXDY6VaUATQHuxRec9jNtiYSJ7Dc1g4uM44ZzJm5a2uXDqBSUB2DXkM2B1kXibRXsQDo8MUitBu9SP0ZgsRQumrhj3gk61ba5xjy73JoJd8dGsCQBB8mLFlvfTt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408888; c=relaxed/simple;
	bh=2Bob0ZNJjMEU9xhD7EfrULhkbCgZghUlFHEdnIxTbBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suRalEIkQqTu/BLgnptXXGPa+sfCnZZlLXfTj5DwPodoAMh8qzJu3+vrg9ChSMJTllVOHwxyZ1IH8mK1DQpmnFBHhnHLtTfSoO8lMEv/r05F9kYRRN9hojvhMiKIgXW+DOUAKthqI6mnrCJ7QcUot8Eo8GsO/Nes6by7Ij3XkOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P20H9yEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P20H9yEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E17AC4CEFB;
	Sat, 25 Oct 2025 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408886;
	bh=2Bob0ZNJjMEU9xhD7EfrULhkbCgZghUlFHEdnIxTbBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P20H9yEalV+y9kfjFq941pj8zuxNdnrJypTXegrY9TBNBY9JcoeoUCTHxqD1B36TL
	 p1buiE9RqT9jJ4ToyrYAhWXVLci+F6Sf3JOHMnEIPoPBk/Q04VN5c9LGQH3Asvi9N3
	 ecrce/ZmOzZYB4SGGEhp/JllFTloVpoY3Md9mOWi0l2pMhFvHpjMsxmNYma5HoSQ/S
	 VjN3TNvP6gjoCbW6U59YKX+l+f6f4BHrtj4RouzMMSUxyv57EWB/eMPP5GnVQ0W/JX
	 rqcjhZqxNbc4Rg4eLSi6zTXXVeD0/LlwIanpR5+X6lGr+LfaBfRk41kekN5niFiVbX
	 28JTpYFAGTDLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] ASoC: tas2781: Add keyword "init" in profile section
Date: Sat, 25 Oct 2025 11:55:45 -0400
Message-ID: <20251025160905.3857885-114-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
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

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit e83dcd139e776ebb86d5e88e13282580407278e4 ]

Since version 0x105, the keyword 'init' was introduced into the profile,
which is used for chip initialization, particularly to store common
settings for other non-initialization profiles.

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20250803131110.1443-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this matters
- Fixes a functional gap for RCA firmware ≥ 0x105: since that format
  introduces an “init” profile with common chip settings, failing to
  apply it can leave later (non-init) profiles missing required base
  configuration, causing misconfiguration or degraded audio. This is a
  user-visible bug for systems shipping new firmware files.

What the change does (specific code references)
- Adds per-firmware init profile tracking
  - include/sound/tas2781-dsp.h:172 adds `int init_profile_id;` to
    `struct tasdevice_rca` with comment clarifying semantics (negative
    means no init profile). Internal-only struct, no UAPI/ABI impact.
- Detects “init” profile while parsing RCA configs
  - sound/soc/codecs/tas2781-fmwlib.c:171 is the existing place where,
    for binary_version_num ≥ 0x105, the code skips a 64‑byte profile
    header. The patch scans those 64 bytes for the keyword “init” and
    records the last such profile in `rcabin.init_profile_id`. It also
    initializes `rca->init_profile_id = -1;` at the start of
    `tasdevice_rca_parser` (around
    sound/soc/codecs/tas2781-fmwlib.c:290).
- Applies init profile at probe/firmware ready
  - sound/soc/codecs/tas2781-i2c.c:1423 currently loads program 0 and
    sets `cur_prog`. The patch adds a guarded call to
    `tasdevice_select_cfg_blk(..., TASDEVICE_BIN_BLK_PRE_POWER_UP)`
    using `rcabin.init_profile_id` when available, seeding the common
    settings before normal profile usage.

Why it fits stable
- Bug fix impact: Enables correct initialization with new RCA files (≥
  0x105) that rely on a separate init profile for common settings.
  Without it, normal profiles may miss required base settings.
- Small and contained: Touches only ASoC TAS2781 driver and its header,
  with minimal code paths. No architectural changes or core subsystem
  impact.
- Backward-compatible and low risk:
  - Fully gated on `binary_version_num >= 0x105`. For older firmware,
    behavior is unchanged.
  - If no “init” profile is present, `init_profile_id` remains -1 and
    the new path is skipped.
  - Profile application uses the existing `tasdevice_select_cfg_blk()`
    mechanism; no new behavior beyond one extra PRE_POWER_UP block.
- No ABI/UAPI changes: The new struct member is internal to the driver.
- Regression risk: Minimal. The “init” string search only operates on a
  bounded 64‑byte header already being skipped
  (sound/soc/codecs/tas2781-fmwlib.c:171). Extra initialization writes
  are vendor-authored and expected by the new firmware format.

Notes
- Commit message doesn’t carry a Fixes or Cc: stable tag, but the change
  corrects behavior for newly formatted firmware files and is safe to
  backport.
- One subtlety: it uses a substring match (“init”) over the 64‑byte
  profile header. This mirrors vendor intent; risk of false positives in
  profile naming is low and limited to ≥ 0x105 images.

 include/sound/tas2781-dsp.h       |  8 ++++++++
 sound/soc/codecs/tas2781-fmwlib.c | 12 ++++++++++++
 sound/soc/codecs/tas2781-i2c.c    |  6 ++++++
 3 files changed, 26 insertions(+)

diff --git a/include/sound/tas2781-dsp.h b/include/sound/tas2781-dsp.h
index c3a9efa73d5d0..a21f34c0266ea 100644
--- a/include/sound/tas2781-dsp.h
+++ b/include/sound/tas2781-dsp.h
@@ -198,6 +198,14 @@ struct tasdevice_rca {
 	int ncfgs;
 	struct tasdevice_config_info **cfg_info;
 	int profile_cfg_id;
+	/*
+	 * Since version 0x105, the keyword 'init' was introduced into the
+	 * profile, which is used for chip initialization, particularly to
+	 * store common settings for other non-initialization profiles.
+	 * if (init_profile_id < 0)
+	 *         No init profile inside the RCA firmware.
+	 */
+	int init_profile_id;
 };
 
 void tasdevice_select_cfg_blk(void *context, int conf_no,
diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index c9c1e608ddb75..8baf56237624a 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -180,6 +180,16 @@ static struct tasdevice_config_info *tasdevice_add_config(
 			dev_err(tas_priv->dev, "add conf: Out of boundary\n");
 			goto out;
 		}
+		/* If in the RCA bin file are several profiles with the
+		 * keyword "init", init_profile_id only store the last
+		 * init profile id.
+		 */
+		if (strnstr(&config_data[config_offset], "init", 64)) {
+			tas_priv->rcabin.init_profile_id =
+				tas_priv->rcabin.ncfgs - 1;
+			dev_dbg(tas_priv->dev, "%s: init profile id = %d\n",
+				__func__, tas_priv->rcabin.init_profile_id);
+		}
 		config_offset += 64;
 	}
 
@@ -283,6 +293,8 @@ int tasdevice_rca_parser(void *context, const struct firmware *fmw)
 	int i;
 
 	rca = &(tas_priv->rcabin);
+	/* Initialize to none */
+	rca->init_profile_id = -1;
 	fw_hdr = &(rca->fw_hdr);
 	if (!fmw || !fmw->data) {
 		dev_err(tas_priv->dev, "Failed to read %s\n",
diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 0e09d794516fc..ea3cdb8553de1 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1641,6 +1641,12 @@ static void tasdevice_fw_ready(const struct firmware *fmw,
 	tasdevice_prmg_load(tas_priv, 0);
 	tas_priv->cur_prog = 0;
 
+	/* Init common setting for different audio profiles */
+	if (tas_priv->rcabin.init_profile_id >= 0)
+		tasdevice_select_cfg_blk(tas_priv,
+			tas_priv->rcabin.init_profile_id,
+			TASDEVICE_BIN_BLK_PRE_POWER_UP);
+
 #ifdef CONFIG_SND_SOC_TAS2781_ACOUST_I2C
 	if (tas_priv->name_prefix)
 		acoustic_debugfs_node = devm_kasprintf(tas_priv->dev,
-- 
2.51.0

