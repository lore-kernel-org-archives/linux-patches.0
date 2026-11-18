Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054795;
	b=KYpZIyO4np+EVIrYvkzOF+8JPiiVkkw2MYxsB+Pl3sW8bWD/TsEQMaDLnbgSPpAnsWxf
	 5tswmRsqsiknIBRjIo1GKrwyLi6rQyLQFpWoxB7GX9PCdrBz5q/L5GJ+C/n523Mw1kLhF
	 vbpLsV4YW7hnB6wbU/jnv9DSYD80AllEFQrf68XkGZPfeDv75YZROuZk0AHZLTdd5zLsj
	 QvFqPehEzITWee35N1oWs2Q/QfIup8ZFfuYmZJeiCV7tGFjXSmkGG60G52PYY3UTlQWpw
	 LaP67feEAQC4Fs90mnIDW9L4j7gIuSo8Iex2OA4kVmpG9oX+/oWtwk/Y9lpEtysS6Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eiA/zbiGxuFqBkOCUsysfgldR5yEnDAL+58q2rkLW78=;
	b=emSME9etrxFs9+vK6UZvthWVEzPuBmtglBd8fh1OCCqWqmPUCWAPmZMGZnXB8I+tGHt7
	 EXd3zHRva+5Z7ILE0Cc28JUe8dQtNIOozt4opm1LgIZS9LrjgDEx6NW2TlvNwlGdR1hst
	 uMpqoonkQpGuInyKRmAJ9Pr4YFXLiUpa6ECzp6i0tchYaP6l9sKNpesIXtUDCdSdTCHRS
	 i5fT9OkQrVPMh7KtlbCoUSR8agDNFtwIbPx3E+WqISGJ3JvCr8UdhE730N+ljWUKOmKYv
	 8QkAIZF1nrMlXIOmXrUg6byQ5PQymLuHRAxT2/KCsAf2YhyDuG5IPjie/jvJIfQtqQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eT5oeXba;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D2A606A320;
	Thu, 19 Nov 2026 02:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eT5oeXba
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1521F000C4;
	Thu, 19 Nov 2026 02:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054795;
	bh=eiA/zbiGxuFqBkOCUsysfgldR5yEnDAL+58q2rkLW78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eT5oeXbarf84cl4pXjI0O5gaAwVxEE0/K4oBP7ZKl/mQf4gN4xrpunyPyvpUKdcHv
	 BJCaxoB4pAFQ/oO5FXW8zlEUtM1sg/ly/nDQx/dozjAWs7dDKuxhL4rGTNEzVzxAdS
	 IRKlqpgMpKcOu2uKrsyeuN6cL/2DgoXh5TV3jQWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Manush Prajwal <manushprajwal555@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1402/2214] pwm: lp3943: fix NULL pointer dereference for an unconfigured channel
Date: Wed, 18 Nov 2026 15:51:18 +0100
Message-ID: <20261118150107.372809157@linuxfoundation.org>
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
index 725f2abeaefc9..bafeeaa15f995 100644
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



