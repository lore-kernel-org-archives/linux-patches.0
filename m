Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC4923CE;
	Wed,  7 Aug 2024 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042894; cv=none; b=dRnZbVHWe1a6335dLvTNn+L2KXYy7BFB1l0h+cCHlJymnOpdKefeMDMGA0qo0RqoG4unJBp9q71ZpHTm43IaplTBc0xe7v5zoKWDu4CdlXVs4BGFh1V9fz8BRzqNaLD1ddG7DN1drx+lE/cXSNIDfkU6fhBFPoD/pd0iAVHYgy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042894; c=relaxed/simple;
	bh=0hE+lr604slyCXJbmh91xcpLSd2WYniTvAnZ0wVz7qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQpbq8taRRaOwUNa28gMR+HqjqUJX6DJSl0tCrw9enQC8eq3etc32dj78Klw925kXk+g6VhUp8cf9QGl5hvPoUSi7jJ0DZqfx8Mc1LjCSO3cw4Dh4fSYnVCBIL+JmB2k9Bt9C4Smpqo67FdJEE8DkjtUCG7208dxmJ+vXOa+q1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U76meely; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U76meely"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC8BC4AF0B;
	Wed,  7 Aug 2024 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042893;
	bh=0hE+lr604slyCXJbmh91xcpLSd2WYniTvAnZ0wVz7qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U76meelyhPUWwqLNT+No+V6Z7eEIn1PT5TMIKflzZuu6Zqk7J7mIA1cD3Bd3qKmGt
	 pRJ2JqA0Q0elbKQtAznp2CQgwHfSkN1hycSO1vMj0EQt8uZH7pqEu0O7hjwW7kXmZ3
	 QR/bPrQT3YYBTW+EELPdJQCkUq/NacY4YW5n5L+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 015/123] MIPS: dts: loongson: Fix ls2k1000-rtc interrupt
Date: Wed,  7 Aug 2024 16:58:54 +0200
Message-ID: <20240807150021.314515414@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



