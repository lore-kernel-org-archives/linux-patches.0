Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E8C188003;
	Tue, 30 Jul 2024 16:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355340; cv=none; b=N+IDpZ4zSmZ/cDt0G0BynEHIYpFotqKmfTNQBIh7BophG9beoTZ2EPgIRdljpavDKdV8NNaL4s8WRTRYd+mWNEmVWjbZ9X39XU1iwlNxppGU6NoL+Lz0RSzX5b/eW8n28W4ZgFtV5PWBREa5SwbhTE2y2sKR/8mj32FOYatQ1EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355340; c=relaxed/simple;
	bh=68slAEprQ+S4Bvmm4ZtZ8yhZj62sYEYC+YybOuhbwKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmjjKX4kekMGtsE+V6HpAdgouqN8niFPE8sFS5FsHK+jsKYCQm5nkiJQdQ1sNnV6RX6Ic27iBafXsXM2OFae+oMJ91JyxSkHg68XNHi8nIGUTR8EtF8IUnh1lSbLaAsuD+RlNkFSkDeCMz/eag2PKJtv9yPT3IfJ2ajQcTYzfhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDcbNTjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDcbNTjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF9AC32782;
	Tue, 30 Jul 2024 16:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355339;
	bh=68slAEprQ+S4Bvmm4ZtZ8yhZj62sYEYC+YybOuhbwKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDcbNTjP11ZkenCjmJf6e2cbchzLkf81CeTbjl1NFNuLDrYPj9hkYhxZUYzOeAXyr
	 +8XnUZF6qoRMI2hZYc3QcwRPxIJp3yBjxdV/XZcxdoHM7V4WoG/vLxThuRuFK0iuUq
	 9YUlHj+7+7w7ayrgshhDxCUSkZrrGam7E/IhCzLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 042/809] arm64: dts: qcom: sc8180x: Correct PCIe slave ports
Date: Tue, 30 Jul 2024 17:38:38 +0200
Message-ID: <20240730151726.311228495@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit dc402e084a9e0cc714ffd6008dce3c63281b8142 ]

The interconnects property was clearly copy-pasted between the 4 PCIe
controllers, giving all four the cpu-pcie path destination of SLAVE_0.

The four ports are all associated with CN0, but update the property for
correctness sake.

Fixes: d20b6c84f56a ("arm64: dts: qcom: sc8180x: Add PCIe instances")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240525-sc8180x-pcie-interconnect-port-fix-v1-1-f86affa02392@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 581a70c34fd29..456ec81327021 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1890,7 +1890,7 @@ pcie3: pcie@1c08000 {
 			power-domains = <&gcc PCIE_3_GDSC>;
 
 			interconnects = <&aggre2_noc MASTER_PCIE_3 0 &mc_virt SLAVE_EBI_CH0 0>,
-					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
+					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_3 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
 			phys = <&pcie3_phy>;
@@ -2012,7 +2012,7 @@ pcie1: pcie@1c10000 {
 			power-domains = <&gcc PCIE_1_GDSC>;
 
 			interconnects = <&aggre2_noc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI_CH0 0>,
-					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
+					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_1 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
 			phys = <&pcie1_phy>;
@@ -2134,7 +2134,7 @@ pcie2: pcie@1c18000 {
 			power-domains = <&gcc PCIE_2_GDSC>;
 
 			interconnects = <&aggre2_noc MASTER_PCIE_2 0 &mc_virt SLAVE_EBI_CH0 0>,
-					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
+					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_2 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
 			phys = <&pcie2_phy>;
-- 
2.43.0



