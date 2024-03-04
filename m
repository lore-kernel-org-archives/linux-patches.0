Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FCB78B4C;
	Mon,  4 Mar 2024 21:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588591; cv=none; b=VU9B38CLsHF6R+SheSxGu4FYboOd75wv/Pb9ruGUhndZuWmCj1RqnFCDco1T5l2x5vgltd+tgp1q/fTunxXjURZiHCcXhSMCpWS1El7AvrPUYs3+iZ0nY/0ui8VZ5ivHdIAxJISi12LD4jfB+PwxwrDtQMtKizYXX4/dCG6aJhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588591; c=relaxed/simple;
	bh=K0vTBrhgmTG3jipN89v4lrmdFU5D/CjoWJZPYfYzhzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4Xiw6KeTubG4gWM4nrPgIvwDDR/pLz8hvevPANwCXb5KC2LY/6myxeFgUdYr/OLjd2hCeIom9kNODJNMKzU8NMT5xWZYvT5FcmfJUD4ysCRwRxBXQeQqwAGi+BWd4jLX3RXXhbHWqtjynQ/kOaTol+OPICCio1joCzancvPSgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mR06Ifq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mR06Ifq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4A8C433C7;
	Mon,  4 Mar 2024 21:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588591;
	bh=K0vTBrhgmTG3jipN89v4lrmdFU5D/CjoWJZPYfYzhzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mR06IfqQbWytYC2CbS0bJvopPjLmZBS4y7pzjr3Sg91uhE7kNsvpfZ1C8bOorjdY
	 TcNTPAttiOmHmDsLaFWYqv73Qc7ClQ9KuQwgp6DUo+4KRxeI6PAnTj0tifadiGu8qv
	 4fM2A+S+WdddbjFLm2XD+z3Setg8QXOZuUB90nFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/215] ARM: dts: imx7s: Drop dma-apb interrupt-names
Date: Mon,  4 Mar 2024 21:21:17 +0000
Message-ID: <20240304211557.463318199@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 9928f0a9e7c0cee3360ca1442b4001d34ad67556 ]

Drop "interrupt-names" property, since it is broken. The drivers/dma/mxs-dma.c
in Linux kernel does not use it, the property contains duplicate array entries
in existing DTs, and even malformed entries (gmpi, should have been gpmi). Get
rid of that optional property altogether.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 2940dacaa56fc..69aebc691526f 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1274,7 +1274,6 @@ dma_apbh: dma-controller@33000000 {
 				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "gpmi0", "gpmi1", "gpmi2", "gpmi3";
 			#dma-cells = <1>;
 			dma-channels = <4>;
 			clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
-- 
2.43.0



