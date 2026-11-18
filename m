Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023143;
	b=lwC2V0nF2rv+aflVQHVFMyK2svBtKzR1GCkYcsTPR6zG6LvWesspW38UyVuAMU7/KUa0
	 MQcIty1a/qYi0YUQ9vVG8wumoeHslRcrhN+sq8iPSsqv+OEAZEMjuzi08MatatJ6+qMTy
	 u9+eK43TIQDj5R3oPY0SvNiYFirNSlTFEfLoywIhl6E9OXs+5XJ5t/6ZpvGw5be0dG0VF
	 53eOKZdutI2Tlg25ZzHU7fx1DkOh2M0BzgSg2z7qJl37AGOkET8hAF3oXPmrHGDfoGmk3
	 GroLE9efRunsIkZcW+v4W0zAyxTA5YduWp/5is13W32EAH1mrSG/O8y4r3vwEg1d1Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=n664HoK3bJfv4p3tjfFPYksUbWT9cA4AHDG4UldYGYU=;
	b=X/e8fpfTJ5j8mzwxmI1n2qB+V3iTnB9DClCdrNeIh26tHDQYNsSzhEfcE2VjSJ+IHrZx
	 XV6SGeyKDGyRyzOByig7ij8hsAgMpxYETrXpXng8OMPYdx8fxhQ6i5DsPLKjab39iDWzR
	 FWIxAdazZk+hGWGPuoK4EAgT2tljEUt2H7LccSK5gckbCKAAplJ7nkPwZG/eIlA364Oce
	 CGBUWBPyRK6y3m2E9CWdB5ZjA9xv9tZdPLJRy742O84NB+Z6fYvdVF+1aB51iRkXNK57i
	 ew3XjATRVzFKMIsOO/04SoZVZ5t7Ou87o0UuRCc0bWHx4JRtiMzEWQEXo5xbMF5CXcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bwlMtzOP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441BF606A320;
	Wed, 18 Nov 2026 17:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bwlMtzOP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDE61F000C6;
	Wed, 18 Nov 2026 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023143;
	bh=n664HoK3bJfv4p3tjfFPYksUbWT9cA4AHDG4UldYGYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwlMtzOP2aLoUXlGm9Xd27smLILCvv7bd0Dhx+t25j1bA0LvRQ6O94xIrjtGqPPr6
	 DRcDlHckc/EM+FOMhC+QmADotG9w1uxqdsjxl9OCeGZ5LbSU50ZnbSOhY4N9i1i0xp
	 T7GqVuh/xx5Zg6QCCwmkZNwwP4sFzfySpuOCVrOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keguang Zhang <keguang.zhang@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0264/2151] pwm: loongson: Reload PWM configuration through counter reset
Date: Wed, 18 Nov 2026 15:33:19 +0100
Message-ID: <20261118150131.424554198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keguang Zhang <keguang.zhang@gmail.com>

[ Upstream commit 0de9b836a3bc1cd30578ae2c4463d09afd85ed3d ]

The Loongson PWM controller latches the LOW and PERIOD registers only at
the start of each PWM period. After disabling and re-enabling the PWM,
the controller resumes from the previous counter value and completes the
current period before re-latching the updated LOW and PERIOD values.

Reset the PWM counter when disabling the PWM and release it when
enabling the PWM so that the updated LOW and PERIOD values are latched
before the PWM starts running again.

Fixes: 2b62c89448dd ("pwm: Add Loongson PWM controller support")
Signed-off-by: Keguang Zhang <keguang.zhang@gmail.com>
Link: https://patch.msgid.link/20260715-pwm-loongson-fix-v3-2-0aab2847eaa7@gmail.com
[ukleinek: Note LOW refers to the register currently named
LOONGSON_PWM_REG_DUTY. That name is wrong, the fix is still under
discussion.]
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-loongson.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pwm/pwm-loongson.c b/drivers/pwm/pwm-loongson.c
index 31a57edecfd0b..a7bd479aafe01 100644
--- a/drivers/pwm/pwm-loongson.c
+++ b/drivers/pwm/pwm-loongson.c
@@ -99,6 +99,7 @@ static void pwm_loongson_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct pwm_loongson_ddata *ddata = to_pwm_loongson_ddata(chip);
 
 	val = pwm_loongson_readl(ddata, LOONGSON_PWM_REG_CTRL);
+	val |= LOONGSON_PWM_CTRL_REG_RST;
 	val &= ~LOONGSON_PWM_CTRL_REG_EN;
 	pwm_loongson_writel(ddata, val, LOONGSON_PWM_REG_CTRL);
 }
@@ -109,6 +110,7 @@ static int pwm_loongson_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct pwm_loongson_ddata *ddata = to_pwm_loongson_ddata(chip);
 
 	val = pwm_loongson_readl(ddata, LOONGSON_PWM_REG_CTRL);
+	val &= ~LOONGSON_PWM_CTRL_REG_RST;
 	val |= LOONGSON_PWM_CTRL_REG_EN;
 	pwm_loongson_writel(ddata, val, LOONGSON_PWM_REG_CTRL);
 
-- 
2.53.0



