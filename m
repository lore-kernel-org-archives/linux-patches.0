Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CB6225414;
	Tue,  8 Jul 2025 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993387; cv=none; b=gidrpnTUNcG+4YPMe3t1frGU5oCrx1frqM5VOBQvbV/xv/1p5AQbJ1PpeUHYxWtfF/NHqSpa8zkXamgyH+kcbbmMerh/DtjGWxhV4gG7GUst781kwkgJ0N4/pNSzZCBaIddnSn8LdeF8CxFUgnxGpc0ZoHhVAG2ky4mvfGijNjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993387; c=relaxed/simple;
	bh=3vl+mVhsF1vxD8r9qdgJJtbwEJGFbf79Z0anBIVfI4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiQaLXxfHbDLDwcmUdCT74tMKZ/cbB56df4GzBpfC9GaACOPcC5qM9pOjn6gn7LkFZ2Ws5r7cmWlCy0hYb1bBEToZezlHsxYVgiIdjz2qsZTKk+muy5+YMwMidhHjtvTGO63z0Avgn7ZWOORKX17+EXvOKz4PhnavyO/fG9rqK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QDJV9/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QDJV9/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71464C4CEED;
	Tue,  8 Jul 2025 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993386;
	bh=3vl+mVhsF1vxD8r9qdgJJtbwEJGFbf79Z0anBIVfI4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QDJV9/Q6CfiMqnoXtGY6Sa/0+RqF/reWvezANSa7o9cOn7ceRB1EKqd1v1B/9TV4
	 /ZRKOnhL0PSlPvc24kORnc7W//yYT0xTcGl11q4ABnl7PebqqU7yTSj3Cc0VSV5SKZ
	 HmGkEsRo+39MztvBHgKGcdyPlyLpopFaF2dayv5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 039/178] arm64: dts: apple: t8103: Fix PCIe BCM4377 nodename
Date: Tue,  8 Jul 2025 18:21:16 +0200
Message-ID: <20250708162237.702201646@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

[ Upstream commit ac1daa91e9370e3b88ef7826a73d62a4d09e2717 ]

Fix the following `make dtbs_check` warnings for all t8103 based devices:

arch/arm64/boot/dts/apple/t8103-j274.dtb: network@0,0: $nodename:0: 'network@0,0' does not match '^wifi(@.*)?$'
        from schema $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
arch/arm64/boot/dts/apple/t8103-j274.dtb: network@0,0: Unevaluated properties are not allowed ('local-mac-address' was unexpected)
        from schema $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#

Fixes: bf2c05b619ff ("arm64: dts: apple: t8103: Expose PCI node for the WiFi MAC address")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Sven Peter <sven@kernel.org>
Link: https://lore.kernel.org/r/20250611-arm64_dts_apple_wifi-v1-1-fb959d8e1eb4@jannau.net
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
index 8e82231acab59..0c8206156bfef 100644
--- a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
+++ b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
@@ -71,7 +71,7 @@ hpm1: usb-pd@3f {
  */
 &port00 {
 	bus-range = <1 1>;
-	wifi0: network@0,0 {
+	wifi0: wifi@0,0 {
 		compatible = "pci14e4,4425";
 		reg = <0x10000 0x0 0x0 0x0 0x0>;
 		/* To be filled by the loader */
-- 
2.39.5



