Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A5321504F;
	Thu, 12 Dec 2024 15:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016584; cv=none; b=gF4TSHQDAumVYxig6o3FO16G1KOcCIIYifoU0hvetYc9xZhP/O5Pai70SqDi9ElYqIpjsUDNmkhRhTcIRXPS9BA/Cb1NEjo0hma7CRrlXEDDGMWTks71l/Bzatst1IVeN8VBNh1PbyaVvCkAtNA3dW6f/XpDnGtMSAT4JXl84bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016584; c=relaxed/simple;
	bh=cl7nXJA+xbMol58vR7uT71yHhlFEsdtCtWIyHSzpQ1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtIlagk2yq7jhE2ED9KUot7Nkzr9dYyHF9mMeQ5lXOPyqa9uTpc8CGJbXVAvh0F61kLCQFyuXFOBBfjWTSlKQPdhSA2Nu/GG6HBzlbw147vVU1EyYV2F6Hlfu5EOVRNljGeW/LOO36suNiedjTKF75SwULhIIyVdJurx1Ud0ips=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lc/5qCfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lc/5qCfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB083C4CECE;
	Thu, 12 Dec 2024 15:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016584;
	bh=cl7nXJA+xbMol58vR7uT71yHhlFEsdtCtWIyHSzpQ1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lc/5qCfZF4WMjfKU9u0P0tq9bPxtRVS8So2NEgaRe3/FF63+zebyJYf5c3tAgtKqj
	 NdbGDq4NJ2WELRkzyom0lUn68x4Qi89QpEFWX8gDkN6E7BUXC9DUQZILOTTY2iMQ0K
	 viy91W/hxnHejhcfyNzYyrd+2kxmeL3IaiT7SKfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/466] soc: qcom: pd-mapper: Add QCM6490 PD maps
Date: Thu, 12 Dec 2024 15:56:49 +0100
Message-ID: <20241212144316.264491313@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 31a95fe0851afbbc697b6be96c8a81a01d65aa5f ]

The QCM6490 is a variant of SC7280, with the usual set of protection
domains, and hence the need for a PD-mapper. In particular USB Type-C
port management and battery management is pmic_glink based.

Add an entry to the kernel, to avoid the need for userspace to provide
this service.

Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241004-qcm6490-pd-mapper-v1-1-d6f4bc3bffa3@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom_pd_mapper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/qcom_pd_mapper.c b/drivers/soc/qcom/qcom_pd_mapper.c
index c940f4da28ed5..6e30f08761aa4 100644
--- a/drivers/soc/qcom/qcom_pd_mapper.c
+++ b/drivers/soc/qcom/qcom_pd_mapper.c
@@ -540,6 +540,7 @@ static const struct of_device_id qcom_pdm_domains[] __maybe_unused = {
 	{ .compatible = "qcom,msm8996", .data = msm8996_domains, },
 	{ .compatible = "qcom,msm8998", .data = msm8998_domains, },
 	{ .compatible = "qcom,qcm2290", .data = qcm2290_domains, },
+	{ .compatible = "qcom,qcm6490", .data = sc7280_domains, },
 	{ .compatible = "qcom,qcs404", .data = qcs404_domains, },
 	{ .compatible = "qcom,sc7180", .data = sc7180_domains, },
 	{ .compatible = "qcom,sc7280", .data = sc7280_domains, },
-- 
2.43.0



