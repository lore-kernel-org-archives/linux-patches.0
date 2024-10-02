Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEBF1D0437;
	Wed,  2 Oct 2024 13:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875556; cv=none; b=ENNZXfemtjhZq1agbs7u3+nxtsO8wfMsq/b0NBeJUKMFhWLoz1Qu97i1YIKalbSlFd/CmA241mGiLRRv0vLs5oY5iCXhcUz1S+v+wAxA+nzJDmaO1Y2mcZTBLkTiOCbRpO7e0yz8qRmcvhpQwWuZ8BF2QTME7S1K2yZCAe3MqKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875556; c=relaxed/simple;
	bh=mW+U/f8UyrMbqEHcSfch1UIV35WWJUTm5jyHnJ0bz04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDPq9+9Uw98AZj014W24jEt9DbPuHSMYyHBkeuCaIZSr6JSHKvU2Ukl3fd46R/k0/8xDegkjYLbcMFcckZGsOONmW5dlI3FLgWclszVKy9B57MwzS5rmpnmd2+A4nML++FZpctVPbsoLNlkEBrUdQFstufsrV2XRjc8MvPN+h2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANExy3V1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANExy3V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940D1C4CEC5;
	Wed,  2 Oct 2024 13:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875556;
	bh=mW+U/f8UyrMbqEHcSfch1UIV35WWJUTm5jyHnJ0bz04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANExy3V1BMq4GsOkizwpYl5cwwjuHUM+K/a/Bf3Mdd9fe8GM2Xig/Eqf9or6+DmAh
	 NmgEKP/rJHtLaBUqXdfuHXlCwky71vIy4Km5vq2rd1+/j4MDgPkzSbi+qeAkzuE0A8
	 KqSmfQBaKMh0tZqIGr+L0hxpSw1yOlJQIMiBo0x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 141/695] arm64: dts: renesas: r9a07g043u: Correct GICD and GICR sizes
Date: Wed,  2 Oct 2024 14:52:19 +0200
Message-ID: <20241002125828.113344057@linuxfoundation.org>
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
index 18ef297db9336..20fb5e41c5988 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
@@ -210,8 +210,8 @@
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



