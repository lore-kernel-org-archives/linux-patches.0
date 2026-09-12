Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97697345EA7;
	Sat, 12 Sep 2026 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232235; cv=none; b=av7AZR9OqhbtyldijPv08NgVTMMLJEEEPbyQL/XX+CWtfUNNiEtALhubFraidf32iUkaCowku0bEJEuJu55cC3B1P+mgyVLnffk730X4ThF/K6rzQNpGhLPlfG/64qhihBZAoth5dENOBJiXbF9kfw1ucj69m2QstT2ScwO3yeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232235; c=relaxed/simple;
	bh=mAO8qdfNhKAfJdzqZR2ZYVu4Md0uU5Ws7ATDTtDEIeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM4uCH8/PLjDLkWGompGLOzYg1PnXz10h7F82r6dVtInZ/MfH4AS9nuuroAo4F1FSMaBRUQoH6SfyOA1Atc7xtjx/rAgynSJm8V2CJiXwov56xKNw80PfY39wE1w5DBOAFne4ju9fkbJQBwl/+7QWZEtEVWKVYACd6XBTXHw7jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjedFYXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjedFYXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527871F000FF;
	Sat, 12 Sep 2026 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232234;
	bh=9MkA28+I5psS66cKV/KtYmULzJj81GccrDf27D7PoBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FjedFYXJp8svPfFBxFHfsPB5xXMP9TI7JCL7Fyq7tSyyvVbXqDh43jWgAFsY5UYZ7
	 xqIx8bLF15ZzHKaFdrlPlHVtcQdekXma7KhC/l/04iH+Ci6cfuIjorliD77JpX1zYl
	 1j3TsYKQZG2hC+i6kVgJCHxzGKZZOHnUmQabizpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1162/1191] arm64: dts: qcom: sm8550: Mark UFS controller as cache coherent
Date: Sat, 12 Sep 2026 09:04:50 +0200
Message-ID: <20260912065614.240814530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit ee1d5100c37e7a95af506c7addf018f652545ce6 ]

The UFS controller on SM8550 supports cache coherency, hence add the
"dma-coherent" property to mark it as such.

Fixes: 35cf1aaab169 ("arm64: dts: qcom: sm8550: Add UFS host controller and phy nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308054630.7202-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 7d53d057ad5b2..21fbfa2a2633c 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1636,6 +1636,7 @@ ufs_mem_hc: ufs@1d84000 {
 			required-opps = <&rpmhpd_opp_nom>;
 
 			iommus = <&apps_smmu 0x60 0x0>;
+			dma-coherent;
 
 			interconnects = <&aggre1_noc MASTER_UFS_MEM 0 &mc_virt SLAVE_EBI1 0>,
 					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_UFS_MEM_CFG 0>;
-- 
2.53.0



