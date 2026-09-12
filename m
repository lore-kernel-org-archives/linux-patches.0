Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9813750D6;
	Sat, 12 Sep 2026 09:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205555; cv=none; b=pWfPMB2YPRGlnzEIqTtZslNLW6MbFVCcTFqQDLA/olD3iKjSblR89GEPCGlQGiZNnbubQP4OZKvmPzE2YY3cLFTvMTT0tYPRKGweb0rY0c7y7JwNLxDW8m83O0/2ZF/UU6bjrMBEbL9+3I6QWt85M3B2lo/GdO0dRAvEfbyRP20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205555; c=relaxed/simple;
	bh=xpLdpMOM2gXKaJ65YpY2pVU+/ri1NAkmXx1hmRwvPDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuyJo0GGTB7titcXu3rZutbqvZC4FHMxHyLzQfOfQFujOog4/FZvo6EAgpTLsvqyJQItv3MTMrMWfqJQk7hLWE9AIlnwzUdn4KtwoGm6lYsmfiC0ychw9ZBW8v5SJO5L6scjPronJIAtd8Y9uQtTzTpj8YtYM2xCGqjfdKYREXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsfYHz5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsfYHz5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06B71F000FF;
	Sat, 12 Sep 2026 09:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205554;
	bh=aymhtx29RjxwGjY/vi4U1efLhNz8EHrCyEFryCVMuEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsfYHz5n7j2k3CpstD6WprGhJLcYkHvhpxHv0qxF25YOkB/n88ialo7uwxk4ihC7N
	 l57kpakfcfOrSr2t8bqBTh6G8rQawCqfFbdf1FVB8rZTsWuixwK/oXJYqlYmuxzo7A
	 knli0w0h4eg/LW0OK7eppvM7aXq0+kHVGVgDum1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0026/1518] i2c: qcom-cci: Do not check return value of cci_init()
Date: Sat, 12 Sep 2026 08:36:35 +0200
Message-ID: <20260912065624.014240846@linuxfoundation.org>
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

[ Upstream commit 17c5d247e3e4708cac05ff087c8013c0dda383a2 ]

The cci_init() function is not supposed to fail, and it never returns
a non-zero, so it'd make sense to convert its signature to void.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260515234121.1607425-3-vladimir.zapolskiy@linaro.org
Stable-dep-of: f98d49864821 ("i2c: qcom-cci: fix autosuspend cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -246,7 +246,7 @@ static int cci_reset(struct cci *cci)
 	return 0;
 }
 
-static int cci_init(struct cci *cci)
+static void cci_init(struct cci *cci)
 {
 	u32 val = CCI_IRQ_MASK_0_I2C_M0_RD_DONE |
 			CCI_IRQ_MASK_0_I2C_M0_Q0_REPORT |
@@ -287,8 +287,6 @@ static int cci_init(struct cci *cci)
 		val = hw->scl_stretch_en << 8 | hw->trdhld << 4 | hw->tsp;
 		writel(val, cci->base + CCI_I2C_Mm_MISC_CTL(i));
 	}
-
-	return 0;
 }
 
 static int cci_run_queue(struct cci *cci, u8 master, u8 queue)
@@ -598,9 +596,7 @@ static int cci_probe(struct platform_dev
 	if (ret < 0)
 		goto error;
 
-	ret = cci_init(cci);
-	if (ret < 0)
-		goto error;
+	cci_init(cci);
 
 	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
 	pm_runtime_use_autosuspend(dev);


