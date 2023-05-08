Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1896D168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B41C433D2;
	Mon,  8 May 2023 10:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541725;
	bh=V3++XKrNmyYUFe/j+O97u4SQGMsnygWagTRVHlKE2lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/HDjgwa9KT2RotVKPmQ3+X4JBJ29XTGGQAUgrqsDmaZIYydXdmcJKW+lOeuZs8CD
	 OMvgK8mjOxPDiR4gxE5ieZqOPHEV6yznzH6zCXZmQZCP5ofY6CM2RQehDPxyR4RwmG
	 r1H/kvMcBhLxYeArvDFDUu43p1ACUZxRu4c586Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 173/663] arm64: dts: qcom: msm8976: Add and provide xo clk to rpmcc
Date: Mon,  8 May 2023 11:39:59 +0200
Message-Id: <20230508094434.081985546@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit 4a2c9b9e1215c557c17a48e3fabe9b1674c1d608 ]

In order for consumers of RPMCC XO clock to probe successfully
their parent needs to be feed with reference clock to obtain proper rate,
add fixed xo-board clock and supply it to rpmcc to make consumers happy.
Frequency setting is left per board basis just like on other recent trees.

Fixes: 0484d3ce0902 ("arm64: dts: qcom: Add DTS for MSM8976 and MSM8956 SoCs")
Fixes: ff7f6d34ca07 ("arm64: dts: qcom: Add support for SONY Xperia X/X Compact")
Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
[bjorn: Squashed the two patches]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230302123051.12440-1-a39.skl@gmail.com
Link: https://lore.kernel.org/r/20230302123051.12440-2-a39.skl@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8956-sony-xperia-loire.dtsi | 4 ++++
 arch/arm64/boot/dts/qcom/msm8976.dtsi                   | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8956-sony-xperia-loire.dtsi b/arch/arm64/boot/dts/qcom/msm8956-sony-xperia-loire.dtsi
index 67baced639c91..085d79542e1bb 100644
--- a/arch/arm64/boot/dts/qcom/msm8956-sony-xperia-loire.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8956-sony-xperia-loire.dtsi
@@ -280,3 +280,7 @@
 	vdda3p3-supply = <&pm8950_l13>;
 	status = "okay";
 };
+
+&xo_board {
+	clock-frequency = <19200000>;
+};
diff --git a/arch/arm64/boot/dts/qcom/msm8976.dtsi b/arch/arm64/boot/dts/qcom/msm8976.dtsi
index 05dcb30b07795..c125ebcdd1e47 100644
--- a/arch/arm64/boot/dts/qcom/msm8976.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8976.dtsi
@@ -20,6 +20,13 @@
 
 	chosen { };
 
+	clocks {
+		xo_board: xo-board {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+		};
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -351,6 +358,8 @@
 
 				rpmcc: clock-controller {
 					compatible = "qcom,rpmcc-msm8976", "qcom,rpmcc";
+					clocks = <&xo_board>;
+					clock-names = "xo";
 					#clock-cells = <1>;
 				};
 
-- 
2.39.2



