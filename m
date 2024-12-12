Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBD1748A;
	Thu, 12 Dec 2024 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017228; cv=none; b=TnhUdQ9zkz618NBBU1zWgn2lGGwP1QfMsmodMQY2LuCDAuOgf0SVeFJ22zES4IrEhd7+bX6lFdvm6hMVwgqbbVxffgxNSyN3ryqewMLU+05MkSiMBB4x4g2AlOrfPlfaKXXJB5YIURXR1cUCwU7UEksm36Rem6nz5dC26sauYHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017228; c=relaxed/simple;
	bh=kk7ZC4gIZi6utwI2b+JasTOXYiWJAOkPSfqzhAjlOow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2bEJIx/j30fqNJxd/F5ktYItTi/yU80M+TSv81YXMYdsfqwJeeSc/9x75QOgxsAC/lwV7Xth80gXOGuZ3gswLvJI8hB81X3r8etWv/5CzJk4WQfwa6D3X3W5ZwpV0nPJX89ceYywAyB11DRm91uAoixfVrmXoeDZT7ifA0j8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvKE2QpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvKE2QpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0F6C4CECE;
	Thu, 12 Dec 2024 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017227;
	bh=kk7ZC4gIZi6utwI2b+JasTOXYiWJAOkPSfqzhAjlOow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvKE2QpJqtbF7gV/ZKBkVS0xM1iX6AZRQVWbNn/Z0DYkOLIrmaEYKram1oF909S42
	 inr4Lr1R2NnUyFaMusCpa5zCryC1+6vjTFTe+Tp8+FGwv7vqN52CrlTpHboUIIaIuT
	 TYwhDCLjISE2FkPdcxUVbdlWX+vdCa7WEmBa2jsk=
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
Subject: [PATCH 6.12 391/466] PCI: qcom: Add support for IPQ9574
Date: Thu, 12 Dec 2024 15:59:20 +0100
Message-ID: <20241212144322.217151074@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b5447228696dc..6483e1874477e 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1830,6 +1830,7 @@ static const struct of_device_id qcom_pcie_match[] = {
 	{ .compatible = "qcom,pcie-ipq8064-v2", .data = &cfg_2_1_0 },
 	{ .compatible = "qcom,pcie-ipq8074", .data = &cfg_2_3_3 },
 	{ .compatible = "qcom,pcie-ipq8074-gen3", .data = &cfg_2_9_0 },
+	{ .compatible = "qcom,pcie-ipq9574", .data = &cfg_2_9_0 },
 	{ .compatible = "qcom,pcie-msm8996", .data = &cfg_2_3_2 },
 	{ .compatible = "qcom,pcie-qcs404", .data = &cfg_2_4_0 },
 	{ .compatible = "qcom,pcie-sa8540p", .data = &cfg_sc8280xp },
-- 
2.43.0



