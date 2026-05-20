Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6625F334C1D;
	Wed, 20 May 2026 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295659; cv=none; b=uqpT7T0N6qGxd4xaUpEKyZ8R2+bQ9bO2cSud7Hi6lGsg3jxxomJiLe59HXI18gmUTAUv/dox9UzopVYGe5Wmbi/Tm06n9m859nwlNfT9nWlzviP8FZhGWxzQ/mTbUeiRsePCSLwuEYr9LVKiiVsM3jjmGKvuzEPdqNkJpOLiPTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295659; c=relaxed/simple;
	bh=M2rCYXydpGOwQGsBtXfqrU+GLSzIa2+GC6/Yq164wZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCjpaZpUTYWNbf3tKydtXUGDeiAqLih8d5Cs4/0+jZYNFn8K0AbD1GvuiFksvBW2xLri5Y9+zS8vPrrXFwU6hge07Xvz45H0vIBRAc4s5z5kqeufOiDDeGma8LUkXAjTrKfq55D0nuZW0f7xreh1Jn29bs7Jx0vYsGRRggG3sIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6mP97aH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6mP97aH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABC11F000E9;
	Wed, 20 May 2026 16:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295658;
	bh=MG3G5yxzfyaIGAeD/f2g075Cn0ATXsfxcCIgJYrKAiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6mP97aHEQICgEtRsE6XK5KRWO4ZywSkocLCsOEMsjlCnb2NET4RWhiVCGPlPSK9R
	 1Kl61wJZ4RVNEtLQhxuI7ogzufVWpPZyjrxRmdrVRicWbY6sTZrCVr6lN7Khc/fkEf
	 vfwwwkfD5eb1RKYyZvcNSg97DIUiiopX0fGbCVu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0502/1146] soc: qcom: ocmem: make the core clock optional
Date: Wed, 20 May 2026 18:12:32 +0200
Message-ID: <20260520162159.551496728@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit e8a61c51417c679d1a599fb36695e9d3b8d95514 ]

OCMEM's core clock (aka RPM bus 2 clock) is being handled internally by
the interconnect driver. Corresponding clock has been dropped from the
SMD RPM clock driver. The users of the ocmem will vote on the ocmemnoc
interconnect paths, making sure that ocmem is on. Make the clock
optional, keeping it for compatibility with older DT.

Fixes: d6edc31f3a68 ("clk: qcom: smd-rpm: Separate out interconnect bus clocks")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260323-ocmem-v1-1-ad9bcae44763@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index 6a23f18b02812..dd46bb14b7be3 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -308,7 +308,7 @@ static int ocmem_dev_probe(struct platform_device *pdev)
 	ocmem->dev = dev;
 	ocmem->config = device_get_match_data(dev);
 
-	ocmem->core_clk = devm_clk_get(dev, "core");
+	ocmem->core_clk = devm_clk_get_optional(dev, "core");
 	if (IS_ERR(ocmem->core_clk))
 		return dev_err_probe(dev, PTR_ERR(ocmem->core_clk),
 				     "Unable to get core clock\n");
-- 
2.53.0



