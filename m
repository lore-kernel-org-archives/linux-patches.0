Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064298;
	b=Z94YQ0skn1wLungxbaZxVI7CwUodMURkMY+GS1x/gSd3VE9NNRXwKrejtX6cRkpYz+EE
	 d7vdekLOwkJGyxhAOIqUd7uboITWNBsEfD9IPxytYJGQ9tp1bbxvB0mqxucU3myZFhPCK
	 ShIunT1mtPQcjevExMQZRmoOFg6Q83ihCBEvHPQjtdzf89MlwX65fuOLgR/qNW6GH/wkC
	 BevON9mJGM67BQFL6FR4djO7WFSKEG21J0N50z8ytldBhoEebEKrrSfclVmgsOyEakL3s
	 Ln4mua8uOVk3PHObDzCq1KL6ia79fXm1xHrDgW6kW/Dbo4MVz4vcRkZrFdK8Jn4fPJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OaWQ4fyv8X+fkytmIkwwXjZ28KscybDGWq6joGVR934=;
	b=DJ+dGdq5xJqh736nuGOgfkrK8PA5/pdShDIjVsr2zV3fXWQ8QiS/PpQkBrpHSKcSsxYo
	 rlcFpJ5dITazmAzkZ3ZyKDo8/0gWE56QP/Su5t0Pe6geQdabdCQtF0JhgGtLrQryq00zX
	 lzjNWx/KoJgA020UNLiXPr9xXa0T+f3JmzvnjhmsicMd6RMK1WDccMG/aEy0DDACs17+N
	 aq4ZimQ+j40K+Q3Gms9xvq6XgPMRrLI1eAwMDOSmEtwWu3Fok3MQgYF1NUdK82O+oVoGv
	 y2aBbFYomthigEVRqrNN57LtzhTxzYux7zHE3DxGYsjHIxnwfrMi97tTTrjemcyCFVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUMgYGWx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A105F606A9D4;
	Sat,  7 Nov 2026 15:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUMgYGWx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F75E1F0089F;
	Sat,  7 Nov 2026 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064298;
	bh=OaWQ4fyv8X+fkytmIkwwXjZ28KscybDGWq6joGVR934=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUMgYGWx0WpEWyz3hD06qGB7CGlrW6M1IU6F+z5jU8zcIfWNJeMcmgW4P3KltPUJ0
	 ftcZbr4PLmhAyNFk1yKf/zkwrNGR6fiQPcrk9Fxpv83AFHBXorMJMxyxKEk0jMImmr
	 BumxHK7h2zptLA78NyM/blVsi4l6i/92gzNfKcSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0392/1257] pwm: tiehrpwm: Clear period on disable to allow reconfiguration
Date: Sat,  7 Nov 2026 08:44:48 -0500
Message-ID: <20261107134950.374272883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3a53489f0b982..e3407d0a1f7fe 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -358,6 +358,9 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	/* Disable clock on PWM disable */
 	pm_runtime_put_sync(pwmchip_parent(chip));
+
+	/* A disabled channel must not constrain the sibling's period */
+	pc->period_cycles[pwm->hwpwm] = 0;
 }
 
 static void ehrpwm_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
-- 
2.53.0



