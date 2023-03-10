Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3AD848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D1FC433D2;
	Fri, 10 Mar 2023 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458388;
	bh=q6rnDoU1CEG/3RwlKSo8In3ZWYiU2Mfp0pnCszW6CRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvOKC0qX9cYDPhbeTTeiJhB/jPc1HtyduoGyjBBQ0At02OvhOEAGmuHqJrgtw6Qtg
	 b+jCrgOX+uslW1Z9+yiF4g1z17qKmXc8sWzLHcGpp31dkSUuZIjqmcHnuGb7g2HgPq
	 0S4KBK6xee7d09urtR4RIKn89SCspgBMBc8ZrEm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/357] arm64: dts: meson: remove CPU opps below 1GHz for G12A boards
Date: Fri, 10 Mar 2023 14:34:59 +0100
Message-Id: <20230310133734.434605436@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index eb5d177d7a999..c8c438c0b429c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
@@ -54,26 +54,6 @@ cpu_opp_table: opp-table {
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



