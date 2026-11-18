Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060354;
	b=pb4CRqrzBEDRmj2fDcjDndaaVqRzTtUbv33V+xhJp61Fa1ceXD11bK1JVF5MoNa8g+Ri
	 2z0uj0iiG4itn6dWSKoJu4qkzRjmSLc2FmrMW73pzzsIUepmzCniB5WJ/TOD8O+awHc8m
	 Gi/fpiD8F4JbeG98lv1zhJ1L/vCzx9pER4BFbHRlEmubqHDb/7T/NvxIYYMRARQn0tkn6
	 o6fcy3ux71G+hzIOF95Qu4JK8XKm17RQuqtwvnOkd3i0yNIxi9bTwTPiCdax1Vrsg+/bX
	 bUb8YMdy2gVX1lUWasXQ2yEwyO8dF5+hH34HE+RxxuCGxXjI9KSZw57VUr9qWNQPJIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=j6RNYF5KKSGHeyIk4d6ZE0gs9FEbR5CvDgP2RZ0CFi8=;
	b=QxR1BCk5koduDtHJiMG6exL4FBWrRLhNsKu3+dr85psHl0wvYBnY1e4V4lYeolLhIk1q
	 vUyYZAyymFMyN2DluCUCHtn8VqJv+HXRirQna1OGBEIUfIfQKM8o/mFsyCmVgL6tYHpri
	 oyjLkYFfWEU5j45OKbDE/vnqRQw6ivCGqyUHO57stRL6jpZxGq5WLnGOY8VghH8JxWMW8
	 z39QfBO9p70WbSyyPwgaELlIsgVSKJpo0GbfOsP+W1gt1Dpnrgi4pJ342QNSzqNl0GV5J
	 9c4EJDQvaFRg/IxrJ3API5S28U+kKH5trl2VpR3YDeOJWXypKK0CcNczcFzLzhhw38g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zjr/Y6Yn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9244E606A326;
	Thu, 19 Nov 2026 03:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjr/Y6Yn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD471F000C4;
	Thu, 19 Nov 2026 03:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060354;
	bh=j6RNYF5KKSGHeyIk4d6ZE0gs9FEbR5CvDgP2RZ0CFi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjr/Y6YnOkDM2WS75bXwG9kQvViOY60tCFg2cfTjlbjc20Iuyys9uE2BMMZAC+EpL
	 X03i7zelsuW/iiXsFavjEOtwe0RgcbR5+GZHLNxmgpsqvrkIeO+Xss4aXyBo4p/l+R
	 L8CcYhILR0tha9JXOg3A+z9TNpeWX8jTit861hMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1152/1848] pwm: renesas-tpu: Fix runtime PM reference leak
Date: Wed, 18 Nov 2026 15:53:10 +0100
Message-ID: <20261118150007.947411905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 62cff15fbf2b12ebbb0b01ca720030c2bc12aed1 ]

tpu_pwm_timer_start() used pm_runtime_get_sync() without checking its
return value before touching the TPU clock.  A failed runtime resume was
therefore ignored, and the callback continued into register access.

Use pm_runtime_resume_and_get() and propagate a failed resume.  Keep the
matching put when clock preparation fails after a successful resume.

tpu_pwm_disable() also needs to propagate a failed start so that the PWM
apply callback does not access registers while runtime PM is inactive.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 99b82abb0a35 ("pwm: Add Renesas TPU PWM driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260814134143.1388120-1-ruoyuw560@gmail.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-renesas-tpu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index a9750a4482a78..cba42ca6fccc6 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -148,10 +148,14 @@ static int tpu_pwm_timer_start(struct tpu_pwm_device *tpd)
 
 	if (!tpd->timer_on) {
 		/* Wake up device and enable clock. */
-		pm_runtime_get_sync(&tpd->tpu->pdev->dev);
+		ret = pm_runtime_resume_and_get(&tpd->tpu->pdev->dev);
+		if (ret < 0)
+			return ret;
+
 		ret = clk_prepare_enable(tpd->tpu->clk);
 		if (ret) {
 			dev_err(&tpd->tpu->pdev->dev, "cannot enable clock\n");
+			pm_runtime_put(&tpd->tpu->pdev->dev);
 			return ret;
 		}
 		tpd->timer_on = true;
@@ -375,15 +379,21 @@ static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	return 0;
 }
 
-static void tpu_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+static int tpu_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct tpu_device *tpu = to_tpu_device(chip);
 	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
+	int ret;
 
 	/* The timer must be running to modify the pin output configuration. */
-	tpu_pwm_timer_start(tpd);
+	ret = tpu_pwm_timer_start(tpd);
+	if (ret < 0)
+		return ret;
+
 	tpu_pwm_set_pin(tpd, TPU_PIN_INACTIVE);
 	tpu_pwm_timer_stop(tpd);
+
+	return 0;
 }
 
 static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
@@ -394,7 +404,10 @@ static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	if (state->polarity != pwm->state.polarity) {
 		if (enabled) {
-			tpu_pwm_disable(chip, pwm);
+			err = tpu_pwm_disable(chip, pwm);
+			if (err)
+				return err;
+
 			enabled = false;
 		}
 
@@ -405,7 +418,7 @@ static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	if (!state->enabled) {
 		if (enabled)
-			tpu_pwm_disable(chip, pwm);
+			return tpu_pwm_disable(chip, pwm);
 
 		return 0;
 	}
-- 
2.53.0



