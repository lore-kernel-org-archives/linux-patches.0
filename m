Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB0C18FDA5;
	Wed,  5 Feb 2025 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766549; cv=none; b=SW8h23y/Y+NqkwsbXAdbwEb+A9H2TK75fpV35NQmVG0wmEmENPmdrZEaFziElgSp1DEUdWNlA9YN+qs0eUa3GXPscmkovrGERsOIke3C0sRApn6f1NdRLgZ82mxv3hndUWPmpaaWSm+eVdX890xQTv9o/U/8yDbsZem1EWbrT14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766549; c=relaxed/simple;
	bh=YAiMKh5m4dyLF36mTjiZ3TTb6oF+iqFH0LVgS23Yo/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO4AOziadE5611Pp3egWa8AN/3lnD/CiSTlip9nXMlISsGdBn6DkHUhJ2VMC5ksnbgSY5x54vnskQdUN/B4gFfe5qW3eTLY0tgbCQ9SABbLxXJV268On+TNH6SC/LUQwfX+renQOS4XZysXUWwaA2h3R145BXDL7N67Crm9xt7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPNPVsF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPNPVsF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40364C4CED1;
	Wed,  5 Feb 2025 14:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766549;
	bh=YAiMKh5m4dyLF36mTjiZ3TTb6oF+iqFH0LVgS23Yo/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPNPVsF3uCPm2ZPWczC9V2Lbn65ODXhknE+xfFVXts1OiKp1mMAwzoCegwblD+Aj6
	 jcjazteL3Lq9VhlsbkiouaQtvbhrBlV8L4KzR/ZHU9XO6GzMBCdkfiOF6db1AqRG2G
	 VNdlOSLs2bMVM3kYQgAJElal3YEKcaSw+4nI5MsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/590] ARM: dts: stm32: Swap USART3 and UART8 alias on STM32MP15xx DHCOM SoM
Date: Wed,  5 Feb 2025 14:41:29 +0100
Message-ID: <20250205134508.056673528@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 479b8227ffc433929ba49200182b6383569f9615 ]

Swap USART3 and UART8 aliases on STM32MP15xx DHCOM SoM,
make sure UART8 is listed first, USART3 second, because
the UART8 is labeled as UART2 on the SoM pinout, while
USART3 is labeled as UART3 on the SoM pinout.

Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
index 086d3a60ccce2..142d4a8731f8d 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
@@ -15,8 +15,8 @@
 		rtc0 = &hwrtc;
 		rtc1 = &rtc;
 		serial0 = &uart4;
-		serial1 = &usart3;
-		serial2 = &uart8;
+		serial1 = &uart8;
+		serial2 = &usart3;
 	};
 
 	chosen {
-- 
2.39.5



