Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015726;
	b=hgGmqEIzHOi3psSEtV+UkPzuwXp3D/ZRjUYdBkdAxeWuAdp38sfvc0D7l0OLQUJB9TKf
	 iHv6Q4SizMyfsdnvIHzLJxLqKLh698+Y9bcyqhloNw9zcQzU0H/U1RHIPnRoJhvtibHxK
	 OzBbCmjEeQrT4XpxthQ8s59sD0lPCMM09JvJQ8qocogVWm+/auAIFPzjOVS/h5rM1GBVi
	 4sQUJgwctB7OC2DFHeSyn0heh+uOZK9JR6SwI7NR9dWACzQo9QCpGvDhoOuzI9es8aeK5
	 7czuEdVpPQXJa+lSDc2A7exjefwX6nXgyOA+IxzZgonQ5NtPKcr0P1XeMYth+OUFMQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9Z5ydIeW7uLjCKVpAJS1M3U9QnrfnjON4sUqJQevHQg=;
	b=K7AOBtf4NPsAB/TeTgDMhY3CTzM1xONuzFsIXmUYd1bAIzcbpGsSnMhnPqpblvTk2wRJ
	 aki2ZDePOpKXOuVxKWqpj9BkswwrBhu+UaKudZC5fxcU/cQVcGs06qdZjIsoJSOFR44ew
	 hmypPzjZ8rAblYPFNQK+IfWNuYrCoNAXeKSVhAeDyXH8pwVyJlk5I0LY/LVEI+l/U04+x
	 uHhhcqwL6k/Wm1Xs6+67gn0qfc9wJvTYsqbzEMZph3NSEeqeH32s+P4UCvyazBShsqYjj
	 qMGcQtSeOteart5XYw9f4OVJ5DeAoqVt5yAN/yIduB/dVoeGf4ZNNEBP03cuMiw5bWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfZToTjU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD57606A339;
	Wed, 18 Nov 2026 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfZToTjU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0931F000C4;
	Wed, 18 Nov 2026 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015726;
	bh=9Z5ydIeW7uLjCKVpAJS1M3U9QnrfnjON4sUqJQevHQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfZToTjUTD8WfKwTC5OYD1kKz8PIvxq+DhBEkwJjvh6TzySst8gCnV0rPGJvxQ33A
	 EVnhcq3b5LM2A/NPv7envAnjt2afUpB6pdQ7q77xdEYRNs4KK9EJzJnmrg+uCrzL2A
	 4ZxTPjJfr9vX2csjctqQ5yLAc75Pb1mRL02PjdbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Manush Prajwal <manushprajwal555@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0276/2651] pwm: lp3943: fix NULL pointer dereference for an unconfigured channel
Date: Wed, 18 Nov 2026 15:25:16 +0100
Message-ID: <20261118150257.847273178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Manush Prajwal <manushprajwal555@gmail.com>

[ Upstream commit 17dbb6938d3ab444cd6be1c95506450595a8800d ]

lp3943_pwm_probe() unconditionally registers a pwmchip with
LP3943_NUM_PWMS(2) hwpwm channels, but lp3943_pwm_parse_dt() only
populates pdata->pwms[i] for the channels whose ti,pwm0/ti,pwm1
property is actually present in the devicetree (the binding
explicitly allows each PWM generator to drive zero or more outputs,
and lp3943_pwm_parse_dt() only fails outright with -ENODATA if
*neither* property is present). A devicetree that configures only one
of the two channels leaves pdata->pwms[] NULL for the other.

lp3943_pwm_request_map() dereferences pdata->pwms[hwpwm] with no NULL
check:

	pwm_map->output = pdata->pwms[hwpwm]->output;
	pwm_map->num_outputs = pdata->pwms[hwpwm]->num_outputs;

so requesting the unconfigured channel (e.g. exporting it from
sysfs) crashes with a NULL pointer dereference instead of failing
cleanly.

Return -ENODEV from lp3943_pwm_request_map() when the channel was
never configured, before the pointer is dereferenced. The caller,
lp3943_pwm_request(), already propagates an ERR_PTR return correctly
(it does so today for the existing -EBUSY case).

Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/6a9d4c6b.79b5ea6e.147aa1.5883@mx.google.com?part=1
Signed-off-by: Manush Prajwal <manushprajwal555@gmail.com>
Link: https://patch.msgid.link/6a9d5187.d63de05c.175391.a17c@mx.google.com
Fixes: af66b3c0934e ("pwm: Add LP3943 PWM driver")
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lp3943.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pwm/pwm-lp3943.c b/drivers/pwm/pwm-lp3943.c
index 10537e74be288..e42af9007546e 100644
--- a/drivers/pwm/pwm-lp3943.c
+++ b/drivers/pwm/pwm-lp3943.c
@@ -38,6 +38,9 @@ lp3943_pwm_request_map(struct lp3943_pwm *lp3943_pwm, int hwpwm)
 	struct lp3943_pwm_map *pwm_map = &lp3943_pwm->pwm_map[hwpwm];
 	int i, offset;
 
+	if (!pdata->pwms[hwpwm])
+		return ERR_PTR(-ENODEV);
+
 	pwm_map->output = pdata->pwms[hwpwm]->output;
 	pwm_map->num_outputs = pdata->pwms[hwpwm]->num_outputs;
 
-- 
2.53.0



