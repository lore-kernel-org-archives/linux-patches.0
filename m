Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532833BB23
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8K/oIBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EA9C433CA;
	Wed, 15 Nov 2023 19:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077475;
	bh=nuXPUKF1RZ/qIUhC4NWXIp8Lac7TPkPNMrB9JfP0qxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8K/oIBv9tVeKHhu4Rx7PU+x6pvdx3RFTLWT3lrv0kkZ50HN6DzTParzXFMBwCvGz
	 OsoG4Jzu7/wi2Um7MroBCg/yLxzksqwaXAzfGK6yAcg5xiMJA+5Vof+7so05wbfE2x
	 12clozoiOdP5je+rfYeBLkyu49YkTbRrYdCzOfM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/603] arm64: dts: qcom: sdx75-idp: align RPMh regulator nodes with bindings
Date: Wed, 15 Nov 2023 14:13:55 -0500
Message-ID: <20231115191633.455621754@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 815ea491460766dbd4b39a3c9904b44b5880c41c ]

Device node names should be generic and bindings expect certain pattern
for RPMh regulator nodes:

  sdx75-idp.dtb: rsc@17a00000: 'pmx75-rpmh-regulators' does not match any of the regexes: '^regulators(-[0-9])?$', 'pinctrl-[0-9]+'

Fixes: 8a2dc39d1043 ("arm64: dts: qcom: sdx75-idp: Add regulator nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230905163103.257412-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdx75-idp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdx75-idp.dts b/arch/arm64/boot/dts/qcom/sdx75-idp.dts
index 10d15871f2c48..a14e0650c4a8a 100644
--- a/arch/arm64/boot/dts/qcom/sdx75-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sdx75-idp.dts
@@ -44,7 +44,7 @@ vreg_bob_3p3: pmx75-bob {
 };
 
 &apps_rsc {
-	pmx75-rpmh-regulators {
+	regulators-0 {
 		compatible = "qcom,pmx75-rpmh-regulators";
 		qcom,pmic-id = "b";
 
-- 
2.42.0



