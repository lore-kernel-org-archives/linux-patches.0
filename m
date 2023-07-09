Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51540522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64DCC433C7;
	Sun,  9 Jul 2023 11:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902064;
	bh=10gVgYobHoMz99FJfexLnExfjj73SNX/AirwAwlQmj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+0t61TNWrqzDgTfmvVrKz0Ll9OEPDuDQ8MyOlfTmrqc1r4FE7c0hYTwhFxDgJcO9
	 Rfn++90Nolw5hskuA6E/FQP3jB6uMORSXLCUIL4u0ungJ0DhUIQOf6/35Bw1Y40IS2
	 l9IAZ9/FcXQ9Txx+OazoziQgoj846QDQyf0LjPx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Molly Sophia <mollysophia379@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 241/431] arm64: dts: qcom: sdm845-polaris: add missing touchscreen child node reg
Date: Sun,  9 Jul 2023 13:13:09 +0200
Message-ID: <20230709111456.808351143@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit 4a0156b8862665a3e31c8280607388e3001ace3d ]

Add missing reg property to touchscreen child node to fix dtbs W=1 warnings:

  Warning (unit_address_vs_reg): /soc@0/geniqup@ac0000/i2c@a98000/touchscreen@20/rmi4-f12@12: node has a unit name, but no reg or ranges property

Fixes: be497abe19bf ("arm64: dts: qcom: Add support for Xiaomi Mi Mix2s")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Molly Sophia <mollysophia379@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-18-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index 56f2d855df78d..406f0224581a7 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -483,6 +483,7 @@ rmi4-f01@1 {
 		};
 
 		rmi4-f12@12 {
+			reg = <0x12>;
 			syna,rezero-wait-ms = <0xc8>;
 			syna,clip-x-high = <0x438>;
 			syna,clip-y-high = <0x870>;
-- 
2.39.2



