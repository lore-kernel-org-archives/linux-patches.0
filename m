Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A9922A81D;
	Tue, 29 Apr 2025 17:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946494; cv=none; b=j0TTL3ryf8nPYx0xpuOqh6idhEOev+7c5NpnwKv9FnbIUbOv2pGaAkNNly4HXQccmhUnhf9NEj8N29m1CSOlxxQCP7U7np7x4YpRiLSkU/XI8ORys4gpOTli/9ilJWWiV3H6+zTAeouubTHweudfmIaEWa/Yzq6kFzJ8GYAg/HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946494; c=relaxed/simple;
	bh=1KN+n1OTRu5qPmWQ7fHStklVNBmBwdV13ocKIhEXrEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jfmCbNfVUlHsA82o9v8uQkkBBQvUdNFO6jaYVAmgioiBCmS79o+ChOpDqsg6RJLixhCsZ4LCziDYktgL00hS6EyleuC3IHB8s68XOt3XnRff/p/qfB4q7yTj2j3UvQsNtlsbGBL1j8eOM/VamuMDrIZEvkRF3zPbq+a4l2XSzDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlD9P7eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlD9P7eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129BBC4CEE3;
	Tue, 29 Apr 2025 17:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946494;
	bh=1KN+n1OTRu5qPmWQ7fHStklVNBmBwdV13ocKIhEXrEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlD9P7eqG0vw24Z1UcRXy1PG/dX0sXoP19kCJrCC0A4G93cON3l1K8sfpTOOnCZel
	 0rCM0TQmFILcq/qF80+/Jh2XkloNNzQEo0mnyqMIlhGRHnmgLH/chkVJ1nTtf/y1k8
	 MGgHGHz/utTtyxOxxp//6VentqVLLGTw6rK4okbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 246/311] pwm: axi-pwmgen: Let .round_waveform_tohw() signal when request was rounded up
Date: Tue, 29 Apr 2025 18:41:23 +0200
Message-ID: <20250429161131.105487275@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit a85e08a05bf77d5d03b4ac0c59768a606a1b640b ]

The .round_waveform_tohw() is supposed to return 1 if the requested
waveform cannot be implemented by rounding down all parameters. Also
adapt the corresponding comment to better describe why the implemented
procedure is right.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Tested-by: Trevor Gamblin <tgamblin@baylibre.com>
Link: https://lore.kernel.org/r/ba451573f0218d76645f068cec78bd97802cf010.1743844730.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-axi-pwmgen.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-axi-pwmgen.c b/drivers/pwm/pwm-axi-pwmgen.c
index 4259a0db9ff45..4337c8f5acf05 100644
--- a/drivers/pwm/pwm-axi-pwmgen.c
+++ b/drivers/pwm/pwm-axi-pwmgen.c
@@ -75,6 +75,7 @@ static int axi_pwmgen_round_waveform_tohw(struct pwm_chip *chip,
 {
 	struct axi_pwmgen_waveform *wfhw = _wfhw;
 	struct axi_pwmgen_ddata *ddata = axi_pwmgen_ddata_from_chip(chip);
+	int ret = 0;
 
 	if (wf->period_length_ns == 0) {
 		*wfhw = (struct axi_pwmgen_waveform){
@@ -91,12 +92,15 @@ static int axi_pwmgen_round_waveform_tohw(struct pwm_chip *chip,
 		if (wfhw->period_cnt == 0) {
 			/*
 			 * The specified period is too short for the hardware.
-			 * Let's round .duty_cycle down to 0 to get a (somewhat)
-			 * valid result.
+			 * So round up .period_cnt to 1 (i.e. the smallest
+			 * possible period). With .duty_cycle and .duty_offset
+			 * being less than or equal to .period, their rounded
+			 * value must be 0.
 			 */
 			wfhw->period_cnt = 1;
 			wfhw->duty_cycle_cnt = 0;
 			wfhw->duty_offset_cnt = 0;
+			ret = 1;
 		} else {
 			wfhw->duty_cycle_cnt = min_t(u64,
 						     mul_u64_u32_div(wf->duty_length_ns, ddata->clk_rate_hz, NSEC_PER_SEC),
@@ -111,7 +115,7 @@ static int axi_pwmgen_round_waveform_tohw(struct pwm_chip *chip,
 		pwm->hwpwm, wf->duty_length_ns, wf->period_length_ns, wf->duty_offset_ns,
 		ddata->clk_rate_hz, wfhw->period_cnt, wfhw->duty_cycle_cnt, wfhw->duty_offset_cnt);
 
-	return 0;
+	return ret;
 }
 
 static int axi_pwmgen_round_waveform_fromhw(struct pwm_chip *chip, struct pwm_device *pwm,
-- 
2.39.5



