Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E11BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0CFC433D2;
	Tue,  7 Mar 2023 17:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209244;
	bh=uYf6Ix9X5JwD3yvYIMdWonOHbYAciUUb6PJoVTFp1Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFoy9MXWYP9w/qXZQErKVSTdmRvEWZqcD24pT8nV1RQIH57O7gidhE6uNHKc9XkQj
	 C2IVrM2N84RFLyLAjfXIX6G3nPR8BSC4lwZUrFKxUfUsMlss90PKSxY7vOI/hZ71tw
	 UwmiqlAUSrRqfcms8ilvCDQbRK0BzX1IME1p2l6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0126/1001] arm64: dts: qcom: pmk8350: Use the correct PON compatible
Date: Tue,  7 Mar 2023 17:48:18 +0100
Message-Id: <20230307170027.533389297@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit c0ee8e0ba5cc17623e63349a168b41e407b1eef0 ]

A special compatible was introduced for PMK8350 both in the driver and
the bindings to facilitate for 2 base registers (PBS & HLOS). Use it.

Fixes: b2de43136058 ("arm64: dts: qcom: pmk8350: Add peripherals for pmk8350")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230213212930.2115182-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmk8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmk8350.dtsi b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
index 32f5e6af8c11c..f26fb7d32faf2 100644
--- a/arch/arm64/boot/dts/qcom/pmk8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
@@ -21,7 +21,7 @@ pmk8350: pmic@PMK8350_SID {
 		#size-cells = <0>;
 
 		pmk8350_pon: pon@1300 {
-			compatible = "qcom,pm8998-pon";
+			compatible = "qcom,pmk8350-pon";
 			reg = <0x1300>, <0x800>;
 			reg-names = "hlos", "pbs";
 
-- 
2.39.2



