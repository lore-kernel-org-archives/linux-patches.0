Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D79078C92;
	Wed,  7 Aug 2024 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043429; cv=none; b=NO6WZpH+a+a0fqRo+4tLivuwYcG4vIPplgoXlRepUknuNI/uYE/MNazHZtMwAth21aIlgKxOaLCJpqW308+iEI8xOM+qyfD0/DRA7bcOOaJG3f8WJHnyFkkvWhG+iM9VKMaYeKcF9a3sYiT5zNgwh1BuaMoITs39DYL3h28SqlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043429; c=relaxed/simple;
	bh=+9QkHlQmlnANAwmQ/qDkwWPeOEjBsXdWFoO0yv1E1Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leuWWgN+eIl0ahEq0NOM7gOTQI4hVo1crhR9avnH4SpB7UldPKG9SEF86+6k+1XXeJKBt9dMR4Ps91b9K3iRxESSrNeLBclcrsP19EcG9wAlvfw3q5EZ6WgCT05VWVR1/JghglZEDO6J7KTOE43F6p8x30uhc6T+oX5/PMHaPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSOCdgjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSOCdgjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D08C32781;
	Wed,  7 Aug 2024 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043429;
	bh=+9QkHlQmlnANAwmQ/qDkwWPeOEjBsXdWFoO0yv1E1Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSOCdgjd57mh+xr4TydvO5dnkW0F2xJNvhnrZlv5gHGRIpP+84qaq4Lp6psr8uLCt
	 GRsFTUJ0FpaNDV7yIZ8LwGYrn3HRZt2ZcnRvOWi56teQJLZk6LcKmuF8XrtN0/Rztu
	 8TcS6FBVLIUX9hr4YgkaA1UGrZPw+WBIgm6fDoyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/121] MIPS: dts: loongson: Fix ls2k1000-rtc interrupt
Date: Wed,  7 Aug 2024 16:59:41 +0200
Message-ID: <20240807150021.009285949@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



