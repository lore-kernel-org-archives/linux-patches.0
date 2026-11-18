Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028965;
	b=tpKomMuwqxgmvx14/MZGDHf0zXfIcxd7Ur8xDaG7AzxcGUZZGpkKiQfSi9cwzR4jJzjE
	 OxRXmybPq7W6F1s1hGHcwe89HjeZNFIHd3tYMm+bwmlnyLlV1S/AMC0kdpkdS4jg+xgVW
	 8XXnt3ScBSQrhEmLX+m/8gjMvqvb6X13nhkLYpZMQmLlGFL4PQiUN1aj7By5XxtVofaBv
	 O9ky79ACQNlk3cA6JALMG1xwTG1E3YAomEq34B0radIAJS3/EVH4l6+F/aoK/AT5iHedr
	 CLbm3WxdsNubuymPF0bBTWxilbBD9OLFsTE5AwJNsaoYOVjjXM8gPUZ2Bq5Epq0vkxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wDgxt04sPZNiiMCO4nLLArWGh3qoInsSGasxEP6Dr9I=;
	b=UagoYukybb6ZcXwOinuMBXOWTnfYDGUGAcQQT1MXQUNkLASJnx8LkOPneV+cl1ymA/PI
	 ++ni06a8Kohhi0DW9v5OUk+T7gfNFvEl+vITYB+yE284FvKF8gNj1ip+TvvAiZlwXqG5U
	 WUFGyNJ7hxE/7bkys9vA6MYodrI2p3XIKdCm/YnXdedi495y6ZeGdm4zXNUcMx2WB4OiP
	 uubmR/9VqwaCxzCpnaX8VYlUESI3aMEt8MDgYkbICrWA8tT1VNy4VBb3nxQK+cxBhVbeK
	 5vRolNIipuSWgI5av6uJ+NSN5dRvIsAlriwKqBICxFHePCv1438XUnJaToGJkkbG2xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sgtWpqlK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC3F606A333;
	Wed, 18 Nov 2026 19:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sgtWpqlK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53A41F000C4;
	Wed, 18 Nov 2026 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028965;
	bh=wDgxt04sPZNiiMCO4nLLArWGh3qoInsSGasxEP6Dr9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgtWpqlKPu8lZ5QHl50RNy18QRU1R3eTG+aW9sB8bJwGmQR5bzDbH+NVVLCgPAAO8
	 TfSH+TukftHaoBFYOkba7G3hxgxd/MB+oAzZj/ORzuW+umCPoDvC3p7uUcNQubDcvv
	 ypKohv51O3Uf7sY2tX4+P0f2xBlAg4dy5sw5HGi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0182/1756] pwm: renesas-tpu: Fix runtime PM reference leak
Date: Wed, 18 Nov 2026 15:38:29 +0100
Message-ID: <20261118150015.671792662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2196080b41770..c0bbe275275c8 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -149,10 +149,14 @@ static int tpu_pwm_timer_start(struct tpu_pwm_device *tpd)
 
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
@@ -382,15 +386,21 @@ static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
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
@@ -401,7 +411,10 @@ static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	if (state->polarity != pwm->state.polarity) {
 		if (enabled) {
-			tpu_pwm_disable(chip, pwm);
+			err = tpu_pwm_disable(chip, pwm);
+			if (err)
+				return err;
+
 			enabled = false;
 		}
 
@@ -412,7 +425,7 @@ static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	if (!state->enabled) {
 		if (enabled)
-			tpu_pwm_disable(chip, pwm);
+			return tpu_pwm_disable(chip, pwm);
 
 		return 0;
 	}
-- 
2.53.0



