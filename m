Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7C6F517
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9F9C433C7;
	Mon, 21 Aug 2023 19:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647990;
	bh=XsE2xXDYa9Py1/k39AvFo5ZYDkvyg/Fuhnz7kt4Mu68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkxlBmbQPX44qfJgGP4IlVC+wDTzGzVcVI8tv15d1k5h7l16Kak5mUl4LtBPC72/9
	 eDOXqQc9yyTMolbX0k1WdR2w932/XKNFkNoqgRw/fq/HmZexLhErsZmv4vg+c8iwLa
	 5FFfTHexyOnRvmyhsRS+rDmBPZQBKDITi8SYx5qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Kathiravan T <quic_kathirav@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 016/234] arm64: dts: qcom: ipq5332: add QFPROM node
Date: Mon, 21 Aug 2023 21:39:39 +0200
Message-ID: <20230821194129.470362420@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kathiravan T <quic_kathirav@quicinc.com>

[ Upstream commit 2f34a2aa4c88f4882e3c5df8c9b78f8bbd3f564f ]

IPQ5332 has efuse region to determine the various HW quirks. Lets
add the initial support and the individual fuses will be added as they
are required.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Kathiravan T <quic_kathirav@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230526125305.19626-3-quic_kathirav@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq5332.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/ipq5332.dtsi b/arch/arm64/boot/dts/qcom/ipq5332.dtsi
index af4d97143bcf5..c2d6cc65a323a 100644
--- a/arch/arm64/boot/dts/qcom/ipq5332.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5332.dtsi
@@ -135,6 +135,13 @@ soc@0 {
 		#size-cells = <1>;
 		ranges = <0 0 0 0xffffffff>;
 
+		qfprom: efuse@a4000 {
+			compatible = "qcom,ipq5332-qfprom", "qcom,qfprom";
+			reg = <0x000a4000 0x721>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+		};
+
 		rng: rng@e3000 {
 			compatible = "qcom,prng-ee";
 			reg = <0x000e3000 0x1000>;
-- 
2.40.1



