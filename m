Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3517213792B;
	Thu, 12 Dec 2024 15:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017153; cv=none; b=Pem4irtkF+Q2ibU9aurU6Dtm4tivf79eBfb3RHc7Xbp+ZGnQ7gAkgyFcbyayzUtlZPp2qPx2ZH31Ngh5IO7j4PkqQ8y7Qc82e6pVVJmFjqBU0uw7SGwgZef0q7VmgnZ3i5PwUdkTwJY0wdATz5J+6OE0PT7F+7b5edonh7LEWLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017153; c=relaxed/simple;
	bh=8Xig4ZtKgtvzl06w8O1ubjeJQ6PFhry+a0znc8bbVW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGlKqC4ExGV3MTHPtzzJmlo0fL/C/dI6+LVIcPHY79aC5Lx5qtln8X9GKfs0uKdZHxyw/ZPwCkDdiV8h1NvXRQHYXrOTCHZe3l9v/3BoIb8vuDekOKdLubWQjgVt1aDzQ3f6rEhFa1mvt7yHGBrI2/S5ehTE+lhzGwwgLUpXbY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igGsxJvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igGsxJvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795B7C4CECE;
	Thu, 12 Dec 2024 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017153;
	bh=8Xig4ZtKgtvzl06w8O1ubjeJQ6PFhry+a0znc8bbVW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igGsxJvgdkcyoVI+PSgVahSjjYRPiq8+REVX98sMejJj4cqLtWqazbgjP0t6ANkik
	 lfbUtydDdtILLaBtUtdH2flyXXzX9JP0cpwPlDxvlNgJ0cmERQQZewIxKOs4Wj+RZ4
	 sW7hcL1DbD7OrusLUetzb3y2OehcoiUkBHCJ6tRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 398/466] remoteproc: qcom: pas: enable SAR2130P audio DSP support
Date: Thu, 12 Dec 2024 15:59:27 +0100
Message-ID: <20241212144322.486754088@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 009e288c989b3fe548a45c82da407d7bd00418a9 ]

Enable support for the Audio DSP on the Qualcomm SAR2130P platform,
reusing the SM8350 resources.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241027-sar2130p-adsp-v1-3-bd204e39d24e@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 793b1d274be33..1a2d08ec9de9e 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -1433,6 +1433,7 @@ static const struct of_device_id adsp_of_match[] = {
 	{ .compatible = "qcom,sa8775p-cdsp1-pas", .data = &sa8775p_cdsp1_resource},
 	{ .compatible = "qcom,sa8775p-gpdsp0-pas", .data = &sa8775p_gpdsp0_resource},
 	{ .compatible = "qcom,sa8775p-gpdsp1-pas", .data = &sa8775p_gpdsp1_resource},
+	{ .compatible = "qcom,sar2130p-adsp-pas", .data = &sm8350_adsp_resource},
 	{ .compatible = "qcom,sc7180-adsp-pas", .data = &sm8250_adsp_resource},
 	{ .compatible = "qcom,sc7180-mpss-pas", .data = &mpss_resource_init},
 	{ .compatible = "qcom,sc7280-adsp-pas", .data = &sm8350_adsp_resource},
-- 
2.43.0



