Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054793;
	b=o604SJS1X908EH50jCk69Zx5/VFit0sNf2atLC1D/NRN2rqjjbdyEUrTBHxRPqOzjAUm
	 fKZqdJdIi/Nag536vElNg1TWNsz/9LaAS8GcObQNFegb7B4nT3X4KTKO4+MzX2B5KSlqo
	 wlzXW33MnGBICreY4CUwKhEYTNlTJEt1mNpWxGV0E7TCWxemkHmRUvovmdtUsIJIMr2+i
	 bJPEIY+owfJ0WWtXgXcne9KMPQPZD+ydW+UBk1kb9wKKo9FNNlr9QBCAG0BR/D82K69xH
	 vcPyMZCMsgRxpcIz4BvjEU2PXTXqpAexZcdtPLTT4s8RQHcGpMUWBnZMYCS58eIfyaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=K7iaNwYODcPVcDPDDstGbx7t/fIOecMAouzV5sD6ZX4=;
	b=5Ch5+8nLGJeOS2obQmUZb+X7DwUbbKOa71jlJeGXcozJWmU4/GwDrlO4xh5LInrtXZTi
	 KNTuiuNKLh3ErEjbkwQasETA/3OPwk8uOvORbzJIAUnXHf4gJDRslG4YfIvUBsfMgxKEy
	 oQLWTM++pWwuTtwABAUBOL3BZdJDin6YTUSmzob+996NRXSD71n8VtWB+Fr1+9kZ12/oK
	 dYHPe7XsFVsNbGxvY+COU2AcLCAiHjapNVL0QIhI8IjAM6hitrMcU2L0HJveWk6F4kQHX
	 NLdIE0YTcLkB+iUnXLXdd3FsJ1NorkLurktmc2hcWru3SqdI9MdnIyp/C1VdVWvM2KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYBqP7Gh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0190B606A31C;
	Thu, 19 Nov 2026 02:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYBqP7Gh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575371F000C4;
	Thu, 19 Nov 2026 02:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054792;
	bh=K7iaNwYODcPVcDPDDstGbx7t/fIOecMAouzV5sD6ZX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYBqP7GhtxR3Tg9ccAr9yNbFVbk8KgazL1Z45S1dAn/hsYon+xPeugNdXWbGVaYqp
	 gMH6rCOEi6UC83qiIccJmI3FX49n8Gi9fOlJYiVEeB11ErChX/IMsvEeY9buDgffmr
	 uTk1wRnZB9aq3GrdjVA+9Dnv7hKXpZlUMkmZkSU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1401/2214] pwm: lp3943: Drop usage of pwm_[gs]et_chip_data()
Date: Wed, 18 Nov 2026 15:51:17 +0100
Message-ID: <20261118150107.335960408@linuxfoundation.org>
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

[ Upstream commit 06cc4767750337ad162a0a7bcfd6f6eff6e0fe92 ]

Instead of distributing the driver's bookkeeping over 3 (i.e.
LP3943_NUM_PWMS + 1) separately allocated memory chunks, put all together
in struct lp3943_pwm. This reduces the number of memory allocations and
so fragmentation and maybe even the number of cache misses. Also
&lp3943_pwm->pwm_map[pwm->hwpwm] is cheaper to evaluate than
pwm_get_chip_data(pwm) as the former is just an addition in machine code
while the latter involves a function call.

Link: https://lore.kernel.org/r/20230705080650.2353391-5-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 17dbb6938d3a ("pwm: lp3943: fix NULL pointer dereference for an unconfigured channel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lp3943.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/pwm/pwm-lp3943.c b/drivers/pwm/pwm-lp3943.c
index 2bd04ecb508cf..725f2abeaefc9 100644
--- a/drivers/pwm/pwm-lp3943.c
+++ b/drivers/pwm/pwm-lp3943.c
@@ -23,6 +23,7 @@ struct lp3943_pwm {
 	struct pwm_chip chip;
 	struct lp3943 *lp3943;
 	struct lp3943_platform_data *pdata;
+	struct lp3943_pwm_map pwm_map[LP3943_NUM_PWMS];
 };
 
 static inline struct lp3943_pwm *to_lp3943_pwm(struct pwm_chip *_chip)
@@ -35,13 +36,9 @@ lp3943_pwm_request_map(struct lp3943_pwm *lp3943_pwm, int hwpwm)
 {
 	struct lp3943_platform_data *pdata = lp3943_pwm->pdata;
 	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
-	struct lp3943_pwm_map *pwm_map;
+	struct lp3943_pwm_map *pwm_map = &lp3943_pwm->pwm_map[hwpwm];
 	int i, offset;
 
-	pwm_map = kzalloc(sizeof(*pwm_map), GFP_KERNEL);
-	if (!pwm_map)
-		return ERR_PTR(-ENOMEM);
-
 	pwm_map->output = pdata->pwms[hwpwm]->output;
 	pwm_map->num_outputs = pdata->pwms[hwpwm]->num_outputs;
 
@@ -49,10 +46,8 @@ lp3943_pwm_request_map(struct lp3943_pwm *lp3943_pwm, int hwpwm)
 		offset = pwm_map->output[i];
 
 		/* Return an error if the pin is already assigned */
-		if (test_and_set_bit(offset, &lp3943->pin_used)) {
-			kfree(pwm_map);
+		if (test_and_set_bit(offset, &lp3943->pin_used))
 			return ERR_PTR(-EBUSY);
-		}
 	}
 
 	return pwm_map;
@@ -67,7 +62,7 @@ static int lp3943_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 	if (IS_ERR(pwm_map))
 		return PTR_ERR(pwm_map);
 
-	return pwm_set_chip_data(pwm, pwm_map);
+	return 0;
 }
 
 static void lp3943_pwm_free_map(struct lp3943_pwm *lp3943_pwm,
@@ -80,14 +75,12 @@ static void lp3943_pwm_free_map(struct lp3943_pwm *lp3943_pwm,
 		offset = pwm_map->output[i];
 		clear_bit(offset, &lp3943->pin_used);
 	}
-
-	kfree(pwm_map);
 }
 
 static void lp3943_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
-	struct lp3943_pwm_map *pwm_map = pwm_get_chip_data(pwm);
+	struct lp3943_pwm_map *pwm_map = &lp3943_pwm->pwm_map[pwm->hwpwm];
 
 	lp3943_pwm_free_map(lp3943_pwm, pwm_map);
 }
@@ -154,7 +147,7 @@ static int lp3943_pwm_set_mode(struct lp3943_pwm *lp3943_pwm,
 static int lp3943_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
-	struct lp3943_pwm_map *pwm_map = pwm_get_chip_data(pwm);
+	struct lp3943_pwm_map *pwm_map = &lp3943_pwm->pwm_map[pwm->hwpwm];
 	u8 val;
 
 	if (pwm->hwpwm == 0)
@@ -173,7 +166,7 @@ static int lp3943_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 static void lp3943_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
-	struct lp3943_pwm_map *pwm_map = pwm_get_chip_data(pwm);
+	struct lp3943_pwm_map *pwm_map = &lp3943_pwm->pwm_map[pwm->hwpwm];
 
 	/*
 	 * LP3943 outputs are open-drain, so the pin should be configured
-- 
2.53.0



