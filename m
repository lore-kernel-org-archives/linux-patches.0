Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9A11898EF;
	Tue, 30 Jul 2024 16:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355578; cv=none; b=Xpt2BvB9GhgY9e+FDpdwQ7eY6Ly8BfSDCQpG2Qdf57ynFcd40yNX5aGdxi3QlsgNX8k6Lw35y/030zRu+WeaJSKNnvwTplTWE2yYOLpx/NOcL8Y32svTPEfZpWBVOP8Mq30Rm332wi+VkUVB91hFmXj8CzQuGywQ6TwJjOEWW4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355578; c=relaxed/simple;
	bh=ibvzwIPBfmd2p00NfrZH2Wy5526sZxyz+txw0OejCqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJsCW408zMgxlq0jwCzRRkpEEkdkFnni7m4CNYHBmIxHf0S4sk5wUZi11xjVCicZj9q61Fj+MgqUHfK6uXT0tXx7sYoArP/Q7GjaBqjXKUTvu/a0/iwkpP5XT+nNEkJyqG8KS33S+X5owFSwFje4Y5sfJ2/7Nwwb4l6crWaKFW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=He4X8gKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="He4X8gKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251C7C32782;
	Tue, 30 Jul 2024 16:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355578;
	bh=ibvzwIPBfmd2p00NfrZH2Wy5526sZxyz+txw0OejCqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=He4X8gKkxM2g4K1VPIYR90xgZifQuYq9RN8XAUNAwh6OEY4fef3b77ZC/KBV2HUIH
	 FOC0jfXPHOsSLbRzd3fJfnjYyoD4mxExZu0yra1QNWrmbcNN7X56jv9FgKjUDI2P5P
	 3Yx68/UuEK7opSVSEIu4qAHoMbKZuXQAblFWE+Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 068/809] ARM: dts: stm32: Add arm,no-tick-in-suspend to STM32MP15xx STGEN timer
Date: Tue, 30 Jul 2024 17:39:04 +0200
Message-ID: <20240730151727.328357910@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 4306c047415a227bc72f0e7ba9bde1ccdac10435 ]

STM32MP15xx RM0436 Rev 6 section 46.3 System timer generator (STGEN) states
"
Arm recommends that the system counter is in an always-on power domain.
This is not supported in the current implementation, therefore STGEN should
be saved and restored before Standby mode entry, and restored at Standby
exit by secure software.
...
"
Instead of piling up workarounds in the firmware which is difficult to
update, add "arm,no-tick-in-suspend" DT property into the timer node to
indicate the timer is stopped in suspend, and let the kernel fix the
timer up.

Fixes: 8471a20253eb ("ARM: dts: stm32: add stm32mp157c initial support")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp151.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/st/stm32mp151.dtsi b/arch/arm/boot/dts/st/stm32mp151.dtsi
index 90c5c72c87ab7..4f878ec102c1f 100644
--- a/arch/arm/boot/dts/st/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp151.dtsi
@@ -50,6 +50,7 @@ timer {
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>;
 		interrupt-parent = <&intc>;
+		arm,no-tick-in-suspend;
 	};
 
 	clocks {
-- 
2.43.0



