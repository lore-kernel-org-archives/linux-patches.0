Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C68F268C79;
	Tue,  8 Apr 2025 11:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113314; cv=none; b=sosxcj9p+cv92mSTgda4zkkXodbHnbehwQ92QBchXEPEdy7ix78bOkyU/5JLC7YPu3dD0fh5qA3ChW8Xj9HXLsliJL0wiOXfxzF20PGl/loIWBrqxhjC2kawZa9k80i14MCnDucFF8dhdSGoCtIC40qD2Idce3Xo8d+TsEBByfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113314; c=relaxed/simple;
	bh=9gnSr4d04lXl5Ap0GdEs/eSUjG2jkCBbaZjlgvWkWtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON66qFvFHkneCUdTShJhYO73AjIXBnnraTmtUSRxLL2AShSovmbcNzWFqyBe+DBqpYtZsB4KezC0jBTZASteTSs0NfbZ3VtoL1tpyX5c/QNq6CZHXpkKjcBD+yaiPeUgX9ZB4k1g//BgxFqG6NnD7/JqKiwzEcw6t9k1BXK/UHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtpGzd+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtpGzd+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2F3C4CEE5;
	Tue,  8 Apr 2025 11:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113313;
	bh=9gnSr4d04lXl5Ap0GdEs/eSUjG2jkCBbaZjlgvWkWtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtpGzd+QpTZROhMeCu1C4WL4sk5KMef8oldR55JMYp3at8hymm4IlZZ9tX03NEYwM
	 o0lOO8+PdKW8sCByy4KnDzNR2AvVFUbJxOpz9eGyOGw29kWFDq1jEu7LR72DyKujpX
	 OEUCkesurn0t+0EuSLEwjw6Vz6Du67pmsTk8UBjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Luca Weiss <luca@lucaweiss.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/268] remoteproc: qcom_q6v5_pas: Use resource with CX PD for MSM8226
Date: Tue,  8 Apr 2025 12:48:05 +0200
Message-ID: <20250408104830.494810470@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 181f05506864e..f6336bf4a38b9 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -1240,7 +1240,7 @@ static const struct adsp_data sm8550_mpss_resource = {
 };
 
 static const struct of_device_id adsp_of_match[] = {
-	{ .compatible = "qcom,msm8226-adsp-pil", .data = &adsp_resource_init},
+	{ .compatible = "qcom,msm8226-adsp-pil", .data = &msm8996_adsp_resource},
 	{ .compatible = "qcom,msm8953-adsp-pil", .data = &msm8996_adsp_resource},
 	{ .compatible = "qcom,msm8974-adsp-pil", .data = &adsp_resource_init},
 	{ .compatible = "qcom,msm8996-adsp-pil", .data = &msm8996_adsp_resource},
-- 
2.39.5



