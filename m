Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9F228691;
	Wed,  5 Feb 2025 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765001; cv=none; b=SJNiSdf/KIQMayHCQWjIP7HT3mlGtK2KPBhOj5PVJSbiCIGj1NwE7NZ5hJPOdSw0ziWPn0q/OCvODy3P0rxs8DMG0OAZ+fd73utZbO8iT9ZsPHTRftkBGW6kD+sHSWrw2tWX9k7spXBrJq0foQ9Qya62ogUTQThriqYq5TfvQBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765001; c=relaxed/simple;
	bh=Iprxw9PeJGxvLRe92A+rJXK6yhdhvW90Xx8byhSwkyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF/uKWljbSixC8YjZB4VizvKoXSbpMBQc4tqju7UhPgxrmULhp9gGLeN+w8Jiob+NN0PsHbuSY4Du3uxJlX8rRdc0dwIsY5wfDImLchyhcYNGM800Fok8BZ7802TLqX9A4oJeMTPjd9UQqbgQ9Spb8UO+P2bi9ho9qeH5qfj5Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GN6uLKyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GN6uLKyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E03C4CED1;
	Wed,  5 Feb 2025 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765001;
	bh=Iprxw9PeJGxvLRe92A+rJXK6yhdhvW90Xx8byhSwkyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GN6uLKyEBSoCfo1IbIHVlF7+vyHeQxytFONumopYNEhyGv6w2Y2TlBrrQ+niD+SxP
	 8QqU6W32EhaUPkHD/ZFnCst+DsdhPhZqipGxi+mVEmEjboRhevj6xcI9bDLn5OG7Oc
	 zisw/G+B+XgJce57HCAl8bn8Uj8845MFStmS1QW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/393] ARM: dts: stm32: Swap USART3 and UART8 alias on STM32MP15xx DHCOM SoM
Date: Wed,  5 Feb 2025 14:42:22 +0100
Message-ID: <20250205134428.838381486@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



