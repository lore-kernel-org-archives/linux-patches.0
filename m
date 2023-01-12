Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C178E746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AE7C433D2;
	Thu, 12 Jan 2023 14:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532060;
	bh=qHNKDTYQZ7r6fbuZ4CQddHe5QhJgh9PS3kiUugWEc5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNAmEFy/sAWRL61kUm3HTDp9AdKF5ILzC5H4mbTH1i9XMHRwyicqwDGY60tm4NWKS
	 QncIhBwOrAB/nZoWHDDxuejLRAytMUWLZfFereSL98zmUX0JhwdamlJr7Z7vusCO5s
	 Bgab6gSNO069/PhTQ5TWI64c5YQbAYJlhdg726jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/783] ARM: dts: stm32: Drop stm32mp15xc.dtsi from Avenger96
Date: Thu, 12 Jan 2023 14:45:25 +0100
Message-Id: <20230112135524.617043100@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 3b835f1b8acef53c8882b25f40f48d7f5982c938 ]

The Avenger96 is populated with STM32MP157A DHCOR SoM, drop the
stm32mp15xc.dtsi which should only be included in DTs of devices
which are populated with STM32MP15xC/F SoC as the stm32mp15xc.dtsi
enables CRYP block not present in the STM32MP15xA/D SoC .

Fixes: 7e76f82acd9e1 ("ARM: dts: stm32: Split Avenger96 into DHCOR SoM and Avenger96 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts b/arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts
index 2e3c9fbb4eb3..275167f26fd9 100644
--- a/arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts
+++ b/arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts
@@ -13,7 +13,6 @@
 /dts-v1/;
 
 #include "stm32mp157.dtsi"
-#include "stm32mp15xc.dtsi"
 #include "stm32mp15xx-dhcor-som.dtsi"
 #include "stm32mp15xx-dhcor-avenger96.dtsi"
 
-- 
2.35.1



