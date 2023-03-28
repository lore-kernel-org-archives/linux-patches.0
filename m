Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844EB8474
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09263C433D2;
	Tue, 28 Mar 2023 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014680;
	bh=n+NIo9kqP4hmteV5DoH+qYC4LboSjXMa2HGqnvvQ7HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zo5j9CzZ1Qxgszi9L1dIaL3xBiwyS0v9gCh9kZvDhxx50e0QncUletbNTH95BHckn
	 datoW7RHuDgSRTDQrSaVmYK/9fWG/lVHMjLYundz3iGO2P0XMwqw5rmEEOrmt6IfG/
	 LJixbdu6J/f9C5/SWAQ5xtPia/Md49Yi02PA5AkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 014/240] arm64: dts: qcom: sm8450: Mark UFS controller as cache coherent
Date: Tue, 28 Mar 2023 16:39:37 +0200
Message-Id: <20230328142620.247591074@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 8ba961d4339c5db0e69ff6627606fe1f34c838e5 ]

The UFS controller on SM8450 supports cache coherency, hence add the
"dma-coherent" property to mark it as such.

Fixes: 07fa917a335e ("arm64: dts: qcom: sm8450: add ufs nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230307153201.180626-2-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 40348bb6ffcdd..16a73288c1b37 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -3658,6 +3658,7 @@ ufs_mem_hc: ufshc@1d84000 {
 			power-domains = <&gcc UFS_PHY_GDSC>;
 
 			iommus = <&apps_smmu 0xe0 0x0>;
+			dma-coherent;
 
 			interconnects = <&aggre1_noc MASTER_UFS_MEM 0 &mc_virt SLAVE_EBI1 0>,
 					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_UFS_MEM_CFG 0>;
-- 
2.39.2



