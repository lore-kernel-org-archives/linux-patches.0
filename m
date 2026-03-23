Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889AE3AE1A8;
	Mon, 23 Mar 2026 13:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274109; cv=none; b=tY+FixbO8jRc1A6nMCECafcDZNCGCS04+ahc+9dwcpKAsgviukRukIHH5Wz/cwrbbQupB7oCqV1GQLVXX9hdtPC08zEF+H3a+mkYV1nqKu/RGYXnAICAwYn6DGGq3t1i1YMekw2UAuQceq8nKFNYJlrxYfuMZqPnkInKoxuXVZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274109; c=relaxed/simple;
	bh=6Oy6fZphLzh8zRIryAwf6X7evrhslASPxILfG+iLIO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOhHCTY/ZlyBiGH+1ubWSHCW2dup29ofWWFTWHASrRaMhCysPIIctFt8GAgQFlEl3Hk3b5WkWqfyYtD4G7xRsYQmyuksY58YBWypb8BK+XTuXfWDMb+QFWW9KDXPS96igv4z+t8MAl+Twd6kMwoOxa2eFllYnL8tatMXCnXL3es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDZAmvU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDZAmvU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E135C2BC9E;
	Mon, 23 Mar 2026 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274109;
	bh=6Oy6fZphLzh8zRIryAwf6X7evrhslASPxILfG+iLIO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDZAmvU8e7fyQ+hHkAEdiQMflSCuU8x1XqYaVCyqmKtcGRbtbkdsN5Isjf6I8BXKz
	 uGSWDTr6g90lDweAATfqk1lrXiW56rNEV7aQRZquONqzjHO2YX4VAbTpBtWpgsJOg7
	 N5r6rMyTzK1SiJmHtP6ld4CoMLB5LDhBe0wTQmtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 111/220] arm64: dts: renesas: r9a09g077: Fix CPG register region sizes
Date: Mon, 23 Mar 2026 14:44:48 +0100
Message-ID: <20260323134508.107118918@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit b12985ceca18bcf67f176883175d544daad5e00e ]

The CPG register regions were incorrectly sized.  Update them to match
the actual hardware specification:
  - First region (0x80280000): 0x1000 -> 0x10000 (64kiB)
  - Second region (0x81280000): 0x9000 -> 0x10000 (64kiB)

Fixes: d17b34744f5e4 ("arm64: dts: renesas: Add initial support for the Renesas RZ/T2H SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260213131742.3606334-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g077.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g077.dtsi b/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
index f5fa6ca064097..5f4d30f75cbde 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
@@ -747,8 +747,8 @@ mii_conv3: mii-conv@3 {
 
 		cpg: clock-controller@80280000 {
 			compatible = "renesas,r9a09g077-cpg-mssr";
-			reg = <0 0x80280000 0 0x1000>,
-			      <0 0x81280000 0 0x9000>;
+			reg = <0 0x80280000 0 0x10000>,
+			      <0 0x81280000 0 0x10000>;
 			clocks = <&extal_clk>;
 			clock-names = "extal";
 			#clock-cells = <2>;
-- 
2.51.0



