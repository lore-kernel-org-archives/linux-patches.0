Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45360847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE106C433D2;
	Wed,  1 Mar 2023 18:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694298;
	bh=VtfQylg4Sji3mmCW+kI8RMSb3CPJyWuTWEmqD+l2E6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+ao4Xs7/jZFM1AX7Gz8Rs4HxZw8yZXV8K+Crs7hjrNd/G20bE+LgBXWj1/HCbwPu
	 xGBjPbO4T5on6CIApocKSFdAMPvA4zLNbRMg/6U3WRhC9KWnIrAzWmOsCT3TqS1jNz
	 1e6qU9zFzCDz/dfaMT36MciQkoVtB0cdt9aUE6eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/42] arm64: dts: rockchip: align rk3399 DMC OPP table with bindings
Date: Wed,  1 Mar 2023 19:08:33 +0100
Message-Id: <20230301180657.588330420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
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

[ Upstream commit b67b09733d8a41eec33d5d37be2f8cff8af82a5e ]

Bindings expect certain pattern for OPP table node name and underscores
are not allowed:

  rk3399-rock-pi-4a-plus.dtb: dmc_opp_table: $nodename:0: 'dmc_opp_table' does not match '^opp-table(-[a-z0-9]+)?$'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230119124631.91080-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-op1-opp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-op1-opp.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-op1-opp.dtsi
index 6e29e74f6fc68..783120e9cebeb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-op1-opp.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-op1-opp.dtsi
@@ -111,7 +111,7 @@ opp05 {
 		};
 	};
 
-	dmc_opp_table: dmc_opp_table {
+	dmc_opp_table: opp-table-3 {
 		compatible = "operating-points-v2";
 
 		opp00 {
-- 
2.39.0



