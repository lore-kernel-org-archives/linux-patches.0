Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053154;
	b=zfRTEcomabw5egEbvZ6ESTb85W8buwgTkpyrXAA09KfZjY9M1hbOJg17l3L70G4Y0nXz
	 hPWBo6d//1uZw8nsp+pejMqlm32ZegtXwMdhivpf9IR9EM6klu69PxRkvrI3OtNmOfwR/
	 +dgOSZDX4AUnxLa5gPqLfS6dMKruywdgo1lpm1PVJmWta5PINXqPKAhRg+mzibRWRYUa+
	 JyNLWMZHQjKpUm6fzZwbfeIoF4D5fpBLyuXyUg/yCPoWIlIwi0trFXK2/rKMiavuV/7b8
	 ZzC+v5nLYuVb51P/vzhdvWXa4q1jcJZZsIWn3Hn6MfXH9MiUyeXnvY8/wU4zREGS8Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3ZUPnPNtU23AyOwG7Z5pjzgDwu3VxOjeQ6ZbWzfKYsY=;
	b=V4/BDbTSldMRYaowvWXOFJL2c4OM4F7Nixll5CByLwgVlqTnOoWs0Rg/ztaJ/SthNbDm
	 0vQlRffxfvH4kK45MAQl09mbpF5KEHAuK7CzCOx2A4nyewtQZmGQ7P5za3+mHUP2v4Bj6
	 3HME1FR+3NAXVmahBDACS8r9DxXvC8rSYICZRLqq85h4v0dv39MmKwSecaQn6gYiqxgI2
	 pl1VeZ7dIZSo5pzXfuVcBR3C02ZQC0wm0RfXrZVs0gcbCZSxL79GENly1/O3NBlyqiy8V
	 LlC6KNkLTtLiVuABJG5w1K85TM+mbXAPXZHJH/HrRgQfTLyHcLFdZjDvqKVKhian37w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZTYWqdX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3817606A32F;
	Thu, 19 Nov 2026 01:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZTYWqdX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA4B1F000C4;
	Thu, 19 Nov 2026 01:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053153;
	bh=3ZUPnPNtU23AyOwG7Z5pjzgDwu3VxOjeQ6ZbWzfKYsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZTYWqdXh8QllWOv1mT/okwuqmPyk6C10OYqXyP8UWvX0r35sQYLLjqoKdNAujoWG
	 z7uucnonBrzje335n3mSk7ROU+w/LUeUidHzODNWY3UqdWAvMHfbIB4AvOPkHxljpy
	 Fzawg215wJyegYkfyyl9do3339aczmRKaY7nhTdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0817/2214] pwm: tiehrpwm: Clear period on disable to allow reconfiguration
Date: Wed, 18 Nov 2026 15:41:33 +0100
Message-ID: <20261118150044.245087808@linuxfoundation.org>
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
index 3fef7d7987736..9a6e30e56e6ee 100644
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



