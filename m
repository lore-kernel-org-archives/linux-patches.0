Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0FB46AA80;
	Tue, 21 Jul 2026 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648295; cv=none; b=bzZPJeX/JaCwR8/PcylaN3nFELGxsxd1er92KEW9MWnv6z22+1K8R6h/ocAUz/59MOc8Jw6uYQ0Er62Y8xcFX0B+A+q2BodcqV/CNNCFROE8oEn806nlRxHKkiabYFboScMoSl805GIZxOsRX0ALpCBS/ME7oBFw9fPiSlIDKEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648295; c=relaxed/simple;
	bh=wM+Uh3cbKmGPDgFpjYJI7Gl14mfiR1jYUTzW6eDJPyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkXuyxhGg3FhXHD20pa7hcq7CyBvjmxXsmyUlfgRRWvd5El5UXUCu4aJpK8arytgVkCCv23oNeQReqmDohrcHt5mytYkR1e/nebwa8QE3bt7Z7B3pPXH9GYMwoE0iF368dEHHzZf9VHE15LVId3zvt2Aqv7eJu0BY7ZRcpCGiGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eyy0/zYL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eyy0/zYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B971F000E9;
	Tue, 21 Jul 2026 15:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648294;
	bh=scWdh2zn8pxCb6joLSG9OuKjA09UinMGzQwuMdDPcUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eyy0/zYL+4T6SyDvG+Xp5pkruFRu65tkymIUwibI/LC9wkkE/HkBAtpcnF6UUe4ut
	 iEoZbnhFS63hbzCNe23Ead2o3Cyu2DMbAXwdmy2n4goSf75JHwNM4pHRQTS/Dnk+Iu
	 LvFg2XXZ1QthQAvw20ONYcRU6MvMkhcMz68kDrLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0146/2077] riscv: dts: microchip: fix pic64gx gpio interrupt-cells
Date: Tue, 21 Jul 2026 16:56:59 +0200
Message-ID: <20260721152556.129448069@linuxfoundation.org>
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

[ Upstream commit 48c7771b3c792b153872a2eff67e4cbcb77e4054 ]

As the pic64gx devicetree files got added in parallel to the
GPIO interrupt-cells being fixed for PolarFire SoC, they didn't get
changed to the correct values. Fix them now.

Fixes: 7219d20f9f421 ("riscv: dts: microchip: add pic64gx and its curiosity kit")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/pic64gx.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/boot/dts/microchip/pic64gx.dtsi b/arch/riscv/boot/dts/microchip/pic64gx.dtsi
index ed4623b29920e0..e6a24cc5715fad 100644
--- a/arch/riscv/boot/dts/microchip/pic64gx.dtsi
+++ b/arch/riscv/boot/dts/microchip/pic64gx.dtsi
@@ -494,7 +494,7 @@ gpio0: gpio@20120000 {
 			reg = <0x0 0x20120000 0x0 0x1000>;
 			interrupt-parent = <&irqmux>;
 			interrupt-controller;
-			#interrupt-cells = <1>;
+			#interrupt-cells = <2>;
 			interrupts = <0>, <1>, <2>, <3>,
 				     <4>, <5>, <6>, <7>,
 				     <8>, <9>, <10>, <11>,
@@ -511,7 +511,7 @@ gpio1: gpio@20121000 {
 			reg = <0x0 0x20121000 0x0 0x1000>;
 			interrupt-parent = <&irqmux>;
 			interrupt-controller;
-			#interrupt-cells = <1>;
+			#interrupt-cells = <2>;
 			interrupts = <32>, <33>, <34>, <35>,
 				     <36>, <37>, <38>, <39>,
 				     <40>, <41>, <42>, <43>,
@@ -530,7 +530,7 @@ gpio2: gpio@20122000 {
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



