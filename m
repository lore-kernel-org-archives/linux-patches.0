Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C4C5684;
	Thu, 13 Feb 2025 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459548; cv=none; b=WdvlDMzVCn7plOGCg0Dt3WoE7wFr0mcOVdu7SCUvhhvNGnGvBklh+uh2a73SuFjoRYnnB46GAoFVf6Kqu4850KDY9V38+clEtxkkZb70QIAGOTUYDoz8UFHV6G/cs/26DQmw3p74rCSgAUlEGbzxPIZlYwTHJMWVrLarD9DxwtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459548; c=relaxed/simple;
	bh=QCWqU9cOwU8nlP5Th0tNNPZL5HhfYP2wuh6SzuJ9PYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avZ8YOVudeEGrb0QmWwr4rxBf7uN0NGTGfIdfxNWCxBbewdZQovC1nyPhM0kNK0uBr0BejIh/c9S+PX1QFIAMM2ChARgS1IHnboZe3kiyAD1tjozL1AKjw7xiAXlYNJr6SI+O1IG8PH1xEKXhOXExZxnOK8mhl1k7axI3FNBHGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCb50M4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCb50M4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01446C4CED1;
	Thu, 13 Feb 2025 15:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459548;
	bh=QCWqU9cOwU8nlP5Th0tNNPZL5HhfYP2wuh6SzuJ9PYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCb50M4B7jPhMaFpLL5vmKKrVcrB09eTeVGJuLIt6OCsl7+Vx2pC9BpvncZW7Th9t
	 MK00g+GMOIu8TZsqs0FeP9mFpxpNsjxJv9p1t9nqkPaLnCBKkWgPFywz7hcJbUlRqi
	 34/F3oF3HHvxaKCbWW6w6F9GC7gzT9/FOLtqJWtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.13 297/443] arm64: dts: mediatek: mt8183: Disable DSI display output by default
Date: Thu, 13 Feb 2025 15:27:42 +0100
Message-ID: <20250213142452.076690413@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

commit 26f6e91fa29a58fdc76b47f94f8f6027944a490c upstream.

Most SoC dtsi files have the display output interfaces disabled by
default, and only enabled on boards that utilize them. The MT8183
has it backwards: the display outputs are left enabled by default,
and only disabled at the board level.

Reverse the situation for the DSI output so that it follows the
normal scheme. For ease of backporting the DPI output is handled
in a separate patch.

Fixes: 88ec840270e6 ("arm64: dts: mt8183: Add dsi node")
Fixes: 19b6403f1e2a ("arm64: dts: mt8183: add mt8183 pumpkin board")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20241025075630.3917458-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts |    4 ----
 arch/arm64/boot/dts/mediatek/mt8183.dtsi        |    1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts
@@ -522,10 +522,6 @@
 	status = "okay";
 };
 
-&dsi0 {
-	status = "disabled";
-};
-
 &dpi0 {
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&dpi_func_pins>;
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1835,6 +1835,7 @@
 			resets = <&mmsys MT8183_MMSYS_SW0_RST_B_DISP_DSI0>;
 			phys = <&mipi_tx0>;
 			phy-names = "dphy";
+			status = "disabled";
 		};
 
 		dpi0: dpi@14015000 {


