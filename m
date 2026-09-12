Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E1333993;
	Sat, 12 Sep 2026 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232217; cv=none; b=mI+tLW4U7XH0AGXqNZmnq3x+wyzvoHpvHNmifDD8YrF7XlQZi7ptZ4QgUuggF4ov9ehWZHnHRJH/i6hKBroKsaF0DDj2IL9mYqRqbJ18Gb51jS0kYUhiOJ4OJDy6T8iahcYwZuJgq0oLXRwmXxaxrL35ezGuA6RlW3H6gBE3hjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232217; c=relaxed/simple;
	bh=bOgxOrRcp0zFXt2l44bgaW9/jfttb50erJksISx7vik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGw/Xf9TYgLA0oaN3aGTcGxvSLv21lHlUw2JABq2aMqdT8az0yt+EM2Mh8/xrfeEA/wrh8c0hdz2IOM5qDZylA+a5zYW7G83JMsv0R+5W5ZoH6eBCjZuf9DmbbRHj8RbwaAQ7V6L6JIuJ02Mz1Ef5STgjeFIfsN7gwUM4sOH8/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmPm1+Ei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmPm1+Ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B341F000FF;
	Sat, 12 Sep 2026 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232216;
	bh=3YhqIrxVczAofNb2B7HPUX5WtbNb0D2TroOsHreEsyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmPm1+EiRT+CUT56IRbaUrcUyn5H2uV51qVC+Tsf6KRuYnXx6K+cz/vtM7ItFqQdp
	 A/iLMaY54gExIjRBEBb2RUYtN7fX+PkgNF4r8VsmyibvraJcXlwfSWfNDFa/Mq80J7
	 qQsS8Ave3jICXkcSR9GFVGNSp1qC85Sn2a/dPLWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1158/1191] arm64: dts: qcom: sm8550: Add missing properties for cryptobam
Date: Sat, 12 Sep 2026 09:04:46 +0200
Message-ID: <20260912065614.153288023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 663cd2cad36da23cf1a3db7868fce9f1a19b2d61 ]

num-channels and qcom,num-ees are required for BAM nodes without clock,
because the driver cannot ensure the hardware is powered on when trying to
obtain the information from the hardware registers. Specifying the node
without these properties is unsafe and has caused early boot crashes for
other SoCs before [1, 2].

Add the missing information from the hardware registers to ensure the
driver can probe successfully without causing crashes.

[1]: https://lore.kernel.org/r/CY01EKQVWE36.B9X5TDXAREPF@fairphone.com/
[2]: https://lore.kernel.org/r/20230626145959.646747-1-krzysztof.kozlowski@linaro.org/

Cc: stable@vger.kernel.org
Fixes: 433477c3bf0b ("arm64: dts: qcom: sm8550: add QCrypto nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250212-bam-dma-fixes-v1-3-f560889e65d8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 1ce2972498277..0c1df1d1e6950 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1581,6 +1581,8 @@ cryptobam: dma-controller@1dc4000 {
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <20>;
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x480 0x0>,
 				 <&apps_smmu 0x481 0x0>;
-- 
2.53.0



