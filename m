Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26594EE864;
	Tue, 13 Oct 2026 12:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893437; cv=none; b=pGSimOeh5cPEM7UwW+dA8eoFqDLbbmC1woJOThcjiD8WiISlpWRGR5wbu76SnPaIR50krRtK8guVVdKHSpDWNXf4HeORzlL+UOrHXpxcOTLT3Mrdp6e7FWRa1Wgk+zHiuXuyBGQOliRXRs7ZO2zZTcKWQLh0ZQ7poYJju+aLA/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893437; c=relaxed/simple;
	bh=ff4lkxK69yFnAsFBJo8O1cyUDOpCkLey5jj54iwQ4BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCcHJZlmeduawMkqxlIN82uETe3pHL8eR1IVGvZkafjIOe4jBR/eepWx0DobG7/Rq+Mp2p4nxc3jTjMn1nXgYTdyxFPtTrEIL2rOO2sT/UEZUYvtJVLNVZ0O9LoejralmIaH/Xtf81mvB4o4xgE8tFNfywc2kW+WtGQqgoZiRHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LG1Q1Iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LG1Q1Iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2A81F000FF;
	Tue, 13 Oct 2026 12:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893435;
	bh=ab3VHzStmIwEb4lJSPh3BHnwakYsdqU81+EuC7lI6ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LG1Q1IvzgIzb8D3oOll7gLWSqtBCBnedv3ZwUfxQ9lU1jfRcEOcVIDQCzc83q6Hr
	 5uQvPuj6o9VWkdgxQxvCWFMfdc8b8yTQr4lfpwSXPf/N2EdLVjtWOU1NcLllqpxXde
	 +TRtRn0KUgbUEcvXYcHBySiSI21mpobXcprfWhR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 225/621] power: supply: max77705: Drop duplicated IRQ error message
Date: Tue, 13 Oct 2026 13:33:40 +0200
Message-ID: <20261013112926.196832336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
 drivers/power/supply/max77705_charger.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/power/supply/max77705_charger.c b/drivers/power/supply/max77705_charger.c
index 1044bf58aeaca..caaf90f91be4a 100644
--- a/drivers/power/supply/max77705_charger.c
+++ b/drivers/power/supply/max77705_charger.c
@@ -633,10 +633,8 @@ static int max77705_charger_probe(struct i2c_client *i2c)
 					NULL, max77705_chgin_irq,
 					IRQF_TRIGGER_NONE,
 					"chgin-irq", chg);
-	if (ret) {
-		dev_err_probe(dev, ret, "Failed to Request chgin IRQ\n");
+	if (ret)
 		goto destroy_wq;
-	}
 
 	ret = max77705_charger_enable(chg);
 	if (ret) {
-- 
2.53.0



