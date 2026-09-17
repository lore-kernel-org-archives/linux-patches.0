Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E1451597A;
	Thu, 17 Sep 2026 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666992; cv=none; b=uGPq3MFwuvuJ0SDV9UfYKCLQE8PBaylHTXQfGKuihyIx7dH/JLrTGdJYVn7vMlYjH/NaTPHV7Wpx7rDrH1S4LbxoxNoSNRX44gFHLqVClBFWyK/H030NCTEjVBYLUYa4nbXTXu6sKvlyTFsoXkZEC97LD4PSyuUCtJmBTwa/3mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666992; c=relaxed/simple;
	bh=M4/cOtAzLT56NtkeywnFiB389Nj/LkBBASlpN7zj7Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIWXDIiI5XNSx64Lvr7YYBU+DIwmSZ6MbotOEXGqLONXOXYkSXC92WoY+DI8EhJQwqdI+XtLO2h22RPiYtQGiC4MW88RGldd10Gv9/2uvmhy1TPFXt5pJW5+7Qfba5i6TzU8g+OooA+CwORZV1/XegBmXJ6YJYCu+eamVFzSUgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5PLqpsO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5PLqpsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909B61F000FF;
	Thu, 17 Sep 2026 17:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666991;
	bh=EdUt0unv3OMIyluh47MhM2bZGDm7Hn1IDKOoPn7Sba4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5PLqpsOhXQnRXMAhVfmbk+28Dxj1TDLG1vRUR0kZAb0Q5qGAQi3VdM38e1MwsSR0
	 SlHEhgQbRVAFqDq8I1MlI+WSl2+2SWYd71D2hDw/UErznJkwa4mLnUEIVISP/gI6+e
	 1UURCa83Ep68MFcQuJbYaMWVYVYZpyJX69mV8d68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1144/1250] Revert "arm64: dts: qcom: sar2130p: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:39 +0100
Message-ID: <20260917151623.267526399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 54176af35d989264e4dce0bee10dd3e4dafb4efb.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sar2130p.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sar2130p.dtsi b/arch/arm64/boot/dts/qcom/sar2130p.dtsi
index d7a80d832f080..d65ad0df68652 100644
--- a/arch/arm64/boot/dts/qcom/sar2130p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sar2130p.dtsi
@@ -1329,8 +1329,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 					 &config_noc SLAVE_PCIE_0 QCOM_ICC_TAG_ALWAYS>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1455,8 +1455,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 					 &config_noc SLAVE_PCIE_1 QCOM_ICC_TAG_ALWAYS>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
+				    <0x100 &apps_smmu 0x1e01 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>,
 				<&gcc GCC_PCIE_1_LINK_DOWN_BCR>;
-- 
2.53.0



