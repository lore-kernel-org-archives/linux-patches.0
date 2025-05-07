Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD711CF5C6;
	Wed,  7 May 2025 19:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644814; cv=none; b=TRt92MpdIWGdZX3Jp8BKACX9N7rr3ke6PpXKgbHbyWRBiEEGOqS5ubdheeyYraPQvYwNh834LQoffyceP/lJC699tkNVJe20HFd5Jf4+44TkQR/awXlsspFkkXAaXlPadxBPdSzbzG5Dh3OsqQyFCaY/cSkidYpNsQTUIgAzXCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644814; c=relaxed/simple;
	bh=c1v0ZWIjsem/Z48zTo86ewjo/72u0EG9AOaLWIFO3Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSQvg1ORwRTkAD3x043BSCjkB30aSEqzRjbZ0vqUOlreHUD4iG6e+UUW9IfwhMTQ8oLNm0JD/zHANdE9FbMBaEizrLLyBDeOTNi2V16uLN+2AzQkl/SGM85HBBlQXr0l9z2h4M9UOlRubAndn29f9jgNwJLd+9rQkM4rPOkCSmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qq83lV9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qq83lV9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7403C4CEE2;
	Wed,  7 May 2025 19:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644814;
	bh=c1v0ZWIjsem/Z48zTo86ewjo/72u0EG9AOaLWIFO3Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qq83lV9rvGhGvD+QFKNf3TcNHsiIG6tdp8vaHIOLA5JQH39EZalk5FrgdqQ2d2gqM
	 7OlXB5Getb2gXeO7Ve8qCpCfxOb3RvSW1XknBpo8TKtjuu88Sc6PskA3nIibNTr774
	 dOWxdP5IeiHpwvxEhrz940DAq5D65yS2JCARLosY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/164] arm64: dts: imx95: Correct the range of PCIe app-reg region
Date: Wed,  7 May 2025 20:40:40 +0200
Message-ID: <20250507183827.243195658@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 40cbb071f265c..f904d6b1c84bf 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -1478,7 +1478,7 @@
 			reg = <0 0x4c300000 0 0x10000>,
 			      <0 0x60100000 0 0xfe00000>,
 			      <0 0x4c360000 0 0x10000>,
-			      <0 0x4c340000 0 0x2000>;
+			      <0 0x4c340000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
 			ranges = <0x81000000 0x0 0x00000000 0x0 0x6ff00000 0 0x00100000>,
 				 <0x82000000 0x0 0x10000000 0x9 0x10000000 0 0x10000000>;
@@ -1518,7 +1518,7 @@
 			reg = <0 0x4c300000 0 0x10000>,
 			      <0 0x4c360000 0 0x1000>,
 			      <0 0x4c320000 0 0x1000>,
-			      <0 0x4c340000 0 0x2000>,
+			      <0 0x4c340000 0 0x4000>,
 			      <0 0x4c370000 0 0x10000>,
 			      <0x9 0 1 0>;
 			reg-names = "dbi","atu", "dbi2", "app", "dma", "addr_space";
@@ -1545,7 +1545,7 @@
 			reg = <0 0x4c380000 0 0x10000>,
 			      <8 0x80100000 0 0xfe00000>,
 			      <0 0x4c3e0000 0 0x10000>,
-			      <0 0x4c3c0000 0 0x2000>;
+			      <0 0x4c3c0000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
 			ranges = <0x81000000 0 0x00000000 0x8 0x8ff00000 0 0x00100000>,
 				 <0x82000000 0 0x10000000 0xa 0x10000000 0 0x10000000>;
@@ -1585,7 +1585,7 @@
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



