Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBD2BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8508CC433EF;
	Tue,  7 Mar 2023 17:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209066;
	bh=uqI6aRolVZjlzdegOLfEgpqZ5KEAX980zGV5Qb490Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1+MksFEwI4Hx4wLQo/hwI8c5tYUUkDIf/IGGZ3oBIkOlhPQNXX/kbpR8JjSv5zkO
	 7RPg+3V0YAiXtymdS1iE4aFvlNWvmYER5l1DO8254Gc+HroFE0uYzAwj8LVrw8wjir
	 CoryVf9iF9eaJnZVyDq8REraBSDL56E3v55YSXwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0100/1001] arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node
Date: Tue,  7 Mar 2023 17:47:52 +0100
Message-Id: <20230307170026.504864865@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 22925af785fa3470efdf566339616d801119d348 ]

Specify #pwm-cells on pwm@11006000 to make it actually usable.

Fixes: ae457b7679c4 ("arm64: dts: mt7622: add SoC and peripheral related device nodes")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221128112028.58021-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 146e18b5b1f46..7bb316922a3a9 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -435,6 +435,7 @@ uart3: serial@11005000 {
 	pwm: pwm@11006000 {
 		compatible = "mediatek,mt7622-pwm";
 		reg = <0 0x11006000 0 0x1000>;
+		#pwm-cells = <2>;
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_LOW>;
 		clocks = <&topckgen CLK_TOP_PWM_SEL>,
 			 <&pericfg CLK_PERI_PWM_PD>,
-- 
2.39.2



