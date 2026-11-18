Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015434;
	b=WklmXNGfpdP2MQphGg+ORhAK3NQLKrnC4ZKuyqrssNlJt8UEaYGPEKh/3c9V0C/pVJgX
	 Z0a4ZhGnXDWaC9uxVzJP4ffihCMsCni+EbWZVkMcq/Qj3CGTQhQ1qJ1WLdzb5PjTt+dTX
	 4iNd6A+h5mPnNYeFCR6vMpA3rdJTQ2aseKKP+Ar4Kp8cOZwOVVBGHci4oVosdyjRFTwme
	 qhj9sxXOid4PKomBxL4+bFthzPRiCWnhEVbCs/Ei3M5REvl20HBa8n6uePhDWgwEI1vQ+
	 3nJ3a5GB3VLxNVZvQi/kXn/0+FSIBDy58ZLVLuzHs/otm2x5FpCRKV3ysMh4dhSjivg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hXdz3uWWFU+1yn9WC8isIyCZo6qfzaDAsfkOWD5+Js0=;
	b=izLul7oL0NdZKfSt1Vejzo4nVx1jgJl75F8SBVNlFy0GrihXrFOXmlqfRkwqr3UZsZXX
	 +dV1j7KCG2MFhsUgYDVnaTr9vyOm2Kl8bP4v0f1QcxeUIN5muLCplOUefOO6nRjFbGAyV
	 03aoK5LP7Jj2MLudnrNFjGpuCH0O5JHPyjfoENpPTTiKxRsX+kogu4ZC7xqR6c+2yKxM0
	 LPzTVNayaSCxyQzGNvuE2A/p11MVcpbgYsTMCFg35x+7S3KAHH0f3u1ZGj+TgnEBrWQEQ
	 hmoPt2kjrbolvNKxooHH9E8Tb02sEW4+fyMjJFSJA8dIVDlYjvM0uG0l2ofiv9HDK+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJ0OJtM5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDF560A2607;
	Wed, 18 Nov 2026 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJ0OJtM5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98D31F000C6;
	Wed, 18 Nov 2026 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015434;
	bh=hXdz3uWWFU+1yn9WC8isIyCZo6qfzaDAsfkOWD5+Js0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJ0OJtM5IXVfderQ5EoYqaHeilaRDCpBQ2PmO/cQySxiTgaMZPHAYtktJ/olosnIY
	 fdEJD3Al4+sC5dCjcktzF8mzOObers+aHRiRhrs94R8JbXSjv5YRC5eDEI2Spvknyl
	 HizagASMQ3SUv25hR8LX+JYMuTb2qXjAHbeDXUh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0173/2651] arm64: dts: imx943: Avoid 32-bit PCIe window System RAM overlap
Date: Wed, 18 Nov 2026 15:23:33 +0100
Message-ID: <20261118150254.080145301@linuxfoundation.org>
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

[ Upstream commit fff67007ad5403966092006867fe9926aaedda0d ]

Move the PCIe non-prefetchable memory PCI bus address from 0xe0000000
to 0x10000000 to avoid overlap with DRAM. Avoid hit this as a P2P
transfer[1]. The 0x10000000 range is reserved and safe to use.

Link: https://lore.kernel.org/imx/753fca23-c3eb-45e3-aeac-b7b248fa723a@app.fastmail.com/ [1]
Fixes: 6de3a7d7a4f65 ("arm64: dts: imx943: Correct PCIe outbound address space configuration")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx943.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx943.dtsi b/arch/arm64/boot/dts/freescale/imx943.dtsi
index 01152fd0efa5e..a564488d9cd7d 100644
--- a/arch/arm64/boot/dts/freescale/imx943.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx943.dtsi
@@ -219,7 +219,7 @@ pcie1: pcie@4c380000 {
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



