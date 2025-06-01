Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73007324361;
	Sun,  1 Jun 2025 23:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821329; cv=none; b=SSvxcip4rDwoCP8MP2FMwX5KHOZwYjmVuL0+9QK45H69Vng2AuXIYm0PY6aloOdBFkuum4qFJ2R+ByKJDRmFQEbRt6ZgAiR+ceJhqYuy7LXz4K3IuCSkmEG8ilOiQMDVZPvFx5irAw4pVHgb6Uf+tzIcgut8rb7J4KzvXUwaoPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821329; c=relaxed/simple;
	bh=zUfq0zFpOPmCH2FwqFhbmCTHG6iP26/GpUSnxPwZZkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fk6lnk00k4OmOJybE9aiUW1E1piugwRt9RwqNCfSebTsOxQJe2enzi6rokntcm6K7G8iskgxOtJrQkfRMNbxbc/LAnPJwvdgAY5bIJcb3k2/HA8dlk8xfuYkgNIXTVohUXFlZg/+iVsuVb9TCOMpTGFr3tIYd5YfHQyo3J2eJzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTCZ/Yxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTCZ/Yxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6A9C4CEEE;
	Sun,  1 Jun 2025 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821329;
	bh=zUfq0zFpOPmCH2FwqFhbmCTHG6iP26/GpUSnxPwZZkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTCZ/Yxlpvp+v7qtPgq9puOp08PrF5Bo6WiH8wwvGmMxFfChXQS3pXaMVdXN1sNaH
	 kNh/FoF18dR2iTll9eu/FssHWQjM8IV+UW195P/jEXAWcLV88Y9zxnKcRheQZPxHil
	 DUueniU/BVTV9lisHvpwJzbUJudBsNCpZTXpoetUr10Lv8WqOfCKZfCYMZHD9UDJ4/
	 KWlSuLl+6jiTKqLczAOFMoanxvrMstUE8pNSspldeW+Pt2NyQsS2O0NUiemLu7m8dh
	 BuuB8OVCeWZdADdUdV962ToyZCtsewLZ8VaBaWKSEQzX4BSq3QV2AnqGGcX8uYhOSC
	 kNhb05DITJgzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	avri.altman@wdc.com,
	keita.aihara@sony.com,
	dsimic@manjaro.org,
	jonathan@raspberrypi.com,
	wsa+renesas@sang-engineering.com,
	victor.shih@genesyslogic.com.tw,
	cw9316.lee@samsung.com,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 50/58] mmc: Add quirk to disable DDR50 tuning
Date: Sun,  1 Jun 2025 19:40:03 -0400
Message-Id: <20250601234012.3516352-50-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601234012.3516352-1-sashal@kernel.org>
References: <20250601234012.3516352-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Transfer-Encoding: 8bit

From: Erick Shepherd <erick.shepherd@ni.com>

[ Upstream commit 9510b38dc0ba358c93cbf5ee7c28820afb85937b ]

Adds the MMC_QUIRK_NO_UHS_DDR50_TUNING quirk and updates
mmc_execute_tuning() to return 0 if that quirk is set. This fixes an
issue on certain Swissbit SD cards that do not support DDR50 tuning
where tuning requests caused I/O errors to be thrown.

Signed-off-by: Erick Shepherd <erick.shepherd@ni.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250331221337.1414534-1-erick.shepherd@ni.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees based on
the following detailed analysis: ## Critical Hardware Compatibility Fix
The commit addresses a specific and serious hardware compatibility issue
where certain Swissbit SD cards (series S46-u, manufactured 01/2019)
throw I/O errors during DDR50 tuning requests, particularly on Bay Trail
host controllers. This represents a real-world deployed hardware issue
that causes system instability. ## Code Analysis - Low Risk, High Impact
**1. Minimal and Targeted Changes:** - Adds a single quirk bit
(`MMC_QUIRK_NO_UHS_DDR50_TUNING`) in `include/linux/mmc/card.h` -
Introduces a simple helper function `mmc_card_no_uhs_ddr50_tuning()` in
`drivers/mmc/core/card.h` - Adds one specific quirk entry for the
problematic Swissbit cards in `drivers/mmc/core/quirks.h` - Modifies the
tuning logic in `drivers/mmc/core/sd.c` to respect the new quirk **2.
Functional Impact Analysis:** The key change is in the
`mmc_sd_use_tuning()` function where DDR50 tuning can now be disabled:
```c case MMC_TIMING_UHS_DDR50: return
!mmc_card_no_uhs_ddr50_tuning(card); ``` This change ensures that: -
DDR50 mode still functions normally - Only the tuning optimization is
disabled - Cards fall back to fixed sampling clock (still functional) -
No loss of core functionality, only slight performance optimization loss
**3. Risk Assessment:** - **Very Low Risk**: The quirk only disables
tuning optimization, not DDR50 functionality itself - **Highly
Targeted**: Affects only very specific cards (Swissbit 0016G,
manufactured 2019/01) - **Maintains Compatibility**: Cards remain fully
functional in DDR50 mode without tuning - **No Regression Potential**:
Other cards are completely unaffected ## Alignment with Stable Backport
Criteria **1. Important Bugfix**: Resolves I/O errors and system
instability on deployed hardware **2. Minimal Risk**: Only disables
optimization feature, maintains full functionality **3. Small and
Contained**: Changes are isolated to the MMC quirk system **4. No
Architectural Changes**: Uses existing quirk infrastructure **5. Clear
User Impact**: Fixes real-world hardware compatibility issues ##
Historical Pattern Consistency This commit follows the same pattern as
other successful stable backports in the MMC subsystem (like Similar
Commit #2 and #5 marked "YES"), which address specific hardware quirks
with minimal, targeted fixes that resolve compatibility issues without
introducing new functionality or architectural changes. The commit
represents exactly the type of hardware compatibility fix that stable
kernel trees are designed to accommodate - resolving real issues on
deployed hardware with minimal risk and maximal benefit.

 drivers/mmc/core/card.h   |  6 ++++++
 drivers/mmc/core/quirks.h | 10 ++++++++++
 drivers/mmc/core/sd.c     | 32 ++++++++++++++++++++++++--------
 include/linux/mmc/card.h  |  1 +
 4 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/core/card.h b/drivers/mmc/core/card.h
index 8476754b1b170..fe0b2fa3bb89d 100644
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -86,6 +86,7 @@ struct mmc_fixup {
 #define CID_MANFID_MICRON       0x13
 #define CID_MANFID_SAMSUNG      0x15
 #define CID_MANFID_APACER       0x27
+#define CID_MANFID_SWISSBIT     0x5D
 #define CID_MANFID_KINGSTON     0x70
 #define CID_MANFID_HYNIX	0x90
 #define CID_MANFID_KINGSTON_SD	0x9F
@@ -291,4 +292,9 @@ static inline int mmc_card_broken_sd_poweroff_notify(const struct mmc_card *c)
 	return c->quirks & MMC_QUIRK_BROKEN_SD_POWEROFF_NOTIFY;
 }
 
+static inline int mmc_card_no_uhs_ddr50_tuning(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_NO_UHS_DDR50_TUNING;
+}
+
 #endif
diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index 12c90b567ce38..d05f220fdeee3 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -34,6 +34,16 @@ static const struct mmc_fixup __maybe_unused mmc_sd_fixups[] = {
 		   MMC_QUIRK_BROKEN_SD_CACHE | MMC_QUIRK_BROKEN_SD_POWEROFF_NOTIFY,
 		   EXT_CSD_REV_ANY),
 
+	/*
+	 * Swissbit series S46-u cards throw I/O errors during tuning requests
+	 * after the initial tuning request expectedly times out. This has
+	 * only been observed on cards manufactured on 01/2019 that are using
+	 * Bay Trail host controllers.
+	 */
+	_FIXUP_EXT("0016G", CID_MANFID_SWISSBIT, 0x5342, 2019, 1,
+		   0, -1ull, SDIO_ANY_ID, SDIO_ANY_ID, add_quirk_sd,
+		   MMC_QUIRK_NO_UHS_DDR50_TUNING, EXT_CSD_REV_ANY),
+
 	END_FIXUP
 };
 
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 819af50ae175c..557c4ee1e2770 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -618,6 +618,29 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
 	return 0;
 }
 
+/*
+ * Determine if the card should tune or not.
+ */
+static bool mmc_sd_use_tuning(struct mmc_card *card)
+{
+	/*
+	 * SPI mode doesn't define CMD19 and tuning is only valid for SDR50 and
+	 * SDR104 mode SD-cards. Note that tuning is mandatory for SDR104.
+	 */
+	if (mmc_host_is_spi(card->host))
+		return false;
+
+	switch (card->host->ios.timing) {
+	case MMC_TIMING_UHS_SDR50:
+	case MMC_TIMING_UHS_SDR104:
+		return true;
+	case MMC_TIMING_UHS_DDR50:
+		return !mmc_card_no_uhs_ddr50_tuning(card);
+	}
+
+	return false;
+}
+
 /*
  * UHS-I specific initialization procedure
  */
@@ -661,14 +684,7 @@ static int mmc_sd_init_uhs_card(struct mmc_card *card)
 	if (err)
 		goto out;
 
-	/*
-	 * SPI mode doesn't define CMD19 and tuning is only valid for SDR50 and
-	 * SDR104 mode SD-cards. Note that tuning is mandatory for SDR104.
-	 */
-	if (!mmc_host_is_spi(card->host) &&
-		(card->host->ios.timing == MMC_TIMING_UHS_SDR50 ||
-		 card->host->ios.timing == MMC_TIMING_UHS_DDR50 ||
-		 card->host->ios.timing == MMC_TIMING_UHS_SDR104)) {
+	if (mmc_sd_use_tuning(card)) {
 		err = mmc_execute_tuning(card);
 
 		/*
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index afa575e362a47..7c6da19fff9f0 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -297,6 +297,7 @@ struct mmc_card {
 #define MMC_QUIRK_BROKEN_SD_CACHE	(1<<15)	/* Disable broken SD cache support */
 #define MMC_QUIRK_BROKEN_CACHE_FLUSH	(1<<16)	/* Don't flush cache until the write has occurred */
 #define MMC_QUIRK_BROKEN_SD_POWEROFF_NOTIFY	(1<<17) /* Disable broken SD poweroff notify support */
+#define MMC_QUIRK_NO_UHS_DDR50_TUNING	(1<<18) /* Disable DDR50 tuning */
 
 	bool			written_flag;	/* Indicates eMMC has been written since power on */
 	bool			reenable_cmdq;	/* Re-enable Command Queue */
-- 
2.39.5

