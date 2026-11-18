Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016112;
	b=nfaMC5duQ5CsRzXjqLK1M94hC5p7GfssUuYZR+8GK8uy3TAXJBkE64IAXNo3VUiJvMNx
	 L3GpcQrIL4lp2kG2mNQ4mETg4h6UG69Z21W/EmrFlBAUBcdeNC3IAmPuXJ3pYBC/9WGMG
	 EJxroJQJHif0GSw2M3koWVoCN6kosdsj/6stV3p4wQQf4Jgn2QXieFxzkRLOb2pnQufY4
	 Kp0WSksBvodypdI/xEvnV99Q7Ln1sG2QgnO9n4/+L4PcgyCztUB5f+nJ/zJkZC3ATZxGE
	 Y8rehN01Zz4FvA1iO7porx/de1M/gDMPgwe1d1KiRtaPLgBdwuXG7CyCkG/ylAWAJfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nVzH6zvxOeZ9sKy0smgJet6L92RMtXPHvLLa7/ybIVg=;
	b=pQ51SdUANB8rWukf03cVIf1DlXBlqvsI9+1tROco7IaFrppw1PQBrFYEXEBJo++GwZ2N
	 hZCj0Uw0T9C0Cwqb5KPO2NNASVSk5tYnQV3Mx6TBWZVNuyJavnEmYv8Ajj0Ul24VAwZtz
	 IisO3XqY72Iy+PDFlzcX1xO3PD9LbnA06OgonY9dOqPdhslyEbeLZe/fHD5sNBImQ03ix
	 fqCc013cWfNn/C/FFMC/x44hmWWTxLCJp6Pt/QPLfRZTC++hVMy/FPa3T62TxPomglkgI
	 ZOxytPBeXo8DCPVUoIjeI0o1UXNVmkUKSV7JbeptRn8YyL1RspS3gUsslFu9NmdKUDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcnFDLSO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1CE606A338;
	Wed, 18 Nov 2026 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcnFDLSO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F231F000C5;
	Wed, 18 Nov 2026 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016112;
	bh=nVzH6zvxOeZ9sKy0smgJet6L92RMtXPHvLLa7/ybIVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tcnFDLSOhxpaxer86gENiXnq/caqfrRv3nU0DWWPXuMnSFt28TbThn8Ko3W9dNuyr
	 iRMX7/fB8gQGGtMOKrMRPZRrU4LmkhABOyxWvD24RNFXQy0gTneLndglV6MJqxT4aA
	 T6caSCqLemcBRMgxzZgYA1SGNBv3KDv82qmw8r6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0412/2651] ARM: dts: stm32: fairytux2: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:27:32 +0100
Message-ID: <20261118150302.669417512@linuxfoundation.org>
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
index 7d3a6a3b5d09e..d30b626a18c20 100644
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



