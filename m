Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9737920B0E
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="af+q8OMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F66AC433CB;
	Tue, 31 Oct 2023 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774359;
	bh=2p+ySdzGx4jxp/G7/TySSu9Wee4UqrZq6/D/vxFXXjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=af+q8OMexdpG5we/NBlmMZGbkBGgUfY3Y+UvAXEQ9h4XcFLa4i5aB48TirawQ2QeQ
	 BVYx0XKwWt7kgUP4EKdSvw7iAy6WN6L/b2f5FbBzjxUQevdwYpOIh9rmVKOni3EiPd
	 mryf/L20Ogfmy+8UWM4rSdzOHWtSVE6y0AhofLfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.5 019/112] arm64: dts: qcom: sa8775p: correct PMIC GPIO label in gpio-ranges
Date: Tue, 31 Oct 2023 18:00:20 +0100
Message-ID: <20231031165901.916915817@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

commit f822899c28572a854f2c746da5ed707d752458ab upstream.

There are several PMICs with GPIO nodes and one of the nodes referenced
other's in gpio-ranges which could result in deferred-probes like:

  qcom-spmi-gpio c440000.spmi:pmic@2:gpio@8800: can't add gpio chip

Reported-by: Brian Masney <bmasney@redhat.com>
Closes: https://lore.kernel.org/all/ZN5KIlI+RDu92jsi@brian-x1/
Fixes: e5a893a7cec5 ("arm64: dts: qcom: sa8775p: add PMIC GPIO controller nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230818135538.47481-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-pmics.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-pmics.dtsi b/arch/arm64/boot/dts/qcom/sa8775p-pmics.dtsi
index 3c3b6287cd27..eaa43f022a65 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p-pmics.dtsi
@@ -173,7 +173,7 @@ pmm8654au_1_gpios: gpio@8800 {
 			compatible = "qcom,pmm8654au-gpio", "qcom,spmi-gpio";
 			reg = <0x8800>;
 			gpio-controller;
-			gpio-ranges = <&pmm8654au_2_gpios 0 0 12>;
+			gpio-ranges = <&pmm8654au_1_gpios 0 0 12>;
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-- 
2.42.0



