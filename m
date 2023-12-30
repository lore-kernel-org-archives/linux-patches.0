Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2969079E0;
	Sat, 30 Dec 2023 12:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLWCHlcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E14DC433C8;
	Sat, 30 Dec 2023 12:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937663;
	bh=+woM/fOuWfaFNivug0gvuA2zZgPW+B1h/B8FwbAVJlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLWCHlcZSxM/43uPfzTJIYBVHoAxbo1QBk51gbVnrKsB4Y1PUnKyUQD+d//XfVzbL
	 5lHK73KJ17cLmHlzoAtcYqpzHZUZTibCkyG+kqS/5Qdiw4UJNQ0THxdB60yRHrFtxe
	 f3IYlOXoe8K7T45qHin5nOkbs9KvUeYOMlGBDW9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/156] ARM: dts: dra7: Fix DRA7 L3 NoC node register size
Date: Sat, 30 Dec 2023 11:57:49 +0000
Message-ID: <20231230115812.878831661@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 1e5caee2ba8f1426e8098afb4ca38dc40a0ca71b ]

This node can access any part of the L3 configuration registers space,
including CLK1 and CLK2 which are 0x800000 offset. Restore this area
size to include these areas.

Fixes: 7f2659ce657e ("ARM: dts: Move dra7 l3 noc to a separate node")
Signed-off-by: Andrew Davis <afd@ti.com>
Message-ID: <20231113181604.546444-1-afd@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/dra7.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/dra7.dtsi b/arch/arm/boot/dts/ti/omap/dra7.dtsi
index 3f3e52e3b3752..6509c742fb58c 100644
--- a/arch/arm/boot/dts/ti/omap/dra7.dtsi
+++ b/arch/arm/boot/dts/ti/omap/dra7.dtsi
@@ -147,7 +147,7 @@
 
 		l3-noc@44000000 {
 			compatible = "ti,dra7-l3-noc";
-			reg = <0x44000000 0x1000>,
+			reg = <0x44000000 0x1000000>,
 			      <0x45000000 0x1000>;
 			interrupts-extended = <&crossbar_mpu GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
 					      <&wakeupgen GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.43.0



