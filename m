Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215108;
	b=Ykl7LwXNwc7nLcDOogIdy/LSeooWNFBuTWPIPFyfJtzoaRtblDqr9lmfnvCe2uRPq/qP
	 RwyQRjwZZInCL9NB4gzlz6LYAowack2mzm1l3D+QpqYJbOqhPOFzsdOeGI6bMk2GRFlX6
	 TVbqNYd2EF5JEnz9cgRg8qnUrXCdprFK5uadrzdWtnv+GhKSav2YUihO3Ieezre3dL+1B
	 KLD4ujebGBtaZOuPNkLWS1oJqhDSV2d/+Rsln0gf1xsslZURYB4SawBYKYq3RwtOQ/VV/
	 S5sNIzizwuPSFuKM37PVXg2CSP6i5g+9s4VvKGERyZR7KEeqostY4snIpiRwh939rsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SxeV/rb0eaTVQaF3y36N2kKl3OG6Dc+EkxrvM38fG6s=;
	b=QiNmk8Wfpul7dLWPY4bR37rQa5QkjezSHBcmWglPwZiV99aEAMpcFBDGZCzrGd9SPQBs
	 PX74FnDkzLEocs+eC+XXrAFd6g9CeeXgTWhbxa2hRKcyIkQYKogKO2kJOKJxtpnlPWJBu
	 jbXkomksjjWQ4TAwrTL5tgQyPvnTNSUJ6nGl/hWgDIoxQFYJThReIeUvqLEGXLeTc9DUM
	 8kIRPey5RU4yqNXbrbQ2cRTzQEC/qCDSKWo2JWTC9xu3U6wDwr9rhCZEiFBWKv1VNiBvR
	 sceKzhAhYOhR2Aa4kfgKcAgPgfqaH/ZlZNECG7eX2vShBKQ3xDNwd5lQIr5cJI3EOUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hnKwUrI5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C59606A31A;
	Wed, 28 Oct 2026 19:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hnKwUrI5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D571F01825;
	Wed, 28 Oct 2026 19:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215108;
	bh=SxeV/rb0eaTVQaF3y36N2kKl3OG6Dc+EkxrvM38fG6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnKwUrI5tiQvHUSQ9BZi8/XEjQV3bWDjSBM+fuw4xlWIgIjSTnQeJPHnF1IBfjFoD
	 wE2JVHI5tOhPoIodeuTtXmMWdW06BT5oZHNaQoIbUjNQbsaJcrwiz5aR1E+EDZheUt
	 tM5ODDak3sfKjfmR9Cnyau+tyULO5bGRDYQ4yhi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1096/1887] gpio: mvebu: Use IS_REACHABLE instead of IS_ENABLED for CONFIG_PWM
Date: Wed, 28 Oct 2026 17:53:12 +0100
Message-ID: <20261028170524.346757849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 3101b1e4ba3874a7dbcc4da6d788e1408a69a5d7 ]

To check if a certain function (here e.g. pwmchip_add()) can be called
IS_REACHABLE is the better check. The relevant difference to IS_ENABLED
is that IS_REACHABLE evaluates to 0 if the current code is builtin but the
checked symbol is =m and so must not be used.

Today there is no practical impact as CONFIG_PWM is a bool.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: b9ad50d7505e ("gpio: mvebu: fix NULL pointer dereference in suspend/resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 3ead4c95fa3d0..c38d28de2e620 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1002,7 +1002,7 @@ static int mvebu_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 		BUG();
 	}
 
-	if (IS_ENABLED(CONFIG_PWM))
+	if (IS_REACHABLE(CONFIG_PWM))
 		mvebu_pwm_suspend(mvchip);
 
 	return 0;
@@ -1054,7 +1054,7 @@ static int mvebu_gpio_resume(struct platform_device *pdev)
 		BUG();
 	}
 
-	if (IS_ENABLED(CONFIG_PWM))
+	if (IS_REACHABLE(CONFIG_PWM))
 		mvebu_pwm_resume(mvchip);
 
 	return 0;
@@ -1238,7 +1238,7 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 				     "failed to register gpiochip\n");
 
 	/* Some MVEBU SoCs have simple PWM support for GPIO lines */
-	if (IS_ENABLED(CONFIG_PWM)) {
+	if (IS_REACHABLE(CONFIG_PWM)) {
 		err = mvebu_pwm_probe(pdev, mvchip, id);
 		if (err)
 			return err;
-- 
2.53.0



