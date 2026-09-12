Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C34355803;
	Sat, 12 Sep 2026 09:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205793; cv=none; b=Z4yW4vfZGNYJ937Ru8oCE4tqrwbclqWTG8HWg+wTOLI2aLkAhlSuRBj+Ii/+3UjJeEKdxI3NTuBEVYclJyVY+512DS4Zqe0c0rRPPOBkFsOl1cFsga+srthqhnUyKAlWXPjUCZXc+vpEKHgVeTfhi8mkuduZEyEklJmGW71vePM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205793; c=relaxed/simple;
	bh=76Lxi/OL6TcOMAT78hJ4CQSXnifZT+75382vmF2uhS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+T/jO9DBmat4uTpw8CcMUrfWVlEaTERcaNnvij1Yw5UCoXbLWQZiDQItN9Tq59sP8VVYWEAZ9XKe+F7+jercwpBV7dmdkGHGbDLGqx656xPuRmKWp4Sp9HjaSuVuypvSiJUr3pMDpR4tu2nVo0w0M167TSu9qinMh22MtOVowU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3h65Pm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3h65Pm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B341F000FF;
	Sat, 12 Sep 2026 09:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205792;
	bh=aQBRgr1hUkVlxX9uhaf40effI2YohZIOaeygiQx3ULg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f3h65Pm0FbBm9PfQ8NVpGhpeW7LUXY8toyqFpxWQAT09caHZCWJzv0zZzuHTSgRD9
	 JTCcMKGNzLCArinxAK3n2EBu2JwHZ5XO/ud0jSMK2AKGA4l3cOzXURy09jSVZWTSbX
	 DktSNhyAp5AA5hQc1r7r/9psx51hctf5zPwDJZ/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0047/1518] i2c: qcom-cci: Remove overcautious disable_irq() calls
Date: Sat, 12 Sep 2026 08:36:56 +0200
Message-ID: <20260912065624.502191698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit f0285c286bca5a1e018ba25040cef6c7806c31ef ]

In cci_probe() the controller's interrupt is requested using a devres
managed API, and in cci_probe() error path and cci_remove() it'd be
safe to rely on devres mechanism to free and shutdown the interrupt,
thus explicit disable_irq() calls can be removed as unnecessary ones.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260515234121.1607425-5-vladimir.zapolskiy@linaro.org
Stable-dep-of: f98d49864821 ("i2c: qcom-cci: fix autosuspend cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -594,7 +594,7 @@ static int cci_probe(struct platform_dev
 
 	ret = cci_reset(cci);
 	if (ret < 0)
-		goto error;
+		goto disable_clocks;
 
 	cci_init(cci);
 
@@ -626,8 +626,6 @@ error_i2c:
 			of_node_put(cci->master[i].adap.dev.of_node);
 		}
 	}
-error:
-	disable_irq(cci->irq);
 disable_clocks:
 	cci_disable_clocks(cci);
 
@@ -647,7 +645,6 @@ static void cci_remove(struct platform_d
 		}
 	}
 
-	disable_irq(cci->irq);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 }


