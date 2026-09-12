Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD67C3839BA;
	Sat, 12 Sep 2026 19:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242729; cv=none; b=rW555PN2nerY3ZW9HyBkcDr9tdXHPXyKD3/UbM4ruxqAJ2gq45rvgE8eOW/vrunsRGUBy+TmutL6jjmJ3fOO3Bu+y2MPL+127PFgI3T7eS8ejSYM4dYsk8ZGV4PnbTNZj6bua+OBMvFntl1VG21HvW90zMn4XZwLAXIbiulL8lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242729; c=relaxed/simple;
	bh=+hKBdQ7dRrUs08ucXQ3jc2lURpIXX0FyU1T4qjiaNjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuCu3t3MbrCAfS0Cz4jJyek7fBpbZ9M0w72InJzQtvCneHo88iAlL48f4godtU3lwbTRGydzZbNr4tcceLoBTOSDtb0BrC7So8N69BIIc0/A9xTPldvQtP+o4m4RRo9HZAAewA4Tl+BdYpVelpk1mjAp1IVdWlaT5J4z5DHd1QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxsH1uQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxsH1uQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140D51F0089A;
	Sat, 12 Sep 2026 19:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242728;
	bh=GlKS+f3eRS6GBlkSXW9iy826fzyfQ5FgW/yrFRzPK70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxsH1uQLfLQpKgyfTUfHDiyrRekXFayv+FvVwgyDpJif6iLfZTMjzw2azRpx2QBD0
	 Hu39V6fk/Q8Z2pf3m6n8DhaK+LhEOHWwihQtNRThcAzmMT6WmCPnhOWFiA/DvEUY4H
	 znSoM2NIHYhjl5H5QKSJ/t6cTbgUiMtxb+935EqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 505/798] ARM: dts: allwinner: a10: Fix PMU interrupt
Date: Sat, 12 Sep 2026 09:02:13 +0200
Message-ID: <20260912065528.709259935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/sun4i-a10.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 1c5a666c54b53..b3a7167cc9de6 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -186,7 +186,7 @@ de: display-engine {
 
 	pmu {
 		compatible = "arm,cortex-a8-pmu";
-		interrupts = <3>;
+		interrupts = <66>;
 	};
 
 	reserved-memory {
-- 
2.53.0



