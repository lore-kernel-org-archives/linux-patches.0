Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CF11863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A38C433EF;
	Wed, 28 Dec 2022 15:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239635;
	bh=oGrzDRJuWJ7lCEy8LdesAxZsLWXXEUBvj1lGSG5grow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1pXi3a3LLS/gUHLLki9cd5VGj39WWUlGvZ4XOvsgLmnv19aWTE8fxwbnWxOI30AH
	 I4ZUE8vXJ82huDXA6ZBjTRQJiwgsWzLxnnkOzCTuOtLAB8Xi/MzHx/1xr38O0MkQjz
	 9OUzgPKMCGActgw3gG4uZdf6DzI7iFWxPZYOoKdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keerthy <j-keerthy@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0058/1073] arm64: dts: ti: k3-j721s2: Fix the interrupt ranges property for main & wkup gpio intr
Date: Wed, 28 Dec 2022 15:27:26 +0100
Message-Id: <20221228144329.677138179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keerthy <j-keerthy@ti.com>

[ Upstream commit b8aa36c22da7d64c5a5d89ccb4a2abb9aeaab2e3 ]

The parent's input irq number is wrongly subtracted with 32 instead of
using the exact numbers in:

https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j721s2/interrupt_cfg.html

The GPIO interrupts are not working because of that. The toggling works
fine but interrupts are not firing. Fix the parent's input irq that
specifies the base for parent irq.

Tested for MAIN_GPIO0_6 interrupt on the j721s2 EVM.

Fixes: b8545f9d3a54 ("arm64: dts: ti: Add initial support for J721S2 SoC")
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Vaishnav Achath <vaishnav.a@ti.com>
Link: https://lore.kernel.org/r/20220922072950.9157-1-j-keerthy@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi       | 2 +-
 arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
index 34e7d577ae13..c89f28235812 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
@@ -60,7 +60,7 @@ main_gpio_intr: interrupt-controller@a00000 {
 		#interrupt-cells = <1>;
 		ti,sci = <&sms>;
 		ti,sci-dev-id = <148>;
-		ti,interrupt-ranges = <8 360 56>;
+		ti,interrupt-ranges = <8 392 56>;
 	};
 
 	main_pmx0: pinctrl@11c000 {
diff --git a/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi
index 4d1bfabd1313..f0644851602c 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi
@@ -65,7 +65,7 @@ wkup_gpio_intr: interrupt-controller@42200000 {
 		#interrupt-cells = <1>;
 		ti,sci = <&sms>;
 		ti,sci-dev-id = <125>;
-		ti,interrupt-ranges = <16 928 16>;
+		ti,interrupt-ranges = <16 960 16>;
 	};
 
 	mcu_conf: syscon@40f00000 {
-- 
2.35.1



