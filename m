Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E39B1BFDFC;
	Mon, 14 Oct 2024 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917582; cv=none; b=NLJvODCXTj4AUULRU8OI20qCTCzF+uu1yGkLJYXS9dkFEsrfVFm16Lt7b2Mim2lzJzyTy44CdGe1oL/DaLhMaKta5oUItBAkQexgNb2aGOrd9EOD8+ZTbUTY59L6m3rO+lsYu/Xayte8PUTTaG7/TRa4nyBUBFuTa1abDLPTiYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917582; c=relaxed/simple;
	bh=bvVpB20sTC0D0MEfXK6nJdPHL0HnLoUi2ZnrCe3yLds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjP33n2YWZ2RXLKoNjSbaydc5HgsiR9dFL2I/9GJeuP2R1zDe6WRtZvoDyoLxZpJgUzH2IhlHv9xs0h6rhomXuV9lVQ+/VA3qVca6BYCcxT3C86E1PETjlrlSNi6BTThfUpu0LCx2MEPdAFDnWdXpxCg/siM8upaNYxoPyHeEAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHd+tZ7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHd+tZ7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B5FC4CEC3;
	Mon, 14 Oct 2024 14:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917582;
	bh=bvVpB20sTC0D0MEfXK6nJdPHL0HnLoUi2ZnrCe3yLds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHd+tZ7pkWOlUZQuGYBknzECIfBj6UOrlAAHwHL9ZHB4xNkaJTFC1Il1WFNFvtXHo
	 pzGSReRXGhDlqs5YwpDo0J5J0XTDGlvLEtoWUG+4aHF8oQNXAiSw4GgAJy0oFjv0Cu
	 48wUmGGBQv/ERG5RO1Q9mPBxwebc9L7o5yMsW2FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/798] arm64: dts: renesas: r9a07g043u: Correct GICD and GICR sizes
Date: Mon, 14 Oct 2024 16:10:27 +0200
Message-ID: <20241014141220.806895283@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e7db48462e1f..1276a9487bfb6 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
@@ -135,8 +135,8 @@ gic: interrupt-controller@11900000 {
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



