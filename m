Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124714431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623BCC433EF;
	Wed, 15 Mar 2023 12:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882622;
	bh=GZo1/HfV69uSctWybylEbuTrnOdmp0VEt15Un82YHPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCb1LFqws2JGnNs5usKr6n7BzEROjqsCRLfW33SA/BHSlzXKfPUr/jmBlmX9rgbmI
	 xtIwjlOkN/O+WdOM8//U9SshurP6QEgyD+TnGhk0cc7o3ybZ9jKLi54dTbWWNBc7e+
	 q17dlz+A9gFuMeSv3ChqvHxwRn9c3htKvmygFR88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/39] ARM: dts: exynos: correct TMU phandle in Exynos4210
Date: Wed, 15 Mar 2023 13:12:30 +0100
Message-Id: <20230315115721.836485041@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
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

[ Upstream commit 408ab6786dbf6dd696488054c9559681112ef994 ]

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property is
already defined in included exynos4-cpu-thermal.dtsi, drop it from
exynos4210.dtsi to fix the error and remoev redundancy.

Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4210.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 2ec6c01550564..24bea84034af2 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -387,7 +387,6 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
 };
 
 &gic {
-- 
2.39.2



