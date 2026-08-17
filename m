Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE1E2E738B;
	Mon, 17 Aug 2026 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977921; cv=none; b=MJ6VWIh4OZdF3bCUKdJ4apOMHpt9nRkKAnajzlIKV5wOVRzYBtRYsGVgpe1Yu3i2/T6+X2CoTygDqC9viEg3/XNQ4pA0xs8jYSjs15/ZeV6gIhh1ANSJ+Hy8mdj5nxbQhT6itub4GILLVQT59IDOSFtRWapS7rWz/uLOhFD7r60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977921; c=relaxed/simple;
	bh=lSGcaUIXNTgba8Ynn6P5VOaw8cvfq6vvwy0v2808hv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCOBcKBtBMllsv35Ob/nz85n5r6SU+l/oxTmDnNUJx6Sj5fPmk2E+p9AafaVI/GXS4ddnRtOq75uonVLoJ+QbEIu5ms+0KQdlgmU02XTmC4Ef1pshSNTSjNKwzYavMR03IJ6/B/iTLb8cvFa7Fx1nU8wMJE4N25c4j2M6z1QpW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+7wPRf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+7wPRf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E93C1F000E9;
	Mon, 17 Aug 2026 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977919;
	bh=QcRGj7cz/95AtmJ2RFWp+lyJa3x+aYTwsz/K+hyzYco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+7wPRf9lFgQlv3El7Fet/HDxK6m2671TYm3ze0Q3vUy5ogdXot9WZBxc77nxk1d9
	 AkhqrhGqOueVRR8/R5E4Svh7uV2iL6xEHKL8vXeShs1pz9yPXQb9j1IbpwbQsuNRXT
	 X/W7JjoOJoBcGutZdWUewOiPDKMnBhddocnDTgRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Daniel Drake <dan@reactivated.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/181] arm64: dts: broadcom: bcm2712: Remove non-functional EL2 virtual timer
Date: Mon, 17 Aug 2026 15:31:41 +0200
Message-ID: <20260817132535.685616836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 209f99b1ceae7..c8e809d77b3fe 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -279,8 +279,6 @@ IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) |
 					  IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) |
-					  IRQ_TYPE_LEVEL_LOW)>,
-			     <GIC_PPI 12 (GIC_CPU_MASK_SIMPLE(4) |
 					  IRQ_TYPE_LEVEL_LOW)>;
 	};
 };
-- 
2.53.0



