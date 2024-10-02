Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695B31D1E8C;
	Wed,  2 Oct 2024 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877584; cv=none; b=HfsUFaQ2hDiWjZpkoQxDBdrs2iofHIQuRqwv33tFtKhZql0d41ls9asswKsmeMS3PJJwzrXp/QJxiZ5y7lWrh1YlJgGemjPWiHCNechFYxp6P3Fx40hSt657S2sLufyca1fkWMNPCUzZBNmPIEiGTIUZnE8gXCSWhzsaB76bS2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877584; c=relaxed/simple;
	bh=kKb50PgaCqrT0B5QWDd5ctutAqfI7ZDddLbeXeI8itk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3pDQZDFq0YSQXKSaDwQ9yghkjVTjKfDiMPQVqJlM+axRveSSpF11xC4NYpGiUusXDN+KiCJL/+GRlxcXFYOjKbYTQ0eFjS6OunpAFEzAmmJMKLbNUaiQirhUxhUpLk8CGS/lL4KOzOeGTXZsTDL91Xw2qxDAvR9fk9rVkPeIRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dm8GHwoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dm8GHwoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95451C4CEC2;
	Wed,  2 Oct 2024 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877584;
	bh=kKb50PgaCqrT0B5QWDd5ctutAqfI7ZDddLbeXeI8itk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dm8GHwoPndQV8XzyG7plc2WaY3bm8oirVCxYKL2yfxoWi4Y11wcs/KbCCBCdskKFm
	 bJFAsYSJXrREZfcZUkF9BSCQkGpKdmlw4TW21j6MW8EA729E+JooaHOtyHf5yEMyvI
	 06CJWAOyxk+yNi2pzy8w6K5ElRw/zTdYnwK3+elo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 124/634] arm64: dts: renesas: r9a08g045: Correct GICD and GICR sizes
Date: Wed,  2 Oct 2024 14:53:44 +0200
Message-ID: <20241002125816.007301657@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit ec9532628eb9d82282b8e52fd9c4a3800d87feec ]

The RZ/G3S SoC is equipped with the GIC-600. The GICD is 64KiB + 64KiB
for the MBI alias (in total 128KiB), and the GICR is 128KiB per CPU.

Despite the RZ/G3S SoC being single-core, it has two instances of GICR.

Fixes: e20396d65b959 ("arm64: dts: renesas: Add initial DTSI for RZ/G3S SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/20240730122436.350013-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a08g045.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a08g045.dtsi b/arch/arm64/boot/dts/renesas/r9a08g045.dtsi
index a2adc4e27ce97..17609d81af294 100644
--- a/arch/arm64/boot/dts/renesas/r9a08g045.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a08g045.dtsi
@@ -269,8 +269,8 @@
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
 			interrupt-controller;
-			reg = <0x0 0x12400000 0 0x40000>,
-			      <0x0 0x12440000 0 0x60000>;
+			reg = <0x0 0x12400000 0 0x20000>,
+			      <0x0 0x12440000 0 0x40000>;
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_LOW>;
 		};
 
-- 
2.43.0



