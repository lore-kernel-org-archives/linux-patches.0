Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058954;
	b=EbUQP3pS771EloR1X2oBwlysDRhR0Xn8aTjipiLqabSonyBkMgtLPnihfh+CigvN/usg
	 izpt0iXKcgkZFrR2ADosBMDhy7+k+Mptw0vE8VYFN1N0nB4YVKSp8FxbJS1z8RDzLzTk+
	 KZQgfO9COHPC01q2EL/gh7NN6ImVzczBZGFATfSzcQetG8JCxA1bkjpNjC8gu0Y00FOIC
	 Upif1EGGPO7OEUT8wEL3uXGBHX2s+diDyIUVm8walFUWmV9x0BSwbnUcZffdni9WRrIFB
	 gfB8e6jtGqe/GnAIOVMgz4aJ041JKWaid7IZ+pZGSghVXdU1D6cxy0n6dx7wTx1lucg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CqtMg9BS9Fk88cqT74MdffB8YyByFwK+ApwkMVZrgAU=;
	b=EHJIBI/pie7HmFxG71OPOlUwwH994BK6yJNrANnd8TQBTiXlpTPophSbqkPOMu7/LsJR
	 hdMtr6ZrmMdvXJ7yZWKeLqvD6ypf2/grY1OM2Nii7OFEkeV1b5cm9NakbY/jaX23IUxXe
	 /kldPAJYKAr1K54un7jyhmfvuNPalGUQ1bFMLOEdVqFD8v2IdiALjEZtJ/3oFk7qstb4b
	 GkXt2FPh6bwTPV2PgXCDBSFyj+XJvZEsIVibD5PuBNu7IXFuGnyiD2nvaQXuiHn9IMl5N
	 9LW/G1KIw4feDTwBauVlBzN6sLDNszxhPiWliWyLyPOsntg9n6gjT84dZRCLjkcDvfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8a8cZcW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DD0606A320;
	Thu, 19 Nov 2026 03:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8a8cZcW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FFC1F000C5;
	Thu, 19 Nov 2026 03:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058953;
	bh=CqtMg9BS9Fk88cqT74MdffB8YyByFwK+ApwkMVZrgAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8a8cZcWcTf6fuTkHUF8+B9qDjopO8AffUWju6+bJLDVYmXIQPzFHl0hHue72/kRS
	 avh1NN62V5DP7gSFYfhpVxw30McUHo+zDV8eR27z2rZ7JfbWu3LtRkz8qI41LIIbrZ
	 7N3o3stIgyM5o34vyQp4QQbC+kZe8gjXWsaeN7Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0663/1848] pwm: tiehrpwm: Clear period on disable to allow reconfiguration
Date: Wed, 18 Nov 2026 15:45:01 +0100
Message-ID: <20261118145943.515465201@linuxfoundation.org>
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
index d799537f320c8..e3bb8d54ce153 100644
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



