Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9014547125E;
	Tue, 21 Jul 2026 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657203; cv=none; b=BB8juITwC20B5EomvWD4hLXZ6Cd6S2tmJK9FlVTqj+YnRwv9A1T0xMLXJWh5eY0gNkyLCWM5qUPMn/D0/9CxQl3tx8jBeg3Ajy9xXBXzt6dCmAu7ZE3IywYNzdRvo32i/VarT2W1Q+N2YxdVcM82UZYHoO9RCFKgIx7ChvQPnlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657203; c=relaxed/simple;
	bh=whdDeMEpB6OZEE9xkHdnTfqpJelm6h+YU29qf0eIDuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hBBGSzPgo5p9MJ47/2lsHZifSXiNjXl7mrb6XQV6wWYHB+thHQPGDOt60zAyueDDC26c4pEPY+1rxz7Z2rnTTiIcKAdI6ykVDWClbtNVdb52mO5HJtlgd09nZZihtUA6YXTAPjAX8tLrRjZeCGmggtRwtS8sWpMBJBxKAvBbB7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFp6vGi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFp6vGi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F5D1F000E9;
	Tue, 21 Jul 2026 18:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657202;
	bh=hVN6HuMFPqxZfmHK1dqXdKSVR/SZXxteWgmyBLD7MOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFp6vGi/CEBBHsQFFRyyUNmNpmj+BjueOxtYxFQNPUVndYfd5gqurmy8LK87Nj9hO
	 bhGEz3RB8tX21iHyg4/eR3SMhqdN7V8G9sfUGm2XJ9ynDTrdAlGpJHJqinwcIHt3Yj
	 L5Rn5CEpBHfGPgivUYqj6YuBNBsajhsEy4iChCy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0676/1611] pwm: rzg2l-gpt: Add missing newlines to dev_err_probe() messages
Date: Tue, 21 Jul 2026 17:13:12 +0200
Message-ID: <20260721152530.587720780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 898ab0f30e008e411ce93ddf81c4099abd9d4e46 ]

dev_err_probe() internally calls dev_err() which uses pr_fmt() and
printk(). Kernel log messages should end with a newline character
to ensure proper log formatting. Add missing '\n' at the end of
the error strings in rzg2l_gpt_probe().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260604095647.108654-5-biju.das.jz@bp.renesas.com
Fixes: 061f087f5d0b ("pwm: Add support for RZ/G2L GPT")
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rzg2l-gpt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-rzg2l-gpt.c b/drivers/pwm/pwm-rzg2l-gpt.c
index 4856af080e8e9f..8534a2a9cf7505 100644
--- a/drivers/pwm/pwm-rzg2l-gpt.c
+++ b/drivers/pwm/pwm-rzg2l-gpt.c
@@ -408,14 +408,14 @@ static int rzg2l_gpt_probe(struct platform_device *pdev)
 
 	rate = clk_get_rate(clk);
 	if (!rate)
-		return dev_err_probe(dev, -EINVAL, "The gpt clk rate is 0");
+		return dev_err_probe(dev, -EINVAL, "The gpt clk rate is 0\n");
 
 	/*
 	 * Refuse clk rates > 1 GHz to prevent overflow later for computing
 	 * period and duty cycle.
 	 */
 	if (rate > NSEC_PER_SEC)
-		return dev_err_probe(dev, -EINVAL, "The gpt clk rate is > 1GHz");
+		return dev_err_probe(dev, -EINVAL, "The gpt clk rate is > 1GHz\n");
 
 	/*
 	 * Rate is in MHz and is always integer for peripheral clk
@@ -424,7 +424,7 @@ static int rzg2l_gpt_probe(struct platform_device *pdev)
 	 */
 	rzg2l_gpt->rate_khz = rate / KILO;
 	if (rzg2l_gpt->rate_khz * KILO != rate)
-		return dev_err_probe(dev, -EINVAL, "Rate is not multiple of 1000");
+		return dev_err_probe(dev, -EINVAL, "Rate is not multiple of 1000\n");
 
 	mutex_init(&rzg2l_gpt->lock);
 
-- 
2.53.0



