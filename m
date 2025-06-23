Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CB84315A;
	Mon, 23 Jun 2025 21:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715002; cv=none; b=T0zVl5f/keKBjBnGm8kKEbPuH6q5vn5K4GPZhccq8FWLRgb4f8qtzwHUJRvZJUcTSJ4U6cZuO3PrLVPQPmVockFc49/f2z2L5vSF/wLjDzebz4ffoR3qYDpKBKaRkk4pd88GynIev8FZBnBnGfuOurZDuaw/08WM+rOW5bEPzts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715002; c=relaxed/simple;
	bh=aFaIY7F7zZFgQ1bhwqhH/3pMDH36+TxpZyTYmDN5/kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3m4TKkD13I4WPIJ50u/xIa1Am0uO2dBG7tgWR3aMR9vvhANoXFp+gW8Q2O+oyBHCe+7SZxS5Az8CicFuCxp0cMKAGcEQLb5vx5aI2yxoFkfUx12C0oYWXRBge/8vWcbgNtXTQCZM55cyqaw3qmaqpvqPcequCaJcAeKTEKImB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ml1AZWaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml1AZWaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90F8C4CEEA;
	Mon, 23 Jun 2025 21:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715002;
	bh=aFaIY7F7zZFgQ1bhwqhH/3pMDH36+TxpZyTYmDN5/kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ml1AZWaIKMBToplj5u8+pzp7PeVfTFP3+qrCGiCyLf2Ovdl/pEEC2jtO3Pc+IYXRE
	 D3wk/kFxQhKxO/CtZCHrdVeJtYHnNCXHJf6DXwBHLdxEkzMWvJujELBG0sBqcJbqIW
	 OAwfGRU24PMWT3umo3vES6pyaT1PjlnBEQG8sZ6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Amit Kucheria <amitk@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/355] thermal/drivers/qcom/tsens: Update conditions to strictly evaluate for IP v2+
Date: Mon, 23 Jun 2025 15:07:27 +0200
Message-ID: <20250623130634.144255171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c73792ca727a1..38492dbd60f3c 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -264,7 +264,7 @@ static void tsens_set_interrupt(struct tsens_priv *priv, u32 hw_id,
 	dev_dbg(priv->dev, "[%u] %s: %s -> %s\n", hw_id, __func__,
 		irq_type ? ((irq_type == 1) ? "UP" : "CRITICAL") : "LOW",
 		enable ? "en" : "dis");
-	if (tsens_version(priv) > VER_1_X)
+	if (tsens_version(priv) >= VER_2_X)
 		tsens_set_interrupt_v2(priv, hw_id, irq_type, enable);
 	else
 		tsens_set_interrupt_v1(priv, hw_id, irq_type, enable);
@@ -316,7 +316,7 @@ static int tsens_read_irq_state(struct tsens_priv *priv, u32 hw_id,
 	ret = regmap_field_read(priv->rf[LOW_INT_CLEAR_0 + hw_id], &d->low_irq_clear);
 	if (ret)
 		return ret;
-	if (tsens_version(priv) > VER_1_X) {
+	if (tsens_version(priv) >= VER_2_X) {
 		ret = regmap_field_read(priv->rf[UP_INT_MASK_0 + hw_id], &d->up_irq_mask);
 		if (ret)
 			return ret;
@@ -360,7 +360,7 @@ static int tsens_read_irq_state(struct tsens_priv *priv, u32 hw_id,
 
 static inline u32 masked_irq(u32 hw_id, u32 mask, enum tsens_ver ver)
 {
-	if (ver > VER_1_X)
+	if (ver >= VER_2_X)
 		return mask & (1 << hw_id);
 
 	/* v1, v0.1 don't have a irq mask register */
@@ -560,7 +560,7 @@ static int tsens_set_trips(void *_sensor, int low, int high)
 static int tsens_enable_irq(struct tsens_priv *priv)
 {
 	int ret;
-	int val = tsens_version(priv) > VER_1_X ? 7 : 1;
+	int val = tsens_version(priv) >= VER_2_X ? 7 : 1;
 
 	ret = regmap_field_write(priv->rf[INT_EN], val);
 	if (ret < 0)
@@ -826,7 +826,7 @@ int __init init_common(struct tsens_priv *priv)
 		}
 	}
 
-	if (tsens_version(priv) > VER_1_X &&  ver_minor > 2) {
+	if (tsens_version(priv) >= VER_2_X &&  ver_minor > 2) {
 		/* Watchdog is present only on v2.3+ */
 		priv->feat->has_watchdog = 1;
 		for (i = WDOG_BARK_STATUS; i <= CC_MON_MASK; i++) {
-- 
2.39.5



