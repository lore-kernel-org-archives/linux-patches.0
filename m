Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3F11863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE5CC433D2;
	Wed, 28 Dec 2022 14:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239332;
	bh=QEo7o9/FH/ZPMqOOGUU032HEKCPCRR3Ts0Ly4H4xBsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjE736bvcGqvtKfuV8ZTCxKKwiqX3u/UBu7P0nklMLNRbHE5lbhxeQXWvTJj6Cr2a
	 AeFDFC8Le0haYvT4eE4u1qpw/eyHwOCx3dE6rhCp6433PxvTzDKa9FSs+DvCvXX0kF
	 fejSm347Okog7yqZihyuBrTtvzoEtrNeEJUB8OLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Molly Sophia <mollysophia379@gmail.com>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0011/1073] arm64: dts: qcom: sdm845-xiaomi-polaris: fix codec pin conf name
Date: Wed, 28 Dec 2022 15:26:39 +0100
Message-Id: <20221228144328.471638008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 58c4a0b6f4bdf8c3c2b4aad7f980e4019cc0fc83 ]

Fix typo in the codec's pin name to be configured.  Mismatched name
caused the pin configuration to be ignored.

Fixes: be497abe19bf ("arm64: dts: qcom: Add support for Xiaomi Mi Mix2s")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Molly Sophia <mollysophia379@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220930192039.240486-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index dba7c2693ff5..2611a5c40ba3 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -628,7 +628,7 @@ sde_dsi_suspend: sde-dsi-suspend {
 	};
 
 	wcd_intr_default: wcd-intr-default {
-		pins = "goui54";
+		pins = "gpio54";
 		function = "gpio";
 		input-enable;
 		bias-pull-down;
-- 
2.35.1



