Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029043;
	b=UdLGizOx+aISQkixv5TFD8WLBfbVk1qQ4wZxajFZRVWxELroYjW1sEpUcm8hLP+OyR6l
	 DRwf54LOYVC78+8sPx9W7gcSeOwHiXGsJFwNnUPeMmTLro0TJhms6K4uJ58o1YrKRvriL
	 27iQvaxYJiBPFRNiKSX/VtFGBUafpDq9oDkPqKz6yyojiV59BpNUupDOYqD9YWW9FrE+X
	 evRQPsRp0QhlwB82Kp5EOXLYBGj0uAWkhH4HnlOuPJeMgjlMUY+70W6ejQpOKqYPoktwg
	 iHPPhd13s41OuadlF56HgbJZ5Bp4V2tb0J5k5pNgx/5mxlYzpg1D76NzRf2lWhos6dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NrEvoJVNc8yj2zNyPBchIoVLq+ytcSTRqUCv2wx9p0o=;
	b=2cmfzQ0G8wJQqkVMfaS112Q6VA6ZDLGE5BSxtrwmC4HMpmaJga9qH4FyzPamq6qWE6Kx
	 vPZG/ojYlByCtZoCA6oVvvHVFiY1QVb1O+4GX+x6n2BU9W1y5iRP2Z2MUcx2RLwgIHDRE
	 pIXsbPmmJuubZuv7QO1lrUNwhdkfeExWY6ibdHFdm2lIpU+QftY0m048mp9gxUO2nrVN/
	 xD9nrkl9qdaV01r9jZwnWFiF/vRsEh2pGBoGuyqbBmQk0f1+cFNaHjMx+u6Dy5oCtBG6f
	 ccq5qMxXORLhRaPa+nk4G9QJtt7miBjKACm5yWzVlghVVNqVtrBhpaqme8/epbsxMpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jOUKqwmw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BAB606A325;
	Wed, 18 Nov 2026 19:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jOUKqwmw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255091F000C5;
	Wed, 18 Nov 2026 19:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029043;
	bh=NrEvoJVNc8yj2zNyPBchIoVLq+ytcSTRqUCv2wx9p0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOUKqwmwlFP2zFTcmIKmybHuzKMHq1aHcYocfFHn8p7zhmgjDSAhJ1C4qqhgS1G/c
	 DnjKZY8zZGHuSxIqnzbP8w948O8DlxdyxOicDmjhIoigviT/c+LKLbqkAcVRRHAXY2
	 5N1BKwDdIEPYncA2KMh5JZQDR9VjcNqPEdcfCAUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0208/1756] arm64: dts: imx95: Avoid 32-bit PCIe window System RAM overlap
Date: Wed, 18 Nov 2026 15:38:55 +0100
Message-ID: <20261118150016.631360711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 9094eb07b3e236233dbaac61ed30cc65be9e9c6c ]

Move the PCIe non-prefetchable memory PCI bus address from 0xe0000000
to 0x10000000 to avoid overlap with DRAM. Avoid hit this as a P2P
transfer[1]. The 0x10000000 range is reserved and safe to use.

Fixes: dbecf38e60d4e ("arm64: dts: imx95: Correct PCIe outbound address space configuration")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Link: https://lore.kernel.org/imx/753fca23-c3eb-45e3-aeac-b7b248fa723a@app.fastmail.com/ [1]
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95.dtsi b/arch/arm64/boot/dts/freescale/imx95.dtsi
index 227eae56125d3..7b88fe079087a 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -1481,7 +1481,7 @@ pcie0: pcie@4c300000 {
 			      <0 0x4c340000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
 			ranges = <0x43000000 0x9 0x00000000 0x9 0x00000000 0x0 0xe0000000>,
-				 <0x82000000 0x0 0xe0000000 0x9 0xe0000000 0x0 0x10000000>,
+				 <0x82000000 0x0 0x10000000 0x9 0xe0000000 0x0 0x10000000>,
 				 <0x81000000 0x0 0x00000000 0x9 0xf0000000 0x0 0x00100000>;
 			#address-cells = <3>;
 			#size-cells = <2>;
@@ -1549,7 +1549,7 @@ pcie1: pcie@4c380000 {
 			      <0 0x4c3c0000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
 			ranges = <0x43000000 0xa 0x00000000 0xa 0x00000000 0x0 0xe0000000>,
-				 <0x82000000 0x0 0xe0000000 0xa 0xe0000000 0x0 0x10000000>,
+				 <0x82000000 0x0 0x10000000 0xa 0xe0000000 0x0 0x10000000>,
 				 <0x81000000 0x0 0x00000000 0xa 0xf0000000 0x0 0x00100000>;
 			#address-cells = <3>;
 			#size-cells = <2>;
-- 
2.53.0



