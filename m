Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8567A4409;
	Mon, 23 Jun 2025 22:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716110; cv=none; b=gqyEmhhBQfbTioGk3OJxHXo9opXbtKiTyqyjm45dUYX8q1yeoInHc1bNSuyM8iOAOg/3JCEUgYaIw0gnzp6nHz55vHhfbWGLG3kbOeaBsDAAhM07NAwZoO30T1ZctPhNRH5z+6nP0EN6BngV56SkmIiSA/enKLexKchmupthd+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716110; c=relaxed/simple;
	bh=7VE0Zeklh5c3lYi2c0X8grIREMOqapSBKf/ADdH1vAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YckE01T3CBwEi9+15zvbedBeVWAMQxOTnp8w2momUbUsDfUPkX30uAztiDPGRX4vCE5csDnNidYCiAAodzK20uOtw9T1i4vYru4+VYYtGiMhW2jqGCJiZHIVL4k/9ACNHdxKoVDV6ApoDq1p2zbR1RxH6z9e4uBwEoWcC2ktRXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2z6z6np; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2z6z6np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A878C4CEEA;
	Mon, 23 Jun 2025 22:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716110;
	bh=7VE0Zeklh5c3lYi2c0X8grIREMOqapSBKf/ADdH1vAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2z6z6npyHO3+NatlDrGO+Avnb8xmsahu75vB+4Mn3aveUEY7Tz2dIGfmzSzMxA3N
	 Og5w/zJ0GJXRAwdQ4tfPCpJ3MzsTRcpka6bKiXtkALdqboi+XzRFS4KfnNtum+Gu2n
	 maIipEaF3YOzhf1ZfqJOyvp6EUpM5a+dV6r9q7ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Amit Kucheria <amitk@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/411] thermal/drivers/qcom/tsens: Update conditions to strictly evaluate for IP v2+
Date: Mon, 23 Jun 2025 15:07:27 +0200
Message-ID: <20250623130641.274223555@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit e3f90f167a49902cda2408f7e91cca0dcfd5040a ]

TSENS v2.0+ leverage features not available to prior versions such as
updated interrupts init routine, masked interrupts, and watchdog.
Currently, the checks in place evaluate whether the IP version is greater
than v1 which invalidates when updates to v1 or v1 minor versions are
implemented. As such, update the conditional statements to strictly
evaluate whether the version is greater than or equal to v2 (inclusive).

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Amit Kucheria <amitk@kernel.org>
Link: https://lore.kernel.org/r/DS7PR19MB8883434CAA053648E22AA8AC9DCC2@DS7PR19MB8883.namprd19.prod.outlook.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index 2f31129cd5471..21f980464e71b 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -266,7 +266,7 @@ static void tsens_set_interrupt(struct tsens_priv *priv, u32 hw_id,
 	dev_dbg(priv->dev, "[%u] %s: %s -> %s\n", hw_id, __func__,
 		irq_type ? ((irq_type == 1) ? "UP" : "CRITICAL") : "LOW",
 		enable ? "en" : "dis");
-	if (tsens_version(priv) > VER_1_X)
+	if (tsens_version(priv) >= VER_2_X)
 		tsens_set_interrupt_v2(priv, hw_id, irq_type, enable);
 	else
 		tsens_set_interrupt_v1(priv, hw_id, irq_type, enable);
@@ -318,7 +318,7 @@ static int tsens_read_irq_state(struct tsens_priv *priv, u32 hw_id,
 	ret = regmap_field_read(priv->rf[LOW_INT_CLEAR_0 + hw_id], &d->low_irq_clear);
 	if (ret)
 		return ret;
-	if (tsens_version(priv) > VER_1_X) {
+	if (tsens_version(priv) >= VER_2_X) {
 		ret = regmap_field_read(priv->rf[UP_INT_MASK_0 + hw_id], &d->up_irq_mask);
 		if (ret)
 			return ret;
@@ -362,7 +362,7 @@ static int tsens_read_irq_state(struct tsens_priv *priv, u32 hw_id,
 
 static inline u32 masked_irq(u32 hw_id, u32 mask, enum tsens_ver ver)
 {
-	if (ver > VER_1_X)
+	if (ver >= VER_2_X)
 		return mask & (1 << hw_id);
 
 	/* v1, v0.1 don't have a irq mask register */
@@ -578,7 +578,7 @@ static int tsens_set_trips(void *_sensor, int low, int high)
 static int tsens_enable_irq(struct tsens_priv *priv)
 {
 	int ret;
-	int val = tsens_version(priv) > VER_1_X ? 7 : 1;
+	int val = tsens_version(priv) >= VER_2_X ? 7 : 1;
 
 	ret = regmap_field_write(priv->rf[INT_EN], val);
 	if (ret < 0)
@@ -892,7 +892,7 @@ int __init init_common(struct tsens_priv *priv)
 		}
 	}
 
-	if (tsens_version(priv) > VER_1_X &&  ver_minor > 2) {
+	if (tsens_version(priv) >= VER_2_X &&  ver_minor > 2) {
 		/* Watchdog is present only on v2.3+ */
 		priv->feat->has_watchdog = 1;
 		for (i = WDOG_BARK_STATUS; i <= CC_MON_MASK; i++) {
-- 
2.39.5



