Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBC221ADAE;
	Tue,  8 Apr 2025 11:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110756; cv=none; b=ffe3+phLXzw4Rp3/h93RBYSLp7yVXVZcVj9+G/AtXIwaKVYx2h30J/ijcQdOHDajB4nINv07TCCXuIFzhTJkkawLe8jrNKOtpTbsklH00zd/mMtA08MsBM0OmA3lQ611rUnIVmOAWIRtG43Y9xSbqN9qv8tqEi1FiMqH2mLzoRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110756; c=relaxed/simple;
	bh=slhh0NmjDf3cqY5Fq+w916SfZ4blrlxPS3dgX5tU0Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnwP9v+xThwUlVxGOJ+seNH26ZdzLPVAx0GFaxVKLNuRmstkgWr3yrRyyIBxkRYHssnZvQTCmLvuh3mZcMnEH41ibdVXGau4q8JJzL0tLxgVGVxtMW5DS3kYE/uXXG/vRkGTVL8liN+R3zg4NfXdr2jPkQwpreg6VNmFUiRV2cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMy0cldH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMy0cldH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE10CC4CEEA;
	Tue,  8 Apr 2025 11:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110756;
	bh=slhh0NmjDf3cqY5Fq+w916SfZ4blrlxPS3dgX5tU0Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMy0cldHDoj5nAYSSj3DIKxttOte/NVVAqjlGpzdkyfIzUny0huABYR2i1Eqkgy57
	 nE3gWlCAG+0+UdHI92Urzmxai6Zx7sSc0voD0ThP0V1QCecTf8ZJSgBGh5gzwZSQuQ
	 K9mxMBOrai+8HDeWCB6W16EJ3nz5H3Dp5mwa+LEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 183/731] arm64: dts: rockchip: Move rk356x scmi SHMEM to reserved memory
Date: Tue,  8 Apr 2025 12:41:20 +0200
Message-ID: <20250408104918.535110033@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 8fbb9376f0c489dfdc7e20d16e90686b29dec8f2 ]

0x0 to 0xf0000000 are SDRAM memory areas where 0x10f000 is located.
So move the SHMEM memory of arm_scmi to the reserved memory node.

Fixes: a3adc0b9071d ("arm64: dts: rockchip: add core dtsi for RK3568 SoC")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20250308100001.572657-2-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi | 25 +++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
index e553906291140..8421d4b8c7719 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
@@ -174,6 +174,18 @@
 		method = "smc";
 	};
 
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		scmi_shmem: shmem@10f000 {
+			compatible = "arm,scmi-shmem";
+			reg = <0x0 0x0010f000 0x0 0x100>;
+			no-map;
+		};
+	};
+
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>,
@@ -199,19 +211,6 @@
 		#clock-cells = <0>;
 	};
 
-	sram@10f000 {
-		compatible = "mmio-sram";
-		reg = <0x0 0x0010f000 0x0 0x100>;
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges = <0 0x0 0x0010f000 0x100>;
-
-		scmi_shmem: sram@0 {
-			compatible = "arm,scmi-shmem";
-			reg = <0x0 0x100>;
-		};
-	};
-
 	sata1: sata@fc400000 {
 		compatible = "rockchip,rk3568-dwc-ahci", "snps,dwc-ahci";
 		reg = <0 0xfc400000 0 0x1000>;
-- 
2.39.5



