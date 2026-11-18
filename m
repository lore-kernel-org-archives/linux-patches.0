Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046125;
	b=XBiW0z4YeG5rhGAHN+RlPClSZMTWSKP5fKC17cnVFkxpVYvvfC00dOifriWI32KrZvtn
	 f25Tlojrbx/O4WshzYtmHNYc1jMGmXLWJ9Gl+DBlwt8DEd+eVsliypQ3m7DQ9MoNP02bH
	 ZwWeOKArUhgOdcgSbqo0XtcuJk6siSjEjn9+vQfZ80awY3AhE+JxyQklyVs21+t1HzItO
	 OHWKHHhS8FGJ/LO7kL7w1k3ItxMV+6Ci8ZStsGm71WugK7pxzmyB5o8UmKOlJr05wAQiB
	 rFcqUdOyPdQcKhdc/2xb6hBC6Y3AUOh5wWTucNLki3FKlTAhD9QI76QkPQnz/iyiBRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2uXs1is3OUEQqlOlFq1ca1masYt9obs/gJl3EDVy9yU=;
	b=xO84+AihpyBhE2LsK8mafmGPGj1uXZqFhwU8UbsgP3njBL0ep+2z0527pNXaEGbfhQH2
	 /xFk1JRdk4uoyzUeBPsI7aW1MLs/JBJ3j8QvlZpRCafCz5CtwLfSe7z4kqK5RqyLkIul9
	 0Ec9z9Qz6dk7dDl+Ohuf0a+UTqzLfsu0Kg+GAnIYNiZ9cUnwmNwlZ2sbA+gEccC7RbARj
	 f8MmDyURU+afxPgio6pJbCsdW40uri+F+sJ+BAOIuLUyAioYJ2bpu2egV4qzJiAIl84ix
	 b1QF0niGuf9NfsNVFyAi2I0fxnNACHZSXUCMgHX/3O+9TUb5UYXHgA1FgpmHeVXPc4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2UtriBc2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C39606A31C;
	Wed, 18 Nov 2026 23:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2UtriBc2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68C41F000C4;
	Wed, 18 Nov 2026 23:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046125;
	bh=2uXs1is3OUEQqlOlFq1ca1masYt9obs/gJl3EDVy9yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2UtriBc2yk4LCKQnk9eajKS4TJk5YKRypmi6iqoAp1IqrLml0CAcGQCs0y1wqJHOq
	 Q0ApkLGizr/SETKQXBw78RR+wvSATWxQgStxP1tgiU0ld8MIy3UvjtUMIMjDJtAj7K
	 oP2GfcM5iPxyB58R3SujP4R9ckIiU22J8m/9scBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1170/2857] pwm: tiehrpwm: Clear period on disable to allow reconfiguration
Date: Wed, 18 Nov 2026 15:36:44 +0100
Message-ID: <20261118150243.719365486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit e74b9a7ee50071aad25d3989bf985292f90b0c6e ]

Both channels share one period register, so ehrpwm_pwm_config() rejects a
period differing from the sibling's period_cycles[]. That value was cleared
only in .free(), not in .disable(), so a stopped channel kept blocking the
sibling from switching to a new frequency. Clear it in .disable() too.

Testcase:

  cd /sys/class/pwm/pwmchip0; echo 0 > export; echo 1 > export
  for p in pwm0 pwm1; do
    echo 1000000 > $p/period; echo 500000 > $p/duty_cycle
    echo 1 > $p/enable; echo 0 > $p/enable; echo 2000000 > $p/period
  done
  echo 1 > pwm0/enable	# before: -EINVAL, after: succeeds

Fixes: 01b2d4536f02 ("pwm: pwm-tiehrpwm: Fix conflicting channel period setting")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/20260929120806.2790355-1-alexander.sverdlin@siemens.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tiehrpwm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 6b3248be2bf10..210ab9fcd87b3 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -386,6 +386,9 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	/* Disable clock on PWM disable */
 	pm_runtime_put_sync(chip->dev);
+
+	/* A disabled channel must not constrain the sibling's period */
+	pc->period_cycles[pwm->hwpwm] = 0;
 }
 
 static void ehrpwm_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
-- 
2.53.0



