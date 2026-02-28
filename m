Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE85347FF8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302533; cv=none; b=Yw7XEn9GwKoQgbfGpOFwRniAlMbxPq+/eGx5TboROtD+b2hCHhKW5uhuS0jw+BRgwYaDPzUGg18M5nHj9dinJWEoOJAZnX6/fnlbQm6xq2xUhDqj8tiafU6n3w6LmO29FshyEJkBxQCCV1m8jHvtfFWssNTQJqGuNBYfxUh7laI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302533; c=relaxed/simple;
	bh=MuPjQGa0/922i8wBeFOrZL5FMAVxu03Y8/glFZ7b2/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya6q6cM6cYzK9CMOvxbrnO8qYiCj1FjtYuwqxez1LN16TtkMT8z6nhwW7qEfbKKHZ9lybR2KFe+Mxuco3toRDFNM4cl4xDmqiBwxX+vZ8N8qhuelQ1Bvc4+NanLoJyBqBijpWnzquGV5noA4nY94O6lQwFNKO9mWD187rkqjKOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pu1i0xNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pu1i0xNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7883C116D0;
	Sat, 28 Feb 2026 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302533;
	bh=MuPjQGa0/922i8wBeFOrZL5FMAVxu03Y8/glFZ7b2/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pu1i0xNW/I0CS7nnTker+3VRmxQXdBks2unMnxTUWGg7m/XFJaCiLMECKbmv9KkGO
	 K65PhqNncSa2wczvQVVJ6NQ3RSa2uM4KiPUqogqTEEjSsAUs97motq1V5F5eEzhtNr
	 Oo9MtyotK7Cc4Jcf+46a2F2blxnfiVXQccdWFpgoMX6SOWpZ/A6CL8NJdvGUagMjGF
	 tUn4k0sqjJ85BL/qABP+cBpA1IEyRbAVi63v1LsFELU9UuapbhkFE4b9YHq3BOXhKZ
	 0w60OhjEBSibQ+iZGZpeB7vigHPfLRBSBg0NJnN+yo9YtR33XY7ZPpmciVILKSTrlV
	 fwyDs6vRj1YSg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/164] clk: qcom: Return correct error code in qcom_cc_probe_by_index()
Date: Sat, 28 Feb 2026 13:12:52 -0500
Message-ID: <20260228181505.1600663-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

