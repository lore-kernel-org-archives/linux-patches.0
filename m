Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F6844C6F;
	Thu, 13 Jun 2024 12:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280694; cv=none; b=mZsPTIhee9H0T5e+5K9xxOvHFRkA6FO7vtGrqvktqmWBoLfQufUh58rU3R0FOycplQA583Itp2FzEMCRlcZUWM336V7kHdIl0WXxNTRGPJ+DJX74BpEaAF8FhdyN25tBzvq7ClmFPTyNAuqxdGOohqwD6+Tgr0ZdFbDWsYy7K8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280694; c=relaxed/simple;
	bh=zPyGEDxv42pQFAoY2PE1ysCAyRLE6+O9qg0airHqWI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXxCS41nP0VsuGSL7LnQtRLEwrZkXZeMNvw9SaAndiKgsCKkVNP+sEETBjGMqsbhq4PfG67RSSjwPANy0lBtrfGuUJArqtK1KktRI5iWUFRbKa9RXLNJyAXlST7jz1fi6msDDe3KKGxQd9M/iXBkRCiFxLauGddB3G3PaRndMog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tU5g3PAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tU5g3PAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F33C4AF1C;
	Thu, 13 Jun 2024 12:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280694;
	bh=zPyGEDxv42pQFAoY2PE1ysCAyRLE6+O9qg0airHqWI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tU5g3PAKkgkcDrds0s6/7NdksHg76/WBUOOapX4lrOacXW05FPPnhO/6JWxM6gv2h
	 LM7A2A3dbxRtiJG3ES/MOBV6sqA25ji+Ovqzv+F2LALTrgy8PERk2pko3/tUDn+goj
	 Uogq99fiwHdzdThbx8GNZpxLVKtFvyIjPTSK6K/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Gan <ganboing@gmail.com>,
	Shengyu Qu <wiagn233@outlook.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.6 110/137] riscv: dts: starfive: Remove PMIC interrupt info for Visionfive 2 board
Date: Thu, 13 Jun 2024 13:34:50 +0200
Message-ID: <20240613113227.565110486@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -162,7 +162,6 @@
 	axp15060: pmic@36 {
 		compatible = "x-powers,axp15060";
 		reg = <0x36>;
-		interrupts = <0>;
 		interrupt-controller;
 		#interrupt-cells = <1>;
 


