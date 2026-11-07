Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062156;
	b=nkS55axMrZlwj3hmiBdCpayXWd6+YsWn06qKS1EBlgeNXBy282kpTDH00SG2kcpsslud
	 lYpKro1+AaXtqyfEZQpxDLiJE/g4qjwYjo/rrKqDrEG4vW648o81xB6PKGd4RsKiVp0NY
	 Sdph2tEMQM3BfUG5AR8Lnzzw6f7Vnv9V1HmHYUUKwJ3yOoUREFqDvJByFlj3Jn9Ky/YiE
	 Xx5yBf4KvG2B9essCY3Yl2FbHHF5wL2y5Bj6rReTtOm1q+7Vs9LAEEqzVtyDLD9ijowIu
	 XO2eu1mVW6nd214RKcE6CadV9qTCluyIS053UKsPVhdFIunBgayAsmfR2wxu4kgEQng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wne13es3bvA4aUWCOL74Vn7vJqesLEJlF7M1difUDNs=;
	b=rshw+r5p2bPfNMH/B2HFqiosd7gu/1M2kNP2kN+9Xxj/4abBHK+5rDgTiXopyTHFb7Zk
	 5vgU5Veb+9SOR8nGgerCyjWtrUQy7GZEorapSYKWMMUs5rv7fndHJ41aMpkgCuI0QAdbh
	 cgJ8Wra2TTZl0YyB36jD/7SH06+c4LJNGPRXvr8tCmPquihg0i9LlfFwVlVDMp7s4qdQJ
	 /rObHepPObQ+UM4i3li11vJ1M1JSv+ZzZtn2c0UeBoTqf3ajmqPjMJXjqnIY6RxeqtcTL
	 XFeP6xIj5Eqbh3k7bQ1mtwZgd+SrYzSYJle3FNjtKHsCiadqwnQjKxrcvj0yh20l4bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x/RIpVNM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B3A606A66A;
	Sat,  7 Nov 2026 14:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x/RIpVNM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E981F008A3;
	Sat,  7 Nov 2026 14:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062155;
	bh=wne13es3bvA4aUWCOL74Vn7vJqesLEJlF7M1difUDNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/RIpVNM2SGCF9QPHsz3BtIb2fbG4uHUsi7XyhGq5FIa8KXLxJa8SH/tgxh3scyN7
	 iwprIH8PEtp1R3G+oJykMIO1SlltznMv1CWT0HNT7NPSc0ma1aoww7bCUWH4gReo1/
	 R44H9L63Fm5wsMC8rJsi3phHPmE3nguIPXbLTbd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1112/1536] pwm: tiehrpwm: Clear period on disable to allow reconfiguration
Date: Sat,  7 Nov 2026 08:52:08 -0500
Message-ID: <20261107135028.940382138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7a86cb090f76f..a1c36ce1a6619 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -362,6 +362,9 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	/* Disable clock on PWM disable */
 	pm_runtime_put_sync(pwmchip_parent(chip));
+
+	/* A disabled channel must not constrain the sibling's period */
+	pc->period_cycles[pwm->hwpwm] = 0;
 }
 
 static void ehrpwm_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
-- 
2.53.0



