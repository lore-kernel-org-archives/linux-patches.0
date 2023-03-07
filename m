Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7651BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC41C4339B;
	Tue,  7 Mar 2023 19:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216224;
	bh=/BgzxS7JaIxRIEWj8qbWZ7h3bxXz3cNqi++S7abWyTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USIEGj6PoWav2gWlf3cap/6PLlR/CEfQ/9oFzcT8erauY9cKCcPr4mGKFvWR7y7O8
	 6OQbgtcVCYq2udu8q2sgj9MUXB5CmEyZctc+nqBHCZHwv2pyKlD7LxUwakGZCYwYkL
	 xrKpRRbAf+vg+DHI82jMjrWpMnV0z/DWlfYATWsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 516/567] ARM: dts: exynos: correct TMU phandle in Exynos4210
Date: Tue,  7 Mar 2023 18:04:12 +0100
Message-Id: <20230307165928.339279305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

commit 408ab6786dbf6dd696488054c9559681112ef994 upstream.

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property is
already defined in included exynos4-cpu-thermal.dtsi, drop it from
exynos4210.dtsi to fix the error and remoev redundancy.

Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos4210.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -393,7 +393,6 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
 };
 
 &gic {


