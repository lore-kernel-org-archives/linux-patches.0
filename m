Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048300;
	b=s8rjGRWpWIiIae9ayAhbPgO3bnisTlmqTMXGdUnCxzZq0tT63QAXS3NUTDF7nT2/lQyq
	 h16c3M9jcNUwdnRkxE4XoQVhdZOiqtvtxhiwY/dbcv8JMnMVkgEHpmvdX8Gw6U+6f6pp9
	 Tmns2R79M27CcimdSXz/kfn1UC/Lb/OXgWrhln8Sz7/ZHyj4Fwc++/rKNDCsWNRUQ58P5
	 3OA9DwNrMDfmWLxa1Cj2XnoJPungUH6cZRboTkM/2u17wXZ6RSsdxV2F+VuTmfCKJJyrs
	 duwJczrakPaNtJSaipE8J4i+NpwtA2rXosmRE6mLD5HlfOSUn6vZBBQF3TsWeklNe8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8sZF3SstyPrEUvxG4cLNl15YHO0EdTm0AXt/cmimYHg=;
	b=13IIH3s88C4t7nR+6Fzm8PuGsv8FCKgtWqw2pM1BamdqA2An0o47djpdRvdA3n/OJjzu
	 Tz/IcMWNtS9MOD9k4hx2qDRfv1WpPSyi2RHSVeqwJWT6KE55KrfN4jR+KHaQ7EuBpJIcp
	 y171NrOHJDslXfLEXX00mw/x3bfTxjIQ/v4s3u8+hy8K4R6bSStH1OpxKztHCUZV65RM/
	 cXJPhVS6O9o4R5zWj8YefzUHVemCtFl45QsX+MTeAkODsG6X6R8P7kTJIkeD5O9LByw+f
	 CJZQe7E/czLvIUuS95VFEUwJj4MBDJGkZ+i3zgXw405Be0w2MRmoHn6L2J2j6eOGHtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJot51gk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3961B606A320;
	Thu, 19 Nov 2026 00:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJot51gk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450631F000C4;
	Thu, 19 Nov 2026 00:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048299;
	bh=8sZF3SstyPrEUvxG4cLNl15YHO0EdTm0AXt/cmimYHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJot51gkGjJZNEf1Z56RecGlVRBDLqrs9zppvUMSb4hqLB+fNc0iWwwT0HDwcGvGH
	 q16CL9TicfKKHsJK432dQnEo+9BodzOxkBN/8mtGUbxmzE+A1I0Q3PlJ0ARoRFNwLY
	 c/CUk4u+6ZGkWJB7rxOnAD7fO2PY9NMB/3k3gqaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1904/2857] ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:48:58 +0100
Message-ID: <20261118150309.780111148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cb00ce7cec8b1..410e45cf538dd 100644
--- a/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
+++ b/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
@@ -33,7 +33,7 @@ backlight: backlight {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	led-controller-0 {
-- 
2.53.0



