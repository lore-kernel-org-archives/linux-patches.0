Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022978;
	b=oT1uWLeWF9j5DFQoBcXSOtX2WKTw2kmzBkjh7coeI2MXvOLa5kdc4o3+pt6BGbUmOvCi
	 fZTBCqGcTWHOVa20uMOi+iQl3vJqXvHhmrkVrquSgY03yauAOUhVk1ESfu6ChO5TeJUU6
	 xfG8r8N4LsvyVic2CtfGxIJQ3UHIQ974qdSo/d6PB9fywfPACa4NTstyBTiLaOoGJWJCO
	 OvY9MnIDuHG5K1LclIvRcam2kOvELV6ewPdU9PTA5eF5M7tRBtvVdc3o1T1QolnOuJOrx
	 PcrR7BmAQzPKgdlBcwqjfL/82kszHgKCPnGpR4+eyoeREMPdYFrBsFen/7KF3g5aqVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0g0QcUQ3pKyyTSxR6Skf3QEZ675LW3HUJtAwU/bUXwc=;
	b=l/ijQ1PzN2BCDkxiRzU+VELF91VCF+zjCwv8k4tfkmAzjiIejnh/3bwcAlisl9/oCkjr
	 JJSdssRjTFxKnBcU6wRva1Z7GlTSgYIGJiQ88q2X/DGxe3VFdsPZI05eSfvPaOG564gNI
	 1qgmLgfio8O+ZqR+hZuTwRtXfjP4E1cxxlKJh2geXeEYj1P7G1p6kBmLda1QtmEaNIW0m
	 aeY9oLkpLm50OWlAuiQ1BRY9R1JycxXwHiH1qiB+krxeW9LoCLOd7bM95nYiQhBGJzCfK
	 sOIogqnW9K2l+bPPhwj5+5NBzsWMi4shIEpu+b8OF5lSDW2J/80FH1oCy4dBg/SFozw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CRGmYq/y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98583606A31C;
	Wed, 18 Nov 2026 17:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CRGmYq/y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C1A1F000C4;
	Wed, 18 Nov 2026 17:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022978;
	bh=0g0QcUQ3pKyyTSxR6Skf3QEZ675LW3HUJtAwU/bUXwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRGmYq/ylFXh6DK+Xlf8KY3OA70DRrHUX7t+T8ZHvsLR1Vf3aTByJgW1KHDDhfWgy
	 b9P+iWgSTaIrhjc2QCJj4JenjhYb0lJu4mrkPqdm2GqdMQsj2N8AWwZo/VgluMtRe1
	 swEyN/KlulGAMjR+AkDIN5asMCQqW8QVLNBugep4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0205/2151] arm64: dts: imx95: Avoid 32-bit PCIe window System RAM overlap
Date: Wed, 18 Nov 2026 15:32:20 +0100
Message-ID: <20261118150129.251415080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 47fd5a5862b4f..6a9524650ba70 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -1824,7 +1824,7 @@ pcie0: pcie@4c300000 {
 			      <0 0x4c340000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
 			ranges = <0x43000000 0x9 0x00000000 0x9 0x00000000 0x0 0xe0000000>,
-				 <0x82000000 0x0 0xe0000000 0x9 0xe0000000 0x0 0x10000000>,
+				 <0x82000000 0x0 0x10000000 0x9 0xe0000000 0x0 0x10000000>,
 				 <0x81000000 0x0 0x00000000 0x9 0xf0000000 0x0 0x00100000>;
 			#address-cells = <3>;
 			#size-cells = <2>;
@@ -1900,7 +1900,7 @@ pcie1: pcie@4c380000 {
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



