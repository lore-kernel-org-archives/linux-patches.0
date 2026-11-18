Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039209;
	b=PQ4J0oHKRyVdQiKhFEfErOp46xrrXn7G4TmhoM1pM7Gt/cDqdYeM9OETgLv+TRaRpxKB
	 VySc9Xhd+11+8A3EXLGS3FnPlLKrbfkQpIhQu3QmwtPV3Pt9EZesXe5/ioG3eYB+B1GDT
	 s1+kyOW/dFkiRi6Yj8fzQ+O/GpsR38CD/TRDSooq43DIkmn6eZN/wzoWZtCF7oMVQxnmQ
	 LK/fU2e8Lp8FifP9IyTnheqq8cPPbKT1aBE8cJqQvd82d0OPmS8RHN9bC4JTySMfeHHy+
	 jiScPchCQdqc0XjoIw6ahDxFx4pvy/rfZbd5zR6WMVQhvmak1/KQqLhZmYq0wGBXlGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kaYioaEJzNVBly2bFBA9l/gNJghZA7xwv0oq5C1PT3A=;
	b=YFz1NZBSnqFbICmlswgqGVPlJ3vKmejFefSJLnwcgzNWDBnVAiT4x8m5tD0Ta+ofqclz
	 aQN919QKOKJr9lYVbSXt3XqMW6rtGuvjaoiNLP83kLMj2zl9bzXmk/uswdH2dI8Z12NK1
	 hXNzJLWJuGGwFF7P3AjVQcTtP/wxhz1Z3XWZuJSu7QmeCZLR076hF6k/EAl/qtyRscR0a
	 Rj4Dbj4S0kizQiXmnyl4k8S6MKeLW9iQ4Aj+CgX8whyeN0Fd2WzuEanTkQNDHiIexFvUj
	 tUQH6v3xnqfMBPVU7dpvmS1vpCuao3XadRHROCbx3r+QC+poPU2Q6KANWhrV0b2NC7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alpApX2g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4DC606A32C;
	Wed, 18 Nov 2026 22:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alpApX2g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA151F000C4;
	Wed, 18 Nov 2026 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039208;
	bh=kaYioaEJzNVBly2bFBA9l/gNJghZA7xwv0oq5C1PT3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alpApX2ghHIDDE9ZeHVPOj/QkF5QNEW1cTV7mp+onriZMazrfPMZY8V3PUwQzGwTH
	 oK7Q8+2EBf7mVYz28twLxX08uPdVTAgkdHllCU0fT7yCIZMPFpKh5GmHrVtilHR4Tk
	 PStoBDpIroVx82XMhFRAsWgqIS53UyXX2wnA0pHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2019/3318] pwm: renesas: Drop usage of pwm_[gs]et_chip_data()
Date: Wed, 18 Nov 2026 15:44:01 +0100
Message-ID: <20261118150422.610822321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ec63391a0d402cafa5f4dfd11e05cd325ae7e2f5 ]

Instead of distributing the driver's bookkeeping over 5 (i.e.
TPU_CHANNEL_MAX + 1) separately allocated memory chunks, put all together
in struct tpu_device. This reduces the number of memory allocations and
so fragmentation and maybe even the number of cache misses. Also
&tpu->tpd[pwm->hwpwm] is cheaper to evaluate than pwm_get_chip_data(pwm)
as the former is just an addition in machine code while the latter involves
a function call.

Link: https://lore.kernel.org/r/20230705080650.2353391-6-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 62cff15fbf2b ("pwm: renesas-tpu: Fix runtime PM reference leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-renesas-tpu.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index d7311614c846d..613dd549edf8f 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -85,6 +85,7 @@ struct tpu_device {
 
 	void __iomem *base;
 	struct clk *clk;
+	struct tpu_pwm_device tpd[TPU_CHANNEL_MAX];
 };
 
 #define to_tpu_device(c)	container_of(c, struct tpu_device, chip)
@@ -215,9 +216,7 @@ static int tpu_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 	if (pwm->hwpwm >= TPU_CHANNEL_MAX)
 		return -EINVAL;
 
-	tpd = kzalloc(sizeof(*tpd), GFP_KERNEL);
-	if (tpd == NULL)
-		return -ENOMEM;
+	tpd = &tpu->tpd[pwm->hwpwm];
 
 	tpd->tpu = tpu;
 	tpd->channel = pwm->hwpwm;
@@ -228,24 +227,22 @@ static int tpu_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	tpd->timer_on = false;
 
-	pwm_set_chip_data(pwm, tpd);
-
 	return 0;
 }
 
 static void tpu_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
+	struct tpu_device *tpu = to_tpu_device(chip);
+	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
 
 	tpu_pwm_timer_stop(tpd);
-	kfree(tpd);
 }
 
 static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			  u64 duty_ns, u64 period_ns, bool enabled)
 {
-	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
 	struct tpu_device *tpu = to_tpu_device(chip);
+	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
 	unsigned int prescaler;
 	bool duty_only = false;
 	u32 clk_rate;
@@ -353,7 +350,8 @@ static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 static int tpu_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 				enum pwm_polarity polarity)
 {
-	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
+	struct tpu_device *tpu = to_tpu_device(chip);
+	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
 
 	tpd->polarity = polarity;
 
@@ -362,7 +360,8 @@ static int tpu_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 
 static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
+	struct tpu_device *tpu = to_tpu_device(chip);
+	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
 	int ret;
 
 	ret = tpu_pwm_timer_start(tpd);
@@ -384,7 +383,8 @@ static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 static void tpu_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
+	struct tpu_device *tpu = to_tpu_device(chip);
+	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
 
 	/* The timer must be running to modify the pin output configuration. */
 	tpu_pwm_timer_start(tpd);
-- 
2.53.0



