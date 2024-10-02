Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891361D014D;
	Wed,  2 Oct 2024 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879448; cv=none; b=D36Hvi6Pb5xsM0Y7G9mnRL0trLsljy9QoIbDDEx7ZkHUUyBcDh9y+7QRfD4WhDNQxdUaSpQwOVsR+sSwTeULGcihTblTNCjViy4bHEHSVekfMSWs/vmv/uAaHUgiA4SO47YmSTctzODbbTa3VqwesslQ7rEvlkKcapMyJ8LuzOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879448; c=relaxed/simple;
	bh=jZdkfwoe1X/maDUUyyNT5/iT+Kgh75a58asOm0kmYmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kocEZ4+4Jcr/QliO3qja0M4N/zDDP+24rtAtuP70W6KfKxzZePwGJ7ToXHB84To+dsf0D46bqo3M37m+RXXS1I2lgpPjqUka1C0jmCJ4lx+M7iYweXX87ixda1/XlnTSWfTY9EmpNltQqp0KgF51p/bIh/SpiHi0SBLDK9q0gc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fifQM3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fifQM3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B235C4CEC5;
	Wed,  2 Oct 2024 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879448;
	bh=jZdkfwoe1X/maDUUyyNT5/iT+Kgh75a58asOm0kmYmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fifQM3lCrPJdTntjV9fgfbEK10ii1UR3WQ2vJXpmDS1GnnhZDK+HSlsffZNiAgZh
	 kQZJttseCCW7EDZ8wiaaO8rPHKW3QPfHQqYljBsolp9LCHRFZBEi9WCBOnpu0g+rB1
	 /PGj2yp6e0ioPmkb12iNKbiIyV5n5pKlnYij4euE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/538] arm64: dts: renesas: r9a07g043u: Correct GICD and GICR sizes
Date: Wed,  2 Oct 2024 14:55:34 +0200
Message-ID: <20241002125755.978854022@linuxfoundation.org>
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

[ Upstream commit ab39547f739236e7f16b8b0a51fdca95cc9cadd3 ]

The RZ/G2UL SoC is equipped with the GIC-600. The GICD is 64KiB + 64KiB
for the MBI alias (in total 128KiB), and the GICR is 128KiB per CPU.

Despite the RZ/G2UL SoC being single-core, it has two instances of GICR.

Fixes: cf40c9689e510 ("arm64: dts: renesas: Add initial DTSI for RZ/G2UL SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/20240730122436.350013-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g043u.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi b/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
index 4b72de43b71cc..71d51febabc1e 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
@@ -145,8 +145,8 @@ gic: interrupt-controller@11900000 {
 		#interrupt-cells = <3>;
 		#address-cells = <0>;
 		interrupt-controller;
-		reg = <0x0 0x11900000 0 0x40000>,
-		      <0x0 0x11940000 0 0x60000>;
+		reg = <0x0 0x11900000 0 0x20000>,
+		      <0x0 0x11940000 0 0x40000>;
 		interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_LOW>;
 	};
 };
-- 
2.43.0



