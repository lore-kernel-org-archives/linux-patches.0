Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023518;
	b=rLtHMMb47Xl0Pm33cLAaIA90VR6mKd78cOyPXZ4i6FURDxPq48CmeQuRknqCk46niLQn
	 UfclFryTdSjXKvP/9l0IQu4tHyTbQ7ckJ9O25KWYVuu20+hH7qt5O34JNKFY+lari+uQK
	 4e7UmGTS+4xHQ6hlauME8rBsVwMwG5pGSHBAh9WFRPprx93UM+kBn+jvxIcR7U86tKwbZ
	 ErJVJlp0mMachaSirnO8sODqDSTBsWEtiTyG/orML49ptAWuOoQvZQGFa25paZZSkxF2P
	 4jI9nL1lpZV8Q+BGn8r9aZfPEPqId2lrA3bVII2Bto/31F4uIpS2XnybqmDn7WefScQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qyhDqUL7HC7GhyIHe6OqrlQl4fJif4gPg+xFZE19xdc=;
	b=Y1PtQAubPb48dcF01fcMLy0F8kgC7Z2/rsExySYsCWE1AAieaT4mVVC09KTj9VWcy/FN
	 2YeeY1jcFK1yWPXk6iTAH4f++W4ej67l3bXzpxW87rAVXmq3S5jvalTAg3G8ToShbTBAv
	 0/EC4Eb0oLSaNhveVOvd5uwId7jT79XYP2STFyV8+XUpr40XwSS6wRRdUXlKHGQW7vdAV
	 Zzuqlo516N9ZPhdWo3KYrA5necm1xv0lMFrIoARFWsfglAgQ5HR/LITOgFyHibsqt88nw
	 D0WecE7KONrkquTL08Bwtz+tqrqFnGdfhZKt5k3UA32z7RLXS3PPUe+L/9c1n8ibYPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mX9xJzbI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64176606A31C;
	Wed, 18 Nov 2026 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mX9xJzbI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B180E1F000C4;
	Wed, 18 Nov 2026 17:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023518;
	bh=qyhDqUL7HC7GhyIHe6OqrlQl4fJif4gPg+xFZE19xdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mX9xJzbI2ia2ZM9SclBNyi9A/x8WmZC9BrvRJ5SNqPARsCdRG3hotUMLOFnAED69c
	 n6Q9WlV9xT2uDvjyuvzIYKZnJQcyYcaQ6r0ENMGxhcw3lhAvhHMX+XjR0nmETmeoFl
	 YeUhJQRqQh1dHhDC7gzxgAVy3Ph6ocQrg6sWJz+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0399/2151] ARM: dts: stm32: lxa-tac: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:35:34 +0100
Message-ID: <20261118150136.598210731@linuxfoundation.org>
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

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 85bb59fc12ef439b248d5f4faf846d5566b701fe ]

The default baud rate when none is specified is up to the DT consumer.

In the case of the Linux STM32 serial driver, it defaults to 9600 baud,
which differs from the 115200 baud that this board's barebox bootloader
configured.

This went unnoticed, because barebox automatically fixes up a console=
command-line option that looks like this on the LXA boards:

  console=ttySTM0,115200n8

This had precedence over the 9600 fallback baud rate.

But when EFI booting a kernel via GRUB, we run into this issue, because
the barebox-provided command-line is disregarded by GRUB.

Fix this by explicitly setting the baud rate to the correct 115200.

Fixes: 518272af37b2 ("ARM: dts: stm32: lxa-tac: add Linux Automation GmbH TAC")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20260611-lxa-stdout-path-baudrate-v1-2-59b60a5069ff@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi b/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
index 154698f87b0e5..eb76f11c9d576 100644
--- a/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
@@ -33,7 +33,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	led-controller-0 {
-- 
2.53.0



