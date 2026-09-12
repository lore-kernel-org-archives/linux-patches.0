Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA448F4F1;
	Sat, 12 Sep 2026 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238793; cv=none; b=RB/TFQR+WJ+W4N0uJY3wGmN9TJkfax7RluHDK4ZC1Y5Ae8stUSIGolShnPi7mS3e/m7ge3gLXC5fTIYf6xiwYIr8wABDcKycU4fVOEOqpe0hnkbmOhRYWyl5C6kfspnaRXIew8ZlMX2lJ0cApOue0Lj/NmfpJ5/kUemGZbSTOAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238793; c=relaxed/simple;
	bh=EA9uSsT/nT9rDIRDKTaGfT54PQ8dKVP7GDZJA2ae3z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nystmhuA5HYV7oBSAIBf5sxRQrni98Zt+4HN/CEbAfrhcY+Bh5rdG6+KTgQtl38/9YjDk8D+zxl3otCIOP7TtnkvmrdJbjsnQ4Q2iQ2sWC5UHC22wuc5fkAuUCd2qVBcB7tUdhsaeL3gZyOUgJP/rOnkLBqHQh6hWP6TPfD8nCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yr0OI4F6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yr0OI4F6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06CE1F000FF;
	Sat, 12 Sep 2026 18:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238792;
	bh=msBz/N57LxZ48v5Byf9cn6fh3yp5ceicygdJFkJsTxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yr0OI4F6+RSCiL6Tnn6RufbebcMOKT/geaXilvvoGLzVL3vA+FGjgLcr1MXljM68I
	 o94S7J9VVUf47a6L8BPZfCTVq37crN9BkeCtfdxAbKQpDBXbIVSjjNwkv1GoAusnoK
	 Zxmm5Z0Zg+eFAq80ASQm/8jax37lHGTKzoFkVjoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 532/935] arm64: dts: qcom: sm8250: Add camcc DT node
Date: Sat, 12 Sep 2026 08:59:22 +0200
Message-ID: <20260912065539.023231433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit ca79a997f2c0826ccf7d313068de3d04d5e8c82b ]

Add the camcc DT node for the Camera Clock Controller on sm8250.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415164655.1679628-2-bryan.odonoghue@linaro.org
Stable-dep-of: d5c8efda722e ("arm64: dts: qcom: sm8250: sort out Iris power domains")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index f3897a5bdf802..4659bf33c144b 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -18,6 +18,7 @@
 #include <dt-bindings/soc/qcom,rpmh-rsc.h>
 #include <dt-bindings/sound/qcom,q6afe.h>
 #include <dt-bindings/thermal/thermal.h>
+#include <dt-bindings/clock/qcom,camcc-sm8250.h>
 #include <dt-bindings/clock/qcom,videocc-sm8250.h>
 
 / {
@@ -2579,6 +2580,21 @@ videocc: clock-controller@abf0000 {
 			#power-domain-cells = <1>;
 		};
 
+		camcc: clock-controller@ad00000 {
+			compatible = "qcom,sm8250-camcc";
+			reg = <0 0x0ad00000 0 0x10000>;
+			clocks = <&gcc GCC_CAMERA_AHB_CLK>,
+				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&rpmhcc RPMH_CXO_CLK_A>,
+				 <&sleep_clk>;
+			clock-names = "iface", "bi_tcxo", "bi_tcxo_ao", "sleep_clk";
+			power-domains = <&rpmhpd SM8250_MMCX>;
+			required-opps = <&rpmhpd_opp_low_svs>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			#power-domain-cells = <1>;
+		};
+
 		mdss: mdss@ae00000 {
 			compatible = "qcom,sm8250-mdss";
 			reg = <0 0x0ae00000 0 0x1000>;
-- 
2.53.0



