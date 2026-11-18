Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060695;
	b=3uqVkIiM4Jp/fm3RFFkjXs9ueBPehvOrhiVVCukcenqQCOI9ABDaR4SrX11xKxy7P2N+
	 9Lzt61NwkOA6+j7ugFBvcegvjAFxj/gWLe9/gGXxQKqfqHcSXcHvSgbR9d6lAfPjWAdxR
	 aXvd148DlTtOTBsx3493w0dlUCOiqMik8Gbt683lNAxLB/m7VCexyint88LaEYY81E3Rq
	 MCeoY1dXh8fFpkj3GYkOR7Ax+bEFDYdeMlMGMrDrcSx+smxTzKiBkYI5Hcy7kzq5YdO13
	 dKNYfgKfRssd3w5x7f1yBxFvrFSpmpFMuN0975AfX1iwSya+rk89/M1kHEOMEYp/vmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YhU+Hh0iFk1DyxdJAJYVSU5+RFg49izFdg/ar/52CNc=;
	b=4VCPPeecek7ZgJKAxtMQAhsF56TqSLC51AlOzCpP3t+MgiZ6KwZpe/+Fe+K1XTFt0X2C
	 Z5QklUNR3gfBCRD/srBUFwMgS8RTiO4Dud0s1ppspvsHne+Frvl2ebX2s5SiXM9g8sjsJ
	 u2I+8rmq6w1BuUnugLyWcBdNG/j2+SMabDFmvVn0ljTAM7W9OoYlOFggDOG+0OH0SLqW+
	 SSUA/9wbDXWI41+d7IK6unJQCgUKRgJRT9m2mlQvvSuJLvxbTwgwekSGoa7s/1HNgqAQs
	 At/nnlP/gkgW4vKsShpBz20SwsEen3x+9JRRzX3Nft5RdLDbmvFmud/BSzttLffM8ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FziTLYY8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CED6606A320;
	Thu, 19 Nov 2026 03:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FziTLYY8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C7F1F000C4;
	Thu, 19 Nov 2026 03:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060695;
	bh=YhU+Hh0iFk1DyxdJAJYVSU5+RFg49izFdg/ar/52CNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FziTLYY84hWqVGfX/CN+e/xpL3VjnbUWpEUhjgsifDBXeT6ItG1gi1hs1mQIqFrYO
	 AnYcITOl6S6uNSggM2Pch5ky+QdzVNNBPcMm39Fe7EkgXje7ie5kibKEri5e3+3XfX
	 aUaqCbToSZonNBryjvCX3T3xaWzfWKFFaMiPOWWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1239/1848] ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:54:37 +0100
Message-ID: <20261118150011.715742422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit fc3c0ffefc169719316eddb8c36e2427e11ce713 ]

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

Fixes: 666b5ca85cd3 ("ARM: dts: stm32: add STM32MP1-based Linux Automation MC-1 board")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20260611-lxa-stdout-path-baudrate-v1-1-59b60a5069ff@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts b/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
index 1e5333fd437fe..32c173d2e2404 100644
--- a/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
+++ b/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
@@ -33,7 +33,7 @@ backlight: backlight {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	led-act {
-- 
2.53.0



