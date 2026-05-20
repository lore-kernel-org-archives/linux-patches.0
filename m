Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC30C318EC7;
	Wed, 20 May 2026 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295887; cv=none; b=dy4YwYH3hzQCAjjDWKvvOavo+Ni8MHu6zJWk2e0cw//k5DPjzBID30NfZOOIK1C2Nf0Ec8wpmnyN37BQi5XiVC51J+LPM7JVpyrFY6YfPoc7z2I3JJv5xWYRxFO6/EHgv7YhnEgBP4ExdB5hpdTUgpjl/VpujoaU/Vu4xAQb/tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295887; c=relaxed/simple;
	bh=BADr2ZxAUoQ0v8z7kW+ISEddcTDVFYWlvZ9DsB5ZD0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcSPTwl4c7ovHP4bCsQSEdC66ElIit9cG6s/alBf/zszkCYQo+djY3tu/u36zX05yOGVo8ZFafOqJix9La6g+NhhtA+XDB0RdoThza2017eBgTMPa8XBki/Ihg2gvqosnPTr751vgnHle2Z9VVrA5a5gIy77fbKxSe5C2dt4Ui0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IC+LOigv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IC+LOigv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA6D1F000E9;
	Wed, 20 May 2026 16:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295886;
	bh=3jWvKiZJGR7HYdr+7AkuCbPNJpEomfHnYpx798460zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IC+LOigvQ5iVsB6d+t4l6z5+4vJd9p/fGALmcWickB789WThZDCAiIq0fgVIAb+Cs
	 Y3/9v2g6j4XDy4BV5G93UcdWLE0U0RZj6j1q4e+o1jwlmsHaAT57k0v9TQaLugLCmC
	 UI17A9zjkaJfgNPZuZAb6pDxbK8DxDOLPAB/rSgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0589/1146] power: supply: max77705: Drop duplicated IRQ error message
Date: Wed, 20 May 2026 18:13:59 +0200
Message-ID: <20260520162201.508315837@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 2064c64ceb1996ee02a6bbb1de05fd6e8028e3e4 ]

Core already prints error message on devm_request_threaded_irq()
failure, so no need to do that second time.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260305-workqueue-devm-v2-3-66a38741c652@oss.qualcomm.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 1e668baadefb ("power: supply: max77705: Free allocated workqueue and fix removal order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max77705_charger.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/max77705_charger.c b/drivers/power/supply/max77705_charger.c
index 5dd02f658f5bd..0dfe4ab10919f 100644
--- a/drivers/power/supply/max77705_charger.c
+++ b/drivers/power/supply/max77705_charger.c
@@ -666,19 +666,15 @@ static int max77705_charger_probe(struct i2c_client *i2c)
 					NULL, max77705_chgin_irq,
 					IRQF_TRIGGER_NONE,
 					"chgin-irq", chg);
-	if (ret) {
-		dev_err_probe(dev, ret, "Failed to Request chgin IRQ\n");
+	if (ret)
 		goto destroy_wq;
-	}
 
 	ret = devm_request_threaded_irq(dev, regmap_irq_get_virq(irq_data, MAX77705_AICL_I),
 					NULL, max77705_aicl_irq,
 					IRQF_TRIGGER_NONE,
 					"aicl-irq", chg);
-	if (ret) {
-		dev_err_probe(dev, ret, "Failed to Request aicl IRQ\n");
+	if (ret)
 		goto destroy_wq;
-	}
 
 	ret = max77705_charger_enable(chg);
 	if (ret) {
-- 
2.53.0



