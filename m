Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CCF146A66;
	Thu, 13 Jun 2024 11:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279575; cv=none; b=UePtjQujjUgKY4plLS/FUWX1Jo+AtX4ONqw+xiLhElgTByPjj9Ue/5WGEgo/xGI1Hu3mAQ75kV7UnH3bzgECKt5FpKoiymYvpNaT4i3wUmyRC862s9e0EJ3ujTuPAp8nqxdz2VmKQau69OCeAxqrTb4Qeu3Twrq3x4aMWyV/VuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279575; c=relaxed/simple;
	bh=LfoPSpCfw3hkX+dgs6DTUPJ1EULmBa/AhrSPFaK8uR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENuZcTgyxlHeFemXgmzjGsxo7zm3tve4r+WMgc1XDOPjtFGdIelTqNvMFOi66dcG781ugqqheP5+MNflNL93WYA1D7V8FmIcNt3/0NO0oyHGP4xAUUojbdyn/vcMH1m43VDlLDCFRutSEKN1GnaMZA2gGer92lz/XaB320kLNxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xj6kRiWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xj6kRiWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6F3C2BBFC;
	Thu, 13 Jun 2024 11:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279575;
	bh=LfoPSpCfw3hkX+dgs6DTUPJ1EULmBa/AhrSPFaK8uR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xj6kRiWWMQ6FYWR8FpyS+jERY192eet4LjEV11mt6WOhnQ28uxGugbXuKt2VJRWxl
	 EhvDx9le7jGhRqzqs4tebak/xrgbFVZs7GsAOLAf1mYxws24tXte2zmSdm32652iDD
	 G8fx6xq2W0FtZggvi4zSh/8Rs9YRCC6SlMyrnHK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Gan <ganboing@gmail.com>,
	Shengyu Qu <wiagn233@outlook.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.9 121/157] riscv: dts: starfive: Remove PMIC interrupt info for Visionfive 2 board
Date: Thu, 13 Jun 2024 13:34:06 +0200
Message-ID: <20240613113232.094589214@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

From: Shengyu Qu <wiagn233@outlook.com>

commit 0f74c64f0a9f6e1e7cf17bea3d4350fa6581e0d7 upstream.

Interrupt line number of the AXP15060 PMIC is not a necessary part of
its device tree. Originally the binding required one, so the dts patch
added an invalid interrupt that the driver ignored (0) as the interrupt
line of the PMIC is not actually connected on this platform. This went
unnoticed during review as it would have been a valid interrupt for a
GPIO controller, but it is not for the PLIC. The PLIC, on this platform
at least, silently ignores the enablement of interrupt 0. Bo Gan is
running a modified version of OpenSBI that faults if writes are done to
reserved fields, so their kernel runs into problems.

Delete the invalid interrupt from the device tree.

Cc: stable@vger.kernel.org
Reported-by: Bo Gan <ganboing@gmail.com>
Link: https://lore.kernel.org/all/c8b6e960-2459-130f-e4e4-7c9c2ebaa6d3@gmail.com/
Signed-off-by: Shengyu Qu <wiagn233@outlook.com>
Fixes: 2378341504de ("riscv: dts: starfive: Enable axp15060 pmic for cpufreq")
[conor: rewrite the commit message to add more detail]
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
@@ -238,7 +238,6 @@
 	axp15060: pmic@36 {
 		compatible = "x-powers,axp15060";
 		reg = <0x36>;
-		interrupts = <0>;
 		interrupt-controller;
 		#interrupt-cells = <1>;
 


