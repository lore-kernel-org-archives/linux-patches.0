Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09B87C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3454CC433A4;
	Mon, 24 Apr 2023 13:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342990;
	bh=w8bEPHdu3KNgN4GHE1rd4+2U0SIJuhemo7BgFQvv6QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbIgg8ASGiE2DMZrx153jtu+UmeVto8CBl/ThnIMh/A9meI34ndFBPjF6w4VtVOOS
	 8HnOMHWPXNP6NlLGjeTGYITpKmOFIE6kLUKV5voe92kwTIuOMLzHCLjewnCin9Udtj
	 HpEFcWi4fJ+lcYhMMgRf/LZexvb8CKb54IsfnVIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Steev Klimaszewski <steev@kali.org>
Subject: [PATCH 6.2 008/110] arm64: dts: qcom: sc8280xp-pmics: fix pon compatible and registers
Date: Mon, 24 Apr 2023 15:16:30 +0200
Message-Id: <20230424131136.436436923@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit ad8cd35c58ca3ec5e93f52a0124899627b98efb2 ]

The pmk8280 PMIC PON peripheral is gen3 and uses two sets of registers;
hlos and pbs.

This specifically fixes the following error message during boot when the
pbs registers are not defined:

	PON_PBS address missing, can't read HW debounce time

Note that this also enables the spurious interrupt workaround introduced
by commit 0b65118e6ba3 ("Input: pm8941-pwrkey - add software key press
debouncing support") (which may or may not be needed).

Fixes: ccd3517faf18 ("arm64: dts: qcom: sc8280xp: Add reference device")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Steev Klimaszewski <steev@kali.org> #Thinkpad X13s
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230327122948.4323-1-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
index f2c0b71b5d8e8..896a6925bbc32 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
@@ -59,8 +59,9 @@
 		#size-cells = <0>;
 
 		pmk8280_pon: pon@1300 {
-			compatible = "qcom,pm8998-pon";
-			reg = <0x1300>;
+			compatible = "qcom,pmk8350-pon";
+			reg = <0x1300>, <0x800>;
+			reg-names = "hlos", "pbs";
 
 			pmk8280_pon_pwrkey: pwrkey {
 				compatible = "qcom,pmk8350-pwrkey";
-- 
2.39.2



