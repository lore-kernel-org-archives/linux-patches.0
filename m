Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017114;
	b=MtWdmfSpBKfqf1Uhdn33rUtKfgPty11INmrlt20HthpmmVZbXHWEmB5L0CE4Un2CdHpx
	 ke311HJZAsWOFw+fzIL4sZX+YMaM2HBfOwbTEqx2WI9Oy/NvFCINjo5YKZDgztH2iZqzQ
	 6KSC4Trx1Bb8m+06kpo4qBGhBuUjljj51QsPmTCogFtF1JjkBeygLPPZoFrYniK7mWGHC
	 wYURIYRpcqJQDWqAG0qS28mppGDzhnAmirB4gl8wLpvOwa1n8ZsrRdKJM7kPJ/Qnli8+X
	 dTxCY3fJElhSawA0zlhxncwcvZ96nnoSyz2w7fvIcXlFcmGBPS1rHDfnNRWxY/a4CAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4+iy4mkdZ8xKYr89wQptSUOI7/ZSreloOctM+SYnBs8=;
	b=hMfWTAOOa+QAJTfsIP7QPdb1K6Vv1Yjakjf42GVdoMftTFU4tsHtUmkoz9LVi5psEcS1
	 8MuPbpn6iEwNIIZHql8Wif81bxyFhxlVl5yXTmasZ2+bYFcfJGLWSKZjYRDANvz/iXiNz
	 WH7bt6U73snOEOw0YmbYz12HRmG1s6EqtpBs8LhmmVfW5owyDz4PYqTixKGTsPHb15OVB
	 R+LafnTgfZSJJjrCxdzVpdmkBzpG6oIvDS0Hpa6Su71Bx72k4Pq2S70Z/eF3AAmsqLFf/
	 Kn70EFxH6+lRCADiRxsvpsHWraGC00Mt1T+u37na7GmgyGIy0UZHnoCz3Trur6SwaTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXxTdHxh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BC8606A330;
	Wed, 18 Nov 2026 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXxTdHxh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E62F1F000CE;
	Wed, 18 Nov 2026 15:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017113;
	bh=4+iy4mkdZ8xKYr89wQptSUOI7/ZSreloOctM+SYnBs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXxTdHxhRI1EHdnsYbwIGGQHqtv6Zf2Lz4fPVZjz+HUxz7wQ9HPTzQLaI4bMhhiwF
	 H47ijARgt/N24AKuRSQwsUvppj9qfCdL9W5UepG/vfS/4KUeV0SVcxVD60IvCtgLxf
	 QE53kCn81GMdTONdpJ2rTiMSQgYgWnFkMYQh7wEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0768/2651] arm64: dts: renesas: r9a09g077: Drop unwired ADC interrupts
Date: Wed, 18 Nov 2026 15:33:28 +0100
Message-ID: <20261118150315.531768532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit b508d6fb28fe406c12e2070c53db79c57143d592 ]

Remove the compare match and compare mismatch interrupts from the ADC
device nodes, as these interrupts are not wired to the GIC according to
the hardware manual Rev.1.30.

Fixes: a82a42963c89 ("arm64: dts: renesas: r9a09g077: Add ADCs support")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260921110144.44425-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g077.dtsi | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g077.dtsi b/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
index bac39390ead74..67cd67cdcce96 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
@@ -1258,11 +1258,9 @@ adc0: adc@90014000 {
 				     <GIC_SPI 699 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 700 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 701 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 702 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 851 IRQ_TYPE_EDGE_RISING>,
-				     <GIC_SPI 852 IRQ_TYPE_EDGE_RISING>;
+				     <GIC_SPI 702 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "adi", "gbadi", "gcadi",
-					  "cmpai", "cmpbi", "wcmpm", "wcmpum";
+					  "cmpai", "cmpbi";
 			clocks = <&cpg CPG_CORE R9A09G077_CLK_PCLKL>,
 				 <&cpg CPG_MOD 206>;
 			clock-names = "adclk", "pclk";
@@ -1280,11 +1278,9 @@ adc1: adc@90014400 {
 				     <GIC_SPI 704 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 705 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 706 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 707 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 853 IRQ_TYPE_EDGE_RISING>,
-				     <GIC_SPI 854 IRQ_TYPE_EDGE_RISING>;
+				     <GIC_SPI 707 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "adi", "gbadi", "gcadi",
-					  "cmpai", "cmpbi", "wcmpm", "wcmpum";
+					  "cmpai", "cmpbi";
 			clocks = <&cpg CPG_CORE R9A09G077_CLK_PCLKL>,
 				 <&cpg CPG_MOD 207>;
 			clock-names = "adclk", "pclk";
@@ -1302,11 +1298,9 @@ adc2: adc@80008000 {
 				     <GIC_SPI 709 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 710 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 711 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 712 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 855 IRQ_TYPE_EDGE_RISING>,
-				     <GIC_SPI 856 IRQ_TYPE_EDGE_RISING>;
+				     <GIC_SPI 712 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "adi", "gbadi", "gcadi",
-					  "cmpai", "cmpbi", "wcmpm", "wcmpum";
+					  "cmpai", "cmpbi";
 			clocks = <&cpg CPG_CORE R9A09G077_CLK_PCLKL>,
 				 <&cpg CPG_MOD 225>;
 			clock-names = "adclk", "pclk";
-- 
2.53.0



