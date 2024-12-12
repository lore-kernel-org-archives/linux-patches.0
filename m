Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F367722968C;
	Thu, 12 Dec 2024 16:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022040; cv=none; b=TivHy7UF1LHiUDhIkjLgAgVW1Wwo4cYpKx0N2vljUPTWTw7mgDuZm2VLwyRiHVz12bWzuAgSZgGktguYRaYzraEyspTSVEmmT3CZHOsgbEqc03Cd5eRWc/cVnZucyzgF1LG4BJZ52zDC1LnJS87804T24VygRW6j6bPueGrlwpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022040; c=relaxed/simple;
	bh=h/uSp3peHoLOdgQ+TLRwzqo2ZIRaRDcjf58GM0lTeUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJNcym2ziQ723jpMj4TJ/FqstUChtW3pt9QxlAgpUX7nSpkLd/cLfGKt0/EhhmVkd215pyAFrnz0LkuWdntCXhh+NTKb340lIFATzXnKEsO07bQ8iVvAk5Nnz+lU5el98D2nRiT+Bp/Z1tm7B+AXOMcyufu6+Zgj2ZssBDerk4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhilhbWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhilhbWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48609C4CECE;
	Thu, 12 Dec 2024 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022039;
	bh=h/uSp3peHoLOdgQ+TLRwzqo2ZIRaRDcjf58GM0lTeUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhilhbWDwlcqeDBWzisw1BhmaN4SKNpvs0DFWHng51cHeSaLzxV7RmDmFTwO7TLPN
	 MzHruITHzcBT2Y7FadP/rp5oLu9yNEi0tnNUctvy2kcpl8yqgIiWA994OWFTdnfVPZ
	 TQ22BIZkNb0k+EbL9dCDRub7n7+V7pxBJ7fkOOCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/565] arm64: dts: mt8183: jacuzzi: Move panel under aux-bus
Date: Thu, 12 Dec 2024 15:55:26 +0100
Message-ID: <20241212144316.660003699@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 474c162878ba3dbd620538d129f576f2bca7b9e1 ]

Read edp panel edid through aux bus, which is a more preferred way. Also
use a more generic compatible since each jacuzzi models use different
panels.

Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20221228113204.1551180-1-hsinyi@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Stable-dep-of: c4e8cf13f174 ("arm64: dts: mediatek: mt8183-kukui-jacuzzi: Fix DP bridge supply names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/mediatek/mt8183-kukui-jacuzzi.dtsi    | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
index b9b7ddbeaabb3..5c6721371945c 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
@@ -8,18 +8,6 @@
 #include <arm/cros-ec-keyboard.dtsi>
 
 / {
-	panel: panel {
-		compatible = "auo,b116xw03";
-		power-supply = <&pp3300_panel>;
-		backlight = <&backlight_lcd0>;
-
-		port {
-			panel_in: endpoint {
-				remote-endpoint = <&anx7625_out>;
-			};
-		};
-	};
-
 	pp1200_mipibrdg: pp1200-mipibrdg {
 		compatible = "regulator-fixed";
 		regulator-name = "pp1200_mipibrdg";
@@ -188,6 +176,20 @@ anx7625_out: endpoint {
 				};
 			};
 		};
+
+		aux-bus {
+			panel: panel {
+				compatible = "edp-panel";
+				power-supply = <&pp3300_panel>;
+				backlight = <&backlight_lcd0>;
+
+				port {
+					panel_in: endpoint {
+						remote-endpoint = <&anx7625_out>;
+					};
+				};
+			};
+		};
 	};
 };
 
-- 
2.43.0



