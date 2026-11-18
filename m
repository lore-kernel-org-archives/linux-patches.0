Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015428;
	b=O8gT8MifZdOp25rhWQCaKk1aU36R8yeqHtTj5397xeaBGc/tk/D4gjwLmv5lq9scnri4
	 vQ9nYQ8R+GM87gjqna168Og/qxkeXj1M7LxhPPT+wlZ1udlGxOKZLRLQEzWOFGjhY7UJ6
	 n0z4x4AGXXtH37Riak1jlU/LduWkMOs/HzjIOo9OBZ/HYOOT/7TX0NJxSRQdE6qfGYe/F
	 UzTuvrtwcI3Cw6jqfkto0gZtV3UqVLiDPxZrB6hIu0/88RmfDQLNE6HIqIZCIlZN2Q067
	 PpL14nTUCrQ8wFlVqezSvGOl3OEXJUJQWiA5K0svr2dM7Nci6mWJ6R0IUCfoSxB9DMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zhf+NBi+U9pnu8yOvaWSY1bYHZcYfPavylyN3lNAkEM=;
	b=H5LneqwejXKu3QuDmVWRTNgcg/gPrLlcmEQf0c7J2Ra3SYxJDfVXgEtAk12bL+6OWNeP
	 1oA69flVNFPZ0qeBL4kaIs4N2VECrZgkTWgpLlQQd0p6E5E0dLLFNkldj9VW49w2T+fMR
	 3QYfrJ5w3ap3yPUZsuqKB4Iba6D0U9bvjRv1tRxjhIIUlR2927eJAkkke7PWBnoUDfo7i
	 pYMZoTekjzDlMss0qrzJ5AW2x4dxVutz1LQQpZ50+5jB7UJ8GnAzsugMJQ8hqolh5rMWF
	 naOCFYK7u8r4v42Oj8g/iUe0b7nyDupFTdwONu+ZT6h6FSsd4r5AYIP4mFv6xcNwLZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fAB3v8Z9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EEC606A32A;
	Wed, 18 Nov 2026 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fAB3v8Z9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E621F000C5;
	Wed, 18 Nov 2026 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015428;
	bh=zhf+NBi+U9pnu8yOvaWSY1bYHZcYfPavylyN3lNAkEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAB3v8Z9lKXs1yIx29zfgU83NKBIFfEubjyFJO65ZY9N+BUKxVq7RMFwpaG9KQNLF
	 U1SlgBPRJgGl02l0HTbiOFuIVA4RwjQDKONoo1ouyN1F64TOaCKfzWx7WlfscnL7Pu
	 ItjyTw6Z9Pc9IPwhvi876H7C91pT8+ghlFWcflzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0171/2651] arm64: dts: imx95: Avoid 32-bit PCIe window System RAM overlap
Date: Wed, 18 Nov 2026 15:23:31 +0100
Message-ID: <20261118150254.011206784@linuxfoundation.org>
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
index 38fc47024841f..0f03b85aaec17 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -1948,7 +1948,7 @@ pcie0: pcie@4c300000 {
 			      <0 0x4c340000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
 			ranges = <0x43000000 0x9 0x00000000 0x9 0x00000000 0x0 0xe0000000>,
-				 <0x82000000 0x0 0xe0000000 0x9 0xe0000000 0x0 0x10000000>,
+				 <0x82000000 0x0 0x10000000 0x9 0xe0000000 0x0 0x10000000>,
 				 <0x81000000 0x0 0x00000000 0x9 0xf0000000 0x0 0x00100000>;
 			#address-cells = <3>;
 			#size-cells = <2>;
@@ -2039,7 +2039,7 @@ pcie1: pcie@4c380000 {
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



