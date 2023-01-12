Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019EA746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7135AC433EF;
	Thu, 12 Jan 2023 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532012;
	bh=JPvQJx1L/9SNsj60LdR+FuYW0lIKhDtE50esaUICdV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXVfHpcWeU8MGR1ntv6yrxploUOtySDyzSWQWzubOAU9dx/aGC0lccigsamHyf4nl
	 BLSOsECJyVY3NYZC6KJx80oJVj0IfJE1oHX+16Z9h3PsNSnH9uamb+JK0oHRDqpzoY
	 aDZqRAvsQJPZ0NpDZXlUbP3ES5IeogljF/QuqYow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/783] arm64: dts: mt2712e: Fix unit address for pinctrl node
Date: Thu, 12 Jan 2023 14:45:40 +0100
Message-Id: <20230112135525.284102859@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 1d4516f53a611b362db7ba7a8889923d469f57e1 ]

The unit address for the pinctrl node is (0x)1000b000 and not
(0x)10005000, which is the syscfg_pctl_a address instead.

This fixes the following warning:
arch/arm64/boot/dts/mediatek/mt2712e.dtsi:264.40-267.4: Warning
(unique_unit_address): /syscfg_pctl_a@10005000: duplicate
unit-address (also used in node /pinctrl@10005000)

Fixes: f0c64340b748 ("arm64: dts: mt2712: add pintcrl device node.")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-5-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
index e0b26cd67eb3..cc3d1c99517d 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
@@ -266,7 +266,7 @@ syscfg_pctl_a: syscfg_pctl_a@10005000 {
 		reg = <0 0x10005000 0 0x1000>;
 	};
 
-	pio: pinctrl@10005000 {
+	pio: pinctrl@1000b000 {
 		compatible = "mediatek,mt2712-pinctrl";
 		reg = <0 0x1000b000 0 0x1000>;
 		mediatek,pctl-regmap = <&syscfg_pctl_a>;
-- 
2.35.1



