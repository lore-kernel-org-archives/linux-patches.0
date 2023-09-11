Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F3C1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590D9C433C7;
	Mon, 11 Sep 2023 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441066;
	bh=q8vlF1f6dQHJa7TDEh5uRG0Ipa6cyVHJpQWP9JVqnY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXna1C1qsbA+AJ8y9YzqnDwq/tgd2gagxR8BahVH0E+RbiDRGeSS6NLmSpCOqLfBz
	 OhYfEb1loOk90xxm4x52QDvdKnNKOOqOR4yaV19trJnFAuE5Zi5Kk8v98elekUtgDw
	 Pi7kBDEVsQ31GEpJooACsVkhaoV8sbvYekRkwEqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 257/739] arm64: dts: qcom: sc8180x: Add missing cache-unified to L3
Date: Mon, 11 Sep 2023 15:40:56 +0200
Message-ID: <20230911134658.328443359@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit e4322bb818bbcd36b441de9880fa4ac911a5eb51 ]

Add the missing property to fix the dt checker warning:

qcom/sc8180x-primus.dtb: l3-cache: 'cache-unified' is a required property

Fixes: 8575f197b077 ("arm64: dts: qcom: Introduce the SC8180x platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230626-topic-bindingsfixups-v1-7-254ae8642e69@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 363f438ff6059..8a6d9e0914ad9 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -64,6 +64,7 @@ L2_0: l2-cache {
 				L3_0: l3-cache {
 					compatible = "cache";
 					cache-level = <3>;
+					cache-unified;
 				};
 			};
 		};
-- 
2.40.1



