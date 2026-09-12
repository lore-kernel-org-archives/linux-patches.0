Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A2A36EAB8;
	Sat, 12 Sep 2026 14:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225101; cv=none; b=bgStRB/mX7GeHoMGfKAhawSQi9QMnH5U1K/mrVXLy2TGvNJJkvP7AVyXzI+730OhkYPK2j3I20Z7UlilO4KoGrDKpMoak5vLeNZ/r7QwTszR1v0T8V48SYg/OSivkC5LPMjfFy3osDnOQ7JS0h6Dq8LVRtQ3lwxWSN1oA4Yjpx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225101; c=relaxed/simple;
	bh=Rcc79a0WFRVDZyfJdbBWdiqaHe4PDwexFIuJHaE9mTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF/rVXSu/lPYd+6Hc5QC5SkztHKEa3vZ+VrBvw6mW2+FYVTcq3O94SpnrWDB/3kJa+wZjmIIYXVGXLYLZUnFC2MiaVX2JIuu95+lQ4QXw8Sbhr/8sVmy4hkEEq/kWLpi78zQbmTJgY58t0/0zXZ5sl5YwE3paaR4uFkFL10e1Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxXLBti7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxXLBti7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF2A1F000FF;
	Sat, 12 Sep 2026 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225100;
	bh=ooBSxmBzeQtYomVPLu1XbG8q+JF6mgSaGpG3OYK1fyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxXLBti7ymd5pgT0CjIAOS6AltQp0VqdGPQbByWoxZrSFDn0O54yclivy8HQ5Da6u
	 yLVVT8xhKAEIt1hqP3rtJqXbJxvgQda61KdVp4CatblfDj+XTZf+xjSHflw+rdt1LK
	 ipfNmKaRATkx3fTs/3pmjQ47XHnerVQNyIhnvKg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1092/1424] arm64: dts: ti: k3-am64: Fix MDIO clock reference for ICSSG0 node
Date: Sat, 12 Sep 2026 08:58:44 +0200
Message-ID: <20260912065631.762354309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 197df050a10fe216971b45a79f07195c86a02236 ]

MDIO clock index changed from 62:3 to 81:0 to match proper clock
definition in the SoC device tree. Clock Id 81:0 belongs to ICSSG0
core clock, where as 62 belongs to EQEP2 device.

See: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am64x/clocks.html

Fixes: c9087e3898a1d0 ("arm64: dts: ti: k3-am64-main: Add ICSSG nodes")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Link: https://patch.msgid.link/20260706092229.82674-1-m-malladi@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
index 064eb062bb54a..67a7336053d9e 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -1316,7 +1316,7 @@ tx_pru0_1: txpru@c000 {
 		icssg0_mdio: mdio@32400 {
 			compatible = "ti,davinci_mdio";
 			reg = <0x32400 0x100>;
-			clocks = <&k3_clks 62 3>;
+			clocks = <&k3_clks 81 0>;
 			clock-names = "fck";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.53.0



