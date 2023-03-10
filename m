Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1559D881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6374CC4339E;
	Fri, 10 Mar 2023 14:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459495;
	bh=0jHJqBg+SacLjaKX4pE63h9foHMIcJ2ZpgqbFs9CJ6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylFd0B/VdV7/HyQopVzZsO643ftAuEWrHFrBv9RBP5ijOc/FkZZqKS+Alo1kkdIcP
	 36zSrz5cWCcnpIdBn8BTWb5yCo06z5dqA3dxl7OxRsiwzQiwexRXrDlrn6Qjns9AmX
	 v9LLaOhHD3fzuRzciCtG3V5lJgxfoPTxrfOQgW24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/529] arm64: dts: qcom: sdm845-db845c: fix audio codec interrupt pin name
Date: Fri, 10 Mar 2023 14:32:32 +0100
Message-Id: <20230310133805.462018226@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

[ Upstream commit 740862bb5f59b93efb390a417995f88a64bdc323 ]

The pin config entry should have a string, not number, for the GPIO used
as WCD9340 audio codec interrupt.

Fixes: 89a32a4e769c ("arm64: dts: qcom: db845c: add analog audio support")
Reported-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221222151319.122398-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index c6691bdc81002..1e889ca932e41 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -896,7 +896,7 @@ sdc2_card_det_n: sd-card-det-n {
 	};
 
 	wcd_intr_default: wcd_intr_default {
-		pins = <54>;
+		pins = "gpio54";
 		function = "gpio";
 
 		input-enable;
-- 
2.39.2



