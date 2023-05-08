Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8643A171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9A6C433EF;
	Mon,  8 May 2023 11:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545562;
	bh=SGPhHBryQm1bcXIDesbpsA5tl+pAabv8YSVP8MgXpdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMRcD3ktRVIBuMeohyVjf4fxD9rDkRafqx2IQY16GZ8H4ysxwxStgbTo5SNbT9jC9
	 BYTDuO6OZSCRyOtV6usYm15HDY55l8hy0H9dzDP0dGIOJzwjtC+OHC4l2rqrvG1D+F
	 Fg+1hslgQP1qeu33KzPI24b0dgGlZzknbUTQmLNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/371] arm64: dts: renesas: r8a774c0: Remove bogus voltages from OPP table
Date: Mon,  8 May 2023 11:44:42 +0200
Message-Id: <20230508094815.318633073@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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

[ Upstream commit 554edc3e9239bb81e61be9f0f5dbbeb528a69e72 ]

According to the RZ/G Series, 2nd Generation Hardware User’s Manual
Rev. 1.11, the System CPU cores on RZ/G2E do not have their own power
supply, but use the common internal power supply (typical 1.03V).

Hence remove the "opp-microvolt" properties from the Operating
Performance Points table.  They are optional, and unused, when none of
the CPU nodes is tied to a regulator using the "cpu-supply" property.

Fixes: 231d8908a66fa98f ("arm64: dts: renesas: r8a774c0: Add OPPs table for cpu devices")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/8348e18a011ded94e35919cd8e17c0be1f9acf2f.1676560856.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index 9eb08be3b98e2..50189209b6605 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
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



