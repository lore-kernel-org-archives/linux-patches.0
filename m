Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F0C3C2794;
	Mon, 17 Aug 2026 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973893; cv=none; b=hRGPA+KYl+o1VPdYY/Cv+b9yXLDHeb9m8tbhSX763QKb3Cl9xhiNSpnthOOg/xPYDbjHF2UhsdPJ8vzC7An4I4JDTo5BeXyUwINrLzoVKHQDfyI7PJmsxxDnFE0QWHAKYlFPgTphVn/GDscOf8yn55nBrQnjrr9c0iE6rOE+eD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973893; c=relaxed/simple;
	bh=Mopom4nqGpyVwZBXgoDEH6/OfU40kBh9RUePGY1CukQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+zL56jsvzENSx46qEXaTlCVgO85nyPm2vM8rsi/zpE+4VP40MQwAgZeV1rQaBmcjl5F+WNaG7EPfmdoyQyMQ7FFdsjs8mFOg07VE3WzkDJWSi5bF3dRE1NuWVWRJ+1kf+HLaQjo4FycHXT3wTD4GFspU8jxHnLk/r5v92adYlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTyZEOkS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTyZEOkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B561F000E9;
	Mon, 17 Aug 2026 13:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973892;
	bh=hL3kb0SZXEYf7+zje9RIFXneUc3l2o1ljMUcq6AAOkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTyZEOkS0RUJhl0vLOVLcRzsepGhG8RJZievbe8GPHFBUVyjL4xjkGK6bKHBTgdiJ
	 SxumNh2gU2TCWXMz4zQEnoF3ZDatRx/cJ9buuFgwXaSaXOp58SoVRJqoJd5HkKrh+T
	 unbCxmyqvsLr6XHaZZhXuCqDEmeft7bRwSsqR6j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Daniel Drake <dan@reactivated.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 018/271] arm64: dts: broadcom: bcm2712: Remove non-functional EL2 virtual timer
Date: Mon, 17 Aug 2026 15:29:03 +0200
Message-ID: <20260817132537.521967301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 761c59d90ffc9..09ff5e9959d3a 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -678,8 +678,6 @@ IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) |
 					  IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) |
-					  IRQ_TYPE_LEVEL_LOW)>,
-			     <GIC_PPI 12 (GIC_CPU_MASK_SIMPLE(4) |
 					  IRQ_TYPE_LEVEL_LOW)>;
 	};
 
-- 
2.53.0



