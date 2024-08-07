Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8778F823AF;
	Wed,  7 Aug 2024 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043618; cv=none; b=omu5GNGirfp2cua8Es0QFYiloYx/wEBI1BQrWCGxBuZe8Q69syYX93fgS+34cAFFF5q3UVETx4Pbw8T2oHkhQyogSA7yKchsM4RMh/4pYrfg4YEAshmdokAroNM93UYSi/ypEyBzpqDfBz1axzgp3eGaT+46VyYcczOz3VZ2STA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043618; c=relaxed/simple;
	bh=G7OZXzs8sEiOGUX6xNdkwvkWfR40kgnNX+yilyw0v9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejJhcdNB1Vv1zmSKVQSodBma2wZfcv90x3kw0kNiydv7Adc02a9TyAOnSX12/o7pzs+bGSZwfdHozAmBxETJ5Wd3oJ3k2ES0UpWuydHWhJa51u7TVn9JFWqvq5AAiSdyD4OEKd+a1CfMHeIAb7CCFl4cwYprNK/WSQRtEEiJmM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1s9ZwGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1s9ZwGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D59C32781;
	Wed,  7 Aug 2024 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043618;
	bh=G7OZXzs8sEiOGUX6xNdkwvkWfR40kgnNX+yilyw0v9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1s9ZwGuefa3IqyFV5IV3V1Qe8z76RHxpy0+YIZqSyuQZ5d8C0Q2ZNEGed37b9yeD
	 xxSQsnvVFUaISLrmIhvTaKvFx8CG/1ah5TTes6rVvfX2UApvIBmHjlT7sLmm7nYGtl
	 L62tCHVjU2jNg5jlKCAFLciPpkRRypLGEjS9bfcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/86] MIPS: dts: loongson: Fix ls2k1000-rtc interrupt
Date: Wed,  7 Aug 2024 17:00:16 +0200
Message-ID: <20240807150040.451901921@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit f70fd92df7529e7283e02a6c3a2510075f13ba30 ]

The correct interrupt line for RTC is line 8 on liointc1.

Fixes: e47084e116fc ("MIPS: Loongson64: DTS: Add RTC support to Loongson-2K1000")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
index eec8243be6499..cc7747c5f21f3 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -99,8 +99,8 @@ liointc1: interrupt-controller@1fe11440 {
 		rtc0: rtc@1fe07800 {
 			compatible = "loongson,ls2k1000-rtc";
 			reg = <0 0x1fe07800 0 0x78>;
-			interrupt-parent = <&liointc0>;
-			interrupts = <60 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-parent = <&liointc1>;
+			interrupts = <8 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		uart0: serial@1fe00000 {
-- 
2.43.0



