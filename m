Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43FB11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C61C433C7;
	Mon, 11 Sep 2023 14:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443389;
	bh=9yLJXgUhcgjhUkw+b7xErdj73YU+/UrZick2iQSn32Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEE8s12PBh8q/X6q6u/LGJA0tL3P1wkBUsaVLwmWkv9MGlUlreTry3tfBHvNBgOl4
	 xgAA6btEYkMWenIJ9nGJ+/W+/7EiXGxxPXnqRrCx8UAnnRdk47aS6f/jcQWpyh7A35
	 2LbK2sRrdZHRQQO3IEKMfegnU1p7i/Oqb0pYk+VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 333/737] arm64: dts: qcom: msm8996-gemini: fix touchscreen VIO supply
Date: Mon, 11 Sep 2023 15:43:12 +0200
Message-ID: <20230911134659.841534483@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 21fc24ee9c5943732c9ae538766c9be93d70d936 ]

According to bindings and Linux driver, there is no VDDA but VIO supply.

Fixes: 4ac46b3682c5 ("arm64: dts: qcom: msm8996: xiaomi-gemini: Add support for Xiaomi Mi 5")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230720115335.137354-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
index 100123d514944..f1d990dd7f7c9 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
@@ -82,7 +82,7 @@ synaptics@20 {
 		#size-cells = <0>;
 		interrupt-parent = <&tlmm>;
 		interrupts = <125 IRQ_TYPE_LEVEL_LOW>;
-		vdda-supply = <&vreg_l6a_1p8>;
+		vio-supply = <&vreg_l6a_1p8>;
 		vdd-supply = <&vdd_3v2_tp>;
 		reset-gpios = <&tlmm 89 GPIO_ACTIVE_LOW>;
 
-- 
2.40.1



