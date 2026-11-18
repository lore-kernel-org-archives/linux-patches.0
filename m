Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045041;
	b=o+2Ps/UMspUJnNXk8P0jTgFwKYJO85mmEAxkeBPfLl+i29z9PF6M1+3t0lZi7dNkArWw
	 BYcNVitc/GpgQGI1f7ySznwdkhpMs/f1hmcz2gzzHS++BoG26yLAM8RYENCTio6X4j3W3
	 uvNUnY4L81lF9856nf8JAnNmxGZiKDmTwgPBAj3t2ov70LPpOdkioIZ5TzpE0qgBC+pGU
	 V2I/aI2WpWm+CoQPjqrFV0RlgF+Q0g6DLtSsNabHDg/NoRWCK/tM5r3eiaIfmp2YZkWBV
	 0Fz4Xu9SpYTa4imt15wBM5WnMld/0BpVaPPh/9eJR17kuzR3UiT7TgHMfEAkKPA4iEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7HAvK4wpZPrW/njtpbkVIhE0F6p9MG6O+2gBywh6FNU=;
	b=CIu7NQMhVEdI7bU47FTJe72+pt/GZdV2TAADUfp+VJ9rt4wAFgvtUoNMe1beZkiECYSm
	 x5L3n74bRHCLMDmXMmL5V7obDHhgM+Pq1UdKFSTSz1GlhzsuomtDkjNN6gOBfgtE4AdJb
	 W3uz9Mav/xkvzeIIgeFTTZc3ldx6soWBzeAcnITIzsnPC2JNOBttNGowFrq84rkhFFIr5
	 zJ/GOTpQBWPq6KyrOfmWG12ytyON/lcVMEkRNqF+XOPgl+otJQPpO1r6He7wjFWOZatfP
	 fja3V4aEUHNdNnTEhqlKpMb1BP+p+j15tGb8tkx8tTG0MUu1Mw9O4nkBG2MUqg0cItg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDN35Vj+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CD7606A31C;
	Wed, 18 Nov 2026 23:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDN35Vj+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541AD1F000C4;
	Wed, 18 Nov 2026 23:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045040;
	bh=7HAvK4wpZPrW/njtpbkVIhE0F6p9MG6O+2gBywh6FNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDN35Vj+5xgdF1/u7KgH4Ctzh913ufS4x8aXvybAzAVkWIWtPMm9/JQVmE+pe8zdB
	 5KjXdaF2+qSCMFaTTNV8LuWLWHsRZ1NudIJj0wWbEAb2B6ELtPgw5ns8xofjjT6zD5
	 k7ezY5DuzFRxmTaV7XGWDbYVcAXzDoXc6g4mZqP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0779/2857] iio: adc: at91-sama5d2: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:30:13 +0100
Message-ID: <20261118150229.615978714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 022996906e70c6bc9a7968ee663ebbe314fe1524 ]

at91_adc_probe() enables runtime PM autosuspend with
pm_runtime_use_autosuspend(). The probe error path correctly undoes
this setting with pm_runtime_dont_use_autosuspend(), but the normal
remove path only disables runtime PM.

The runtime PM API requires pm_runtime_use_autosuspend() to be undone
with pm_runtime_dont_use_autosuspend() at driver exit unless runtime PM
was enabled with devm_pm_runtime_enable(). Leaving the autosuspend flag
set therefore leaves the runtime PM state incompletely cleaned up after
the driver is unbound.

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: 75d7556ac0e4 ("iio: adc: at91-sama5d2_adc: add runtime pm support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index e53c32c7bb58c..1ae701a5c2066 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -2527,6 +2527,7 @@ static int at91_adc_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(st->dev);
 	pm_runtime_set_suspended(st->dev);
+	pm_runtime_dont_use_autosuspend(st->dev);
 	clk_disable_unprepare(st->per_clk);
 
 	regulator_disable(st->vref);
-- 
2.53.0



