Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4631C11184
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E9AC433C8;
	Mon, 11 Sep 2023 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440893;
	bh=AsBXe/jnuD5L+FPiQjZLa1gV8V5visF1Osd1kf155oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pg0Xlvf7uDtUAmFZEWbhAxf7l8zzi/Y1VCXFLjVhon+iEYaETLYCrs5BVXGnopMk
	 CkEHxWD7Bfq+ouKXmcE2SN6QTJrpDGSsfV3yS+6OqSCC646Zzyt3Ccvungvr9A7jY3
	 gwo4Rdrn6SsIJbmIr8F0rN/pPfBdmaaxno9ZtJEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 222/739] arm64: dts: qcom: sc8280xp-crd: Correct vreg_misc_3p3 GPIO
Date: Mon, 11 Sep 2023 15:40:21 +0200
Message-ID: <20230911134657.384057055@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 9566b5271f68bdf6e69b7c511850e3fb75cd18be ]

The vreg_misc_3p3 regulator is controlled by PMC8280_1 GPIO 2, not 1, on
the CRD.

Fixes: ccd3517faf18 ("arm64: dts: qcom: sc8280xp: Add reference device")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230620203915.141337-1-quic_bjorande@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
index b566e403d1db2..b21b41a066b62 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
@@ -167,7 +167,7 @@ vreg_misc_3p3: regulator-misc-3p3 {
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpio = <&pmc8280_1_gpios 1 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmc8280_1_gpios 2 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 
 		pinctrl-names = "default";
@@ -757,7 +757,7 @@ edp_bl_reg_en: edp-bl-reg-en-state {
 	};
 
 	misc_3p3_reg_en: misc-3p3-reg-en-state {
-		pins = "gpio1";
+		pins = "gpio2";
 		function = "normal";
 	};
 };
-- 
2.40.1



