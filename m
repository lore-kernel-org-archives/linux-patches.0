Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF1B848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F001EC433D2;
	Fri, 10 Mar 2023 14:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458141;
	bh=QZ/J5c16T3DlhoxUHH4nItPt0x0tksRPap4dyxd48Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XuoInTN2atZWlz3ZLPtG4cVJKW6gpfgkuWq0w8X2u1erJpkT0hml1KF0TD5kiNO6P
	 BQK+wkBriH0ZVzDM0KsDOb8qjTV/1R2/+kFEW6NkaMOykVyWEkitxcuqnyJIcSwlLC
	 87s9HXlq8UoDtRpc5cCXAwEsy5ExFc8bb70Kaaww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 4.19 177/252] ARM: dts: exynos: correct TMU phandle in Exynos4
Date: Fri, 10 Mar 2023 14:39:07 +0100
Message-Id: <20230310133724.223585860@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

commit 8e4505e617a80f601e2f53a917611777f128f925 upstream.

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.

Fixes: 328829a6ad70 ("ARM: dts: define default thermal-zones for exynos4")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
+++ b/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
@@ -10,7 +10,7 @@
 / {
 thermal-zones {
 	cpu_thermal: cpu-thermal {
-		thermal-sensors = <&tmu 0>;
+		thermal-sensors = <&tmu>;
 		polling-delay-passive = <0>;
 		polling-delay = <0>;
 		trips {


