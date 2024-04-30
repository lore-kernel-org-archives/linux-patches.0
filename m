Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409C212C47A;
	Tue, 30 Apr 2024 11:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476419; cv=none; b=iqMW4BYCJUhkUvEUveW6eFj9Bzegw3E2uQapm5/Bmkf2lxJ5YheAODur8bgGLpLlrJfsMf39vKcDErxVvh9kxFLMFNBgZ/Oz/fN/jkDkpzEk6YlGlTi//iM6RLs7X+zJZn2vMZVmuCosW8DtwPIM8Myene2AKTQgSDB45clspOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476419; c=relaxed/simple;
	bh=MdWnSpwCQQOZoKzhD9dNyhqJGksuaEWMzuu28bXYy5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqegnA3zZS7SbFQ1cSl+/MN2Lt2oCh2z49NXPdEDNDmxtrXb1OY81eGFpivn3fE98J5/ZNhED8a3bR6V/03nZIQ5a++vwVZOR9N+x7jubSg1qBgjMfQvNOUqQgBmo5F6lGmETtzxFxlyKkA8drbqypN/0JCLTm4Orh635pZRO0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eIjJYEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eIjJYEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A49C2BBFC;
	Tue, 30 Apr 2024 11:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476419;
	bh=MdWnSpwCQQOZoKzhD9dNyhqJGksuaEWMzuu28bXYy5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eIjJYEoprQppRRQY8CUUiM4SGuDYjj4Tuv+zUx6LYr0iJVjO9MMMFP/hxWTVcuPO
	 veSzPMsldhWBp9ZIRdbeZImIHTpQbf1981I+owWjt6JI3sEtAjoFGNAQ+dmxzLW8Yw
	 W9mDpDw4l2Vsr4vw1REYAY1CogyrbT5I0ENDAD9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Simion <andrei.simion@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/110] ARM: dts: microchip: at91-sama7g5ek: Replace regulator-suspend-voltage with the valid property
Date: Tue, 30 Apr 2024 12:39:56 +0200
Message-ID: <20240430103048.371091715@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/at91-sama7g5ek.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama7g5ek.dts b/arch/arm/boot/dts/at91-sama7g5ek.dts
index 4af8a1c96ed63..bede6e88ae110 100644
--- a/arch/arm/boot/dts/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/at91-sama7g5ek.dts
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



