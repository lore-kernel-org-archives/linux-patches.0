Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F24535AC1A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302682; cv=none; b=vCbUlddqTZZedk63JWggo2GhK+zwIzoT0mJa7Uxvn/Y503x3TZZBq4UNmu6lzHs3X9Oe47Lmgd/6z6THJN7xjfvFPP3aL3bbGw3ztA7WJZwulGW9EkY8t0440iKGyx89ktfIThyoUwIC8f4gru8UyhyozGWnblvgyuG9bouUq5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302682; c=relaxed/simple;
	bh=MuPjQGa0/922i8wBeFOrZL5FMAVxu03Y8/glFZ7b2/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzPEEGVqvNZHQAVWCysda1YL71WJEOYgpYtjBqIYZ2VEoFa/8jqTOJtd3Tgch2yfa/Qu39SqKwMTXaV5T4mMUswA0GnAgszM09XFPYRx58hBee7jqxAHqhD6UKPiPNWJJOGnhPDgYdyQyF/NbV8/jgeIRfugOfrVR/ZK/sSDa9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfCZoFim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfCZoFim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2984C116D0;
	Sat, 28 Feb 2026 18:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302682;
	bh=MuPjQGa0/922i8wBeFOrZL5FMAVxu03Y8/glFZ7b2/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfCZoFimpj73yHYzuePsSfRfHlqGdrAH4GHWQNjYOJREEj01khk1aO0wZoD0KCAu6
	 odGhXcCqETb/LQyG1LfIg+jC3ujTN4e4+SjELJ4hnuKTcodKmQbVz8L8t+IaPL8oJm
	 dTBqcBriSMnWhEStbczyZXgnjSN8tv4eIg+qInngFw48C2xuiBSRhMj0cPSZRiWPjY
	 LgnYQ1NmjFbwx0Vi4FifWejrK16Coo25KYtZHWG+B2UEQO3RrPnT6vIBmbhts8A3x2
	 vmhFl2e8GQt/FFVM2vGeC7i7QMx37h+eRhRGQgGZ/Qv1OiNxtF4pSyV1nXjKqrLzfT
	 +sOXxbPtoLuow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/147] clk: qcom: Return correct error code in qcom_cc_probe_by_index()
Date: Sat, 28 Feb 2026 13:15:41 -0500
Message-ID: <20260228181736.1605592-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1e07ebe744fb522983bd52a4a6148601675330c7 ]

When devm_platform_ioremap_resource() fails, it returns various
error codes. Returning a hardcoded -ENOMEM masks the actual
failure reason.

Use PTR_ERR() to propagate the actual error code returned by
devm_platform_ioremap_resource() instead of -ENOMEM.

Fixes: 75e0a1e30191 ("clk: qcom: define probe by index API as common API")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251217041338.2432-1-vulab@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index 2af04fc4abfa9..8aef7749f167d 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -331,7 +331,7 @@ int qcom_cc_probe_by_index(struct platform_device *pdev, int index,
 	res = platform_get_resource(pdev, IORESOURCE_MEM, index);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
-		return -ENOMEM;
+		return PTR_ERR(base);
 
 	regmap = devm_regmap_init_mmio(&pdev->dev, base, desc->config);
 	if (IS_ERR(regmap))
-- 
2.51.0

