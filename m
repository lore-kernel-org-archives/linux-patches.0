Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AC6222D46;
	Thu, 12 Dec 2024 15:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018455; cv=none; b=IS+bkLG99tychyYlTVYCn4ORO3vWDwRavNwdZIl0oHf4acbwUQodJWbq+EFkpxdXFj/SmR8Ie9sNn4RwHyanXFMBvQ8p5BzgITfTsOCG6HCvlXl4TQHEY0iNkIAQZEjhoVhCTNtZBwpGhRwydORHcvz5VlHSDTpvGeiJ9etpMug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018455; c=relaxed/simple;
	bh=4ZVzlEtNjGNBKdpdSn5KmBeDeeksxeqoCM2Ns7IqL08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLoA82+rFSEFcUllsP8Ty6n0cboPOH+a3in5JC4/AllZ4x48fYWzxLO5oqnIQucqRV2/C0VLakefCSkqfEmkGV2cw5jDtl6sAKGeHNsUn62bD7j8IQx5YTVkRIf9wkGfiEaBeljOCV+CLsVP6DDQv9q+/DkiBZQ5nlByNhiafJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFcbvZME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFcbvZME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4526C4CECE;
	Thu, 12 Dec 2024 15:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018455;
	bh=4ZVzlEtNjGNBKdpdSn5KmBeDeeksxeqoCM2Ns7IqL08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFcbvZMECDwRBzqb0l8L4SMMRajs1JNt61+0iTEWpTBW4qT1792f0LVu1OkbHV60L
	 EOayz67RvWilAE8nMbNODaWZL/LpZ7Icn7PRhT/8DfDl5LMLsp3/5x8jwUrRTKUhVP
	 PRwVC3oBQqyHWerWFbfUjLBrTVoZnW+2/OQeylH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anusha Rao <quic_anusha@quicinc.com>,
	devi priya <quic_devipriy@quicinc.com>,
	Sricharan Ramabadhran <quic_srichara@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/356] PCI: qcom: Add support for IPQ9574
Date: Thu, 12 Dec 2024 16:00:09 +0100
Message-ID: <20241212144256.030712797@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: devi priya <quic_devipriy@quicinc.com>

[ Upstream commit a63b74f2e35be3829f256922037ae5cee6bb844a ]

Add the new IPQ9574 platform which is based on the Qcom IP rev. 1.27.0
and Synopsys IP rev. 5.80a.

The platform itself has four PCIe Gen3 controllers: two single-lane and
two dual-lane, all are based on Synopsys IP rev. 5.70a. As such, reuse
all the members of 'ops_2_9_0'.

Link: https://lore.kernel.org/r/20240801054803.3015572-5-quic_srichara@quicinc.com
Co-developed-by: Anusha Rao <quic_anusha@quicinc.com>
Signed-off-by: Anusha Rao <quic_anusha@quicinc.com>
Signed-off-by: devi priya <quic_devipriy@quicinc.com>
Signed-off-by: Sricharan Ramabadhran <quic_srichara@quicinc.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index d3ca6d3493130..2427237cbe9c7 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1618,6 +1618,7 @@ static const struct of_device_id qcom_pcie_match[] = {
 	{ .compatible = "qcom,pcie-ipq8064-v2", .data = &cfg_2_1_0 },
 	{ .compatible = "qcom,pcie-ipq8074", .data = &cfg_2_3_3 },
 	{ .compatible = "qcom,pcie-ipq8074-gen3", .data = &cfg_2_9_0 },
+	{ .compatible = "qcom,pcie-ipq9574", .data = &cfg_2_9_0 },
 	{ .compatible = "qcom,pcie-msm8996", .data = &cfg_2_3_2 },
 	{ .compatible = "qcom,pcie-qcs404", .data = &cfg_2_4_0 },
 	{ .compatible = "qcom,pcie-sa8540p", .data = &cfg_1_9_0 },
-- 
2.43.0



