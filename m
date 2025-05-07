Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690202153C6;
	Wed,  7 May 2025 18:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644254; cv=none; b=sC3zgRn/mFxtHUdr80fw8dA2irzeX3csvt88VIiZ1nVEI+1Zl20iBI78GDk9piiCJ2e/YEq4Y3wBmonl2Ll0elENI1cWHeOkFnme4afTIWqoYNOrHyntNlQyF7bTfKwGllqUMRwFuOOsx2Ra5Oon/of/Q90eq+4H3b/9TEvQxg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644254; c=relaxed/simple;
	bh=qV/AXo/JyJCYb7mwrNnpj+FVpDqsgYbNJq13/T7FYUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahWCGMiqt9MJmShIomRFCpx99etF5xln8NXwbVRu+qk+h6O7/jZWfqpmeH7bhnbMt49xrig7xZrNRQXhtxUuZX8E6LMjF2cJ+vieXo8XsrtNDTW00TDK/O2uSmghrCAk8X6+7ICvtnwBTTSx9hYzlHFjfjf1dVf9Kn6q6WrBQ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIQKEQ+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIQKEQ+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D20C4CEE2;
	Wed,  7 May 2025 18:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644254;
	bh=qV/AXo/JyJCYb7mwrNnpj+FVpDqsgYbNJq13/T7FYUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIQKEQ+A5PQRF3vopjH9EG43cSKc0Xv1N+Ngu3A3037yLBdWXwJ0dQx8B2LVAOPwG
	 g9iZK7pOMvOstElADCUwaBzKlUOWFLcl0wsVyvKBRUBKhmRgtst8bqAun+Rcdk3GX7
	 u0u/ggbSez8nmRw4pbX6THSbKbQUwthrtqX4FkUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 168/183] arm64: dts: imx95: Correct the range of PCIe app-reg region
Date: Wed,  7 May 2025 20:40:13 +0200
Message-ID: <20250507183831.668534010@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 02e4232998db357bb8199778722d81ffcff0cb98 ]

Correct the range of PCIe app-reg region from 0x2000 to 0x4000 refer to
SerDes_SS memory map of i.MX95 Rerference Manual.

Fixes: 3b1d5deb29ff ("arm64: dts: imx95: add pcie[0,1] and pcie-ep[0,1] support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95.dtsi b/arch/arm64/boot/dts/freescale/imx95.dtsi
index 6b8470cb3461a..0e6a9e639d769 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -1542,7 +1542,7 @@
 			reg = <0 0x4c300000 0 0x10000>,
 			      <0 0x60100000 0 0xfe00000>,
 			      <0 0x4c360000 0 0x10000>,
-			      <0 0x4c340000 0 0x2000>;
+			      <0 0x4c340000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
 			ranges = <0x81000000 0x0 0x00000000 0x0 0x6ff00000 0 0x00100000>,
 				 <0x82000000 0x0 0x10000000 0x9 0x10000000 0 0x10000000>;
@@ -1582,7 +1582,7 @@
 			reg = <0 0x4c300000 0 0x10000>,
 			      <0 0x4c360000 0 0x1000>,
 			      <0 0x4c320000 0 0x1000>,
-			      <0 0x4c340000 0 0x2000>,
+			      <0 0x4c340000 0 0x4000>,
 			      <0 0x4c370000 0 0x10000>,
 			      <0x9 0 1 0>;
 			reg-names = "dbi","atu", "dbi2", "app", "dma", "addr_space";
@@ -1609,7 +1609,7 @@
 			reg = <0 0x4c380000 0 0x10000>,
 			      <8 0x80100000 0 0xfe00000>,
 			      <0 0x4c3e0000 0 0x10000>,
-			      <0 0x4c3c0000 0 0x2000>;
+			      <0 0x4c3c0000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
 			ranges = <0x81000000 0 0x00000000 0x8 0x8ff00000 0 0x00100000>,
 				 <0x82000000 0 0x10000000 0xa 0x10000000 0 0x10000000>;
@@ -1649,7 +1649,7 @@
 			reg = <0 0x4c380000 0 0x10000>,
 			      <0 0x4c3e0000 0 0x1000>,
 			      <0 0x4c3a0000 0 0x1000>,
-			      <0 0x4c3c0000 0 0x2000>,
+			      <0 0x4c3c0000 0 0x4000>,
 			      <0 0x4c3f0000 0 0x10000>,
 			      <0xa 0 1 0>;
 			reg-names = "dbi", "atu", "dbi2", "app", "dma", "addr_space";
-- 
2.39.5



