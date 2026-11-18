Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023204;
	b=q7xS3dArA+skgMXjmMPmBgRqXy6BmngDEB8qlr8oo+jMDD3+Hm2u5t5UhSAke5uhJQCO
	 YBb8pguwjoI4G3oQN/4azCCmASRb2Y84XwJfpQ9aswNWaP5YRXP6zsAs+eo1uz1D7tUIm
	 N0kRHeDq39BdGOlgGQAq8juCyHOXV9O2aay0Wj6N1FJkit1iG4EsVo1U0f1hbSMTv9WuF
	 GEz5e+Li37PXKh2Ws9NGNqFF0kxyk7n0TktZOGCOSvLhzGGhKRekZHFN08uhHEUQP7ivi
	 Xr2+EnxMOsfCQMF+ZwtVjujU/qbWwnV7Fti7gRbLiENHihmJEmkK4Swz5qicSP3gEUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=knVNeAVpb/M3dtttxjrtrTv/MSM/Sqq56i5mt698e5Y=;
	b=x5e+lkJ7CMkM4nG0+hunTcVF8pRk9WjAxiFLptJsdikbGK/rlNlT/Pysjz0P2o1J29U6
	 eiH+X/tJiS9IIZw5oKBtMHPHRqSh0HHvZfFURnLtFaPa/EgWoQ7F1vn2dws9S6QSeYwSD
	 ueWvVC5JnktZJyl050fxYvwwr01GF83gCfariyslphXP1qPb0oVYRTHExj70jgnfWhLPJ
	 KE6RZbNSaXf22LkEugiQs/hTqVrxYHrFxVs1f756yXKXa2A82eKRLYq0t+LM7PPwBsfvJ
	 Fu/HThWX3vFOoBlKsFHNchZcWb487Wot6ayAJ6m0LXqhctos4nT/U1TOJiTagNUWWDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjwDDAiL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1213D606A325;
	Wed, 18 Nov 2026 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjwDDAiL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6735E1F000C4;
	Wed, 18 Nov 2026 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023203;
	bh=knVNeAVpb/M3dtttxjrtrTv/MSM/Sqq56i5mt698e5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjwDDAiLOItMp2OtAnsF6SBPBIiFXRIrXU/LIj0/n+nT585zuimY7i6IwqxfXUJbV
	 xCwaaSdSDGIAXc2ZMUurO0yO9lpb2WWmB/4IRzVWsy0ItPlG8XuckqNakL+edwpnDv
	 o77u6iwVtlcmHil+IAYcot1LyxVYRdIeh3T9h/zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Manush Prajwal <manushprajwal555@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0284/2151] pwm: lp3943: fix NULL pointer dereference for an unconfigured channel
Date: Wed, 18 Nov 2026 15:33:39 +0100
Message-ID: <20261118150132.242040838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 90b0733c00c1b..ad761daab4f44 100644
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



