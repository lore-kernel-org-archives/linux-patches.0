Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E192AD38
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B25C433F0;
	Wed,  4 Jan 2023 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848528;
	bh=r8Wy8rSoS4qvnvZzPMfJOSopQypRSVPJ5uA5CQSiK14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDIPKa7qGiO+yPkKK3vUD55PzO9ThLRjwDYyMcZOAQS248Q+8srPXB1/hwtl0Caqg
	 3Gci629Qv1i9wlkfA00RWPV7I/ejwc5BfIEzGbQwDUNKc2pKZJr05fMiZO5UxobEuC
	 uVAcWc38dJjHhWxuMIr+d9viAbC3aT7jGUIPV2fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 014/207] arm64: dts: qcom: sdm845-db845c: correct SPI2 pins drive strength
Date: Wed,  4 Jan 2023 17:04:32 +0100
Message-Id: <20230104160512.365614699@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit 9905370560d9c29adc15f4937c5a0c0dac05f0b4 upstream.

The pin configuration (done with generic pin controller helpers and
as expressed by bindings) requires children nodes with either:
1. "pins" property and the actual configuration,
2. another set of nodes with above point.

The qup_spi2_default pin configuration uses alreaady the second method
with a "pinmux" child, so configure drive-strength similarly in
"pinconf".  Otherwise the PIN drive strength would not be applied.

Fixes: 8d23a0040475 ("arm64: dts: qcom: db845c: add Low speed expansion i2c and spi nodes")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221010114417.29859-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -1123,7 +1123,10 @@
 
 /* PINCTRL - additions to nodes defined in sdm845.dtsi */
 &qup_spi2_default {
-	drive-strength = <16>;
+	pinconf {
+		pins = "gpio27", "gpio28", "gpio29", "gpio30";
+		drive-strength = <16>;
+	};
 };
 
 &qup_uart3_default{


