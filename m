Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039665;
	b=IYThrof1L1iR6I4pFckYHVU2SAOpGsE6u5RN6O2y9aTZ11NVW3OKslvJeBabJPjTKNqc
	 c2u/I3bDNEsmHKSSfI642chJ6KDI0UaHc8M75pjDMYNKFpN/8Ykt/ERqpY0mCwhbvcC+f
	 0hoEX9ekZZbB7ltppZUMa/yzfO6sBNKtalv6X3jGLTcTgh/zGnzadkGgbHSQg5qZ+Tw8G
	 x/GeW1veJjNPRHx9aIu+o3IM/+Kj94yBqBVwdRNM/QCzhChELoOmclMOqm7W8faHG3aBk
	 DVhluellRRuvoFXW/hb0XUHvc6pI5EEnzluNAh3IucE0Xqo4hefvnpHx7lHka+SUfTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S2NC7fheYpvbwF4FXTByQHRggzlYwz1eB61/Cg3uB74=;
	b=I/yqaMY5TOd03yBm8Z1obzG4Ha2TzbD9Zl6cd/iUsAZa+3Is/uqskgshBtcU0GfuP5Qe
	 6xLVeDLTXkQnsw3UkOeaYaPSgFA5Vg9oRNzPN5fFL1YfvEQWK2K2op8EUkZsgO/vsi1m0
	 Y1fiPKOov2bqXyUnugUQ1C69Inj2G6MN+9SRHK/KXsKEXJglHrNbGWyNItd25UPvotz41
	 r3xKmXPXoWW1Wan0R1RgExwQNIwvcKPJ9uGzMFd2yUNk202Aa5xadQMI03ZdQw5LzqOue
	 2kvZsY+NWtVnf6HRLkPl+UqESooi11QbfrD3H88fTKoPbnhhW1fLA9uAHtqOrF+5y/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZ+ICvt4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8F360A2605;
	Wed, 18 Nov 2026 22:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZ+ICvt4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708491F000C8;
	Wed, 18 Nov 2026 22:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039665;
	bh=S2NC7fheYpvbwF4FXTByQHRggzlYwz1eB61/Cg3uB74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZ+ICvt4MTy1mDNE/Opr/sU6CzWLwT/FaFxcZsZWKVYd2vYfZAkD+eQgE12D3taza
	 IBq/ee6f6xcKl0MxUmH9MF0OWOeDpIKspac4vf5HJEg4XpFZfpgpyBBjuV1hgTjynr
	 l29DwfGt1i5X/6wWDAeB+vsArzb7RHyjen5M4X+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2179/3318] ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:46:41 +0100
Message-ID: <20261118150427.336369686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



