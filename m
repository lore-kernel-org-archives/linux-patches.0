Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CFE23BF9B;
	Mon, 23 Mar 2026 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277273; cv=none; b=I3aplwHLDdZioBJczYlKlUW/Z2CaytPSCkjMIsDOaiXgNVFgW+5Pu71QV5iDJPMGx/xAQDLUF+onFnUb5AlZXPbO2LI5p4JBaA4ueXL3cM0uCfGGpj61/6vQUsxFPfH5Wq+PSOIjY4D52UCblcS8gkN1Xsgx/DLHky3XW3vJkX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277273; c=relaxed/simple;
	bh=DnJCSjL/uSIWNJ1gQSj6T2w4EE9HaDnqvMW/iOLzJxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUutGBPzlNVQDltUO6v80seZPYUowIBh1eKXKx4QHQ/DHmgu8uUXNw8a9l7ml2GA2XFWAH0zNiXlKspjnvgPqt1Ltm13arI4e4eYAoFDrwoybHJNkPOrZ/bWYJwOMKjNSWQgwCWCf4DkeFO3K3RdvLQxf4Jw9Ov6wkhw792kNh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0xbGR8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0xbGR8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B56FC4CEF7;
	Mon, 23 Mar 2026 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277273;
	bh=DnJCSjL/uSIWNJ1gQSj6T2w4EE9HaDnqvMW/iOLzJxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0xbGR8xQa8+c6VuuOhPCKZn2P7x+FsJ3kEaU02JMKXg26boGUDJjOt2jNHW1fCPn
	 XfpQoPOdx1r/OztR2BTVucnDTzK9GFFFJCz1s9/gH1HCFTxieZ0471be10LwCVQdC6
	 oP6GZR/GXaTeNT1jHaDG+01nsBAdB8bkAd0evhG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 377/460] arm64: dts: renesas: r9a09g057: Remove wdt{0,2,3} nodes
Date: Mon, 23 Mar 2026 14:46:13 +0100
Message-ID: <20260323134535.829739855@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit a3f34651de4287138c0da19ba321ad72622b4af3 ]

The HW user manual for the Renesas RZ/V2H(P) SoC (a.k.a r9a09g057)
states that only WDT1 is supposed to be accessed by the CA55 cores.
WDT0 is supposed to be used by the CM33 core, WDT2 is supposed
to be used by the CR8 core 0, and WDT3 is supposed to be used
by the CR8 core 1.

Remove wdt{0,2,3} from the SoC specific device tree to make it
compliant with the specification from the HW manual.

This change is harmless as there are currently no users of the
wdt{0,2,3} device tree nodes, only the wdt1 node is actually used.

Fixes: 095105496e7d ("arm64: dts: renesas: r9a09g057: Add WDT0-WDT3 nodes")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260203124247.7320-3-fabrizio.castro.jz@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g057.dtsi | 30 ----------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
index 4676ee7561395..5c7b9e296f439 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
@@ -201,16 +201,6 @@ ostm7: timer@12c03000 {
 			status = "disabled";
 		};
 
-		wdt0: watchdog@11c00400 {
-			compatible = "renesas,r9a09g057-wdt";
-			reg = <0 0x11c00400 0 0x400>;
-			clocks = <&cpg CPG_MOD 0x4b>, <&cpg CPG_MOD 0x4c>;
-			clock-names = "pclk", "oscclk";
-			resets = <&cpg 0x75>;
-			power-domains = <&cpg>;
-			status = "disabled";
-		};
-
 		wdt1: watchdog@14400000 {
 			compatible = "renesas,r9a09g057-wdt";
 			reg = <0 0x14400000 0 0x400>;
@@ -221,26 +211,6 @@ wdt1: watchdog@14400000 {
 			status = "disabled";
 		};
 
-		wdt2: watchdog@13000000 {
-			compatible = "renesas,r9a09g057-wdt";
-			reg = <0 0x13000000 0 0x400>;
-			clocks = <&cpg CPG_MOD 0x4f>, <&cpg CPG_MOD 0x50>;
-			clock-names = "pclk", "oscclk";
-			resets = <&cpg 0x77>;
-			power-domains = <&cpg>;
-			status = "disabled";
-		};
-
-		wdt3: watchdog@13000400 {
-			compatible = "renesas,r9a09g057-wdt";
-			reg = <0 0x13000400 0 0x400>;
-			clocks = <&cpg CPG_MOD 0x51>, <&cpg CPG_MOD 0x52>;
-			clock-names = "pclk", "oscclk";
-			resets = <&cpg 0x78>;
-			power-domains = <&cpg>;
-			status = "disabled";
-		};
-
 		rtc: rtc@11c00800 {
 			compatible = "renesas,r9a09g057-rtca3", "renesas,rz-rtca3";
 			reg = <0 0x11c00800 0 0x400>;
-- 
2.51.0



