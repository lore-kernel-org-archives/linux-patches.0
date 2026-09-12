Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEB74BEE32;
	Sat, 12 Sep 2026 12:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217425; cv=none; b=ChddrGh6WQ3kHfrCLJcem5TUoUwmMu2GqFItjtltuXlfS2g5KmSE43vfwgy4RPDQJTfP8ln5A9XYcL8C0/R5UDhKj9i2AIMFpjnxjYHrgabgWzbBouky8WgDLaIyw5rsCrgH6DB6wdP2Sc7+nCENPlhmSoXgIitj0xoJRwgk33s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217425; c=relaxed/simple;
	bh=xeqwE5mc5jNI960OwW4yf7pRGn37EfoY7cY/ZYZL5nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOrAIiGtVmg0ES9+Ta02TNkAeMsdXT7i+UApv8uIiikyrU2vL7bFsUA3/VSCp9vXLvyW8uIvaVtWSLohz8KJ3jgKmWBsejOa1hx0+s9TcWP/HnfGlcuyU3+anfKEnXBj+8LNvzmhuJdGflxIFAwXHkoGhPdKs1cz/04hX0MUN2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhKfZBzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhKfZBzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75A91F000FF;
	Sat, 12 Sep 2026 12:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217423;
	bh=PMmOoic9Rr6fPchmdf3CZ6lxHWjBgWBhIR1bBQDK8aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhKfZBzcVT8mf1BRf82KVUxV0Tu8tVS7mWVi1VabGBqk47lVdqbppDPBfliMhy4n+
	 Af1Hw9JKBCMru+7TJ5wgF6wenPXJKC5rGL8GN8OR31pG9YVaTyJ5DJmtV7EaiRLVQb
	 QQ+gCCD8s7PFn82CUMaJ02nqlnKeOcHDDhFaOIoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0939/1376] arm64: dts: ti: k3-am64: Fix MDIO clock reference for ICSSG0 node
Date: Sat, 12 Sep 2026 08:56:05 +0200
Message-ID: <20260912065628.488627665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7eae18399caa6..7c6ba86cf8eed 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -1349,7 +1349,7 @@ tx_pru0_1: txpru@c000 {
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



