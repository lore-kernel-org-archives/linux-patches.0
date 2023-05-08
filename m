Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADABA168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1501BC433EF;
	Mon,  8 May 2023 11:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543859;
	bh=mpTes964mqXXGyctO4vhDHifhhAQxSchPulv0ClTJys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHYsiqLX56AGeR0Jx4xnw1e/v02LMIMhw60aAaTXknUyHXfYO3ZbAS7JFLf4hQLJm
	 c2yu+pueFnbV9RsB12j0O1tmbq9AId8KHdXkvGeDIoQ+9M419E4+vna5p1jc2E6GFE
	 yeUDO2Ofo+YVR6ZpBN7s6mlzEkOwagYDMGlDk5iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 225/694] arm64: dts: qcom: sm8450: fix pcie1 gpios properties name
Date: Mon,  8 May 2023 11:41:00 +0200
Message-Id: <20230508094439.663374721@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit e57430d2483506f046e39bf8c61159dde88aede2 ]

Add the final "s" to the pgio properties and fix the invalid "enable"
name to the correct "wake", checked against the HDK8450 schematics.

Fixes: bc6588bc25fb ("arm64: dts: qcom: sm8450: add PCIe1 root device")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230323-topic-sm8450-upstream-dt-bindings-fixes-v2-4-0ca1bea1a843@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index bcb0eac83ef01..243ef642fcef6 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1917,8 +1917,8 @@
 			phys = <&pcie1_lane>;
 			phy-names = "pciephy";
 
-			perst-gpio = <&tlmm 97 GPIO_ACTIVE_LOW>;
-			enable-gpio = <&tlmm 99 GPIO_ACTIVE_HIGH>;
+			perst-gpios = <&tlmm 97 GPIO_ACTIVE_LOW>;
+			wake-gpios = <&tlmm 99 GPIO_ACTIVE_HIGH>;
 
 			pinctrl-names = "default";
 			pinctrl-0 = <&pcie1_default_state>;
-- 
2.39.2



