Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E11239BB1;
	Thu, 12 Dec 2024 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019095; cv=none; b=MKLZBa5rpIle+Bdpo5rvqBVAr8pU2ONqUsGai1ThHppFrOkfzy8sa63NxmqjmUOW3BjWSaCqfRjgpqqTvK/skBFqOdNt44Ww+DlUpcIUvpMmNRnrfC7IMwAbwKA2e3+qsOEbMTn8sHunfCU/2tsJpUxRnA/11KOhAiMFNIksUy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019095; c=relaxed/simple;
	bh=8p30x3/JAWAmQMtBQmnMKY6NZQt7RyKSmr7XOfPP+O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WN/TX/jbSfsfMric/hLHtFq22WijaEqMM2t2zOCC+10zrV+82iWFtv44C1dzM9LKoRGE4WGI1RT5pEroFs4Z9WiaOudHS9nj9Ba5YMgnLMIDuQUMTX7q3hUQiswchex3hM+aoleMUYJNqoedoR7f3Ltsxzlu/f1AYiNvgnee5fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8A9ZUhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8A9ZUhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2311CC4CED4;
	Thu, 12 Dec 2024 15:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019095;
	bh=8p30x3/JAWAmQMtBQmnMKY6NZQt7RyKSmr7XOfPP+O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8A9ZUhRhxcsFgGiMQkd7N4b4XvrAaW5U9ngc5wigNFFXGAecoafVg6U3gjVre0IZ
	 i4i+JEuRy8LEuNVuxzoYI2slsEEFFGLV28rj+xga+5M0gzFDdGkKifvpzotsz+7lgL
	 dflSY2bBYzYhG3oHL8WePH4ogNyYkT0uVvxGG51M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/772] arm64: dts: mt8183: jacuzzi: Move panel under aux-bus
Date: Thu, 12 Dec 2024 15:51:01 +0100
Message-ID: <20241212144354.715356482@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index d7fc924a9d0e3..32f6899f885ef 100644
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



