Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81560267F6B;
	Tue, 25 Mar 2025 12:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905874; cv=none; b=hhSsbb6seD8mGMNy6Zh+tM38qwCtphKnt7xubIPgAQM5Pe/V3Vk5+Z3mjDzve/Tpy23wox3EHVXKJUUVE21CmxHJhpxbWeabSwTRDt+2uc8tsP5NPNp+7AMngKuTBLrvwE3D2xheE8+qgkNQeYHPyOZ7WaCYPDlN/F0LgGwfWlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905874; c=relaxed/simple;
	bh=6mKYwLWOYvr1unuYOcU6EOcPkg4s6JH2cSDHcWWVyE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdUAUjkxo8FAeV3sZejAMc8HOCh66DNUWS1w3QxARv0CtdApP7xt0ENQ7TOJoAcQSccge5GWZNe5eDfGw3Jw7XaBDx5CKuFtCFtCZPUNzuPPolAg5ErnWAyZwE6hsZUfxGfs+Mgy8pa64ouR+kWhXfh8UIb6HhPMFST0x2Rg9QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urCjnU+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urCjnU+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35221C4CEE4;
	Tue, 25 Mar 2025 12:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905874;
	bh=6mKYwLWOYvr1unuYOcU6EOcPkg4s6JH2cSDHcWWVyE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urCjnU+DVfbjAXFTzpxkVntMJ7zQ2aPAQvab/rQ96UYBP5EGMDibUTl2iRgYahRVS
	 cbEaLSTEoBUgC6mMNr748H64x8mwb4MLt33RStv6bgmdCVXG1K2306D7zsG/Z4BDa7
	 sE4Uiaz+glTVmIHck+xzy8bYfb7wFeEYkSpo/EXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 012/119] arm64: dts: bcm2712: PL011 UARTs are actually r1p5
Date: Tue, 25 Mar 2025 08:21:10 -0400
Message-ID: <20250325122149.374378745@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit 768953614c1c13fdf771be5742f1be573eea8fa4 ]

The ARM PL011 UART instances in BCM2712 are r1p5 spec, which means they
have 32-entry FIFOs. The correct periphid value for this is 0x00341011.
Thanks to N Buchwitz for pointing this out.

Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250223125614.3592-3-wahrenst@gmx.net
Fixes: faa3381267d0 ("arm64: dts: broadcom: Add minimal support for Raspberry Pi 5")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
index 26a29e5e5078d..447bfa060918c 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -232,7 +232,7 @@ uart10: serial@7d001000 {
 			interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk_uart>, <&clk_vpu>;
 			clock-names = "uartclk", "apb_pclk";
-			arm,primecell-periphid = <0x00241011>;
+			arm,primecell-periphid = <0x00341011>;
 			status = "disabled";
 		};
 
-- 
2.39.5



