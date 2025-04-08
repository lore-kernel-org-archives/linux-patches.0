Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4997026A0D4;
	Tue,  8 Apr 2025 12:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116394; cv=none; b=JaUI6yCXCyKXY6KRi056RAhteXAne0X1INy8e0UI4zKQ9e6jkzHkTOh/7atq6dk9zUdi7qVkL2Qf0qLIFlBQTMWKJ4tk6woBln813TWLY9Ke3ec6iPgmoAUOza35BlMvv07RATAgTh1hyTESuWr6MSd3g9f9hsTxYVGLIqRAV8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116394; c=relaxed/simple;
	bh=0HtLWYsA2ZcyUSnPODtxZHEUhP16xWNkSiBA4SfIrYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWR5bZzBxq54j6qyLurI39JQQ4ZlMfNgy+D+TgUi/ePHEx1FyicfBiJmvBXSDCYrsa7ulqWKaooE5M4hkVUQ2SnSBi1DdGvOutsAniGQet2FvNU2ZHr3/7rUcrKtWfwOFo5NUNwblWr+aZpCYzZttGymEUU6T4BCR+vcqJaxB9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rt/UT9dA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rt/UT9dA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE420C4CEE5;
	Tue,  8 Apr 2025 12:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116394;
	bh=0HtLWYsA2ZcyUSnPODtxZHEUhP16xWNkSiBA4SfIrYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rt/UT9dAzJ0sprLPRoJOxTyH5+AyhiTsgGTV80SH1HIf1NINSWPKPzkUycdOO1TKh
	 B6W1+w6G6QbgbXKn+dDzJBScAtjWd4j20Es6T+ghnLzZMkV3jbVc3GBR/BdOCmHJxL
	 wC+EKa19WAyh0dCb78p8uWPhhnXoVy5tjFFCGRbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Luca Weiss <luca@lucaweiss.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/423] remoteproc: qcom_q6v5_pas: Use resource with CX PD for MSM8226
Date: Tue,  8 Apr 2025 12:47:29 +0200
Message-ID: <20250408104848.592579701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a1636bbf36118..ea4a91f37b506 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -1419,7 +1419,7 @@ static const struct adsp_data sm8650_mpss_resource = {
 };
 
 static const struct of_device_id adsp_of_match[] = {
-	{ .compatible = "qcom,msm8226-adsp-pil", .data = &adsp_resource_init},
+	{ .compatible = "qcom,msm8226-adsp-pil", .data = &msm8996_adsp_resource},
 	{ .compatible = "qcom,msm8953-adsp-pil", .data = &msm8996_adsp_resource},
 	{ .compatible = "qcom,msm8974-adsp-pil", .data = &adsp_resource_init},
 	{ .compatible = "qcom,msm8996-adsp-pil", .data = &msm8996_adsp_resource},
-- 
2.39.5



