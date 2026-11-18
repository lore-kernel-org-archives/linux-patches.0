Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039401;
	b=jjnmKYTrwoIciVsINQXVs8YMgZOU+eo/ibDO3qHdqZvPNVeCPm9maI4aoaykuGlsFqor
	 8ILQj+Lp5DFGYMfF10j9O82K+CkhwT1puarBU3DoA1s4zoJms1PnLnic9vlXT+amptYR1
	 12qm7PA0Wcygym6mL1le7hzWT6rXC8rSG8ya+KQElsoO1X6sq+xhK+l+0CZ7HQxi5lkh5
	 vP++sOFW3ioD1SlC5P9MeuaVqHHcoIFvrugjOonGueyoHa9Cq3usxPsd7rjBThd8UDeyz
	 y9Iwt1lFkcRdyneUBFDvnEm4qp2Xq4Un2XyEY/4Huh9pIae1DB6c25q2XZMNfPf1kUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gDbhHe6Zz1pCArH9kwRSOSn2ZfKCe6rcaZo5gJXy0Eg=;
	b=zGPnHy3Oh27bxXcwrZiAeT/KL1xHr8J/I4T2+6otHqoyGo5SKDBglZ3MdMc27FBr3xUR
	 yoPpyhdeMhBlvDI933ukjKFB6fCmHCxZiDuXXcznfAC/tEbXHSG1sIUbHGzLKYcMMRGhV
	 ADIY5dCzr9sh46eE3YtvrBCyEG1g+PNqZdkp28KoQ0vhvOcBcaUiC3U6/3U1eQ1e9ZX59
	 SVeqy1TXPuriw9P2tBu8WCH1XN9Vu+AlGI54KKk9cjbuWx7IL0oTC6EMaDWnAFWfv3IZE
	 1xLAIIudkIkg/rywoOCSPY2kumO7iPf/BaxbF9uSzGw9Vt3YlYeOHt2hDY9wX+LFT1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vszhQluY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FFF606A31C;
	Wed, 18 Nov 2026 22:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vszhQluY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120861F000C4;
	Wed, 18 Nov 2026 22:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039401;
	bh=gDbhHe6Zz1pCArH9kwRSOSn2ZfKCe6rcaZo5gJXy0Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vszhQluY0iufQ0boOrf7F5h74FE2ceQEFdWhEu9UNpOy+vxPjC5aSwg8YNKWBfgK3
	 4VdPRTlFo/MVqNsJP35Q/Tx+0bot2L0911HG6KeJXrKs/vPsLE2lB3jSFJjQgtE7KA
	 4/BtrvZhv7G2WPSaQCM1/8BoWtIoB5tEAbWOPetE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2086/3318] pwm: lp3943: Drop usage of pwm_[gs]et_chip_data()
Date: Wed, 18 Nov 2026 15:45:08 +0100
Message-ID: <20261118150424.673804748@linuxfoundation.org>
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
index 4b133a17f4be3..b50cd51b067e6 100644
--- a/drivers/pwm/pwm-lp3943.c
+++ b/drivers/pwm/pwm-lp3943.c
@@ -23,6 +23,7 @@ struct lp3943_pwm {
 	struct pwm_chip chip;
 	struct lp3943 *lp3943;
 	struct lp3943_platform_data *pdata;
+	struct lp3943_pwm_map pwm_map[LP3943_NUM_PWMS];
 };
 
 static inline struct lp3943_pwm *to_lp3943_pwm(struct pwm_chip *chip)
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
@@ -159,7 +152,7 @@ static int lp3943_pwm_set_mode(struct lp3943_pwm *lp3943_pwm,
 static int lp3943_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
-	struct lp3943_pwm_map *pwm_map = pwm_get_chip_data(pwm);
+	struct lp3943_pwm_map *pwm_map = &lp3943_pwm->pwm_map[pwm->hwpwm];
 	u8 val;
 
 	if (pwm->hwpwm == 0)
@@ -178,7 +171,7 @@ static int lp3943_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 static void lp3943_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
-	struct lp3943_pwm_map *pwm_map = pwm_get_chip_data(pwm);
+	struct lp3943_pwm_map *pwm_map = &lp3943_pwm->pwm_map[pwm->hwpwm];
 
 	/*
 	 * LP3943 outputs are open-drain, so the pin should be configured
-- 
2.53.0



