Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1A2221DB0;
	Wed,  5 Feb 2025 14:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766523; cv=none; b=iDyXdKE8W6dogUjEmX4uamNbj9JDqJGDcD3qu3NCk4Ay3+G7ulfkuZ6pHgDf+EQ7AUfit67qAnVuflP/TE84DTlfZuSOLAvuzZOlFUtZSl05c9aJUEcyBY1baQazUqrQmrJ/Vrt+TxN1SaYkSjExd/VYv6FheYsQyiSYYCalH4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766523; c=relaxed/simple;
	bh=dJTtqG8vCO4XcYieVUctABwVZAEzSfifWzeyT8s7DvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvAI5QWOm0TRfqKZ/oiw4/rLbuPCKPv2NV3AA55BCOV2JZa9mLWRmPamCNTbN01uKeVbzE7MfKa4QkHygD+8inaP8y8OKYbPIAdvnU7Z9sAM7tv6nx/jN2DhuA90jluCe83CoZ3+4MTr535l4T+4PCZd//O03qmP0Z50NrFoGeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Po7eLFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Po7eLFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE78C4CED6;
	Wed,  5 Feb 2025 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766523;
	bh=dJTtqG8vCO4XcYieVUctABwVZAEzSfifWzeyT8s7DvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Po7eLFUWW+Z0kpkGXtxoNib0/SkRVvhZc1gYgq7kO3zSglzJ1LCQsLr8DNLyofBZ
	 OuYlgVqcHL76/jQgz5uvXPX5TfS35Tokyug3QDqA8RmLzaSkStqaqtCFKi/myXrKvH
	 XOg7D9SvvFeWfe7ryDiz1fZiRS2sgCaZurB5VFis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/590] arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names
Date: Wed,  5 Feb 2025 14:41:17 +0100
Message-ID: <20250205134507.593365180@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dfa2e9ec6b33f..309e2d104fdc9 100644
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



