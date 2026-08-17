Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521F73DB310;
	Mon, 17 Aug 2026 13:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974676; cv=none; b=jwVoXO461zj9eHtNEoWOscyFc0i+Y+VDNA4TXVBnP0B+diCIPER4QXd9S51xilomjF489N2FPhEvWiACCc+JL4trEaV0N0B32VC69wx+FE00Qp1LvCJ37Nu1em3YrtO3FErU2mG1uF1h5Evcevyrg2TSz82oMkfbB0Q9ppK76Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974676; c=relaxed/simple;
	bh=SqLj8b/oe07OHK4Pia5hvkFDGCi4KzwqdDwv7sY4E6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLqDqJfqjJzF9wwKOj6p2vQJJ/beuWy0kT75rHRQjFy4EG2kULpjCH87iJKJ4CSFDT/GCibE36RyYSyBiXQi8EIJx2uz4+BSBJaUoC11zj7IY3gS+ta8xQ3I6oC2430/286JzM1Q6YwZkgse0h/0ubACXPQSvHCb6Ln8vsO3gVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mN8R/Ul0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mN8R/Ul0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2CB1F00A3D;
	Mon, 17 Aug 2026 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974669;
	bh=OUxeKCKQsM+xdwdlztNQTP/lyyfL4G+J7uV1PUD5bBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mN8R/Ul0tdO4HaqZL79t1elo3yf5hGWuRqqnxoN5eG1XuuWwFTUKhPBo1GHe877Tc
	 16zLODcu95LGMCw8eUhOBSH1Ng6AWI2J7F1DE+OTmQmcSjUiOOFWPsgC/bPjnev0rq
	 aqlTDO+LpKgBmuaR7TGhvJatOH23ZSM6en0d6rWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Daniel Drake <dan@reactivated.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/250] arm64: dts: broadcom: bcm2712: Remove non-functional EL2 virtual timer
Date: Mon, 17 Aug 2026 15:29:35 +0200
Message-ID: <20260817132537.041313065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dan@reactivated.net>

[ Upstream commit 75952cfc7752c52a2b692b59d34ce160d3edabb2 ]

Commit d87773de9efe1 ("clocksource/drivers/arm_arch_timer: Default to EL2
virtual timer when running VHE") causes boot to hang on Raspberry Pi 5.
The newly-selected EL2 virtual timer does not generate any interrupts,
even though the GIC_DIST_ENABLE_SET flag has been confirmed set via
readback.

It is highly unusual that this timer interrupt is non-operational because
this is a standard GIC interrupt corresponding to a standard Cortex-A76
CPU timer. However, Broadcom have confirmed for this SoC:

> the interrupt line was never connected in the first place as this was
> not identified as being a requirement

Remove the corresponding DeviceTree entry.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/all/ea15cce1-b393-43f6-8d58-3d6f90f0c0cd@samsung.com/
Fixes: faa3381267d0 ("arm64: dts: broadcom: Add minimal support for Raspberry Pi 5")
Signed-off-by: Daniel Drake <dan@reactivated.net>
Link: https://lore.kernel.org/r/20260716-bcm2712-el2-v2-1-e708f7fb42fa@reactivated.net
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
index d771694787b28..45a382f75b5ec 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -651,8 +651,6 @@ IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) |
 					  IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) |
-					  IRQ_TYPE_LEVEL_LOW)>,
-			     <GIC_PPI 12 (GIC_CPU_MASK_SIMPLE(4) |
 					  IRQ_TYPE_LEVEL_LOW)>;
 	};
 
-- 
2.53.0



