Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0E911705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8B6C433C7;
	Mon, 11 Sep 2023 14:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443257;
	bh=RFnI1a6dkB24JAGQh402N3NrrTUVVQL0Ijb7F+oSFH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUD7IBnRo4zJzCvmBg5vsElRC9WCCz7xXZ2+kI3ac6RUJzCQmYJyGlSbvUWwEDPyB
	 qUapPFn/rgW489F7XKHibxPfhnI/Y5o0IkU9SnW0DCrCuRLaOYGwxWvMdFRm5F6Ds4
	 W4c5izrTY2Qok+OVkkkfnjobhkSdZEaGY2QjUomA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 314/737] arm64: dts: qcom: sm8250-sony-xperia: correct GPIO keys wakeup again
Date: Mon, 11 Sep 2023 15:42:53 +0200
Message-ID: <20230911134659.336451835@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b8fbeea0253211d97c579eae787274633d3eaf0d ]

gpio-keys,wakeup is a deprecated property:

  m8250-sony-xperia-edo-pdx206.dtb: gpio-keys: key-camera-focus: Unevaluated properties are not allowed ('gpio-key,wakeup' was unexpected)

Fixes: a422c6a91a66 ("arm64: dts: qcom: sm8250-edo: Rectify gpio-keys")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230711063011.16222-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
index eb82247131c10..0268d80248e5c 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
@@ -60,7 +60,7 @@ key-camera-focus {
 			gpios = <&pm8150b_gpios 2 GPIO_ACTIVE_LOW>;
 			debounce-interval = <15>;
 			linux,can-disable;
-			gpio-key,wakeup;
+			wakeup-source;
 		};
 
 		key-camera-snapshot {
@@ -69,7 +69,7 @@ key-camera-snapshot {
 			gpios = <&pm8150b_gpios 1 GPIO_ACTIVE_LOW>;
 			debounce-interval = <15>;
 			linux,can-disable;
-			gpio-key,wakeup;
+			wakeup-source;
 		};
 
 		key-vol-down {
-- 
2.40.1



