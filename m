Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1073E11CA1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A5FC433D2;
	Mon,  8 May 2023 11:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543784;
	bh=9MAsqeaazGuNiXMMAm5m2ptonWtBpnOK+mSH9waaEkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FewynaTnHu9RTJzJqcdmlvqJ0+QgUuaqkeobSQDfzuZjkUSZqkJLHulB+kzRo3Nib
	 iTwhQpgOF4YzcF/T5oPySuW/yAnGZlopI6VUOMPRb5st9CfnUBtfX0cRX47Uyv0vBV
	 P3uk5XltYtlHwagoTuR5dhRGlmIAtap6aPAnfVWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 200/694] arm64: dts: qcom: sm8550: fix qup_spi0_cs node
Date: Mon,  8 May 2023 11:40:35 +0200
Message-Id: <20230508094438.890991816@linuxfoundation.org>
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

[ Upstream commit 7629c7a525d163f2a3a08e260a69ff25163ab357 ]

The node is incomplete and doesn't need a subnode, add the missing
properties and move everything to the root of qup-spi0-cs-state node.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308-topic-sm8550-upstream-dt-fixups-v1-2-595b02067672@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index ad42c451891d1..7da28b36470e8 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2792,10 +2792,10 @@
 			};
 
 			qup_spi0_cs: qup-spi0-cs-state {
-				cs-pins {
-					pins = "gpio31";
-					function = "qup1_se0";
-				};
+				pins = "gpio31";
+				function = "qup1_se0";
+				drive-strength = <6>;
+				bias-disable;
 			};
 
 			qup_spi0_data_clk: qup-spi0-data-clk-state {
-- 
2.39.2



