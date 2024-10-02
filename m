Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01C31D0433;
	Wed,  2 Oct 2024 13:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875562; cv=none; b=CBGw5113AcWKvEu9IO3t/nhUGrtBPxvaGFDFVfUypCC35ZDIDxwT7x0OOa8IlRkIT2FBd/S0/Rr53r0jR5jEehxTOYoNQDQV686JpAWk2AMH0DnpxB2VDviFI2XXEv8rH0rEmcx7h1SJZuzBdPx65svQRoCcqJY+oWxe3NpHU8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875562; c=relaxed/simple;
	bh=zl8rehc5BhD6akZShSUKqH19C2n7psojoSDGfF5PU4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fF+9CzdzQupsqNxuIf6rxeYHsMAFCIzfBLjX2qNfDM37xNsADeroauOeOm6eM6FxBexm9e+f9g7t4xsBzHEbqxzTQjyBQuy0z2cCmleRLHIzhV/WGvp8VpRXQhRvkT5+ueeyWr2gHlWmSzmCDaHhcurl2H7djw6DMSgzTrU+nco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUP9Swrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUP9Swrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B7EC4CEC5;
	Wed,  2 Oct 2024 13:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875561;
	bh=zl8rehc5BhD6akZShSUKqH19C2n7psojoSDGfF5PU4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUP9SwrhlA7uQjrD9FE0D18EelRZ3MVpEU59tKwOY492dg37OOc13lCV4DsZ3480Y
	 MvXmnozZH/zcsAyUBlKI2rubymDSQr36mbCtaRxN2l2glm60cJ6Mg1mjtksc/kccw4
	 XXAXOrfw7lFJCW1NgT2KRTkBX2VDAtvZNl+RV9yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 143/695] arm64: dts: renesas: r9a07g044: Correct GICD and GICR sizes
Date: Wed,  2 Oct 2024 14:52:21 +0200
Message-ID: <20241002125828.193246765@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d3838e5820fca..c9b9b60a3a36e 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -1043,8 +1043,8 @@
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



