Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B34A156225;
	Wed,  5 Feb 2025 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766997; cv=none; b=gf36WlxgK89fMzpPDGLj70POtS4roMIlLvt1Ham5Iwn4e2eZ14jziz+TQ8Clt1wp3i/vIfnIaj8wwUax/FyAlz+4seBu7XIPZhx4KsX6dJ860UoGU6x7vjUZtNEXPE/MG+ThZ4b72MljkdLgRojRjJX/n7OV5PWEF6Pa4LZa31M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766997; c=relaxed/simple;
	bh=KAclt5KImcAdXhVZoSSGYUIQaQ68Cabl8mb6hMhHzw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRXZrI9yIA78ZML/JRWjd8x8B+mPc3Gat3oTqxlBpMwKZINSw45J9YORo3nAmwuKwUIoFKp4XCbjE0HI+OKrqWO9n0xIbiKydUEAeFgkupyGxMyWCYQOzmjbu2xbHEUEwH5g/F+QsHsd9N0gh/JYePPpL19anmg9GkpnjtnC5rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XF86pUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XF86pUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8D0C4CED1;
	Wed,  5 Feb 2025 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766997;
	bh=KAclt5KImcAdXhVZoSSGYUIQaQ68Cabl8mb6hMhHzw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XF86pURzZNhhalT6Hzj25C8pCocmVW6Z0SV5ulQzEbc0xf636HAUip+sA2OknSI7
	 rCTWtGJKRrOtJr08qDkrXHU9Qmoj0lpUih0EB//b+jYxxFOST6QUKNZvscaeRwTPWh
	 +1nNNE/80ZT6BsCMSUHQ4hqQsRGatw8Yyrn69xJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 339/623] ARM: dts: stm32: Increase CPU core voltage on STM32MP13xx DHCOR SoM
Date: Wed,  5 Feb 2025 14:41:21 +0100
Message-ID: <20250205134509.197720044@linuxfoundation.org>
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

[ Upstream commit a4422a9183278162093d4524fdf4b6bbd7dd8a28 ]

The STM32MP13xx DHCOR DHSBC is populated with STM32MP13xx part capable
of 1 GHz operation, increase the CPU core voltage to 1.35 V to make
sure the SoC is stable even if the blobs unconditionally force the CPU
to 1 GHz operation.

It is not possible to make use of CPUfreq on the STM32MP13xx because
the SCMI protocol 0x13 is not implemented by upstream OpTee-OS which
is the SCMI provider.

Fixes: 6331bddce649 ("ARM: dts: stm32: Add support for STM32MP13xx DHCOR SoM and DHSBC board")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi b/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi
index 5edbc790d1d27..34a7ebfcef0ee 100644
--- a/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi
@@ -85,8 +85,8 @@
 
 			vddcpu: buck1 { /* VDD_CPU_1V2 */
 				regulator-name = "vddcpu";
-				regulator-min-microvolt = <1250000>;
-				regulator-max-microvolt = <1250000>;
+				regulator-min-microvolt = <1350000>;
+				regulator-max-microvolt = <1350000>;
 				regulator-always-on;
 				regulator-initial-mode = <0>;
 				regulator-over-current-protection;
-- 
2.39.5



