Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023521;
	b=qPiErbVzCl3dmMXH5P+c87pMno6agV+4+BgKq3WkMYvn2L3b+yyNAsyth+ecd24hdCun
	 8eT/Bfk4/0w74GBaEZ38dYDwkp7TwsiH27hCeZBPnJ4gxjv3aTSMlvJF7+W8BCtjITxUa
	 QBFaoe2jCUpjxWXQYlSZ7CYYi+PfWtEAOQv8oXb2A6tAgJHIuev5mSYLrg5wFGlYdMjfN
	 /iRCl2SG8i9MUY7XFbkEFnDM3Z6NEFAS2W4fNywvx0PMhfOGW6L6L8tOei6y3nbbj+gGB
	 FntiKdK7bRmanHmu0QIoPYHZwGZ/0ZsBc4726pOqEeUMhouEE9OoSvy5QoYzOd7mByQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=slgYHPf3mor0xlSNLCtLoguwkUF+IA72PyNhrKNSv38=;
	b=LK7UCWGQNsLF889ufaDo9DT2baH63IjzXQ64eETBEjzk9Zn99hgyunRwkUDnwpBNyFu3
	 Rii+Q2e6sn7J5gySvW8dDY2kRAazz2MRXU6ZmelMELFWCCZInd/02GTprM7cGOMvGEDPt
	 5jcRoqpiXaIZGHupJSh4zn00sO+LM7qECeHc67EwIbkDXq5XkeJg666BcMx8Dxn1q++NH
	 1bWnPZUaJyQOMO/9mX3leEhvED+tNEV9jAHt49vTE3GlY1vhbwE4B99IL7iGci0yIpbUF
	 BGDnSl7iJYh5ZY4/3oYKfKo1nUtRFoBmT/Ryf0MguGQwZFFsAgn133XppZdmjLphjIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKJOeaAl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E03C606A31C;
	Wed, 18 Nov 2026 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKJOeaAl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F5E1F000C4;
	Wed, 18 Nov 2026 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023521;
	bh=slgYHPf3mor0xlSNLCtLoguwkUF+IA72PyNhrKNSv38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKJOeaAllUMCMxkmGs3sWXCAEgrrtmQPTiyYNtTWQ/BCL40dvFs4fxUNH445o7Uak
	 1n+42w1zQ510iRB3YnlIsfSpA83ttKcRmRJD7withRwRlYOWilj4Ueuwmhnnav/40i
	 VrVXfpZBlGt1AxfVW5PUbQA1ex6qoxeUjEMtUTEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0400/2151] ARM: dts: stm32: fairytux2: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:35:35 +0100
Message-ID: <20261118150136.632965632@linuxfoundation.org>
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

[ Upstream commit 5404275bc121a7b06676777c3362d85fb75356fc ]

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

Fixes: 8c6d469f5249 ("ARM: dts: stm32: lxa-fairytux2: add Linux Automation GmbH FairyTux 2")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20260611-lxa-stdout-path-baudrate-v1-3-59b60a5069ff@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp153c-lxa-fairytux2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/st/stm32mp153c-lxa-fairytux2.dtsi b/arch/arm/boot/dts/st/stm32mp153c-lxa-fairytux2.dtsi
index 9eeb9d6b5eb0e..e9de6b8161d6e 100644
--- a/arch/arm/boot/dts/st/stm32mp153c-lxa-fairytux2.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp153c-lxa-fairytux2.dtsi
@@ -28,7 +28,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	backlight: backlight {
-- 
2.53.0



