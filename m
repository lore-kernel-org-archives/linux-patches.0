Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E911D86E4;
	Wed,  5 Feb 2025 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767157; cv=none; b=pshsM3zVPHAflnszhZWgXfu8edMp/orJ2PYgdX/lpKT6L79mua5P4e6t5+1HPoRvLJ3mkVZzjdRD/FwI11E4l0VA5R89lJLou/iYhLslmYpJ99Voll22YiqRSPnV3kX7CCL9SSrB2ZBXYRgJnQkYzmWYqbQFAfTp+H6GsoWDquU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767157; c=relaxed/simple;
	bh=j8yMDAmPcENwi6b2j7cpMyPnnafBsceBW55pkJDNZNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CC911TptlKTqbUtc6QfMqQ5QlCQO9HnV/L5amANFe8yyEM5pqIh25qzwNFHLxbDuIodeEp3fzytZBNgvIvDP60raKH6yiXMqYa3utTnJ1dcAnkgQrNEEBZRkGn0Vrw67Hg4GdsVop5GQIQhAC80WQTsnegOI2Q48eO7R5xqsolk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNDAa6GZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNDAa6GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BBBC4CED1;
	Wed,  5 Feb 2025 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767157;
	bh=j8yMDAmPcENwi6b2j7cpMyPnnafBsceBW55pkJDNZNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNDAa6GZvlurA0t4m6XOT8N2m/rKsGp+3nAgUygJ1szd58xSAgMvxr0x7HfW6R3KR
	 E4val6p1zPtgK8ERns3zHxSfHuMb1dS1508xUYmzYIlpQrDJ/ycRfpvufJfO1CDCNi
	 4L/SFCvbIHEix9M8WWMqsDqBad3cmKNl4Tz/D2Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 364/623] ARM: dts: stm32: Swap USART3 and UART8 alias on STM32MP15xx DHCOM SoM
Date: Wed,  5 Feb 2025 14:41:46 +0100
Message-ID: <20250205134510.146612710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



