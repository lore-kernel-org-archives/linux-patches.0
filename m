Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016106;
	b=Mc2IEBJDkNcTmyGbLxe7omXuxtCXrJc4JuUG8RmymAKcd9LW+bUzqPMwPKOyv1b8RkPD
	 XdOTmi/HMqVkcH5s1bt0xtpmGsHuLuCgxbP4ymvmxf15wlnnd7c+k2uPseu57PE5a/m3F
	 qa2PAUFYng/yEYGClD+yFWgW3r6s9faZdTWN/jDlq36jZaetj+p6DYQqmwKBKN5aTGmcP
	 KCxFopFKXVpRNX5yVCsMRzk77Vj/mbD2f5EmbxyWcNnagWCX8gM445ErMnWTKdCARr61c
	 7mTX0hr4UBAqVdOwIJ0KSV9lmNDGYi3hmVNZf43i+Mk67JmUN+rJGKOGBE/3u1LYQnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VcTOeQ4+Sp2UGLPQlTQFMcrMpQatMmA6qGofn+QsmnQ=;
	b=TiVct9bV0lJ++IWvMNsHtI7vPtAEc71DVjPCoswq+N/jU18YAs9q0JhHWpAw5eVzvx2f
	 +ioHJEPsqA498DCIZ6Qml3aXc8pWqvE72FhgkqztSEkvnmy5QW/yvFXZFOu4wRBQGEpIz
	 jc26XeUrmlmsSuL+3jCGsIBEVXHG2ZNSslyIMr1XLRLuhQcvP0FuLuNC6WvWeo71figt8
	 3onpCA6J0TZkB767uFcN1ddf6ur1/h0u6T+pjk8V/+xB0HUTbltviSkqVqPrGiVvn/OdY
	 QM9U8jT95uWw2LbLjYO1ypB9kjndvn9QMi4vLk0zZUAmbRtDc++FbWCK8PIuZW8xMHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eitxzgDg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0173606A339;
	Wed, 18 Nov 2026 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eitxzgDg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054371F000D2;
	Wed, 18 Nov 2026 15:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016106;
	bh=VcTOeQ4+Sp2UGLPQlTQFMcrMpQatMmA6qGofn+QsmnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eitxzgDgC/D9b2w74FasR76RSoCK14WsLXbkFrEzH+yA7e2tXDTiQhpnVOEx4I2Ds
	 yzxqmQbNaHNn+KdmPPO7Xu/N4M0ugTdNe8+MvFyInpD4bfEZuqUOFVpnkEXk00/cf5
	 5mlYZmGgwtspXIc66Ro9WDw2rIFsi9DQtxO3SMJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0410/2651] ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:27:30 +0100
Message-ID: <20261118150302.595573940@linuxfoundation.org>
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



