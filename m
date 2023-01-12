Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C03D746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 13:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B26C433F0;
	Thu, 12 Jan 2023 13:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673531933;
	bh=Vdt+Bk/OZEziYZnv9VLkNKFAieQ54foKrb8DvMKbrO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJ6U99xHk+B3JqtAg42dKDggEugr8FnZ/aJMJpDf8EKnPLttJKVpS6VqkCvY1hEgB
	 MXID6AizLBBx2qVCrcO0+ggZ74tbzohOOK3AW5T/7WMtmpiPKVjn1Vz26BLzi5y4Ms
	 2yzN04VN+851ODyMW0m+ZuXP8WOTokIV+wdhHD3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/783] arm64: dts: qcom: ipq6018-cp01-c1: use BLSPI1 pins
Date: Thu, 12 Jan 2023 14:45:18 +0100
Message-Id: <20230112135524.283175408@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 4871d3c38893c8a585e3e96364b7fb91cda8322e ]

When BLSPI1 (originally SPI0, later renamed in commit f82c48d46852
("arm64: dts: qcom: ipq6018: correct QUP peripheral labels")) was added,
the device node lacked respective pin configuration assignment.

Fixes: 5bf635621245 ("arm64: dts: ipq6018: Add a few device nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221006124659.217540-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts b/arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts
index e8eaa958c199..b867506bc7e1 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts
+++ b/arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts
@@ -37,6 +37,8 @@ &i2c_1 {
 
 &spi_0 {
 	cs-select = <0>;
+	pinctrl-0 = <&spi_0_pins>;
+	pinctrl-names = "default";
 	status = "okay";
 
 	m25p80@0 {
-- 
2.35.1



