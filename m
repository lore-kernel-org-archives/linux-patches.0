Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C93BBA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CF0C433D2;
	Tue,  7 Mar 2023 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211613;
	bh=MRkcWzeTw59e1HJ9aaB4R6ACb+YiAEE3sOG6GpVOdAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+ok/xrSTI/YimaN/HGUK88pNQu5F3C8/UTmxBm9mrbcYYGcIw+GhZTKwpcroqZVq
	 me55/luQJTF/bJX2WezacsvvclmZfKsKNZHParTS4wfMc9G9iicm7cSoRpVps0TcI/
	 QvJvUgxt0E2K7/y9OJUW2CerOLzzzoVdKjY9EMuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.2 0919/1001] ARM: dts: qcom: sdx55: Add Qcom SMMU-500 as the fallback for IOMMU node
Date: Tue,  7 Mar 2023 18:01:31 +0100
Message-Id: <20230307170101.961015749@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

commit af4ab377543853b690cc85b4c46cf976ab560dc2 upstream.

SDX55 uses the Qcom version of the SMMU-500 IP. So use "qcom,smmu-500"
compatible as the fallback to the SoC specific compatible.

Cc: <stable@vger.kernel.org> # 5.12
Fixes: a2bdfdfba2af ("ARM: dts: qcom: sdx55: Enable ARM SMMU")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230123131931.263024-3-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -578,7 +578,7 @@
 		};
 
 		apps_smmu: iommu@15000000 {
-			compatible = "qcom,sdx55-smmu-500", "arm,mmu-500";
+			compatible = "qcom,sdx55-smmu-500", "qcom,smmu-500", "arm,mmu-500";
 			reg = <0x15000000 0x20000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <1>;


