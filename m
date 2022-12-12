Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3719628ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D912C433EF;
	Mon, 12 Dec 2022 13:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851280;
	bh=P2+nVTZk03IyAt6aGTu7xU2AEqlJns0RVLTfyvBITAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBeUUMeHpuiCvhx48leBur95wa9Q8NF8HBwEKDCYyJoijjnCS2jdB27d2I6tYNZl1
	 NH8Ku5NqvTgR86ccpk5/eDdckumUfOD+yRvN4ejxilolZbMib67Ljl10OmA75d3hhy
	 V37VIkiuxOH7EWnPgi+JLkzKHsTG2sEMnlyhJNp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/67] ARM: dts: rockchip: disable arm_global_timer on rk3066 and rk3188
Date: Mon, 12 Dec 2022 14:16:42 +0100
Message-Id: <20221212130917.979005131@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit da74858a475782a3f16470907814c8cc5950ad68 ]

The clock source and the sched_clock provided by the arm_global_timer
on Rockchip rk3066a/rk3188 are quite unstable because their rates
depend on the CPU frequency.

Recent changes to the arm_global_timer driver makes it impossible to use.

On the other side, the arm_global_timer has a higher rating than the
ROCKCHIP_TIMER, it will be selected by default by the time framework
while we want to use the stable Rockchip clock source.

Keep the arm_global_timer disabled in order to have the
DW_APB_TIMER (rk3066a) or ROCKCHIP_TIMER (rk3188) selected by default.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/f275ca8d-fd0a-26e5-b978-b7f3df815e0a@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3188.dtsi | 1 -
 arch/arm/boot/dts/rk3xxx.dtsi | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index 95d558dc163c..5e8ba80d7b4f 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -632,7 +632,6 @@
 
 &global_timer {
 	interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
-	status = "disabled";
 };
 
 &local_timer {
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index bce0b05ef7bf..0580eea90fbc 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -108,6 +108,13 @@
 		reg = <0x1013c200 0x20>;
 		interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_EDGE_RISING)>;
 		clocks = <&cru CORE_PERI>;
+		status = "disabled";
+		/* The clock source and the sched_clock provided by the arm_global_timer
+		 * on Rockchip rk3066a/rk3188 are quite unstable because their rates
+		 * depend on the CPU frequency.
+		 * Keep the arm_global_timer disabled in order to have the
+		 * DW_APB_TIMER (rk3066a) or ROCKCHIP_TIMER (rk3188) selected by default.
+		 */
 	};
 
 	local_timer: local-timer@1013c600 {
-- 
2.35.1



