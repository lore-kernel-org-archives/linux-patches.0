Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FE1847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B191DC433D2;
	Fri, 10 Mar 2023 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456306;
	bh=NaX7V+gohbtE2nO5s3MCd4BEQz1hWz649rSjz779D2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YW+4La74Aqo/fSKDEvizuHVYSwh27dHdrHwJAQzELWGwwQcy1qpTT/+dpfQIRe4Vj
	 FoxW3mik8IiG0Xn9bl8/U1iig17O1QfJ1P2IyyoGTgWu2tQCyOFHmCxXEiMXiQNx/y
	 deqoM+iiLd+v40BXT7f6wBIXoez2RnGYOcmK5LGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 4.14 134/193] ARM: dts: exynos: correct TMU phandle in Odroid XU
Date: Fri, 10 Mar 2023 14:38:36 +0100
Message-Id: <20230310133715.695445468@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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

commit 9372eca505e7a19934d750b4b4c89a3652738e66 upstream.

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property
is already defined in included exynosi5410.dtsi, drop it from
exynos5410-odroidxu.dts to fix the error and remoev redundancy.

Fixes: 88644b4c750b ("ARM: dts: exynos: Configure PWM, usb3503, PMIC and thermal on Odroid XU board")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos5410-odroidxu.dts |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -116,7 +116,6 @@
 };
 
 &cpu0_thermal {
-	thermal-sensors = <&tmu_cpu0 0>;
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
 


