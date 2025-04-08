Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45419268C66;
	Tue,  8 Apr 2025 11:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111374; cv=none; b=I9EhXPZ13FPFD+Jhs1ta8dEBo7Jhitd989zfnP7uMxicJBq3rkBfPeSSVfMccdhsk253SC0PZknYl4C0iJ+8LXGx9F2AOUBFEyZy2rRUVNqc4xoaSkmm0zaELJBFNtRo8NqBoxrfXumcFEvpjvtu2PH+X84x+Cf0XLl1WepSp/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111374; c=relaxed/simple;
	bh=R/F/Z1uY/MhzFVrAbfNTQZl29ABTRBXNu8uJ49bO6MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxVVZq7YzjRuTMe15UI7vnrupc0UP6Tyn89054OC5BRvXEGqGAhpNNG/i1EfcwYIqPSbHPWe3DciKTuIzxvFdXL1U5JrKV4efjUXhP+4keff/G2lh6cF1M+tes8KToelRukKttqgg1OSp2zxDcEw7PYAhvCkbS/w2Wd9B9LJXRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/YJhxz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/YJhxz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A89C4CEE5;
	Tue,  8 Apr 2025 11:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111374;
	bh=R/F/Z1uY/MhzFVrAbfNTQZl29ABTRBXNu8uJ49bO6MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/YJhxz9Sg9A6tX2//2mW4LetE/sqBS9l0gT9TiNLrl8PJsr7zEJISYtvOThOlDuQ
	 x5r+rmq2/4umF2bcgmTAJxPnvukvR0zSUuVzJcg4HTnz1UeLf8Yh+G7g69gQq/oHhL
	 1azYpXP1QxBFZEgHFPLwpuf9lZWrxyjJvrAZC8Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Luca Weiss <luca@lucaweiss.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 382/731] remoteproc: qcom_q6v5_pas: Use resource with CX PD for MSM8226
Date: Tue,  8 Apr 2025 12:44:39 +0200
Message-ID: <20250408104923.161294873@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca@lucaweiss.eu>

[ Upstream commit ba785ff4162a65f18ed501019637a998b752b5ad ]

MSM8226 requires the CX power domain, so use the msm8996_adsp_resource
which has cx under proxy_pd_names and is otherwise equivalent.

Suggested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Fixes: fb4f07cc9399 ("remoteproc: qcom: pas: Add MSM8226 ADSP support")
Signed-off-by: Luca Weiss <luca@lucaweiss.eu>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250128-pas-singlepd-v1-1-85d9ae4b0093@lucaweiss.eu
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 9f2d9b4be2790..60923ed129049 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -1411,7 +1411,7 @@ static const struct adsp_data sm8650_mpss_resource = {
 };
 
 static const struct of_device_id adsp_of_match[] = {
-	{ .compatible = "qcom,msm8226-adsp-pil", .data = &adsp_resource_init},
+	{ .compatible = "qcom,msm8226-adsp-pil", .data = &msm8996_adsp_resource},
 	{ .compatible = "qcom,msm8953-adsp-pil", .data = &msm8996_adsp_resource},
 	{ .compatible = "qcom,msm8974-adsp-pil", .data = &adsp_resource_init},
 	{ .compatible = "qcom,msm8996-adsp-pil", .data = &msm8996_adsp_resource},
-- 
2.39.5



