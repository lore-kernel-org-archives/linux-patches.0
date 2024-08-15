Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739B31714A1;
	Thu, 15 Aug 2024 13:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730181; cv=none; b=LZn/c+xxomA0x4iHSlQy8Q3iRmEyriUgLxcHYdh8z30X8nEyxZRToOY8kqRcUMoqLjDD/rLNF+uE++Z/VlrdHL/6mnc4zaufmUcU4vanBlNfZNLlQXlVl8xfN6DkC3NI2CpirXvzQNbR52Dj6mIVTS34OqiXJ/yyC8iaNZ1yUVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730181; c=relaxed/simple;
	bh=Gy8Cs8lRxginpCxIs4SDgufurSnQemxOc7VWVG8lj+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDlcIAcAvDg675REqZb6OTatrhOhgUZN40x3TJT8rzKW4OozUxWvcsPNdcHmaO8Cpsz3+kIsV1pUBuQ8cilP1r3H1qS/NQ+vV45IYO7+l3RyOKkgzdRz19/6WT40wUeZ6XjKFSTvhOY40klCBYmlqsHAs3UmWtev8gsw9bU4oRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5x7dhNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5x7dhNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBD3C4AF0C;
	Thu, 15 Aug 2024 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730181;
	bh=Gy8Cs8lRxginpCxIs4SDgufurSnQemxOc7VWVG8lj+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5x7dhNwhUOFGZj7UGivI1IJupgom0a1VNLUu95liYgDzQe9nF7AT+rtQAlDcBH7S
	 CNJxkpIwfgVyQnnWDbfJPD79YSWFzU03zgBV4mX7jai2rbHksrl7dnMz7hPwTJzpW7
	 PPEuTCSldSiwUY7uonetuRfX9ddbWj0nYmuFl7FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/484] MIPS: dts: loongson: Fix ls2k1000-rtc interrupt
Date: Thu, 15 Aug 2024 15:23:05 +0200
Message-ID: <20240815131954.039745017@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6ad771768dae1..f3fad477ddce2 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -87,8 +87,8 @@ liointc1: interrupt-controller@1fe11440 {
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



