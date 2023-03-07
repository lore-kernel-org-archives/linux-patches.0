Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738D3BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE13C433D2;
	Tue,  7 Mar 2023 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209126;
	bh=+/zHPezVxPq8Edi8kdEoDj4ejhcBRzGkvyHRlHCP8KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiH9CPKKR7V4glpG47USmrffOTYzqaPQF+ubgBA+hOScwLLohQ00E39Ul7WzrQ1ul
	 eH2ShjZ8wAMb/QYtw2NEcXMgiwi42PYURK4Y6bQNsLS8o1vf9zbbG2eLxvfiPjlCJ7
	 Doc5DcVi6W42dqfAR+1a1ZlGJm3L5xtVk8MMcRRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Iskren Chernev <me@iskren.info>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0117/1001] arm64: dts: qcom: sm6115: correct TLMM gpio-ranges
Date: Tue,  7 Mar 2023 17:48:09 +0100
Message-Id: <20230307170027.181209352@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 272fc52431611d779de132c4e03de6e0c1199731 ]

Correct the number of GPIOs in TLMM pin controller.

Fixes: 97e563bf5ba1 ("arm64: dts: qcom: sm6115: Add basic soc dtsi")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Iskren Chernev <me@iskren.info>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230202104452.299048-11-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index 81523ab7ff602..9de56365703cf 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -363,7 +363,7 @@ tlmm: pinctrl@500000 {
 			reg-names = "west", "south", "east";
 			interrupts = <GIC_SPI 227 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-controller;
-			gpio-ranges = <&tlmm 0 0 121>;
+			gpio-ranges = <&tlmm 0 0 114>; /* GPIOs + ufs_reset */
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-- 
2.39.2



