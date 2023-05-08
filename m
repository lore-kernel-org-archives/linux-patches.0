Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2BB168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4C2C433D2;
	Mon,  8 May 2023 11:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543778;
	bh=3RSEXQRKTjHTisWFYFFN26kOYFevNSMsZxEv9uhqO4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKgF+3ErQUrtgg8PEPk2e4dxfUt3Lgk82sIuBdjJdqJHqMVp4qDvMes70O+1Swqkf
	 FDRwGXotZ9U5G1StXaTyNEVIoSq2aSE6yLv4IumC9aej8mtBYWW+lwBoF5mQoJyPoc
	 NLo/XnCDJKJBlZkdAWjj04irBSHy0kXFfNeMdogc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 198/694] arm64: dts: qcom: msm8976: Add and provide xo clk to rpmcc
Date: Mon,  8 May 2023 11:40:33 +0200
Message-Id: <20230508094438.833080082@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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
index 2d360d05aa5ef..e55baafd9efd0 100644
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



