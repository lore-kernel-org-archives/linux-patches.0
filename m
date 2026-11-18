Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037370;
	b=DerUPLsgmZQjvGI9KKGv3hoGLCxq5YJTTJ2OlGtR2NVCJIcT/jAOwAwGbCag85Z+px5n
	 /Xz3MbaSVJZur8psqgjww4opElB9lHllbTOuWV3/OmTYcyyh0X8EAcT4hLc8GH+h1QJqo
	 hWbR1KWSeD93yBwDMiAQZ6CavK1bh67q7TAknWh3V60VCGOy1UJ5fZEIYm0L2as3KdePe
	 zEg/qVG3N6Wc5O9OgZ8kEJNzGx1//9iBhDg6BpsvqEoBfYM+MgBxkIgY6vdqRwaNI3S9+
	 njsw2lLZChatCrcRmgMq73okNVJC126OVAS6e3+uUw+rHHtGg8Fu9hc0JMIYXfJ35tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=s/F4V9mHxSe0PU9o+fpEhL057E1WXNSHTOhPM6glS4c=;
	b=fGzutfgvC+SAdRh6fxpH61Mp3sWoamMakv/AcSeWozmt9xnj9LkhhXoA1EXhweCWKTiA
	 sQ36O/Ia9QYb4cJ8RqO9y2v0Vbrja34byVRXGTnKLPZHDi/TbRMzmomdWYFbQQsll/TM6
	 qR/hzsM6sXg2WgJ6zdJDYEmPPFEZEclG+IPEwCiDg3ZWlSFXbHkHkymWqx5pOz2F04gif
	 n9o5mS+LWfO4HdWuwqflI3e1BxGqSaMM3HSWCURGLtiW9g8JHhqvrzW8WIVTAs81UichM
	 XQ8ha2qTBmkHpgyWWBoHWR4l6qf4U7UzgrsS77z5CjuzLwjiZoVm1dnlTh3U+8cwR6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NfqZypvj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161E7606A32C;
	Wed, 18 Nov 2026 21:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NfqZypvj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528A11F000C6;
	Wed, 18 Nov 2026 21:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037369;
	bh=s/F4V9mHxSe0PU9o+fpEhL057E1WXNSHTOhPM6glS4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfqZypvj+o23lwBp7UtSpBR/pWY4cp4S7wbxXg0l/Ahz4umTtksg0rNnLMgNfiZCv
	 tWsAaf3T6jECixds7ZDqyKHEW5lIgOXpA2Y2TT1reR+LtOLcHzNhskTK1l9ZCrixu9
	 usopi02w3KxaUkaLHXxbnR0sp/DE4pNEUmYEydNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1377/3318] pwm: tiehrpwm: Clear period on disable to allow reconfiguration
Date: Wed, 18 Nov 2026 15:33:19 +0100
Message-ID: <20261118150401.830899617@linuxfoundation.org>
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
index d693b2d65cccf..9af6cb08a01c5 100644
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



