Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060388;
	b=y2MY3KSM8oRQHj51w/yQfx7HFss39Kl39VOnQHYJhDZTW6zkp9Q0wdK+4Amx+nzPvyIn
	 hR37uNiLWp17JWL/43FOWa2hPB0kmjKsC7fgSozH1q9Qx8WSdET6x/Aplaahx+1CNBD/m
	 PeNxn0ce6PJaP1oZ+pZ0Rvehc4Y38U85wZ5Gg8Qo5VHZ+tmi3KOZKv5eyxCploFgFwEg2
	 d28795DqhazVrqQr7zeCl1fDPseCsPbSA/mp5dHYvkiFchEP7kXENza75sbD2ZYEnwx0m
	 q7zvEdeU9fZRMuY6Nr3YMPZkKlDmJ8gYHiFsWM4DWbyq+bDvNebF7buYHHC/o9yh28w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QkwODHyanUNAiVnyfwb+RFRYUIWbgm3D13Wy0wHLfnk=;
	b=Cn4Cx34MHnj4kYY3Qy59m5iOlzvMR2+Tx0CYie1oYOqPEu3qQqoZMSRjZT3IK+qd5xs0
	 Z90rfOscCH0b6iVE6wD9dKZ0mLq2rsMPhUbQIfFtx6X2ZAg/nZugwUdsd70MfeoVJlyxN
	 oqt9JCivAdTdWaxxS+QLIfJsG7nZxABoOtgGNzuLXwSTAok0bkuWEiBICjS2fG3S5o1Tj
	 CVWCusqQjA7NSp9wnvWRYDvM1PvOYAyvN8EDl3t+XbtCgeVPTn+JpZqaBLNRVoDgMEELe
	 xHaNRHSDTSf6+2NS+9BquVPUstWXXV06YlDLwBMexDEo7QOZo+GywfWnfvIjSvNOiIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1sjq3GG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32268606A320;
	Thu, 19 Nov 2026 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1sjq3GG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892291F000C4;
	Thu, 19 Nov 2026 03:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060388;
	bh=QkwODHyanUNAiVnyfwb+RFRYUIWbgm3D13Wy0wHLfnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1sjq3GG843X/51nfTqqb51yjmcImi/0ojeYwUaWIxr9NlU3YHEcyReP6NwSPjldI
	 CreDhtXz2ik4HazZpn7fvNl4ZQqWgKt2csvqv1R4u/kN+xhuW1gYiJxaTz6JwjCb8V
	 cVRNa4Fvxzzx1YcE8gG+7CuyI7D2ZwSKIJdioIwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Manush Prajwal <manushprajwal555@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1180/1848] pwm: lp3943: fix NULL pointer dereference for an unconfigured channel
Date: Wed, 18 Nov 2026 15:53:38 +0100
Message-ID: <20261118150008.957297067@linuxfoundation.org>
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
index 840c4257e5936..16e0291876d0e 100644
--- a/drivers/pwm/pwm-lp3943.c
+++ b/drivers/pwm/pwm-lp3943.c
@@ -39,6 +39,9 @@ lp3943_pwm_request_map(struct lp3943_pwm *lp3943_pwm, int hwpwm)
 	struct lp3943_pwm_map *pwm_map = &lp3943_pwm->pwm_map[hwpwm];
 	int i, offset;
 
+	if (!pdata->pwms[hwpwm])
+		return ERR_PTR(-ENODEV);
+
 	pwm_map->output = pdata->pwms[hwpwm]->output;
 	pwm_map->num_outputs = pdata->pwms[hwpwm]->num_outputs;
 
-- 
2.53.0



