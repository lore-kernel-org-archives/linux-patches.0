Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1803D1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C89C433D2;
	Wed, 28 Dec 2022 16:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245517;
	bh=dRCMaNydInFQ/tG2XTzF+1HqvwiZ6fy+vxvxIUa9J6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbHV3V9fbDWHnTcBSvGdX/BHc9390nwG6XjsJJhW22OeIIOuUQzuP4FW69mZZO4vd
	 f/51GCL3ZsqJrDe/OCJqOQdEJhAnU8COfoFY3C+ZMCyxtYJk3/JjqcAMLM9Yv1hp6k
	 IfBvHYD7qNLW3ili+/LXM1QpROzSE2kA6cKkw9oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0856/1146] powerpc: dts: turris1x.dts: Add channel labels for temperature sensor
Date: Wed, 28 Dec 2022 15:39:55 +0100
Message-Id: <20221228144353.405571033@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 67bbb62f61e810734da0a1577a9802ddaed24140 ]

Channel 0 of SA56004ED chip refers to internal SA56004ED chip sensor (chip
itself is located on the board) and channel 1 of SA56004ED chip refers to
external sensor which is connected to temperature diode of the P2020 CPU.

Fixes: 54c15ec3b738 ("powerpc: dts: Add DTS file for CZ.NIC Turris 1.x routers")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220930123901.10251-1-pali@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/turris1x.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/powerpc/boot/dts/turris1x.dts b/arch/powerpc/boot/dts/turris1x.dts
index 045af668e928..e9cda34a140e 100644
--- a/arch/powerpc/boot/dts/turris1x.dts
+++ b/arch/powerpc/boot/dts/turris1x.dts
@@ -69,6 +69,20 @@ temperature-sensor@4c {
 				interrupt-parent = <&gpio>;
 				interrupts = <12 IRQ_TYPE_LEVEL_LOW>, /* GPIO12 - ALERT pin */
 					     <13 IRQ_TYPE_LEVEL_LOW>; /* GPIO13 - CRIT pin */
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				/* Local temperature sensor (SA56004ED internal) */
+				channel@0 {
+					reg = <0>;
+					label = "board";
+				};
+
+				/* Remote temperature sensor (D+/D- connected to P2020 CPU Temperature Diode) */
+				channel@1 {
+					reg = <1>;
+					label = "cpu";
+				};
 			};
 
 			/* DDR3 SPD/EEPROM */
-- 
2.35.1



