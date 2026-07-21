Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FCC46AA93;
	Tue, 21 Jul 2026 15:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648390; cv=none; b=B/FRR13hHiLFN5+odALpL8d0mi3QQjDXI8EkVGSHx+99pz2QbC6DV/2HL3h/TA79HnwLiPAFPyKgHcLRnbyNpvTiPlO41XcagWDmoh8HvUNmMSadtKUvIZHMJ57LQkWByRFP5fxykOLx6/NOWyNKztInZzYvgu85rQeHbySXMpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648390; c=relaxed/simple;
	bh=oqw0NqaUKNBvv+iueSLzCbcCIiDHM35zYmgPFsgyoZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoT092gVybWJuhdpr2x09NjWq8I8lEDWu6ZcXFLyy+FqNoIRr3Oib3nvD8fIrOaokLqtCXkmLsRF7TW2TQVxNeCoOBrxyTbVxiog0/9PEavM4teRbxshWPtXru7mThgsMeiu//dC8/WR/cXMK8Zri9XnUC3ifKg9EeyRuz+2mHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uN0mievI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uN0mievI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA641F000E9;
	Tue, 21 Jul 2026 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648389;
	bh=L21yUIOBepc4ITJshCYu0N51lqhMEgRvN6a4dCR5rrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uN0mievI5HJBUioZcL0KubnxGPViCBQ51JYA3LpYn4/XOeaC/ETzGrlGzeio/sRnk
	 n2rS0MblHUTo7rmg87QgTrExtaC/yn1OqnwgjrcBV1UxdgmgtOyilhNPHCMIWIOFGk
	 C+qjFOvpDMf1pOLQX4fdppxJgx+ege7D2EWxWedg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0137/2077] riscv: dts: microchip: gpio controllers on mpfs need 2 interrupt cells
Date: Tue, 21 Jul 2026 16:56:50 +0200
Message-ID: <20260721152555.921445891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 79b731da340f1c9703e28665d49a865aa6956278 ]

The platform has variable interrupt types for GPIO interrupts, in
addition to having multiple lines per GPIO controller. Two interrupt
cells are required.

Fixes: 528a5b1f2556d ("riscv: dts: microchip: add new peripherals to icicle kit device tree")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/mpfs.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/boot/dts/microchip/mpfs.dtsi b/arch/riscv/boot/dts/microchip/mpfs.dtsi
index d535d4c72763c9..85d8df6437f23e 100644
--- a/arch/riscv/boot/dts/microchip/mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/mpfs.dtsi
@@ -499,7 +499,7 @@ gpio0: gpio@20120000 {
 			reg = <0x0 0x20120000 0x0 0x1000>;
 			interrupt-parent = <&irqmux>;
 			interrupt-controller;
-			#interrupt-cells = <1>;
+			#interrupt-cells = <2>;
 			interrupts = <0>, <1>, <2>, <3>,
 				     <4>, <5>, <6>, <7>,
 				     <8>, <9>, <10>, <11>,
@@ -516,7 +516,7 @@ gpio1: gpio@20121000 {
 			reg = <0x0 0x20121000 0x0 0x1000>;
 			interrupt-parent = <&irqmux>;
 			interrupt-controller;
-			#interrupt-cells = <1>;
+			#interrupt-cells = <2>;
 			interrupts = <32>, <33>, <34>, <35>,
 				     <36>, <37>, <38>, <39>,
 				     <40>, <41>, <42>, <43>,
@@ -535,7 +535,7 @@ gpio2: gpio@20122000 {
 			reg = <0x0 0x20122000 0x0 0x1000>;
 			interrupt-parent = <&irqmux>;
 			interrupt-controller;
-			#interrupt-cells = <1>;
+			#interrupt-cells = <2>;
 			interrupts = <64>, <65>, <66>, <67>,
 				     <68>, <69>, <70>, <71>,
 				     <72>, <73>, <74>, <75>,
-- 
2.53.0



