Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C527B171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EC9C433D2;
	Mon, 22 May 2023 19:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783456;
	bh=Cs75zMiZEwmV3UAS4IKjgnp5y3TznPwuYo/uXXJNx1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEfw7E6bU9AvQ4yKvp/jpYZvDBsupTLt9/uJO8f2zG4XVOMBlYhtOcW7kIW7UQCU9
	 JdkLCQCNq0KGkXhIbMKZkZnQ3BJ3xS6zLhnhITVFuCmjGjDM3EMGw2ovk4ydBVIwmz
	 aIA1ruud+8GN6uHSQ1cALhmZ/fbshK0fE+2XIgbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/292] arm64: dts: qcom: msm8996: Add missing DWC3 quirks
Date: Mon, 22 May 2023 20:06:46 +0100
Message-Id: <20230522190407.152022143@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit d0af0537e28f6eace02deed63b585396de939213 ]

Add missing dwc3 quirks from msm-3.18. Unfortunately, none of them
make `dwc3-qcom 6af8800.usb: HS-PHY not in L2` go away.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230302011849.1873056-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 67b87915d8224..9f89100542018 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2979,8 +2979,11 @@
 				interrupts = <0 131 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&hsusb_phy1>, <&ssusb_phy_0>;
 				phy-names = "usb2-phy", "usb3-phy";
+				snps,hird-threshold = /bits/ 8 <0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,is-utmi-l1-suspend;
+				tx-fifo-resize;
 			};
 		};
 
-- 
2.39.2



