Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EB1364EA4;
	Mon, 23 Feb 2026 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850264; cv=none; b=N3om+A7V0Ya9DfHq/ENcOQvzm7x0a/UnMfBXqG3V4T1J545T4HOpydS4HeS6T5PR1qczlrwIKPErGe85vUnH498CDzjGqJKsOaHJRFFnxlg3rmwOw54hCGlLI/Q26ScDQxbuJR/CkF3yHt50UzN+Fi7O4t6uSvcFDRKazvihljM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850264; c=relaxed/simple;
	bh=2Tjc0QOogCo/4kQzZTpPjQ6b4nCJ+N3r0zfKuKeqt1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5tiP9nykS7M5KSGGEuObNyCsfxs8MFV905iXwomyHdZYKuvzI1IA1Fj0qpoHgmQD+v5GRVXBWaF6Lcv9Wtx63FcHph2n+6Qzg0ILqVSd7LLVsXhWkBPjJTCuMryz5P2cRY1SmWjn2UBJwFuHwXO87nYxxKowL4xlThJQ9nNUUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sv7BkpSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sv7BkpSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE09C116C6;
	Mon, 23 Feb 2026 12:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850264;
	bh=2Tjc0QOogCo/4kQzZTpPjQ6b4nCJ+N3r0zfKuKeqt1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sv7BkpSyZpVfLQD7tzPiWq7qspluasSRKCw4Bm6x8wY5KCrv5t5Kyk6G/Q1I3ha8R
	 jUnmZU+GlUx15fgmqwHv5xIk5CgaWKyQXCjPrP85dnkeQhQS5kCkX0XkglRrndiAfJ
	 fKrxZxvRoKRI6e55tfS+xSPS9v1s0YAZYFxIRwfjNEuYMqZcob+1sYmrYz7VR8LMTe
	 SWT+sZwwr0Otdlq24Je5nqPVqeifQGY9iqPYzp0iXLbSK8vS2k/QbfU9c5G8Im5y9r
	 tEBlCNXcFCdDYQyOULxPgErhc8VnD0xoLIhtxPzXkiHKvqdtb55Rf4Tea/Lkqi1YeP
	 bRMD+WKFWN6AQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Baojun Xu <baojun.xu@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ALSA: hda/tas2781: Ignore reset check for SPI device
Date: Mon, 23 Feb 2026 07:37:08 -0500
Message-ID: <20260223123738.1532940-3-sashal@kernel.org>
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

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 908ef80e31e4d3bd953a0088fe57640cd9ae7b3e ]

In the SPI driver probe, the device should be in the default state, so the
device status check is not necessary. It should be forced to do the
firmware download as I2C device.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20260211030946.2330-1-baojun.xu@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear picture. Let me complete my analysis.

## Analysis

### Commit Summary
This commit modifies the TAS2781 HDA **SPI** driver's
`tasdev_fw_ready()` function to skip reading the
`TAS2781_REG_CLK_CONFIG` register and comparing it against
`TAS2781_REG_CLK_CONFIG_RESET`. Instead, it unconditionally calls
`tasdevice_prmg_load()` to download firmware — matching the behavior of
the I2C counterpart.

### What the Change Does
**Before:** The SPI driver read the clock config register (`0x5c`) and
only loaded firmware if the value was `0x19` (the reset value). If the
register read failed or returned a different value, firmware would NOT
be loaded.

**After:** Firmware is always loaded unconditionally, which is the
correct behavior because during SPI probe the device is in its default
state — there's no reason to check.

### Bug Being Fixed
This is a **functional bug fix**. The conditional check was
inappropriate for the SPI probe path — if the register happened to read
a non-reset value (due to timing, prior partial initialization, or other
reasons), firmware download would be silently skipped, resulting in a
**non-functional audio device**. The I2C driver already does
unconditional firmware download correctly.

### Stable Kernel Criteria Assessment

**Fixes a real bug:** Yes — without this fix, TAS2781 SPI audio devices
may fail to load firmware during probe, rendering them non-functional.

**Small and contained:** Yes — the change is ~15 lines net, touching a
single function in a single file.

**Obviously correct:** Yes — it aligns the SPI behavior with the
established I2C behavior. The conditional check was unnecessary for the
SPI probe path.

**No new features:** Correct — this removes unnecessary conditional
logic, not adding features.

### Key Concern: Is this code even in stable trees?
The TAS2781 SPI driver was **first added in v6.14** (commit
`bb5f86ea50ffb`, dated 2024-12-16). Current active stable trees include:
- 6.12.y, 6.6.y, 6.1.y, 5.15.y, 5.10.y, 5.4.y — **none contain this
  driver**
- 6.14.y through 6.18.y — these would contain it (if they are still
  maintained as stable)

This significantly limits the backport scope. The driver only exists in
v6.14+.

### Risk Assessment
**Low risk.** The change removes a conditional check and makes firmware
download unconditional. This matches the I2C driver behavior which has
been working correctly. There's essentially zero regression risk — the
firmware load path was already tested and working; the only change is
removing the gate that could prevent it from running.

### Verification
- `git log --follow` confirmed the SPI driver file was first added in
  commit `bb5f86ea50ffb` (2024-12-16)
- `git tag --contains bb5f86ea50ffb` confirmed it first appeared in
  v6.14
- Subagent exploration confirmed the I2C driver (`tas2781_hda_i2c.c`)
  does NOT have the reset check — it always loads firmware
  unconditionally
- Subagent confirmed `TAS2781_REG_CLK_CONFIG = TASDEVICE_REG(0x0, 0x0,
  0x5c)` and `TAS2781_REG_CLK_CONFIG_RESET = 0x19` are defined locally
  in the SPI driver
- Subagent confirmed `tasdevice_prmg_load()` loads DSP firmware program
  data into the device — it's the core firmware download function
- Could NOT independently verify whether the bug was reported by users
  or discovered by code review (no Reported-by tag; commit message
  suggests developer-found issue)

### Conclusion
This fixes a real functional bug where TAS2781 SPI audio devices could
fail to load firmware during probe, but the driver only exists in
kernels v6.14+. For those stable trees that contain the SPI driver, the
fix is small, obviously correct, low-risk, and aligns behavior with the
well-tested I2C path. It's a reasonable backport for any maintained
stable tree containing v6.14+.

**YES**

 .../hda/codecs/side-codecs/tas2781_hda_spi.c  | 20 +++++++------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
index b9a55672bf15d..488e35dac9524 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
@@ -634,7 +634,7 @@ static void tasdev_fw_ready(const struct firmware *fmw, void *context)
 	struct tasdevice_priv *tas_priv = context;
 	struct tas2781_hda *tas_hda = dev_get_drvdata(tas_priv->dev);
 	struct hda_codec *codec = tas_priv->codec;
-	int ret, val;
+	int ret;
 
 	pm_runtime_get_sync(tas_priv->dev);
 	guard(mutex)(&tas_priv->codec_lock);
@@ -673,20 +673,14 @@ static void tasdev_fw_ready(const struct firmware *fmw, void *context)
 	tas_priv->rcabin.profile_cfg_id = 0;
 
 	tas_priv->fw_state = TASDEVICE_DSP_FW_ALL_OK;
-	ret = tasdevice_spi_dev_read(tas_priv, tas_priv->index,
-		TAS2781_REG_CLK_CONFIG, &val);
-	if (ret < 0)
-		goto out;
 
-	if (val == TAS2781_REG_CLK_CONFIG_RESET) {
-		ret = tasdevice_prmg_load(tas_priv, 0);
-		if (ret < 0) {
-			dev_err(tas_priv->dev, "FW download failed = %d\n",
-				ret);
-			goto out;
-		}
-		tas_priv->fw_state = TASDEVICE_DSP_FW_ALL_OK;
+	ret = tasdevice_prmg_load(tas_priv, 0);
+	if (ret < 0) {
+		dev_err(tas_priv->dev, "FW download failed = %d\n", ret);
+		goto out;
 	}
+	tas_priv->fw_state = TASDEVICE_DSP_FW_ALL_OK;
+
 	if (tas_priv->fmw->nr_programs > 0)
 		tas_priv->tasdevice[tas_priv->index].cur_prog = 0;
 	if (tas_priv->fmw->nr_configurations > 0)
-- 
2.51.0

