Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055731;
	b=wUkJ6+HFoQ9+BUg7k3BuGDp2GLziZo0IkkunVmcYrOHkuxR5f3P/LVSIQTLo6rU6+oAw
	 zJ75LlfZL4RS+eFYRV+5nLJyLbOH/Z+qjk4N5pNesHB0aggzFS2OrYR4B/F8mKfeBoDT7
	 7Agunfc4xSVNhLPWc0Q/EKsuEX3ZzAs14BqmrqosDkKBhef0DEX4dTjw3nNEAPeT9Bz8s
	 zXRGPIFjAFcLNX+1dNhmbWsq/f1zbx9FRkPNmgg9J/gpf8Wy2dctP4jd9MyZB+0SYRT+8
	 07sUIKSWuNDy0d20M+a5H5djP0IzZ63SxkZABzYQz6BtwEErDfpPMAkfRffHxf+NOcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hP7boeuan2NhIb21zDTp1aZKXlo0MDo4PU3/QDDsCmI=;
	b=pKY2hcCTD1QC11/yiP57g+kTDkpQgBn8UwkgCTGAV4WIYLXOn1UXR5LibcMbplU93KuL
	 qdb009BjmxV3pHs1Q8nNRp1LurjCLCyNlch+rVMEM8tfs+1eOJuFsvPB5FlVsS9RyiLfO
	 hzMAFEYa8t+dPMByFIoDf2owCWQHuXRNF0sXpDUw+9SkcI81Qff7P4pH9UU2zkTVcrs5U
	 MABvYTRZ/wj1L0dyW1mCbqdMBlptu/J+Hvz/Bs7ID9Vga4zrcsY76gxuo9zgQJqvoi/ZM
	 wAaGM4t+iH393bs2r9yFkEJ9Ln08rajjl8YxrnLgYXPmaGvZ2Y/0NYNyYHz4WA4QZgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBkQkbGV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A7C606A320;
	Thu, 19 Nov 2026 02:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBkQkbGV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44CA1F000C4;
	Thu, 19 Nov 2026 02:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055731;
	bh=hP7boeuan2NhIb21zDTp1aZKXlo0MDo4PU3/QDDsCmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBkQkbGVjgpIyWti24fnkJEm6PrZ2Zuh7eEwepDFVgv6Cc9pxftqSnyyKqICsgEpv
	 pu9GG6ELDQLczJgRaUSDARPf617gejDJ2Jb4TzSUWt0USCSTgKvMUeiIsmo3hj5AQc
	 RD9yUYZqRrCMGUeoHLwyoI7jLHj/mrFWitjaGeqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1737/2214] ARM: dts: ux500: Use AB8505 charger compatible
Date: Wed, 18 Nov 2026 15:56:53 +0100
Message-ID: <20261118150121.151104338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit ff1501cbb825de117267124ecb8898112b4051c5 ]

Identify the AB8505 charger using its variant-specific compatible and
retain the AB8500 compatible as a fallback for the existing driver. This
selects the AB8505 interrupt constraints from the binding.

The AB8505 interrupt table explicitly omits the five interrupt sources
belonging to the AB8500 main charger. Remove these nonexistent interrupts
from the AB8505 charger node, leaving its nine USB charger interrupts.

Fixes: bc324d447fba ("ARM: dts: ux500: Add interrupts to charger")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ab8505.dtsi | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ab8505.dtsi b/arch/arm/boot/dts/ste-ab8505.dtsi
index ad40bd52311f6..9926f99718d80 100644
--- a/arch/arm/boot/dts/ste-ab8505.dtsi
+++ b/arch/arm/boot/dts/ste-ab8505.dtsi
@@ -134,13 +134,9 @@ ab8500_btemp {
 				};
 
 				ab8500_charger {
-					compatible = "stericsson,ab8500-charger";
-					interrupts = <10 IRQ_TYPE_LEVEL_HIGH>,
-						     <11 IRQ_TYPE_LEVEL_HIGH>,
-						     <0 IRQ_TYPE_LEVEL_HIGH>,
-						     <107 IRQ_TYPE_LEVEL_HIGH>,
-						     <106 IRQ_TYPE_LEVEL_HIGH>,
-						     <14 IRQ_TYPE_LEVEL_HIGH>,
+					compatible = "stericsson,ab8505-charger",
+						     "stericsson,ab8500-charger";
+					interrupts = <14 IRQ_TYPE_LEVEL_HIGH>,
 						     <15 IRQ_TYPE_LEVEL_HIGH>,
 						     <79 IRQ_TYPE_LEVEL_HIGH>,
 						     <105 IRQ_TYPE_LEVEL_HIGH>,
@@ -149,12 +145,7 @@ ab8500_charger {
 						     <22 IRQ_TYPE_LEVEL_HIGH>,
 						     <21 IRQ_TYPE_LEVEL_HIGH>,
 						     <16 IRQ_TYPE_LEVEL_HIGH>;
-					interrupt-names = "MAIN_CH_UNPLUG_DET",
-							  "MAIN_CHARGE_PLUG_DET",
-							  "MAIN_EXT_CH_NOT_OK",
-							  "MAIN_CH_TH_PROT_R",
-							  "MAIN_CH_TH_PROT_F",
-							  "VBUS_DET_F",
+					interrupt-names = "VBUS_DET_F",
 							  "VBUS_DET_R",
 							  "USB_LINK_STATUS",
 							  "USB_CH_TH_PROT_R",
-- 
2.53.0



