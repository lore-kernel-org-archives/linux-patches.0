Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AADE168C7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DEBC433EF;
	Mon,  8 May 2023 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543658;
	bh=3SEBQJiay7/1AtfULfwBM/rBIqPEwXEasYcTtbThZJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBQDrTZuLrbxurRnmHEp4HACISazw/fcgryauI6hRpSbCdJJWalczmkZQfgXn3hYY
	 UfXFjW0fMGuFnuMcZY/gTs+leDL11IqpKXTx1ReUFAQEX6Ig8MWiWPfonIhzI1CIJz
	 pu0zsLKVJeF5qoUOXBSea+DbpZm/qbSqJP2J5IxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 160/694] arm64: dts: renesas: r8a77990: Remove bogus voltages from OPP table
Date: Mon,  8 May 2023 11:39:55 +0200
Message-Id: <20230508094437.614623636@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit fb76b0fae3ca880363214e1dcd6513ab8bd529e7 ]

According to the R-Car Series, 3rd Generation Hardware User’s Manual
Rev. 2.30, the System CPU cores on R-Car E3 do not have their own power
supply, but use the common internal power supply (typical 1.03V).

Hence remove the "opp-microvolt" properties from the Operating
Performance Points table.  They are optional, and unused, when none of
the CPU nodes is tied to a regulator using the "cpu-supply" property.

Fixes: dd7188eb4ed128dc ("arm64: dts: renesas: r8a77990: Add OPPs table for cpu devices")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/9232578d9d395d529f64db3333a371e31327f459.1676560856.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77990.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index d4718f144e33c..4529e9b57c331 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
@@ -49,17 +49,14 @@
 		opp-shared;
 		opp-800000000 {
 			opp-hz = /bits/ 64 <800000000>;
-			opp-microvolt = <820000>;
 			clock-latency-ns = <300000>;
 		};
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
-			opp-microvolt = <820000>;
 			clock-latency-ns = <300000>;
 		};
 		opp-1200000000 {
 			opp-hz = /bits/ 64 <1200000000>;
-			opp-microvolt = <820000>;
 			clock-latency-ns = <300000>;
 			opp-suspend;
 		};
-- 
2.39.2



