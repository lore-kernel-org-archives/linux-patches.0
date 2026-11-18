Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029495;
	b=l9TbltJeRaDzOuI6Z6Ir5bqFcEL8CaGVQtjqVoVRtjUSEHveeiHddr6CaNMOPw9iT2bG
	 6n/S2gXEVX0idlzJkmoDMgfxPbCAVPtITK6L+IkKvSHOFKw7kgXHlft1etxT0ECJHFO56
	 LB+8LXsx+jiCOAmSHpvdDuBpubfBDzWvfdMHgwVcBq02JtxZN4OOn9PVPZoVDDYAf9ZTC
	 y6TM5sPNzTniFROyxBy5BqJXLX0Gbi4TEye0luc3nron82Nm8mmsEyesrIfRPCCP5W28R
	 w/KOoWXLYB2psXNRTs0Jmbsqs4tiJoFo52pEUIL2tE9SSrfeCryoCcAU9uAnRFUMIew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vqI/7YTbk2sxfFeBXTCm/38y+UusZdCcA7s9ac6ZqwA=;
	b=P1rPvOY7zhtqriVxJZKgc1q0Xs+H7Yyh6BeII4kpkfIHesSG/k7QJfg94OHFNQ48nqXE
	 edWMkpJbT6y2Hk4DwiJtWvGBJfO2OiLFAVZmCAcIIafQDERFiBt2zrjpepZFrUsTOQacH
	 mfPtBSBaBsgUpztrq8t64+IZthYq9B7xuy62+MvJr8E5nMl0OhKlbDykUuj/HIU4vkNYW
	 5ETN/7r87cQndmN4pYV42wQNRcyEi6AuwO1Jw9OQFX3hyPvTzrWSrmtf04oGiYaWd2Zad
	 NXDBDlpkMlVN+wNPYNcMW/gSdWpUgVj3heSP7zTjZVG+RpS3TDXsueSEB1PQE96LTnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYopkAZf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03052606A325;
	Wed, 18 Nov 2026 19:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYopkAZf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EF21F000C4;
	Wed, 18 Nov 2026 19:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029494;
	bh=vqI/7YTbk2sxfFeBXTCm/38y+UusZdCcA7s9ac6ZqwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYopkAZfL1OEqJIh3eZnnbXLt1lCVScrTZmj3Bit5x/LSvm2y5V1sFBlk5dXK0bCj
	 wL2drdM01eisAcjzLAWa6PRPfEc1MPqqs5z/BlxIOFIPn4GIpVtyNmF9OkiNQzesRp
	 lQaWoSDLAGshFg0uujDomhBdLJ6sSfDRlx1EeW0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0368/1756] ARM: dts: stm32: lxa-tac: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:41:35 +0100
Message-ID: <20261118150023.063788072@linuxfoundation.org>
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
index c87fd96cbd918..05623806277d9 100644
--- a/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
@@ -25,7 +25,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	led-controller-0 {
-- 
2.53.0



