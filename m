Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0CA1D175B;
	Wed,  2 Oct 2024 14:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879463; cv=none; b=X8iE3t07ny4yI1N00bdANXMs3TeI0uJKl6eNXP9rv4Lx79L7a6NmBhFabE/r9oQ1uNbQZ+O9R4extgH4mo/ent8sykpuKR7T6Alb1DmUDz2ItaIZ7QWGiBN8J+qn9M1ft2iJr2SGEpDYtNbsQ9QrSPCOJrdWfF+mr1euIIVdFd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879463; c=relaxed/simple;
	bh=hIM1teF/NmEPDM12UyteVrF5k8Ur3dlBDpiOoW9Fm24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuNlCtWaJhonEGYxmCRD5+qtG0O3yafDRduhSoCdgPZlRXWeA1S/Az+6iL2U7TxXNBYs+FTE/e/itNLvR9vilaEmmIQHV0mNb2gxpP1b7vYghp6nSuKbm5pMZphr/vOG8B8Yr6B5MR77e23jUvFppIT4d9ItB4Wq8aClzseY4gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rq5Zjmkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rq5Zjmkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B693C4CEC2;
	Wed,  2 Oct 2024 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879462;
	bh=hIM1teF/NmEPDM12UyteVrF5k8Ur3dlBDpiOoW9Fm24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rq5Zjmkq74+eBOVcYBHD9dji6lXPuGAZajCtHYI8DpDOrTIDwcsUheolBH3AOva0t
	 UsjaZ61KLFmqAF1zpm8y/WnVHrtQY7GuioNNJP9NKx1XRpO6IarYP0SxXBY4bLe9X4
	 pNjzIpuXlzvi5j8fx6vS+uDn8/gqQLy4kRvjXh6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/538] arm64: dts: renesas: r9a07g054: Correct GICD and GICR sizes
Date: Wed,  2 Oct 2024 14:55:35 +0200
Message-ID: <20241002125756.018594997@linuxfoundation.org>
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

[ Upstream commit 45afa9eacb59b258d2e53c7f63430ea1e8344803 ]

The RZ/V2L SoC is equipped with the GIC-600. The GICD is 64KiB + 64KiB
for the MBI alias (in total 128KiB), and the GICR is 128KiB per CPU.

Fixes: 7c2b8198f4f32 ("arm64: dts: renesas: Add initial DTSI for RZ/V2L SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/20240730122436.350013-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g054.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g054.dtsi b/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
index 3f01b096cfb71..d61f7894e55cd 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
@@ -1004,8 +1004,8 @@ gic: interrupt-controller@11900000 {
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



