Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3A4235358;
	Sat, 12 Sep 2026 07:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199586; cv=none; b=Aw53Z0RVffAne98dDw3Yherzn34Rs2b9KaqxDCMqiRBw4yjts3UiOiFchKI8caeIczo/9Ao4TWt/KSekT1GgGF5Umu3TV2tN5KN4k/eubwxV8I5IEfxuXlKje52cntHAQsVpQOkXeXYs0f6VXSPuhOEFfFliL2mrbjz3jTdCADc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199586; c=relaxed/simple;
	bh=3NaIuh4nuX6KG0cZIww+4dFPGfR0x9D2gRV+RMQ/E3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FleLtlrzUV/pqjmMrl5pLxs68S0jo4NwDcPiIb7e9caIYqSamOvcaKiCjh8KFinLFz9BjfITKHDZpDcRmFhRH+4SuX8be1agvLQWadH7pMDqQAg/1LnMQW2QiEOdTGFPbCNg7IBKEC4kV0Fsuo+5tym0a9BFGHSgbfp62HNJJMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5Dzh3+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5Dzh3+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843721F000FF;
	Sat, 12 Sep 2026 07:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199585;
	bh=XhvDmaESpG2+0CchXh8tZTYt4qqNSTQ8J8Yg1aXafyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5Dzh3+pAQ/8b9Kpvx5r3BznNAstBX+zJeU5Ny8aDmQ7fQ7UfnufPQ8W2u2jRzL9T
	 95AMn7itDodhq59SvV0wFIFs1JXuKSAxTC+C0IrD760GsQjSR/j0zrskjocd1b1ARS
	 cqc1/jInXrlF1trdXcmzOyHw2QNH8eDQCaRMvmMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0615/1815] ARM: dts: allwinner: a10: Fix PMU interrupt
Date: Sat, 12 Sep 2026 08:39:25 +0200
Message-ID: <20260912065703.319915268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit eb7051f756460d7b951e94d9656e31ebb631ba28 ]

The Performance Monitoring Unit of the Cortex-A8 cores in the Allwinner
A10 SoC is connected to interrupt line 66, not 3. This is shown in the
manual (where interrupt 3 is assigned to UART2, also in our .dtsi), but
has also been confirmed by triggering an PMU overflow interrupt and
inspecting the IRQ controller status registers (from U-Boot).
Please note that "perf stat" does not use interrupts, this might explain
why this evaded the initial testing.

Fixes: 7e345d25c796 ("ARM: dts: sun4i-a10: Add PMU node")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20260720215128.5761-1-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/allwinner/sun4i-a10.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/allwinner/sun4i-a10.dtsi b/arch/arm/boot/dts/allwinner/sun4i-a10.dtsi
index 51a6464aab9a3..cabf619c2e217 100644
--- a/arch/arm/boot/dts/allwinner/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/allwinner/sun4i-a10.dtsi
@@ -185,7 +185,7 @@ de: display-engine {
 
 	pmu {
 		compatible = "arm,cortex-a8-pmu";
-		interrupts = <3>;
+		interrupts = <66>;
 	};
 
 	reserved-memory {
-- 
2.53.0



