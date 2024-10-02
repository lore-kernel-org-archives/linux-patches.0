Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA6C1D0DC8;
	Wed,  2 Oct 2024 14:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879465; cv=none; b=fLSB/IBXfwgz7LnTZERFML0EGkT1o9cCDIbjNph7Ivm3fhHb9F4xgB7v7/nHG3WHqyTRvM9RcskSpt6S0xAqiFi33vWggOwARMSSCnnimm78S1uo8YctvslKXrzYpevd/4RU9DQbPZkCw8SolmapKUc6Pa9nfnj6+hJBcBtKU4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879465; c=relaxed/simple;
	bh=nRhYUjcZChKndPjZr75JEeLnsCwABPd7QJF8cvJcc+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLtcFJEVdD4eVUlVFenOst4jW5LUHR7zEJVyW2qhzckBKeYjleLBbDkKpnGjXSF5THtYlBj6d/OouRrfwQhHqRGFvhvAt3ger1yxKsxkZ0pPvfQqc9Fr9WSpE7NJul1Ca0cRiCI+0L8aSXP0Kx5YLlfiXHmy+pdQCkiuBnFztfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCqYwBe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCqYwBe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0CCC4CEC5;
	Wed,  2 Oct 2024 14:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879465;
	bh=nRhYUjcZChKndPjZr75JEeLnsCwABPd7QJF8cvJcc+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCqYwBe+26Nd46GF5GZikzz02Hs8j7p9IbO/7huCKMk4M32dbN+6tmd+VglV9TOJR
	 VrntA64bK3oR2WjRFgUVNPIGUWcyfOzcLmGEj6/FM6IRaqbZCpRxNS+Yo/mBiHqGRC
	 XShKJwtqwNrCy5xYDfr636BPUsmL2znsWQQGjOLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/538] arm64: dts: renesas: r9a07g044: Correct GICD and GICR sizes
Date: Wed,  2 Oct 2024 14:55:36 +0200
Message-ID: <20241002125756.059615323@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index a877738c30484..edc942c846395 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -997,8 +997,8 @@ gic: interrupt-controller@11900000 {
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
 			interrupt-controller;
-			reg = <0x0 0x11900000 0 0x40000>,
-			      <0x0 0x11940000 0 0x60000>;
+			reg = <0x0 0x11900000 0 0x20000>,
+			      <0x0 0x11940000 0 0x40000>;
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_LOW>;
 		};
 
-- 
2.43.0



