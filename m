Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2842765ED;
	Wed, 25 Feb 2026 01:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983831; cv=none; b=PYXHvhox7cNr6eK4mQe+QrbxrzyGzGaqQ48W1A/z66j42/LV7V8rSdYnqtmkwgei+aiKVXbYEvo4z0CCCJyZUpP3mLoyFu9Nqh7js5E/yyGBVw8sQdgkyxMaetRqbY44eQjnKI347cmDo0oPtRXb900dNIUlqj6lWNTrsL7seVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983831; c=relaxed/simple;
	bh=Qsy9OsHCC39NqXg0QMhwu6q2iySe+sh06cs+uBraK38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avxKEC7Qei24B0HeOXaUaxD8km+iFbXv7ZAqe7wdIoBw27HyOeTa8RA6F9ogrNbrH0t/372IHy6e70+x/G+o6wuwL5NirqvTMyxT1GM66eENUX9QU+H3bKGa/bYD5WMOiugdRfhrNBNmS1z9L5PfRsFED160pLuve6l9WeUdvGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoFr4Zk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoFr4Zk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8264AC116D0;
	Wed, 25 Feb 2026 01:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983831;
	bh=Qsy9OsHCC39NqXg0QMhwu6q2iySe+sh06cs+uBraK38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoFr4Zk/gFU288w9Q5G8g+j1apZP2XdaYi4cw27qsUH/Snp1t6YCcl+GrME2OiQpR
	 X7Gv3gO8G/dI5KAC3ImviJeGc32KaLXb/gqNvizE7BE5w95xDfKayaKC1N45MkPJja
	 p2wqM2l1wF4qD+F3DAji+W1376EpuOw1GW28uk94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/641] rtc: amlogic-a4: Remove IRQF_ONESHOT
Date: Tue, 24 Feb 2026 17:17:18 -0800
Message-ID: <20260225012351.838046091@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 18d28446231390e4ea3634fb16200865df2c6506 ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until
the secondary (threaded) handler is done. If only a primary handler is
used then the flag makes no sense because the interrupt can not fire
(again) while its handler is running.

The flag also prevents force-threading of the primary handler and the
irq-core will warn about this.

Remove IRQF_ONESHOT from irqflags.

Fixes: c89ac9182ee29 ("rtc: support for the Amlogic on-chip RTC")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Link: https://patch.msgid.link/20260128095540.863589-13-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-amlogic-a4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-amlogic-a4.c b/drivers/rtc/rtc-amlogic-a4.c
index a993d35e1d6b0..d766055d95848 100644
--- a/drivers/rtc/rtc-amlogic-a4.c
+++ b/drivers/rtc/rtc-amlogic-a4.c
@@ -371,7 +371,7 @@ static int aml_rtc_probe(struct platform_device *pdev)
 	}
 
 	ret = devm_request_irq(dev, rtc->irq, aml_rtc_handler,
-			       IRQF_ONESHOT, "aml-rtc alarm", rtc);
+			       0, "aml-rtc alarm", rtc);
 	if (ret) {
 		dev_err_probe(dev, ret, "IRQ%d request failed, ret = %d\n",
 			      rtc->irq, ret);
-- 
2.51.0



