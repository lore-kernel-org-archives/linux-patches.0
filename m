Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30F612CDAE;
	Tue, 30 Apr 2024 11:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475278; cv=none; b=tMZxHyIqvzgghPcJIK2DdndabRY7h7DR2szJ7bRfvDLxWjw+KASA36kM2DjyYAl1bNR3sak6QQLtSFb/Gsm2a/We9AQymRcQ6KY6Kr3FcHPMbm/eeY5Q9bvZduibWAaQHkTopEurejUY6DXely0F1p6POtLVEmW4xnB/5syKFn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475278; c=relaxed/simple;
	bh=7JcElU5uO2pD8Apw3n1K1FJzWI6RA2ANfKerNNlW5ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3Dh5VcK2BEIhm5oti3C2p5SgFFdg4clnFJXcRkLDqPnevsqAZthl72g/RsYPGN+mS7ANAvRUs0pr3eXuX9PGRUbxyAf+4pW7p766pH8Xl0AJXcFy+mFewcRrWaII9vfrIpIYM3T63aoAzSTL1y2brxXjd82wQKH3Z19U8hoPNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9Gay1DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9Gay1DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3081BC2BBFC;
	Tue, 30 Apr 2024 11:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475278;
	bh=7JcElU5uO2pD8Apw3n1K1FJzWI6RA2ANfKerNNlW5ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9Gay1DStmRm6yqNGvTlgMhbaMz7aVxf5o8ZtVFTl8ng48qjw1GDUmvQK8RFDd+sF
	 h2ZS9OarUTuHeba+2pFbyxw4tVC1a7hrtuSjrJx84mUP4c7a5SxaMoSb/ozqg1wmu0
	 U5FK9HiTF2d7pAKE+rqCZ7p4n2SFwoP5HloaKkuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Simion <andrei.simion@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/186] ARM: dts: microchip: at91-sama7g5ek: Replace regulator-suspend-voltage with the valid property
Date: Tue, 30 Apr 2024 12:38:21 +0200
Message-ID: <20240430103059.455845251@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Simion <andrei.simion@microchip.com>

[ Upstream commit e027b71762e84ee9d4ba9ad5401b956b9e83ed2a ]

By checking the pmic node with microchip,mcp16502.yaml#
'regulator-suspend-voltage' does not match any of the
regexes 'pinctrl-[0-9]+' from schema microchip,mcp16502.yaml#
which inherits regulator.yaml#. So replace regulator-suspend-voltage
with regulator-suspend-microvolt to avoid the inconsitency.

Fixes: 85b1304b9daa ("ARM: dts: at91: sama7g5ek: set regulator voltages for standby state")
Signed-off-by: Andrei Simion <andrei.simion@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20240404123824.19182-2-andrei.simion@microchip.com
[claudiu.beznea: added a dot before starting the last sentence in commit
 description]
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/at91-sama7g5ek.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/microchip/at91-sama7g5ek.dts b/arch/arm/boot/dts/microchip/at91-sama7g5ek.dts
index 217e9b96c61e5..20b2497657ae4 100644
--- a/arch/arm/boot/dts/microchip/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/microchip/at91-sama7g5ek.dts
@@ -293,7 +293,7 @@
 
 					regulator-state-standby {
 						regulator-on-in-suspend;
-						regulator-suspend-voltage = <1150000>;
+						regulator-suspend-microvolt = <1150000>;
 						regulator-mode = <4>;
 					};
 
@@ -314,7 +314,7 @@
 
 					regulator-state-standby {
 						regulator-on-in-suspend;
-						regulator-suspend-voltage = <1050000>;
+						regulator-suspend-microvolt = <1050000>;
 						regulator-mode = <4>;
 					};
 
@@ -331,7 +331,7 @@
 					regulator-always-on;
 
 					regulator-state-standby {
-						regulator-suspend-voltage = <1800000>;
+						regulator-suspend-microvolt = <1800000>;
 						regulator-on-in-suspend;
 					};
 
@@ -346,7 +346,7 @@
 					regulator-max-microvolt = <3700000>;
 
 					regulator-state-standby {
-						regulator-suspend-voltage = <1800000>;
+						regulator-suspend-microvolt = <1800000>;
 						regulator-on-in-suspend;
 					};
 
-- 
2.43.0



