Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CB53B3C05;
	Wed, 30 Sep 2026 17:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790336; cv=none; b=LrbjMdU9B1nGFBm/BQ6WnRdN1Cki5J50rTQbbXPHKwRfDXEIi5Fm+FFCphgZjcgwp9/ebYFb2yVaVAoJlgBSS5qLPINI9A3hpzRk8zMGeKEktLHbeCJ2o2aF/SCFEnIuF5MwUps67M6GHq8iHErfTbZtTLKmk0beK9ejk9QplLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790336; c=relaxed/simple;
	bh=O5sykJ5o8Jsip8Cd30RyN2XiirUfhKfxkdbmaC74ECE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NiQwz/T/9izbSrhtLdmYFR7WR20yLd9HVO4bCKsReWAjblHnH+bWVIpbS7wdCiH8m/8omKjUuG2MN0wMRmgmJdfd63ExOaOL5FMQwoXkcJZ4RxZ+TB3ZHn125h+c1qM4pUpd7Tx6L9ex8uEu/CLuPqlryLPEu5IMMU+7tuKUvB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOXl7pB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOXl7pB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127AE1F000FF;
	Wed, 30 Sep 2026 17:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790335;
	bh=KQkjW3P7KJGt97A5pmYp8tM+++7ONk6/9G4E6kfRPfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOXl7pB3qM3Ovdg37bwrUPOfCi+4BA4YDDM53W29ZYY1NaQjWDuc5da1Cjnll9QHE
	 xlMC0tr33OZqNq8LOivN0g87uyZHiV3Zik9tpdecwvnDXtZYeTT9hCxLdAHBMrt16+
	 uE7/bKCo0W7UJ6lzyAC1GqlYkKVTRhIFpN4rLeHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 794/877] i2c: qcom-cci: Remove the unused variable cci_clk_rate
Date: Wed, 30 Sep 2026 17:28:25 +0200
Message-ID: <20260930152431.851462602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit b88c79699d72caa947ecaae85839b3563662ccce ]

Variable cci_clk_rate is not effectively used, so delete it.

drivers/i2c/busses/i2c-qcom-cci.c:526:16: warning: variable ‘cci_clk_rate’ set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=11532
Fixes: 8284750a1829 ("i2c: qcom-cci: Stop complaining about DT set clock rate")
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 7362a1553eb0 ("i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -523,7 +523,6 @@ static const struct dev_pm_ops qcom_cci_
 static int cci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	unsigned long cci_clk_rate = 0;
 	struct device_node *child;
 	struct resource *r;
 	struct cci *cci;
@@ -594,14 +593,6 @@ static int cci_probe(struct platform_dev
 		return dev_err_probe(dev, -EINVAL, "not enough clocks in DT\n");
 	cci->nclocks = ret;
 
-	/* Retrieve CCI clock rate */
-	for (i = 0; i < cci->nclocks; i++) {
-		if (!strcmp(cci->clocks[i].id, "cci")) {
-			cci_clk_rate = clk_get_rate(cci->clocks[i].clk);
-			break;
-		}
-	}
-
 	ret = cci_enable_clocks(cci);
 	if (ret < 0)
 		return ret;


