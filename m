Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9D82A1BA;
	Tue,  8 Jul 2025 16:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992091; cv=none; b=i66EdAWX5xEsETS47LeSY2I/m6Ky1+J5rkUHxtaHSlhBS9fbFajjInMueJJXu8CIAnnlI/q0cbpP1aVVC91hFHCJDPiN7TLlxpQz0xIDhdWL9YMqBmbFZqPDaMUa+RWEtwkn6QrYN1bPo0aTPPe5hXZx7F75v0yUKcHxywnI85g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992091; c=relaxed/simple;
	bh=WTrU1XVa5QocD4df7Ty2+N0nV1nCksfDKzTDeJmXxow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZESubg2xLQYAifOzb/6IR4z2TsVLH1fjai+IrZaWdx3MFo08mqUWMEaYUHWPIoSZB5Qmd0mDUvS1dSPr75zgZKRugLdb2DdF9yqaczzNa71jWjuXJVvmUo2X6bwtyIUp2SUtShkcMuTpyLD3GzxFgnnYJgv/MaIZmUJvTvSTDMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTtFaIGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTtFaIGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB843C4CEED;
	Tue,  8 Jul 2025 16:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992091;
	bh=WTrU1XVa5QocD4df7Ty2+N0nV1nCksfDKzTDeJmXxow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTtFaIGocsPt8vcS5meDPiHbXfXqmeH0sP7H1PWQPuJPtrwSkli/KBNgbSweuzZrV
	 wqUYxKTIuMb8p4kYLVzbcBqcvRp44Do/by578Qf9lum32Iq1Uw9fAAOZzmgAiEKhLV
	 jl3Pi9TUogrWTSMn4chm23tyBbfD95k2i+36MWJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/81] arm64: dts: apple: t8103: Fix PCIe BCM4377 nodename
Date: Tue,  8 Jul 2025 18:23:07 +0200
Message-ID: <20250708162225.371283442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3d15b8e2a6c1e..6d78f623e6df5 100644
--- a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
+++ b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
@@ -70,7 +70,7 @@ hpm1: usb-pd@3f {
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



