Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D0E190052;
	Wed,  5 Feb 2025 14:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767069; cv=none; b=kx64bIzZGKblSOqO2NrvftQ0qo9aZF+RnEF5b41E2aMTsM1MRk3i8G40GIDVaF0n7kTCRhmPvyjHm01zqmLWtXH53Vqnk1y/g2Q6az7XW6szkuZtj2a9B5ZTOBZhQZPQk9nmHFVbAmVQy5/tqA9dV3QrUlrsul5FWxXSvN63ewc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767069; c=relaxed/simple;
	bh=xIoOOUzQmQLriB7KHMNpzUqYlKjqpPZF5i4Q5J+s0qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIE3lQ5l2D2AFVzZ3dFYAst/AkzpaWzXpvu0U1UhPEhVFRlqsymY1f9kF1lJq2Brd+h034Ce9sZoKWs2hElQUEIbo/lB1qWDPE3W9UNs2GBfFrY4vmcHQUlN/kryaq1xv0sCI42XRoLEj92X6ykNWVFz3vgOjxcU49jzeK4tCog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwam1esI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwam1esI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06E6C4CED1;
	Wed,  5 Feb 2025 14:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767069;
	bh=xIoOOUzQmQLriB7KHMNpzUqYlKjqpPZF5i4Q5J+s0qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xwam1esIA8sP/TpuU/bzoErHoN+alq2HjKSgJH72bxSWYNpYXp+hgvrJQ4dvMAH3F
	 0OAdnlzgdLOl0mgOHzt1If2RyODjpkhbDMqawgyOn8yrk34PaFr5jZLz4PFc7bL/X0
	 U1VSLSBgoQn3sWH/K80nM+1RwTuDl98iQzFidm28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 352/623] arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names
Date: Wed,  5 Feb 2025 14:41:34 +0100
Message-ID: <20250205134509.691614316@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index b91072f4723f3..b5d4b5baf4785 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
@@ -931,7 +931,7 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		clock: mt6397clock {
+		clock: clocks {
 			compatible = "mediatek,mt6397-clk";
 			#clock-cells = <1>;
 		};
@@ -942,7 +942,7 @@
 			#gpio-cells = <2>;
 		};
 
-		regulator: mt6397regulator {
+		regulators {
 			compatible = "mediatek,mt6397-regulator";
 
 			mt6397_vpca15_reg: buck_vpca15 {
@@ -1108,7 +1108,7 @@
 			};
 		};
 
-		rtc: mt6397rtc {
+		rtc: rtc {
 			compatible = "mediatek,mt6397-rtc";
 		};
 	};
-- 
2.39.5



