Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19BB24677F;
	Thu, 28 May 2026 20:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998446; cv=none; b=HB0AP0QgihfUJaApgmtuo6EsVG0Fh52yc7CvbP+zxYfKQ7qZs8Q/Xz7f78vZ73v052v0rTmCZ5VO8YF8y9mvO7l7QPEsENz2nMH0roQtB7iYWJjOALpTQbpya++n+zJd9WA1ei0AHFy0kBeRaB5eC2YcGEDTTEsncQREJ+T8fws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998446; c=relaxed/simple;
	bh=16uMLhtzrbTspXWtbnX8fnfeJAt1pHknw5IlWE5UZRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PYHRvfXXAlBS4cloy//6fkIpNWTsdHA82otnEcCoQJ+9aHpd6frqtbut9uLI5IF6uMcA5slBONhLpcLjNxUJG18zbjct4ja+O3Yh69PEv4NXhDch3nkz92AjpAFXFLPAa2BoJwUXGcVvTlHI45M+63XwoILuDe9KkxzP8f07sYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhNFQjhM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhNFQjhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE8B1F000E9;
	Thu, 28 May 2026 20:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998445;
	bh=xXgU5yBj5eV4D1zwtN5d6JBHYAeLmC21O/xM617i/kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhNFQjhMAZLAXMmm+1+xkd7tv5mVv29QR3Dtjaapib1WGGOPHw4QrIrZXZM0dbOid
	 4kie3o/ZwKWPZLA+nnSNW2BAVwzDJziQyy7kkItPyBYnxiiBbJQLME+6O69H2dxHui
	 KNTormFL9+9ODneiourKEkk+JdnwqRxgLqf0Psd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 176/461] arm64: dts: renesas: r8a78000: Fix SCIF brg_int clocks
Date: Thu, 28 May 2026 21:45:05 +0200
Message-ID: <20260528194652.166091164@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 86637727c11a105499e9faa38f3422dfcf4d211d ]

According to the documentation, the internal clock input for the BRG is
SGASYNCD4_PERW_BUSφ.

Fixes: c13a643e2c491f5b ("arm64: dts: renesas: Add R8A78000 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/459d360a8332f92b3766b30814e7e1c76169aaf7.1767719254.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a78000.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a78000.dtsi b/arch/arm64/boot/dts/renesas/r8a78000.dtsi
index 3e1c98903cea0..3ec1b53d27828 100644
--- a/arch/arm64/boot/dts/renesas/r8a78000.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a78000.dtsi
@@ -699,7 +699,7 @@ scif0: serial@c0700000 {
 				     "renesas,rcar-gen5-scif", "renesas,scif";
 			reg = <0 0xc0700000 0 0x40>;
 			interrupts = <GIC_ESPI 10 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&dummy_clk_sgasyncd16>, <&dummy_clk_sgasyncd16>, <&scif_clk>;
+			clocks = <&dummy_clk_sgasyncd16>, <&dummy_clk_sgasyncd4>, <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			status = "disabled";
 		};
@@ -709,7 +709,7 @@ scif1: serial@c0704000 {
 				     "renesas,rcar-gen5-scif", "renesas,scif";
 			reg = <0 0xc0704000 0 0x40>;
 			interrupts = <GIC_ESPI 11 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&dummy_clk_sgasyncd16>, <&dummy_clk_sgasyncd16>, <&scif_clk>;
+			clocks = <&dummy_clk_sgasyncd16>, <&dummy_clk_sgasyncd4>, <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			status = "disabled";
 		};
@@ -719,7 +719,7 @@ scif3: serial@c0708000 {
 				     "renesas,rcar-gen5-scif", "renesas,scif";
 			reg = <0 0xc0708000 0 0x40>;
 			interrupts = <GIC_ESPI 12 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&dummy_clk_sgasyncd16>, <&dummy_clk_sgasyncd16>, <&scif_clk>;
+			clocks = <&dummy_clk_sgasyncd16>, <&dummy_clk_sgasyncd4>, <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			status = "disabled";
 		};
@@ -729,7 +729,7 @@ scif4: serial@c070c000 {
 				     "renesas,rcar-gen5-scif", "renesas,scif";
 			reg = <0 0xc070c000 0 0x40>;
 			interrupts = <GIC_ESPI 13 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&dummy_clk_sgasyncd16>, <&dummy_clk_sgasyncd16>, <&scif_clk>;
+			clocks = <&dummy_clk_sgasyncd16>, <&dummy_clk_sgasyncd4>, <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			status = "disabled";
 		};
-- 
2.53.0



