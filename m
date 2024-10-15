Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494D1D9A42;
	Tue, 15 Oct 2024 11:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992529; cv=none; b=sRU+bEKwp1q21FlA6DQsEYStgNmQ84E8btNmyXxrSz1dBHV1lKT/txYHxb3HpZn++zGseYptkLgQiPpif25jjO8Js/UjXWxt0CQ8gnaQsO2bJLRW488KZe4dZqlJKeduJQNTxz982LOzOCCOWNJSirBXpkjbtvfkD8tUVFnEJH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992529; c=relaxed/simple;
	bh=jEfLRjz9fkJaRLZbs8Kg/RF8zbY4cX5/tzaR2l19jsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWpnuQxB0rqhzmQWRUCYNiUAtwyMEw1VbULXq1BJLEjN8xvhmauMOGVkjqOOuWnOu3mpJz4B+ZoyNs4UtizXgvYDrx6Mmm0vgPGipg3L81Wu3NybfN3AzeomZ8is3sBN4RSUOlT07aG/MoCbetzWye/3iR0rmOTgrN6E9E3aH24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0x3EkpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0x3EkpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE82C4CEC6;
	Tue, 15 Oct 2024 11:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992529;
	bh=jEfLRjz9fkJaRLZbs8Kg/RF8zbY4cX5/tzaR2l19jsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0x3EkpWzee8K9HOABuOYZ9AwVEtSkD4DgMiIONKr/V2TA4GR0SYnbhIiMfdj9QbS
	 rm4Inyxe5mr2KP1vC2nvyonsrGEXobkwfojKjcs8pgidKuoiHPsPYeqAmff2FrMeCq
	 9hHEurfi3Q4E60c2kGUK8RAXugILgGUH3tvIcU/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/691] arm64: dts: renesas: r9a07g044: Correct GICD and GICR sizes
Date: Tue, 15 Oct 2024 13:21:29 +0200
Message-ID: <20241015112445.951411297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 833948fb2b63155847ab691a54800f801555429b ]

The RZ/G2L(C) SoC is equipped with the GIC-600. The GICD is 64KiB +
64KiB for the MBI alias (in total 128KiB), and the GICR is 128KiB per
CPU.

Fixes: 68a45525297b2 ("arm64: dts: renesas: Add initial DTSI for RZ/G2{L,LC} SoC's")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/20240730122436.350013-5-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
index 5f3bc2898daf2..0818560913028 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -300,8 +300,8 @@ gic: interrupt-controller@11900000 {
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
 			interrupt-controller;
-			reg = <0x0 0x11900000 0 0x40000>,
-			      <0x0 0x11940000 0 0x60000>;
+			reg = <0x0 0x11900000 0 0x20000>,
+			      <0x0 0x11940000 0 0x40000>;
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_LOW>;
 		};
 	};
-- 
2.43.0



