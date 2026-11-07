Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063059;
	b=5KPWfb804gqVri0y5vJnuTd03KicIRq0InRVvgZw6LaWrH2k19Gcp3pB5wHVv1o92C2k
	 fhGeMnhUjSvDz5KJQABD51Q/EExbpU/gvtUwxHUt8pyJgIRlXtdZGh9Q3VzRM9TRiVl7q
	 ZzU40bgAbwXwDULhWrIP6OibVVwdM2GpqN1+i7jfhbPkCBhavQvd/YK1SiLMQ4UfPzWga
	 Xw+rXILo5QNxLzWtDvVmRFaF+OxKbsqsO5e31fppDOkzR0h9FnoRzDv70buCSQrO631Dj
	 fC1Og9GzY1MquJ3U/eDPlCjq4HkXa4HjNsjjp0crp4IGJq8s2kZqiJVMV18OSs5jzEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Pp/L8sh33wLdRFjD44aeXbzWvyUERYxVrP4lJYKYYDQ=;
	b=UwnzAc6h9VT5vTIpXI8FIDr0I18hD8g1Bpu0ylciYQ/L7oWFzrCDDW5ljr4ObLOhp9Cm
	 TP0SE/FNbtlaGfe+cD8FM1rEJW26bY8Olf9Irx1yxg6WS11MEPRJQ03cDMVm7OX0bjCKy
	 u5CHWdCVO+ww0tjsyIezT4+fiQgBV7yUs3IYi58CzhyUObXy3c20cv7GTIEam7ptsYqAm
	 rA7NhgPWKWarTWiErUHzsW1kWoKLr3uvtDGMEDMZxSCM38+G/MOmph3ntJKy/FExS3DQp
	 gfGGfq8DsTGylbCGbWyBofyzeb33JQL2qPCyeRyEGENEJDnY1Hft3QBza3IlzodMyRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znl6FSuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE53606A331;
	Sat,  7 Nov 2026 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znl6FSuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C255C1F0089F;
	Sat,  7 Nov 2026 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063059;
	bh=Pp/L8sh33wLdRFjD44aeXbzWvyUERYxVrP4lJYKYYDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znl6FSuVEBa6iZvyjZZPffFsapA0uK7GrS2XqI1tGOaG1g5SbcfPOZvDL+1I5W1J1
	 SF/qYcQ2Q0yvLGF/iWcUJ8/0tstfF8vgmHzUwyPR+MKvT3ab6Gr6vymYf6A5gkuA5d
	 N9cR1GDy6IUgzztUcAzBRO9VP039Cs5Ur2InX+yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/869] pwm: tiehrpwm: Clear period on disable to allow reconfiguration
Date: Sat,  7 Nov 2026 08:49:43 -0500
Message-ID: <20261107134902.784524978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 2533c95b0ba9d..c02f69de44dcf 100644
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



