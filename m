Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82C2BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC9CC4339C;
	Tue,  7 Mar 2023 18:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214721;
	bh=XvN+vnBs1AdgJkMmCEvqpw5yTPyAUwzo9AIP6A9gYw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKdCFRqx57+Rnwv1zM8n+bvkn8CstLIqg0YDX/sJ6L1HeFZ/Ve3DOZrOzTm5EHtlh
	 bS0gSidNIyKLhLAasJvuV5SUXGGx3DaD58qrTfEYrXN0jplDOaYCZK9PUNGBJbWxDu
	 OPmMfX/9gwHahi52Bh8Uhg3f2ga3l97Udy4EwpFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/567] arm64: dts: meson: remove CPU opps below 1GHz for G12A boards
Date: Tue,  7 Mar 2023 17:56:04 +0100
Message-Id: <20230307165907.144357595@linuxfoundation.org>
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

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 3cbd431c2b34d84605d358c8c57654193fd661fb ]

Amlogic G12A devices experience CPU stalls and random board wedges when
the system idles and CPU cores clock down to lower opp points. Recent
vendor kernels include a change to remove 100-250MHz and other distro
sources also remove the 500/667MHz points. Unless all 100-667Mhz opps
are removed or the CPU governor forced to performance stalls are still
observed, so let's remove them to improve stability and uptime.

Fixes: b190056fa9ee ("arm64: dts: meson-g12a: add cpus OPP table")
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Link: https://lore.kernel.org/r/20230119053031.21400-1-christianshewitt@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
index fb0ab27d1f642..6eaceb717d617 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
@@ -57,26 +57,6 @@ cpu_opp_table: opp-table {
 		compatible = "operating-points-v2";
 		opp-shared;
 
-		opp-100000000 {
-			opp-hz = /bits/ 64 <100000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-250000000 {
-			opp-hz = /bits/ 64 <250000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-500000000 {
-			opp-hz = /bits/ 64 <500000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-667000000 {
-			opp-hz = /bits/ 64 <666666666>;
-			opp-microvolt = <731000>;
-		};
-
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
 			opp-microvolt = <731000>;
-- 
2.39.2



