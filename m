Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6CD4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BFDC433EF;
	Wed, 15 Mar 2023 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882678;
	bh=v3aus6T8DUiMx14NFNPeUTHL9yErBioF38Regk5Cdh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJqfusDfnyc2aBjiVnoJZ10DJra8U4KH02cZUFTNdM7ghTDoY8rSfYMqq82YBCmzn
	 /up6yRszZKsyCwV6WoGw4DWLJJCqn+qXvvUDugDuVhILBh1bhMTgDnqbN5becHzWmr
	 dBSvoe9cYCHQWPKAsVv5U8Z6Qhm1aoVlwKU2jJvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/68] ARM: dts: exynos: correct TMU phandle in Exynos5250
Date: Wed, 15 Mar 2023 13:12:22 +0100
Message-Id: <20230315115727.187773543@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
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

[ Upstream commit 33e2c595e2e4016991ead44933a29d1ef93d5f26 ]

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.

Cc: <stable@vger.kernel.org>
Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Link: https://lore.kernel.org/r/20230209105841.779596-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 624fa234e7175..d5eccc86f5f78 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1122,7 +1122,7 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
+	thermal-sensors = <&tmu>;
 
 	cooling-maps {
 		map0 {
-- 
2.39.2



