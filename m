Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9081DE887;
	Wed, 19 Feb 2025 09:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956435; cv=none; b=WH9yYR9z3gq7npCN8fj5tg2fqtk34QRpP3PQV5PISoM87OUNwhin6quQdYNvoC89xDoeWo9AOtHwwEbwOBTWLD9sMR71fCpI1fCfF1b+A0FPpWeAoV1P3GXmlZJjtPKERhaTpRwjp1GClgZIf5hxifkauN3OMw6+t/Fa+sdH62c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956435; c=relaxed/simple;
	bh=KWrkwjXMTQpIftUOPNs6sFQRH3rqw1Vc2XxgpZdxdUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZShQSsz0kDQaLTSVY33wHEA0GWMk7az+2wiW5Eu95TycJeVHCdiqjRO7whhdJ2PqLOK94x1m1LVNluvMCqF+/vVwkDYUgOgAZGDXmk2pz9l+S4r9abYTBLCsxkMiGeMdrwREGWYv+NCkuL7DgE7jQm/lGpFMt6cEO3b3t2hYBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNAHlZ5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNAHlZ5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861BBC4CED1;
	Wed, 19 Feb 2025 09:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956434;
	bh=KWrkwjXMTQpIftUOPNs6sFQRH3rqw1Vc2XxgpZdxdUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNAHlZ5GOuaZ9IO7mPhsN8Uc3GWYT5tWHzmj0X4X9sePgTSxIqfjDIePT/d4w/TKc
	 UK8egS/O5pkp4j8T27jl3CdDswQvnuEKD0WLIgK/ey3FDvq7SfswKNpMrAWrLZ73vc
	 hGGFMli/6DBvT+wszlF9+hYcwdoEs01xTNwutRrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/578] arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names
Date: Wed, 19 Feb 2025 09:22:30 +0100
Message-ID: <20250219082658.723297526@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit beb06b727194f68b0a4b5183e50c88265ce185af ]

The MT6397 PMIC bindings specify exact names for its sub-nodes. The
names used in the current dts don't match, causing a validation error.

Fix up the names. Also drop the label for the regulators node, since
any reference should be against the individual regulator sub-nodes.

Fixes: 689b937bedde ("arm64: dts: mediatek: add mt8173 elm and hana board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241210092614.3951748-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
index 6e82aea16c729..1135ed0bf90c4 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
@@ -922,7 +922,7 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		clock: mt6397clock {
+		clock: clocks {
 			compatible = "mediatek,mt6397-clk";
 			#clock-cells = <1>;
 		};
@@ -934,7 +934,7 @@
 			#gpio-cells = <2>;
 		};
 
-		regulator: mt6397regulator {
+		regulators {
 			compatible = "mediatek,mt6397-regulator";
 
 			mt6397_vpca15_reg: buck_vpca15 {
@@ -1100,7 +1100,7 @@
 			};
 		};
 
-		rtc: mt6397rtc {
+		rtc: rtc {
 			compatible = "mediatek,mt6397-rtc";
 		};
 
-- 
2.39.5



