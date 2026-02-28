Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D8C379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302080; cv=none; b=ii0uLP4TQ5WtvszHeQc6Ug6DH8H2YVBKD+kL6mGK5zsp70gRdiuexnDbRAsdMiY+lWLFieEUfPhvpEAREAfmvyrHkhXCrb7fSufZ5Fh4nan9oWdSdEokflFud+PkgiFjmaNmJG6KF+3fDX4a2I30n8MI6qOmv5AckgKeNNpkHAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302080; c=relaxed/simple;
	bh=J4hWNcnVetcgZuiuoZW1w/8/HxaXjdsi/uL+nmCT2IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPMlfvP7EH+GeSPdF4qUGBFkEt98lB1ov0b5T+pOXmybuTuwgivnHZr2ygKp/1RXMnI4HuWjberfGD0talpXwxrhjhEz9xqrL3JfBTaMsX/a+MMjSX0iQUfSGCZkAzHiNiXqB4o+aFK6DH6qo100A4+4nA/buIrL9WZHFKIIl6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3xuLJdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3xuLJdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216A3C19423;
	Sat, 28 Feb 2026 18:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302080;
	bh=J4hWNcnVetcgZuiuoZW1w/8/HxaXjdsi/uL+nmCT2IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3xuLJduLF/or6e1QhoTpZtZ4YLmzFFTtDUIvpftiA0C6i4xpsk2VCRgfnBTgt6Ba
	 Ie7mvH7luSTwx0Erarft9Q6xiVQC8qAEENuOGHSV/p19wCKgBb73R88TihUO1MoYG9
	 v/83hSOpMUzMOAEEElcHRhN27sTLVMoEVEmRa9OwJfSQK8xJvj3KvtgxwrlK5UWX+k
	 y5rXnPxp30TOVPySk+D4P/DthhS+hgXMXiZILkszDWtE2Q7X6oidY4xHQF3xE9cSmV
	 OY22QfP4MNF4eC5KgeVbNllDHGA9PhnghOX0Ija0ijDUYKiGLh+7AUR3DWJe3K/Q7R
	 CgCcey0lAQsxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/283] clk: qcom: Return correct error code in qcom_cc_probe_by_index()
Date: Sat, 28 Feb 2026 13:03:24 -0500
Message-ID: <20260228180709.1583486-62-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 35bd987f2e52a..3d6e87872ddc3 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -325,7 +325,7 @@ int qcom_cc_probe_by_index(struct platform_device *pdev, int index,
 
 	base = devm_platform_ioremap_resource(pdev, index);
 	if (IS_ERR(base))
-		return -ENOMEM;
+		return PTR_ERR(base);
 
 	regmap = devm_regmap_init_mmio(&pdev->dev, base, desc->config);
 	if (IS_ERR(regmap))
-- 
2.51.0

