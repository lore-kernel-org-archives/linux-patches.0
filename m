Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5521CCB4B;
	Wed,  4 Jun 2025 00:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998336; cv=none; b=O7SzarHGpxRaJlL6cD7EYVdaMx8M9G77Hm24ZZ7PkaIGssYOioMKqZkWQqtQYDQMFnZDCF56ZYAv1zIq7BH4h2y8HPaFdPeqZAcFtQtjt2O9iz6dsqu4zEcofNtTDfLw8uR47U2gek4IudzpW0sWuwexpn2IgO+H5fZzHqjgTag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998336; c=relaxed/simple;
	bh=ZN9AF9DK4sfsbW4P396ilze9UhIc8JoMh1clH7zvHFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cUxpH5vyX+nSswZrKWOOdP3BZ9tgPPAcQ+JVLC1s49rRci/vpOj+NwIEHUSlqOaKb+gpCApPjeenPJsVBZaFawMIujUvYllwTQ7NQfCkJCnf2cCUxjlQZt1PdgXClZ89Y6dD+hX6T5bIjWWUKSigRI4vdIImdhwH8mecIOovazQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJEp/2c8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJEp/2c8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9637C4CEED;
	Wed,  4 Jun 2025 00:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998335;
	bh=ZN9AF9DK4sfsbW4P396ilze9UhIc8JoMh1clH7zvHFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJEp/2c8EkdSyL+0kXlSXlX3epmdNdrcQVEa1rvQic9BWoRsQUzLmpogyHWhyKq9y
	 MxOlFdKTziD5SNY+XdrY+/5cMJNlKfQaX5MiKKeQtxZti36BKcaQwwytUtjXMUyPE2
	 ctw+vFU8BY0pMGYwRKxFtDEe96swVsRCSMRh/cDiF74SclvGdTOLpSqt0WZ9s/wmIe
	 90ggx+P6pFrpKKQitouyXij8Ayw4QES15PtYaN2T5RmiUPnRCS6BcL+tne1seQAI1K
	 liIrYBz1ei/mJ+CeOjXM+KvmrUB8v0a83Q/Q574MRCElENMb+PUPFu6Rzoli1w23ib
	 i8lHfb4wzTnyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dimitri Fedrau <dima.fedrau@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 043/118] net: phy: marvell-88q2xxx: Enable temperature measurement in probe again
Date: Tue,  3 Jun 2025 20:49:34 -0400
Message-Id: <20250604005049.4147522-43-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: Dimitri Fedrau <dima.fedrau@gmail.com>

[ Upstream commit 10465365f3b094ba9a9795f212d13dee594bcfe7 ]

Enabling of the temperature sensor was moved from mv88q2xxx_hwmon_probe to
mv88q222x_config_init with the consequence that the sensor is only
usable when the PHY is configured. Enable the sensor in
mv88q2xxx_hwmon_probe as well to fix this.

Signed-off-by: Dimitri Fedrau <dima.fedrau@gmail.com>
Link: https://patch.msgid.link/20250512-marvell-88q2xxx-hwmon-enable-at-probe-v4-1-9256a5c8f603@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and the kernel repository context,
here is my assessment: **YES** ## Detailed Analysis ### Summary of the
Commit This commit addresses a functional regression where the
temperature sensor in Marvell 88Q2XXX PHY devices is only usable when
the PHY is configured. The fix implements a dual enablement strategy:
enabling the temperature sensor in both the probe phase
(`mv88q2xxx_hwmon_probe`) and the configuration phase
(`mv88q2xxx_config_init`). ### Code Changes Analysis 1. **Removal of
`enable_temp` field from private structure**: The commit removes the
`bool enable_temp` field from `struct mv88q2xxx_priv` because it's no
longer needed with the new approach. 2. **Introduction of
`mv88q2xxx_enable_temp_sense()` helper**: A new static function is added
that encapsulates the temperature sensor enablement, providing a clean
interface for both CONFIG_HWMON enabled and disabled builds. 3. **Dual
enablement strategy**: - **Probe phase** (line 731): Temperature sensor
is enabled during HWMON probe to ensure it works immediately when the
device is detected - **Config phase** (line 850): Temperature sensor is
re-enabled during PHY configuration with explicit comment explaining
this handles hardware resets 4. **Improved error handling**: The probe
function now properly handles and propagates errors from temperature
sensor enablement. ### Why This Should Be Backported 1. **Fixes a Real
Functional Issue**: The commit addresses a legitimate problem where
temperature monitoring becomes unavailable when PHYs are not configured,
which is problematic for automotive applications that rely on
temperature monitoring for thermal management. 2. **Hardware Reset
Robustness**: The dual enablement ensures that even after hardware
resets (via reset-gpios), the temperature sensor remains functional.
This is critical for systems using device tree reset configurations. 3.
**Small and Contained Change**: The modification is localized to the
temperature sensor functionality and doesn't introduce architectural
changes or affect other subsystems. 4. **Low Regression Risk**: - The
change is additive (enabling in both places) rather than moving
functionality - Maintains backward compatibility - No changes to
external APIs or user-visible behavior - Proper conditional compilation
for CONFIG_HWMON 5. **Clear Problem Statement**: The commit message
clearly identifies the issue ("sensor is only usable when the PHY is
configured") and provides a straightforward solution. 6. **Consistent
with Similar Fixes**: Looking at the similar commit history
(particularly commit #2 in the reference examples), this follows the
established pattern of addressing temperature sensor reset issues in PHY
drivers. ### Risk Assessment - **Low architectural impact**: Only
affects temperature sensor enablement logic - **Well-tested code path**:
Uses existing `phy_modify_mmd()` infrastructure - **No timing
dependencies**: Temperature sensor enablement is idempotent - **Clear
fallback**: Non-HWMON builds have proper stub implementation ###
Conclusion This commit represents a classic stable-tree candidate: it
fixes a clear functional regression with minimal code changes, low risk
of side effects, and addresses a real-world problem affecting automotive
Ethernet applications. The dual enablement approach is a robust
engineering solution that ensures temperature monitoring works
regardless of PHY configuration state or hardware reset scenarios.

 drivers/net/phy/marvell-88q2xxx.c | 103 +++++++++++++++++-------------
 1 file changed, 57 insertions(+), 46 deletions(-)

diff --git a/drivers/net/phy/marvell-88q2xxx.c b/drivers/net/phy/marvell-88q2xxx.c
index 23e1f0521f549..65f31d3c34810 100644
--- a/drivers/net/phy/marvell-88q2xxx.c
+++ b/drivers/net/phy/marvell-88q2xxx.c
@@ -119,7 +119,6 @@
 #define MV88Q2XXX_LED_INDEX_GPIO			1
 
 struct mv88q2xxx_priv {
-	bool enable_temp;
 	bool enable_led0;
 };
 
@@ -482,49 +481,6 @@ static int mv88q2xxx_config_aneg(struct phy_device *phydev)
 	return phydev->drv->soft_reset(phydev);
 }
 
-static int mv88q2xxx_config_init(struct phy_device *phydev)
-{
-	struct mv88q2xxx_priv *priv = phydev->priv;
-	int ret;
-
-	/* The 88Q2XXX PHYs do have the extended ability register available, but
-	 * register MDIO_PMA_EXTABLE where they should signalize it does not
-	 * work according to specification. Therefore, we force it here.
-	 */
-	phydev->pma_extable = MDIO_PMA_EXTABLE_BT1;
-
-	/* Configure interrupt with default settings, output is driven low for
-	 * active interrupt and high for inactive.
-	 */
-	if (phy_interrupt_is_valid(phydev)) {
-		ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS,
-				       MDIO_MMD_PCS_MV_GPIO_INT_CTRL,
-				       MDIO_MMD_PCS_MV_GPIO_INT_CTRL_TRI_DIS);
-		if (ret < 0)
-			return ret;
-	}
-
-	/* Enable LED function and disable TX disable feature on LED/TX_ENABLE */
-	if (priv->enable_led0) {
-		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PCS,
-					 MDIO_MMD_PCS_MV_RESET_CTRL,
-					 MDIO_MMD_PCS_MV_RESET_CTRL_TX_DISABLE);
-		if (ret < 0)
-			return ret;
-	}
-
-	/* Enable temperature sense */
-	if (priv->enable_temp) {
-		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS,
-				     MDIO_MMD_PCS_MV_TEMP_SENSOR2,
-				     MDIO_MMD_PCS_MV_TEMP_SENSOR2_DIS_MASK, 0);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-
 static int mv88q2xxx_get_sqi(struct phy_device *phydev)
 {
 	int ret;
@@ -667,6 +623,12 @@ static int mv88q2xxx_resume(struct phy_device *phydev)
 }
 
 #if IS_ENABLED(CONFIG_HWMON)
+static int mv88q2xxx_enable_temp_sense(struct phy_device *phydev)
+{
+	return phy_modify_mmd(phydev, MDIO_MMD_PCS, MDIO_MMD_PCS_MV_TEMP_SENSOR2,
+			      MDIO_MMD_PCS_MV_TEMP_SENSOR2_DIS_MASK, 0);
+}
+
 static const struct hwmon_channel_info * const mv88q2xxx_hwmon_info[] = {
 	HWMON_CHANNEL_INFO(temp, HWMON_T_INPUT | HWMON_T_MAX | HWMON_T_ALARM),
 	NULL
@@ -762,11 +724,13 @@ static const struct hwmon_chip_info mv88q2xxx_hwmon_chip_info = {
 
 static int mv88q2xxx_hwmon_probe(struct phy_device *phydev)
 {
-	struct mv88q2xxx_priv *priv = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	struct device *hwmon;
+	int ret;
 
-	priv->enable_temp = true;
+	ret = mv88q2xxx_enable_temp_sense(phydev);
+	if (ret < 0)
+		return ret;
 
 	hwmon = devm_hwmon_device_register_with_info(dev, NULL, phydev,
 						     &mv88q2xxx_hwmon_chip_info,
@@ -776,6 +740,11 @@ static int mv88q2xxx_hwmon_probe(struct phy_device *phydev)
 }
 
 #else
+static int mv88q2xxx_enable_temp_sense(struct phy_device *phydev)
+{
+	return 0;
+}
+
 static int mv88q2xxx_hwmon_probe(struct phy_device *phydev)
 {
 	return 0;
@@ -853,6 +822,48 @@ static int mv88q222x_probe(struct phy_device *phydev)
 	return mv88q2xxx_hwmon_probe(phydev);
 }
 
+static int mv88q2xxx_config_init(struct phy_device *phydev)
+{
+	struct mv88q2xxx_priv *priv = phydev->priv;
+	int ret;
+
+	/* The 88Q2XXX PHYs do have the extended ability register available, but
+	 * register MDIO_PMA_EXTABLE where they should signalize it does not
+	 * work according to specification. Therefore, we force it here.
+	 */
+	phydev->pma_extable = MDIO_PMA_EXTABLE_BT1;
+
+	/* Configure interrupt with default settings, output is driven low for
+	 * active interrupt and high for inactive.
+	 */
+	if (phy_interrupt_is_valid(phydev)) {
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS,
+				       MDIO_MMD_PCS_MV_GPIO_INT_CTRL,
+				       MDIO_MMD_PCS_MV_GPIO_INT_CTRL_TRI_DIS);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Enable LED function and disable TX disable feature on LED/TX_ENABLE */
+	if (priv->enable_led0) {
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PCS,
+					 MDIO_MMD_PCS_MV_RESET_CTRL,
+					 MDIO_MMD_PCS_MV_RESET_CTRL_TX_DISABLE);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Enable temperature sense again. There might have been a hard reset
+	 * of the PHY and in this case the register content is restored to
+	 * defaults and we need to enable it again.
+	 */
+	ret = mv88q2xxx_enable_temp_sense(phydev);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int mv88q2110_config_init(struct phy_device *phydev)
 {
 	int ret;
-- 
2.39.5

