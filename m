Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060324;
	b=T5FlSdg5GoXf3gnmmak7yVWviCrYKtjDAL5ait8DUTCEzlVI0qQRi0Bj9M+FaeI/V7AX
	 4oT53+bdXZyCa5iOcODsCr1YV2cGpSCeyMF8aJh/qswjJkpwyWlTNsHFTcrW55nP/wV3Z
	 /RSG6hLR3XhFx2vPT2F9076/bZp8wxZEx0iFGQNG9eZ0N1nX/UCHt5AJy5pCBWaklamdI
	 QzsCDaWp7w7YxQHPVaGOELjEMrZo9ye8N7sJBKTPrmBZmzRmcurJSS8Sd7AWR7GecEn7O
	 qa36+lX7nCwU0RyJQY78/8+h1b0YIU2Mq3XNBrfmEgZd5sf2S9XyepiMWCr3ratBaLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ILIjxHuduoXbp68lxIONZKZpdnSHYrsMJXF70IS0YtI=;
	b=JN2rf6twDZvDSOiB6H/cVUxsbsVRhXZgkJMoYXZd7wy25CXZnp8cCyCwz8elwiNBFuhQ
	 k0ggKnx8K8vKpMlmdan4Nd2FQ3yGAb9CPirDE6xBBdClr7a1nZdlUG5ipAPOiqwumj05k
	 0jauCKJ7W+t/C9Tv90wxAhjMpUdeNDm6udtYUXmH+mBV3uqt+GrRmMPOEP09bk3MQLjbX
	 vbHSYIWz44rQa4FOz5t4fwAKXTnKpOVG5OIUU1PFtqjQvl5UcvzQAP88JeHE6NDeU84R3
	 i8w9h7OHEDCJvC1ZW/7j2rRjjlqJVUVS3uSHpo+fRhELHi3ntPQB9kz5nzleoILJbNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVKkezBu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3300606A325;
	Thu, 19 Nov 2026 03:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVKkezBu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED951F000C4;
	Thu, 19 Nov 2026 03:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060323;
	bh=ILIjxHuduoXbp68lxIONZKZpdnSHYrsMJXF70IS0YtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVKkezBub+s5xCeSlpj4sf9CZiad7gGJ3ICZqdvqkY+ZOR042abY5QOIOj+5eH9AP
	 j8woZBWBbewCA+tD9y2QsSW3EZ878Mrr+YvnW5cts7I/jiyPNyYz5s3kRtTa0jrknY
	 /3BVM698rIdNOiL/vBWO/QXu6dt3lzgmegStpGZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1151/1848] pwm: renesas: Drop usage of pwm_[gs]et_chip_data()
Date: Wed, 18 Nov 2026 15:53:09 +0100
Message-ID: <20261118150007.912107689@linuxfoundation.org>
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
index 9e4298ceb5871..a9750a4482a78 100644
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
 			  int duty_ns, int period_ns, bool enabled)
 {
-	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
 	struct tpu_device *tpu = to_tpu_device(chip);
+	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
 	unsigned int prescaler;
 	bool duty_only = false;
 	u32 clk_rate;
@@ -347,7 +344,8 @@ static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 static int tpu_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 				enum pwm_polarity polarity)
 {
-	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
+	struct tpu_device *tpu = to_tpu_device(chip);
+	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
 
 	tpd->polarity = polarity;
 
@@ -356,7 +354,8 @@ static int tpu_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 
 static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
+	struct tpu_device *tpu = to_tpu_device(chip);
+	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
 	int ret;
 
 	ret = tpu_pwm_timer_start(tpd);
@@ -378,7 +377,8 @@ static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 static void tpu_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
+	struct tpu_device *tpu = to_tpu_device(chip);
+	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
 
 	/* The timer must be running to modify the pin output configuration. */
 	tpu_pwm_timer_start(tpd);
-- 
2.53.0



