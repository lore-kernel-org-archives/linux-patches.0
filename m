Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D050AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BF1C433EF;
	Wed,  4 Jan 2023 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848849;
	bh=VOTvp+4qMnS4pIXR2TLEide2mul8kp9d7DnWzB0oKc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00/5G7H2vfR/71IEktPSBLzkHKJvgDG3okhqnt2IGWfU7KxvHtZGOOzP/CZBQ55S5
	 iTkfqEbCjjRbEUVGIM3gzbz5fG27cc6csLXDFrRzxrn8A0IF6VDNuAaaI4XWAGjcqZ
	 r+qIMF2o7eZWI1hn0nrAwd+IywMUW18NOCgqZmtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Steev Klimaszewski <steev@kali.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.0 024/177] arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength
Date: Wed,  4 Jan 2023 17:05:15 +0100
Message-Id: <20230104160508.400668617@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

commit fd49776d8f458bba5499384131eddc0b8bcaf50c upstream.

The pin configuration (done with generic pin controller helpers and
as expressed by bindings) requires children nodes with either:
1. "pins" property and the actual configuration,
2. another set of nodes with above point.

The qup_i2c12_default pin configuration used second method - with a
"pinmux" child.

Fixes: 44acee207844 ("arm64: dts: qcom: Add Lenovo Yoga C630")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220930192039.240486-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -487,8 +487,10 @@
 };
 
 &qup_i2c12_default {
-	drive-strength = <2>;
-	bias-disable;
+	pinmux {
+		drive-strength = <2>;
+		bias-disable;
+	};
 };
 
 &qup_uart6_default {


