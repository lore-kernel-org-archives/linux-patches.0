Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ED41BC07A;
	Tue, 30 Jul 2024 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355107; cv=none; b=WjK56CTVzxrtpqFrsoSrSHd25/h0Fz846m1m5JWzAvnjIa6yjltaCRqVDr0MRnEoUyx67LtA8jQD0A+HAvb9y7OkRgEwpnVc1MJE6Z9kSJeKfEXwK6WSF219HjSIx3Q1fuI0SHBtAilV/BUS5TSX761/iN99eWFckFjVLcfUqtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355107; c=relaxed/simple;
	bh=68tWB734qiod7TeOYJ33vi7NrSooXIrVD3kau6SwDlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCV1/IjcbQa7aLivd9IDeX7mroMu+SQ2l2wB9KDIwsr8R54XHXWFoMBmpsJqebQDO/iJS6kSbTwHHnwwpudb64FMzcU0rgOBlHNib4Mf8w13IQDdZVbzjrobHJbj3EnFlAwuYYqRz5Fv4hvV8BAdDdHQn5TM0VyNflnozVNHgMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQAqo/f8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQAqo/f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11967C32782;
	Tue, 30 Jul 2024 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355106;
	bh=68tWB734qiod7TeOYJ33vi7NrSooXIrVD3kau6SwDlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQAqo/f8v5RXOEHc/XFWL0elr02tztl4rWo1yH9KJYeiw3y9GAZfk17TzBDnGDzy2
	 fEBA/zSs395QgKVzRQ0MqfCGrZg+ONuxFFfhHk22LPp8+IhunihGzlkzsej1mpn7tK
	 zH4yoKF+eg7RofMtp7JzoAPaU8YjMbNWxFfbqdv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/568] arm64: dts: qcom: sc8180x: Correct PCIe slave ports
Date: Tue, 30 Jul 2024 17:42:15 +0200
Message-ID: <20240730151640.938107005@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dd207eb81360a..9163c1419cc12 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1853,7 +1853,7 @@ pcie3: pci@1c08000 {
 			power-domains = <&gcc PCIE_3_GDSC>;
 
 			interconnects = <&aggre2_noc MASTER_PCIE_3 0 &mc_virt SLAVE_EBI_CH0 0>,
-					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
+					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_3 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
 			phys = <&pcie3_phy>;
@@ -1952,7 +1952,7 @@ pcie1: pci@1c10000 {
 			power-domains = <&gcc PCIE_1_GDSC>;
 
 			interconnects = <&aggre2_noc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI_CH0 0>,
-					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
+					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_1 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
 			phys = <&pcie1_phy>;
@@ -2051,7 +2051,7 @@ pcie2: pci@1c18000 {
 			power-domains = <&gcc PCIE_2_GDSC>;
 
 			interconnects = <&aggre2_noc MASTER_PCIE_2 0 &mc_virt SLAVE_EBI_CH0 0>,
-					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
+					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_2 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
 			phys = <&pcie2_phy>;
-- 
2.43.0



