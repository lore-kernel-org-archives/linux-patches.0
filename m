Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054673;
	b=RejJcci9FUAfRN2g121A2DTMFD2U1ujzgnpfi3F7BjtH92ECWfD8ZbZ1WT5MGi5c5xEN
	 CttG71w8S+S3n44R3RoxVO6cdioxvoW5jvOHfnQA3lOSCEksBbaTUbFjIQlnAuTuLZiYY
	 XvyJpfzdYUzVSy83ZGVW2S/tPJJbEBxGUNAswbDulUlAdpGAR+TmNBf17hVDx7HN8aumc
	 0SiwVOdN30uuUqH/0bLNJ8fTEx//zTEH2+5iomH5lUxXUs4RfM7xYGs8Sdv9tUbfaBsbL
	 Hq4JTtniccd0mt+Zor9PwCIheIMLDMD5hVJa4MsQzYgrWTapvbFPw233yGkY7eVaWoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qePf16wgf2dQI30B9/BCsWmbRMyFhTxr60Tn0ruQKQI=;
	b=kRovoPYF3IYmyb76JSf5Fs1fc04wXG36zG1OugcKhjkbnk/Bb7Ud71YEwKcYZUpIP1qm
	 mlkE/MDvOQTnV4+NRBn4ouERYNvbMvOOIlDyssd7iI4hQmOxX2Phy2Q/GQEbpo3qWGG9n
	 LLBD6UiEeKvR978XEBbikky3TCHz6xoSYo8Cf+Dcq+JblZkH1rxPOvQOkPvWyH9IqZ2fo
	 3UjlGYdE11oOUIJuO8VOqqseMFlNuXNZzJNzy/00W8hJCRMCcLTob8VVydN6irfiP6rm5
	 tMuCGY8ZfzhM6kqObFRTxkPgP3e/Wr9DhMbTkSB5/9CEQC8T0FPvUudd+9HElBnSWRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KZJIQq/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F7E606A31C;
	Thu, 19 Nov 2026 02:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KZJIQq/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9041F000C4;
	Thu, 19 Nov 2026 02:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054673;
	bh=qePf16wgf2dQI30B9/BCsWmbRMyFhTxr60Tn0ruQKQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZJIQq/LZUOCKsso/tUuRgyHKtya/8M9hnO4EQGiO8PflIIbm+6oATzDlBi4MSjyZ
	 kaeOUidQQ4hQJPYuPEy1OKSZ9J5lRrBLz3I1x+O1CIOI+l72qHplDVmAvXJRvtEjE5
	 Y2IbK+jd3N5nB82pyPisWWTTyO3Q58MF14rd0BCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1358/2214] pwm: renesas-tpu: Rename variables to match the usual naming
Date: Wed, 18 Nov 2026 15:50:34 +0100
Message-ID: <20261118150105.740359420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 208ab8676b9c787b4285364fcb52a159f94b861d ]

The driver used "pwm" for struct tpu_pwm_device pointers. This name is
usually only used for struct pwm_device pointers which this driver calls
"_pwm". So rename to the driver data pointers to "tpd" which then allows
to drop the underscore from "_pwm".

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 62cff15fbf2b ("pwm: renesas-tpu: Fix runtime PM reference leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-renesas-tpu.c | 172 +++++++++++++++++-----------------
 1 file changed, 86 insertions(+), 86 deletions(-)

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index 0d2e87132d212..ee56d28e55b8e 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -89,71 +89,71 @@ struct tpu_device {
 
 #define to_tpu_device(c)	container_of(c, struct tpu_device, chip)
 
-static void tpu_pwm_write(struct tpu_pwm_device *pwm, int reg_nr, u16 value)
+static void tpu_pwm_write(struct tpu_pwm_device *tpd, int reg_nr, u16 value)
 {
-	void __iomem *base = pwm->tpu->base + TPU_CHANNEL_OFFSET
-			   + pwm->channel * TPU_CHANNEL_SIZE;
+	void __iomem *base = tpd->tpu->base + TPU_CHANNEL_OFFSET
+			   + tpd->channel * TPU_CHANNEL_SIZE;
 
 	iowrite16(value, base + reg_nr);
 }
 
-static void tpu_pwm_set_pin(struct tpu_pwm_device *pwm,
+static void tpu_pwm_set_pin(struct tpu_pwm_device *tpd,
 			    enum tpu_pin_state state)
 {
 	static const char * const states[] = { "inactive", "PWM", "active" };
 
-	dev_dbg(&pwm->tpu->pdev->dev, "%u: configuring pin as %s\n",
-		pwm->channel, states[state]);
+	dev_dbg(&tpd->tpu->pdev->dev, "%u: configuring pin as %s\n",
+		tpd->channel, states[state]);
 
 	switch (state) {
 	case TPU_PIN_INACTIVE:
-		tpu_pwm_write(pwm, TPU_TIORn,
-			      pwm->polarity == PWM_POLARITY_INVERSED ?
+		tpu_pwm_write(tpd, TPU_TIORn,
+			      tpd->polarity == PWM_POLARITY_INVERSED ?
 			      TPU_TIOR_IOA_1 : TPU_TIOR_IOA_0);
 		break;
 	case TPU_PIN_PWM:
-		tpu_pwm_write(pwm, TPU_TIORn,
-			      pwm->polarity == PWM_POLARITY_INVERSED ?
+		tpu_pwm_write(tpd, TPU_TIORn,
+			      tpd->polarity == PWM_POLARITY_INVERSED ?
 			      TPU_TIOR_IOA_0_SET : TPU_TIOR_IOA_1_CLR);
 		break;
 	case TPU_PIN_ACTIVE:
-		tpu_pwm_write(pwm, TPU_TIORn,
-			      pwm->polarity == PWM_POLARITY_INVERSED ?
+		tpu_pwm_write(tpd, TPU_TIORn,
+			      tpd->polarity == PWM_POLARITY_INVERSED ?
 			      TPU_TIOR_IOA_0 : TPU_TIOR_IOA_1);
 		break;
 	}
 }
 
-static void tpu_pwm_start_stop(struct tpu_pwm_device *pwm, int start)
+static void tpu_pwm_start_stop(struct tpu_pwm_device *tpd, int start)
 {
 	unsigned long flags;
 	u16 value;
 
-	spin_lock_irqsave(&pwm->tpu->lock, flags);
-	value = ioread16(pwm->tpu->base + TPU_TSTR);
+	spin_lock_irqsave(&tpd->tpu->lock, flags);
+	value = ioread16(tpd->tpu->base + TPU_TSTR);
 
 	if (start)
-		value |= 1 << pwm->channel;
+		value |= 1 << tpd->channel;
 	else
-		value &= ~(1 << pwm->channel);
+		value &= ~(1 << tpd->channel);
 
-	iowrite16(value, pwm->tpu->base + TPU_TSTR);
-	spin_unlock_irqrestore(&pwm->tpu->lock, flags);
+	iowrite16(value, tpd->tpu->base + TPU_TSTR);
+	spin_unlock_irqrestore(&tpd->tpu->lock, flags);
 }
 
-static int tpu_pwm_timer_start(struct tpu_pwm_device *pwm)
+static int tpu_pwm_timer_start(struct tpu_pwm_device *tpd)
 {
 	int ret;
 
-	if (!pwm->timer_on) {
+	if (!tpd->timer_on) {
 		/* Wake up device and enable clock. */
-		pm_runtime_get_sync(&pwm->tpu->pdev->dev);
-		ret = clk_prepare_enable(pwm->tpu->clk);
+		pm_runtime_get_sync(&tpd->tpu->pdev->dev);
+		ret = clk_prepare_enable(tpd->tpu->clk);
 		if (ret) {
-			dev_err(&pwm->tpu->pdev->dev, "cannot enable clock\n");
+			dev_err(&tpd->tpu->pdev->dev, "cannot enable clock\n");
 			return ret;
 		}
-		pwm->timer_on = true;
+		tpd->timer_on = true;
 	}
 
 	/*
@@ -161,8 +161,8 @@ static int tpu_pwm_timer_start(struct tpu_pwm_device *pwm)
 	 * completely. First drive the pin to the inactive state to avoid
 	 * glitches.
 	 */
-	tpu_pwm_set_pin(pwm, TPU_PIN_INACTIVE);
-	tpu_pwm_start_stop(pwm, false);
+	tpu_pwm_set_pin(tpd, TPU_PIN_INACTIVE);
+	tpu_pwm_start_stop(tpd, false);
 
 	/*
 	 * - Clear TCNT on TGRB match
@@ -172,80 +172,80 @@ static int tpu_pwm_timer_start(struct tpu_pwm_device *pwm)
 	 * - Output 1 until TGRA, output 0 until TGRB (active high polarity
 	 * - PWM mode
 	 */
-	tpu_pwm_write(pwm, TPU_TCRn, TPU_TCR_CCLR_TGRB | TPU_TCR_CKEG_RISING |
-		      pwm->prescaler);
-	tpu_pwm_write(pwm, TPU_TMDRn, TPU_TMDR_MD_PWM);
-	tpu_pwm_set_pin(pwm, TPU_PIN_PWM);
-	tpu_pwm_write(pwm, TPU_TGRAn, pwm->duty);
-	tpu_pwm_write(pwm, TPU_TGRBn, pwm->period);
+	tpu_pwm_write(tpd, TPU_TCRn, TPU_TCR_CCLR_TGRB | TPU_TCR_CKEG_RISING |
+		      tpd->prescaler);
+	tpu_pwm_write(tpd, TPU_TMDRn, TPU_TMDR_MD_PWM);
+	tpu_pwm_set_pin(tpd, TPU_PIN_PWM);
+	tpu_pwm_write(tpd, TPU_TGRAn, tpd->duty);
+	tpu_pwm_write(tpd, TPU_TGRBn, tpd->period);
 
-	dev_dbg(&pwm->tpu->pdev->dev, "%u: TGRA 0x%04x TGRB 0x%04x\n",
-		pwm->channel, pwm->duty, pwm->period);
+	dev_dbg(&tpd->tpu->pdev->dev, "%u: TGRA 0x%04x TGRB 0x%04x\n",
+		tpd->channel, tpd->duty, tpd->period);
 
 	/* Start the channel. */
-	tpu_pwm_start_stop(pwm, true);
+	tpu_pwm_start_stop(tpd, true);
 
 	return 0;
 }
 
-static void tpu_pwm_timer_stop(struct tpu_pwm_device *pwm)
+static void tpu_pwm_timer_stop(struct tpu_pwm_device *tpd)
 {
-	if (!pwm->timer_on)
+	if (!tpd->timer_on)
 		return;
 
 	/* Disable channel. */
-	tpu_pwm_start_stop(pwm, false);
+	tpu_pwm_start_stop(tpd, false);
 
 	/* Stop clock and mark device as idle. */
-	clk_disable_unprepare(pwm->tpu->clk);
-	pm_runtime_put(&pwm->tpu->pdev->dev);
+	clk_disable_unprepare(tpd->tpu->clk);
+	pm_runtime_put(&tpd->tpu->pdev->dev);
 
-	pwm->timer_on = false;
+	tpd->timer_on = false;
 }
 
 /* -----------------------------------------------------------------------------
  * PWM API
  */
 
-static int tpu_pwm_request(struct pwm_chip *chip, struct pwm_device *_pwm)
+static int tpu_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct tpu_device *tpu = to_tpu_device(chip);
-	struct tpu_pwm_device *pwm;
+	struct tpu_pwm_device *tpd;
 
-	if (_pwm->hwpwm >= TPU_CHANNEL_MAX)
+	if (pwm->hwpwm >= TPU_CHANNEL_MAX)
 		return -EINVAL;
 
-	pwm = kzalloc(sizeof(*pwm), GFP_KERNEL);
-	if (pwm == NULL)
+	tpd = kzalloc(sizeof(*tpd), GFP_KERNEL);
+	if (tpd == NULL)
 		return -ENOMEM;
 
-	pwm->tpu = tpu;
-	pwm->channel = _pwm->hwpwm;
-	pwm->polarity = PWM_POLARITY_NORMAL;
-	pwm->prescaler = 0;
-	pwm->period = 0;
-	pwm->duty = 0;
+	tpd->tpu = tpu;
+	tpd->channel = pwm->hwpwm;
+	tpd->polarity = PWM_POLARITY_NORMAL;
+	tpd->prescaler = 0;
+	tpd->period = 0;
+	tpd->duty = 0;
 
-	pwm->timer_on = false;
+	tpd->timer_on = false;
 
-	pwm_set_chip_data(_pwm, pwm);
+	pwm_set_chip_data(pwm, tpd);
 
 	return 0;
 }
 
-static void tpu_pwm_free(struct pwm_chip *chip, struct pwm_device *_pwm)
+static void tpu_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct tpu_pwm_device *pwm = pwm_get_chip_data(_pwm);
+	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
 
-	tpu_pwm_timer_stop(pwm);
-	kfree(pwm);
+	tpu_pwm_timer_stop(tpd);
+	kfree(tpd);
 }
 
-static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *_pwm,
+static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			  int duty_ns, int period_ns, bool enabled)
 {
 	static const unsigned int prescalers[] = { 1, 4, 16, 64 };
-	struct tpu_pwm_device *pwm = pwm_get_chip_data(_pwm);
+	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
 	struct tpu_device *tpu = to_tpu_device(chip);
 	unsigned int prescaler;
 	bool duty_only = false;
@@ -285,29 +285,29 @@ static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *_pwm,
 		"rate %u, prescaler %u, period %u, duty %u\n",
 		clk_rate, prescalers[prescaler], period, duty);
 
-	if (pwm->prescaler == prescaler && pwm->period == period)
+	if (tpd->prescaler == prescaler && tpd->period == period)
 		duty_only = true;
 
-	pwm->prescaler = prescaler;
-	pwm->period = period;
-	pwm->duty = duty;
+	tpd->prescaler = prescaler;
+	tpd->period = period;
+	tpd->duty = duty;
 
 	/* If the channel is disabled we're done. */
 	if (!enabled)
 		return 0;
 
-	if (duty_only && pwm->timer_on) {
+	if (duty_only && tpd->timer_on) {
 		/*
 		 * If only the duty cycle changed and the timer is already
 		 * running, there's no need to reconfigure it completely, Just
 		 * modify the duty cycle.
 		 */
-		tpu_pwm_write(pwm, TPU_TGRAn, pwm->duty);
-		dev_dbg(&tpu->pdev->dev, "%u: TGRA 0x%04x\n", pwm->channel,
-			pwm->duty);
+		tpu_pwm_write(tpd, TPU_TGRAn, tpd->duty);
+		dev_dbg(&tpu->pdev->dev, "%u: TGRA 0x%04x\n", tpd->channel,
+			tpd->duty);
 	} else {
 		/* Otherwise perform a full reconfiguration. */
-		ret = tpu_pwm_timer_start(pwm);
+		ret = tpu_pwm_timer_start(tpd);
 		if (ret < 0)
 			return ret;
 	}
@@ -317,29 +317,29 @@ static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *_pwm,
 		 * To avoid running the timer when not strictly required, handle
 		 * 0% and 100% duty cycles as fixed levels and stop the timer.
 		 */
-		tpu_pwm_set_pin(pwm, duty ? TPU_PIN_ACTIVE : TPU_PIN_INACTIVE);
-		tpu_pwm_timer_stop(pwm);
+		tpu_pwm_set_pin(tpd, duty ? TPU_PIN_ACTIVE : TPU_PIN_INACTIVE);
+		tpu_pwm_timer_stop(tpd);
 	}
 
 	return 0;
 }
 
-static int tpu_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *_pwm,
+static int tpu_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 				enum pwm_polarity polarity)
 {
-	struct tpu_pwm_device *pwm = pwm_get_chip_data(_pwm);
+	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
 
-	pwm->polarity = polarity;
+	tpd->polarity = polarity;
 
 	return 0;
 }
 
-static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *_pwm)
+static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct tpu_pwm_device *pwm = pwm_get_chip_data(_pwm);
+	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
 	int ret;
 
-	ret = tpu_pwm_timer_start(pwm);
+	ret = tpu_pwm_timer_start(tpd);
 	if (ret < 0)
 		return ret;
 
@@ -347,23 +347,23 @@ static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *_pwm)
 	 * To avoid running the timer when not strictly required, handle 0% and
 	 * 100% duty cycles as fixed levels and stop the timer.
 	 */
-	if (pwm->duty == 0 || pwm->duty == pwm->period) {
-		tpu_pwm_set_pin(pwm, pwm->duty ?
+	if (tpd->duty == 0 || tpd->duty == tpd->period) {
+		tpu_pwm_set_pin(tpd, tpd->duty ?
 				TPU_PIN_ACTIVE : TPU_PIN_INACTIVE);
-		tpu_pwm_timer_stop(pwm);
+		tpu_pwm_timer_stop(tpd);
 	}
 
 	return 0;
 }
 
-static void tpu_pwm_disable(struct pwm_chip *chip, struct pwm_device *_pwm)
+static void tpu_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct tpu_pwm_device *pwm = pwm_get_chip_data(_pwm);
+	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
 
 	/* The timer must be running to modify the pin output configuration. */
-	tpu_pwm_timer_start(pwm);
-	tpu_pwm_set_pin(pwm, TPU_PIN_INACTIVE);
-	tpu_pwm_timer_stop(pwm);
+	tpu_pwm_timer_start(tpd);
+	tpu_pwm_set_pin(tpd, TPU_PIN_INACTIVE);
+	tpu_pwm_timer_stop(tpd);
 }
 
 static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
-- 
2.53.0



