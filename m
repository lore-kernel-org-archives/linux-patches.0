Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C088F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C0DC433EF;
	Mon, 13 Feb 2023 14:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300114;
	bh=IveKXnijaLdf7GlElWquv5ObVO2jo7+fskoyomlBDi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfofPeF3fQQERm17ZP1LOIRIN+uY6oyuxmqb12PfAimmbWZ15JNlhEXFX9NuzNcnd
	 bQeZAMaoI1UoOQhsJX2dZ6wLVZTCZ2KwDqQkmJrek/cHC1qIdUw+R67KI0Byx7H98X
	 OUAXC8E1E7g//VbZ7ELW9mpXrTedHekdlxNlL7VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/114] arm64: dts: mediatek: mt8195: Fix vdosys* compatible strings
Date: Mon, 13 Feb 2023 15:48:20 +0100
Message-Id: <20230213144745.601170270@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 97801cfcf9565247bcc53b67ea47fa87b1704375 ]

When vdosys1 was initially added, it was incorrectly assumed to be
compatible with vdosys0, and thus both had the same mt8195-mmsys
compatible attached.

This has since been corrected in commit b237efd47df7 ("dt-bindings:
arm: mediatek: mmsys: change compatible for MT8195") and commit
82219cfbef18 ("dt-bindings: arm: mediatek: mmsys: add vdosys1 compatible
for MT8195"). The device tree needs to be fixed as well, otherwise
the vdosys1 block fails to work, and causes its dependent power domain
controller to not work either.

Change the compatible string of vdosys1 to "mediatek,mt8195-vdosys1".
While at it, also add the new "mediatek,mt8195-vdosys0" compatible to
vdosys0.

Fixes: 6aa5b46d1755 ("arm64: dts: mt8195: Add vdosys and vppsys clock nodes")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Acked-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20230202104014.2931517-1-wenst@chromium.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 0b85b5874a4f9..6f5fa7ca49013 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1966,7 +1966,7 @@
 		};
 
 		vdosys0: syscon@1c01a000 {
-			compatible = "mediatek,mt8195-mmsys", "syscon";
+			compatible = "mediatek,mt8195-vdosys0", "mediatek,mt8195-mmsys", "syscon";
 			reg = <0 0x1c01a000 0 0x1000>;
 			mboxes = <&gce0 0 CMDQ_THR_PRIO_4>;
 			#clock-cells = <1>;
@@ -2101,7 +2101,7 @@
 		};
 
 		vdosys1: syscon@1c100000 {
-			compatible = "mediatek,mt8195-mmsys", "syscon";
+			compatible = "mediatek,mt8195-vdosys1", "syscon";
 			reg = <0 0x1c100000 0 0x1000>;
 			#clock-cells = <1>;
 		};
-- 
2.39.0



