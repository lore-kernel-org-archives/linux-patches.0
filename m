Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E8200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B19C433C8;
	Fri, 21 Jul 2023 18:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965927;
	bh=4wa9dory63ytiRvMxlRHwQ25dV0eYXU7+bo9HAseS4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZW6apTrd0VI2ZK+CaEJqVeyLKWsd3lwgzXPKWyYuMPHInjoIkgNpTHEeB3XiFXTz
	 QKGFTgvt0gUduAskvQ+VyJfX5zi2ORunawJkGH+j0YK0XXO/m1ggAjVWrg6HySIhBn
	 eZPO2J1O7IYfySmi8UaV42ksofOf9yx3zoqjfOUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/532] arm64: dts: qcom: apq8016-sbc: fix mpps state names
Date: Fri, 21 Jul 2023 18:00:39 +0200
Message-ID: <20230721160621.783895627@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a4344427eadd6caf0dc9e5384b023083e567221d ]

The majority of device tree nodes for mpps use xxxx-state as pinctrl
nodes. Change names of mpps pinctrl nodes for the apq8016-sbc board to
follow that pattern.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211008012524.481877-13-dmitry.baryshkov@linaro.org
Stable-dep-of: e27654df20d7 ("arm64: dts: qcom: apq8016-sbc: Fix regulator constraints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
index 0e4a1f0040211..1c097098f1e0f 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
@@ -821,7 +821,7 @@ &pm8916_mpps {
 	pinctrl-names = "default";
 	pinctrl-0 = <&ls_exp_gpio_f>;
 
-	ls_exp_gpio_f: pm8916-mpp4 {
+	ls_exp_gpio_f: pm8916-mpp4-state {
 		pins = "mpp4";
 		function = "digital";
 
@@ -829,7 +829,7 @@ ls_exp_gpio_f: pm8916-mpp4 {
 		power-source = <PM8916_MPP_L5>;	// 1.8V
 	};
 
-	pm8916_mpps_leds: pm8916-mpps-leds {
+	pm8916_mpps_leds: pm8916-mpps-state {
 		pins = "mpp2", "mpp3";
 		function = "digital";
 
-- 
2.39.2



