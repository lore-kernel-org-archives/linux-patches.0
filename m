Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060444;
	b=MieBT5t/laO6C1wWHsLwQIKNAc27eZzpJuBQMr7MT3AmywF2WiosPch/s1ukSLprtBq6
	 eGGapZipszVvCsBml2a04aVKsLoN13sPq8NWw9xCk54tuqAvp3EKi+u1OV8+NtTCh8Pnm
	 tfPOaM1AWfIFDziO7+koYtMQSi4E3/Xgm9Gmtge7n0vX0hXi53VFGet2Dypff77veY+m4
	 KpcRow9vYed6l052Vf8w4/M/exXJjIQhik3yR/3TD7rQJ0nFUFRP4nlC0kLdV29umlBXJ
	 f4Ul6KtsmO5kvMszmpYXahbHVbQ0KW9ELtbQtY/ysBxLs3NCXslUOprD9V5FB5OoaBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WvNDMJiU0nJvOFpCncjMM9u8nI4HQ0T1EDuTi9VwxcQ=;
	b=co0bcv4xYhX78ugkv4XM49UvW9g4+BSYsewROUZ8a+un5uJhcrHM1cbbWd6up9TRVTmg
	 TxpolksgCaimKs+o9G5ajiko9NNYBp1DTrc/48p3HNLGy+BR3QgKlDf0SsJQRztvYRN3A
	 yX8KR953qv5S8Eilm7q/rprrRYICNV1TlnHHeck9i6tbKBcTH+td/QNX8gfJfXC6XFba8
	 xL1DBiIesWxl4mAvj+pPZNY/2zbmzuyORla6ESQ+VegO9aj9/KQjuoXv3lmftbfdo0wnp
	 2AQG5Rel69toYZRLkB/xx1FPy2L3N/Od4NdStk/4/5BOXUn7m9P0I6RfzKeQI8yAMRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gug1TK2j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55456606A326;
	Thu, 19 Nov 2026 03:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gug1TK2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE1F1F000C5;
	Thu, 19 Nov 2026 03:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060443;
	bh=WvNDMJiU0nJvOFpCncjMM9u8nI4HQ0T1EDuTi9VwxcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gug1TK2jquLsSI2Li5RhWUUmKMsKPpEoLuFmo7gNH6DkSpNGdGBVR0dCj5bjD8lzG
	 ySuXYUDiWmMwu6AADTak/ErSen0MUTOtOW5b1SvIbY2bj/mu0fNLQyiDVdFz8KLRPc
	 91AVha/jCG46B+XkDdLLloZdVF3t9EsZjtV6RgZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1150/1848] pwm: renesas-tpu: Improve maths to compute register settings
Date: Wed, 18 Nov 2026 15:53:08 +0100
Message-ID: <20261118150007.873446891@linuxfoundation.org>
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

[ Upstream commit 3c173376efc461dc670b02ba2846c2a533491104 ]

The newly computed register values are intended to exactly match the
previously computed values. The main improvement is that the prescaler
is computed without a loop that involves two divisions in each step.
This uses the fact, that prescalers[i] = 1 << (2 * i).

Assuming a moderately smart compiler, the needed number of divisions for
the case where the requested period is too big, is reduced from 5 to 2.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 62cff15fbf2b ("pwm: renesas-tpu: Fix runtime PM reference leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-renesas-tpu.c | 50 ++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index 62213a7657e20..9e4298ceb5871 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -244,7 +244,6 @@ static void tpu_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			  int duty_ns, int period_ns, bool enabled)
 {
-	static const unsigned int prescalers[] = { 1, 4, 16, 64 };
 	struct tpu_pwm_device *tpd = pwm_get_chip_data(pwm);
 	struct tpu_device *tpu = to_tpu_device(chip);
 	unsigned int prescaler;
@@ -254,26 +253,47 @@ static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	u32 duty;
 	int ret;
 
+	clk_rate = clk_get_rate(tpu->clk);
+
+	period = clk_rate / (NSEC_PER_SEC / period_ns);
+
 	/*
-	 * Pick a prescaler to avoid overflowing the counter.
-	 * TODO: Pick the highest acceptable prescaler.
+	 * Find the minimal prescaler in [0..3] such that
+	 *
+	 *     period >> (2 * prescaler) < 0x10000
+	 *
+	 * This could be calculated using something like:
+	 *
+	 *     prescaler = max(ilog2(period) / 2, 7) - 7;
+	 *
+	 * but given there are only four allowed results and that ilog2 isn't
+	 * cheap on all platforms using a switch statement is more effective.
 	 */
-	clk_rate = clk_get_rate(tpu->clk);
+	switch (period) {
+	case 1 ... 0xffff:
+		prescaler = 0;
+		break;
 
-	for (prescaler = 0; prescaler < ARRAY_SIZE(prescalers); ++prescaler) {
-		period = clk_rate / prescalers[prescaler]
-		       / (NSEC_PER_SEC / period_ns);
-		if (period <= 0xffff)
-			break;
-	}
+	case 0x10000 ... 0x3ffff:
+		prescaler = 1;
+		break;
 
-	if (prescaler == ARRAY_SIZE(prescalers) || period == 0) {
-		dev_err(&tpu->pdev->dev, "clock rate mismatch\n");
-		return -ENOTSUPP;
+	case 0x40000 ... 0xfffff:
+		prescaler = 2;
+		break;
+
+	case 0x100000 ... 0x3fffff:
+		prescaler = 3;
+		break;
+
+	default:
+		return -EINVAL;
 	}
 
+	period >>= 2 * prescaler;
+
 	if (duty_ns) {
-		duty = clk_rate / prescalers[prescaler]
+		duty = (clk_rate >> 2 * prescaler)
 		     / (NSEC_PER_SEC / duty_ns);
 		if (duty > period)
 			return -EINVAL;
@@ -283,7 +303,7 @@ static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	dev_dbg(&tpu->pdev->dev,
 		"rate %u, prescaler %u, period %u, duty %u\n",
-		clk_rate, prescalers[prescaler], period, duty);
+		clk_rate, 1 << (2 * prescaler), period, duty);
 
 	if (tpd->prescaler == prescaler && tpd->period == period)
 		duty_only = true;
-- 
2.53.0



