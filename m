Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FE81863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1F8C433D2;
	Wed, 28 Dec 2022 14:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238805;
	bh=X6pIe/vcPlIeOVVKFsNobKb7x1C8QXWcFn0Z17KpYos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CafY/RU6wtfVlIuwbOZkaFP3WHuFmQ8PMznXLnuMysAmKsmx0N1J0r/YiTCU7Ka0J
	 HOLzCDTcvRWAc1XhnZ7Sj/F4Llb2FBp/gs0KUQzDnNRJckT5mEYYTlGLT1S8Mt8TFH
	 54Nv6ivX+9vyx+NfmotDSYPfCpN7RydslNSYt2k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/731] arm64: dts: qcom: sm8250: correct LPASS pin pull down
Date: Wed, 28 Dec 2022 15:32:04 +0100
Message-Id: <20221228144257.037556023@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 195a0a11d66d6c696cbcf398d6bc3f3a3a462f7c ]

The pull-down property is actually bias-pull-down.

Fixes: 3160c1b894d9 ("arm64: dts: qcom: sm8250: add lpass lpi pin controller node")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220927153429.55365-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index b710bca45648..9a95c15c7e8b 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1933,7 +1933,7 @@ data {
 					pins = "gpio7";
 					function = "dmic1_data";
 					drive-strength = <2>;
-					pull-down;
+					bias-pull-down;
 					input-enable;
 				};
 			};
-- 
2.35.1



