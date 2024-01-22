Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FBB634F8;
	Tue, 23 Jan 2024 00:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971284; cv=none; b=G0Rt0f+xt1AZUGVBEKV+2C1LMNZJ6tC6te4jw8YZkqjh6ntM7hB7SLQNUqhsHNRV4BFKIZQoWDgXzH3StIy5JAKDyt/e9PUPxc82IgJVd5K1Rd45Wkgj5RoFzCIuKkRHd2iHRHS1zP0yiYDSu3ad4Om+9Mft3eLcRBX74lCLfbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971284; c=relaxed/simple;
	bh=p+QmbL6IYC0pnfkfZ36ddKISoYA8aFBhEQoJMrVcvCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRC9G93kGHK1A3rrhIlc/3oD7COacLauCEJ7V8f4wHUjr3xes5o1tqvxYJo2XR+5avrmjbSWBgy46LQCM62Es8lA0kUjROacZG7C+T6bBlgQ8IzP4JWm/7hnX3EJxtdL1i/kQ78y0p1Y9XUvU0Lta7P6z5xYd39DwWOyhfEbCc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJJTsYWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJJTsYWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13419C433F1;
	Tue, 23 Jan 2024 00:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971284;
	bh=p+QmbL6IYC0pnfkfZ36ddKISoYA8aFBhEQoJMrVcvCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJJTsYWaBEj4YHF4eiadxE93Lf+kyZT11LJUQGVcdFAEsASqxpT1lvKpPIAUKVZ87
	 +XWRWjgV9EVTHL2qnqTbmroqhPD+445qN9n2UA3e2ycKdEE+5ZgPo5ZQEXhaiJo/4s
	 rCgWROZN4t4hGH27RESok3FLNLV+jEWU9tVUHVV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/286] arm64: dts: qcom: sdm845-db845c: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:57:09 -0800
Message-ID: <20240122235736.872269409@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 0c90c75e663246203a2b7f6dd9e08a110f4c3c43 ]

There is no "panic-indicator" default trigger but a property with that
name:

  sdm845-db845c.dtb: leds: led-0: Unevaluated properties are not allowed ('linux,default-trigger' was unexpected)

Fixes: 3f72e2d3e682 ("arm64: dts: qcom: Add Dragonboard 845c")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231111095617.16496-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 1e889ca932e4..31f4f0575094 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -55,8 +55,8 @@ leds {
 		user4 {
 			label = "green:user4";
 			gpios = <&pm8998_gpio 13 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "panic-indicator";
 			default-state = "off";
+			panic-indicator;
 		};
 
 		wlan {
-- 
2.43.0



