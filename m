Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF66183CCA;
	Tue, 30 Jul 2024 16:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355361; cv=none; b=II79Z7mGJw8ZJVEDv/JEgjud6m4Lg2Cx/TrLkVjPG0Vgn4H1QDkxW3ptSSJPZ544DNDxMX61YlCRql9jMGCmAzdjdey2DLqFfz5CewwXBzBmYhmj0z4Hjv7tDVNbXSGtvrBDVi27+LcbML9aA6OeLY1uc1E35kPXByFWO7D0ORs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355361; c=relaxed/simple;
	bh=JmqfSiPWK1IEC8X7LpB3NuZAnAEByLdghiIuDoyHa7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTZLGTR7FElzv4IS7yTfgncXbVm0y/Ptfa+uQ7TN6/DLOxWgqsACBcG++cjK4jxun55q4aR+5+7jivfTIR6i5shEBGfJvq9Dd6YlcfEe3YGEtX5Mji7sfqSJmpVhrE99Rk7T9txZ25Cb6MOafVKTGXTnwrQKP9tkRLUsoeAXI84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLLcASN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLLcASN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D460C32782;
	Tue, 30 Jul 2024 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355360;
	bh=JmqfSiPWK1IEC8X7LpB3NuZAnAEByLdghiIuDoyHa7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLLcASN2QOaoRvR8QJGDgdPt9dMw4aflS02JhU0Zsh6I7xViuAhwRYoFQ61PPUvDJ
	 PzIU1KMCMgK1iue0S5qXCbidFDpJMMjcNTXWtEpCgWM7O02ovXEgGFPjskPSZUD27k
	 Pqg2yAix/NMjFo48uZb40s5dI6I4eAwaCavzwaJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/568] ARM: dts: stm32: Add arm,no-tick-in-suspend to STM32MP15xx STGEN timer
Date: Tue, 30 Jul 2024 17:42:38 +0200
Message-ID: <20240730151641.834490870@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 61508917521c3..aec7fa5ab5d8c 100644
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



