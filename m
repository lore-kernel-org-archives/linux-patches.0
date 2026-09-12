Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4C3331EAE;
	Sat, 12 Sep 2026 16:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230986; cv=none; b=GPbLcIa+IKq6CnxBBCyZJNdlhBbTm6cfu8vo4J45hdivop4fpEUeZFUgg5pcJGjrGMU7mcwg5pxKk3i9mflReoraCrYzMRPT/B6ovOObPJk+MKHTBGXSNE9xyxZQC55X0qSzT20V3jdDLXyH8VNz3ap5frOkWcDdK0c3oXzyK0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230986; c=relaxed/simple;
	bh=Ogv5U3M8yF5LWgWQIrOvOYncywWXqbRNFKVP/lIGg6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+i/youl4R90iCypkPoU36PP3x0f5jDlF4DBH7KrdAsuQpajugtJ71j/AEky1RNMPG4uMTIRSH2UJapX/gWWXn23AYqCZdgXNRaATy+XovjdyRi6B2BpOjXq503gvlAzxt0dNNmTtrchCrS9dgup53OJFYq3HJJhO1I8aKOPyIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUXob3qJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUXob3qJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E678A1F000FF;
	Sat, 12 Sep 2026 16:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230984;
	bh=uv9CQ0aU3j4+IFcnMEq23FjQBFD13+GGhvo8pU4Jklo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qUXob3qJZUv6z+c1siCMnTTP6FRc3MevNoqCqJWQW2CBm+AaQcmzwzseBkrF3nxTR
	 m+Q8RjBYAbBX1qB6J9A5jBFwWxSfxKmLdx75QI3Z5udpS8xQbQOwxZTMZl5DIbEKUU
	 yMqUbofPF9LE02c9vIjV+nbtamSnwWIwH8XRjmzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0905/1191] arm64: dts: ti: k3-am64: Fix MDIO clock reference for ICSSG0 node
Date: Sat, 12 Sep 2026 09:00:33 +0200
Message-ID: <20260912065608.560870559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d6aa23681bbe5..e385fed83dc8a 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -1133,7 +1133,7 @@ tx_pru0_1: txpru@c000 {
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



