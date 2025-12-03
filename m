Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADDA334C36;
	Wed,  3 Dec 2025 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777191; cv=none; b=IjKnkHM0ipobpFBw13j9mGntcykMFuJZ8AQ0RT15WRUTSq2p4TfOJNUeRQl48DuATvovltqTQ2r+X1uCBsoQNYG25muWaqnAhFp4x6Uq5Ga+KtjYG5J9fN4JzpaciVXEHJ/p05/Y5slpiruXtJ44Cr/KakebCWHXRFKgU2yKJ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777191; c=relaxed/simple;
	bh=ZOjV6r4enQjzoQYzQ6DR9rd28t68pdBuelotWstgNMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuizZtjG2Yv5MXobZSpCgRX85KdBbCQA/HXrraYGEAI7kR4c/tl80Pk5FGg3MM8+BBbeeSIoGYIBjPhHvbVY3DUDmX+GNsDHsEtj6VIWqum0Fn0sPPOuxO6TZgXC8frMVrkU/zYJc60QOZ62QISwJf77aQzbkYgK2SNJZ/sKqHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hc2RhYIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hc2RhYIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA25AC4CEF5;
	Wed,  3 Dec 2025 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777191;
	bh=ZOjV6r4enQjzoQYzQ6DR9rd28t68pdBuelotWstgNMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hc2RhYIMYC7bAS8lw06XrNHD2jSJ4fgrEUhbwlJw7YAAIFMpS7oEUbxdZKvC0q4RA
	 SUl2Yb9U36s3UJEgy+kytLAzzxj5ZyVWIdAsUW2INeLblltcjOEjNYf/+eiL7XFDH0
	 Kv5eEpIlSfmszNWHEj5dXntpbHShW5iOWs22nwfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Alexander Dahl <ada@thorsis.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.17 077/146] arm64: dts: imx8dxl-ss-conn: swap interrupts number of eqos
Date: Wed,  3 Dec 2025 16:27:35 +0100
Message-ID: <20251203152349.282937353@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 5b6677d6451bbbac3b6ab93fae6506b59e2c19bd upstream.

Swap interrupt numbers of eqos because the below commit just swap
interrupt-names and missed swap interrupts also.

The driver (drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c) use
interrupt-names to get irq numbers.

Fixes: f29c19a6e488 ("arm64: dts: imx8dxl-ss-conn: Fix Ethernet interrupt-names order")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Tested-by: Alexander Dahl <ada@thorsis.com>
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
@@ -27,8 +27,8 @@
 		compatible = "nxp,imx8dxl-dwmac-eqos", "snps,dwmac-5.10a";
 		reg = <0x5b050000 0x10000>;
 		interrupt-parent = <&gic>;
-		interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-names = "macirq", "eth_wake_irq";
 		clocks = <&eqos_lpcg IMX_LPCG_CLK_4>,
 			 <&eqos_lpcg IMX_LPCG_CLK_6>,


