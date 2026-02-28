Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9895436C9E2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302333; cv=none; b=CqswueRktxUtFE8dei9HyvVPWOd1BghrqLZf/s9Wx5WWTtawj66UBm/C0PqtDLUICKuZwy6QMGss5X6pkfE5S/xmaDQjhaM4rS3jV1r9OBg6JyI/OcFNHsgb3/igtWu8odwOINwtEf2gs8+ufbEoAl/MmZfFlBBYHXjZ+za98/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302333; c=relaxed/simple;
	bh=LqEb/Df1io978bvbE3maujY36mxE7iDMPdBYCuagH28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3Bl0RFQlr+GV7Ox6xr9KqQa/t2L3co/slHNmRWg9lXg01MAFhqU+Mkex0UkUTbVnLKogS/MOSYyFhex0jxWqB82kwDgdL6gMST+Jk8jVb8YJ51b/Fp0GCuA0xIiTzSnOequvyPwVdCziOqSEPvTGmm/pmPDI2UBxsXeKPiztE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TE+TBSDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TE+TBSDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38CFC116D0;
	Sat, 28 Feb 2026 18:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302333;
	bh=LqEb/Df1io978bvbE3maujY36mxE7iDMPdBYCuagH28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TE+TBSDw7rSIYBo9fBBKlnQlDAoRngddn8QLA6Sh7VMGgiedMCCKJAmk71LXCKNm0
	 zhOMBBy8VjAq+71aLWYBquvJefnAKQbW4aY4RnkxzbI3b0efa+a/OiUCzI1DLM9hYO
	 QZWh+IhVlqdx6aQiLvjbx8Q4fAjRpRkYQymjNR7QWQrI/lX9N5WnimfYA6KXZge2VU
	 herJpdqFYwcblf3q/A+/olzDgEnF1Q9GEF8zsHXh3GVuXLYu2GyujClUvRx9iIozlu
	 63/BbN1cwvghmCaXmWtdrgFns03jc+HTD57qGrvvmVia4xiCVUOtEdKcqdx+6GgJSB
	 HFV9qWKnuxc+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/232] clk: qcom: Return correct error code in qcom_cc_probe_by_index()
Date: Sat, 28 Feb 2026 13:08:27 -0500
Message-ID: <20260228181127.1592657-54-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 75f09e6e057e1..86a5283381ae7 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -327,7 +327,7 @@ int qcom_cc_probe_by_index(struct platform_device *pdev, int index,
 
 	base = devm_platform_ioremap_resource(pdev, index);
 	if (IS_ERR(base))
-		return -ENOMEM;
+		return PTR_ERR(base);
 
 	regmap = devm_regmap_init_mmio(&pdev->dev, base, desc->config);
 	if (IS_ERR(regmap))
-- 
2.51.0

