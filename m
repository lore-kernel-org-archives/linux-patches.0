Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029492;
	b=f0i6BZvQx1uxb4S2bOpUzSj7xNP/2jKbd62rDWa9VOzAglY/EUb4LU/5YyzgvDnxLJwe
	 plnpJaI4BIvIBC2y7g0JzPIRcp7Yh7A8SfWGneumj2Q971xyIZYstDMzdGUM9sJTCemiY
	 UW5i9s/+zoHNa2wwIl8Dn4jOjXYrURVOEt71HlCjA2h0KzYKPlnX5dCetN3+uFD6jy2nc
	 oMiQF3HFpWr3839kQNvdFc3r+dcSgaTA1VTNa/Y2uCLiHJhzcA/3WRg+eYWDuQY/6HfNy
	 qQc8WU6dMF8FxizN8rNnlVoh8S+Hnqi0Je3c3SI33rBrAnXXRsBXB3jfLG0eLTL+wWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SnAzqEtoEZotEATLxcL2QQAUvlAlOSbxg/A96lBmfwk=;
	b=KdssRN0CBXNVimQ/rsH7qk+L+uNOB2qp8PIqMEAzquzcS6rCAWX8mowldLdZGyQzc0ph
	 4RgUDnMLo1s8u1fThwsN6L05kmIwT5pa+tsyPUsSsvUYfkuImmuTpPRfLiV1tjtxQFLtk
	 +hthpfP8E6LuuluYlYqIlmQZyX2yrHVrAQ/wuKnvW/vBrez9Zx+q2SozIRT53ykQPHHMY
	 /EolZtuPhMKymAKc/cJ7NqifNWQw3/n8QLGBDu0OvB/uL9vZ7At0K08qQoec1glgUWZQb
	 cYJ6RyjiRCReoe9q8sJjoSwLOYxWd7auAES74E6WN8RRaHy+fnBo+wZpsbiERyWcgCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lC7PnfOR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766E0606A31C;
	Wed, 18 Nov 2026 19:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lC7PnfOR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B14A1F000C4;
	Wed, 18 Nov 2026 19:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029492;
	bh=SnAzqEtoEZotEATLxcL2QQAUvlAlOSbxg/A96lBmfwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lC7PnfORlBkUi1HRQ/BVAa0rXUijpfOIE8v8KZPvsy0NNImHDHQlWBnjkoMIMyTib
	 MFv0rPUMrui/eDEPimm3KhfT9+VUC8jJSzeQWxHkaajd9YW7/6KmE0GZ3K5mFAeBeU
	 9R2xc17e5KEZaVWjDxweNBZ0Ek0e2VoJdyAcnOCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0367/1756] ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:41:34 +0100
Message-ID: <20261118150023.006247016@linuxfoundation.org>
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
 arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts b/arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts
index eada9cf257be9..b3d8eb57aa24e 100644
--- a/arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts
+++ b/arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts
@@ -33,7 +33,7 @@ backlight: backlight {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	led-controller-0 {
-- 
2.53.0



