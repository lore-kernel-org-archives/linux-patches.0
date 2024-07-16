Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2330619DFB9;
	Tue, 16 Jul 2024 15:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144943; cv=none; b=swscR7vh0ZZLAtUIsDmpedFgGGbn2BXRrfGhmN9+/g/amKDiWWftnBa2ybW9D0apfVhBvOH1mVw9p3uSSELR6ZbF9BqWk7ObXvj52TqcqZIBzmu28Tv9MbUwsX6PRu6qVwQoPoPvjEFakGEu5WOtTPm+qf7GfsG/g8nm2IOInUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144943; c=relaxed/simple;
	bh=SVbAu19sQ0gmDo5VyEEKK5OO7W/boYX0ulK+rodl1ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwR9joWjCYlDb2fxZsGQIazD3bTjt2WMwX4J9DjmuvnNZUx2Nb4xL/VA3xYOgW4/m8nfaR4bO0JzHk+Rnr+DRuvY5D+owdJtWvvMDAFWOsa/le5OMIndz6anuTk3PTRaB0M6tW+obFg9wTQrJsNwfqpdWLphQgeIXITlmeqY6M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEwcdQFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEwcdQFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1826C116B1;
	Tue, 16 Jul 2024 15:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144943;
	bh=SVbAu19sQ0gmDo5VyEEKK5OO7W/boYX0ulK+rodl1ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEwcdQFBrEl6YWqD4xtbztVUszT9F+82pmECH72sHbJxH3cKPTnqb++uq7QXIWP/r
	 t22Z5nROh0oXhISSuIZyw9ryyLtXlo+3E/SmkmVerhZIgG+thXxAbYkP2nsojyYmqg
	 xQ1jJFtzinvSzfM3YA8ngzSmvg1Tb+NxmrY2CyzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 047/143] arm64: dts: allwinner: Fix PMIC interrupt number
Date: Tue, 16 Jul 2024 17:30:43 +0200
Message-ID: <20240716152757.797480918@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 5b36166e599b5c1332a1147271d2130cece4bb24 ]

The "r_intc" interrupt controller on the A64 uses a mapping scheme, so
the first (and only) NMI interrupt #0 appears as interrupt number 32
(cf. the top comment in drivers/irqchip/irq-sun6i-r.c).

Fix that number in the interrupts property to properly forward PMIC
interrupts to the CPU.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Fixes: 4d39a8eb07eb ("arm64: dts: allwinner: Add Jide Remix Mini PC support")
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20240515234852.26929-1-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h64-remix-mini-pc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h64-remix-mini-pc.dts b/arch/arm64/boot/dts/allwinner/sun50i-h64-remix-mini-pc.dts
index b6e3c169797f0..0dba413963776 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h64-remix-mini-pc.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h64-remix-mini-pc.dts
@@ -191,7 +191,7 @@
 		compatible = "x-powers,axp803";
 		reg = <0x3a3>;
 		interrupt-parent = <&r_intc>;
-		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_LOW>;
+		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_LOW>;
 		x-powers,drive-vbus-en;
 
 		vin1-supply = <&reg_vcc5v>;
-- 
2.43.0



