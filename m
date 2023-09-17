Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922346FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF866C433C8;
	Sun, 17 Sep 2023 19:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979867;
	bh=UK4FhFAAiuGaE9cwKOK3Z3OP3b7PFEjrkbfY57R7dXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqzq92AQU3a2zEKnvM05Kv45L/jGbm0sPkMMpjQkeE5kCa3ndCk7c/1p2fSD7rq9B
	 SynOgUHA2DqUxuF9YnDPs3sd/9hxbrjv1ieiyjlJt36rvabk7xBfUvi2qOdHioh9em
	 TPkjF5nJ4k6L+qI+gQ6pcA9Tkk/wGepvtpXkqQLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.5 029/285] arm64: dts: qcom: msm8953-vince: drop duplicated touschreen parent interrupt
Date: Sun, 17 Sep 2023 21:10:29 +0200
Message-ID: <20230917191052.679242898@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit b019cf7e5fbaa7d25f716cb936a9237b47156f2d upstream.

Interrupts extended already define a parent interrupt controller:

  msm8953-xiaomi-vince.dtb: touchscreen@20: Unevaluated properties are not allowed ('interrupts-parent' was unexpected)

Fixes: aa17e707e04a ("arm64: dts: qcom: msm8953: Add device tree for Xiaomi Redmi 5 Plus")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230720115335.137354-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts b/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts
index 0956c866d6cb..1a1d3f92a511 100644
--- a/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts
+++ b/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts
@@ -132,7 +132,6 @@ &i2c_3 {
 	touchscreen@20 {
 		reg = <0x20>;
 		compatible = "syna,rmi4-i2c";
-		interrupts-parent = <&tlmm>;
 		interrupts-extended = <&tlmm 65 IRQ_TYPE_EDGE_FALLING>;
 
 		#address-cells = <1>;
-- 
2.42.0



