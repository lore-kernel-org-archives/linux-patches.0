Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62726154C00;
	Fri, 15 Nov 2024 06:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652946; cv=none; b=ScvC3qdl78XYWUg5eNN7RyGzp9qr75nHlOckK6AbK6KzzmPcEGobOVbS0eDV1c6RgAPpr/Otlz3NanAfd9nKKXCvCeqCBafeKTtT3hpHJ+sTp3Nj3BH43P5LdZR9iWbPCa6Zh78x3RLWyYy4oRxsyD8ldJc28DDmAceQZtdEm4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652946; c=relaxed/simple;
	bh=dmqD3XOkzLrYxWwb3DuT/LD4xvjylwDyGN2eJxl051M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA3c18glCkuCb/RORFJVqg07pCLBlDlhWRsa/vcylvadaVyimAP4AIR5kGq2+QXYJdE80TnGxDUGZadjT8XnvoLHB/w2YaQ+N2zxAUDHYR3l2koehli0FRxDmsIPCjahozRRp96frzbSrKQ3Ap2hJzy5EjDU8rieH1jDXIpbaqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0pO3S2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0pO3S2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5962C4CECF;
	Fri, 15 Nov 2024 06:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652946;
	bh=dmqD3XOkzLrYxWwb3DuT/LD4xvjylwDyGN2eJxl051M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0pO3S2WSBGZV8CcWNe/vfl0h71B435TTz2FmqJ134wsWC0s00VubGQpz4bWTY92y
	 BsJkKCES9dLB8FL+d46EkvJwXI/lrEmlqJPO7D860n+658ra/J4GgZflRjUHYP/RA2
	 2hesj3D1DK3N8IKoxHXW0lZv3Oh8oYPNGJlipHn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/66] arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-sapphire-excavator
Date: Fri, 15 Nov 2024 07:37:10 +0100
Message-ID: <20241115063722.891313408@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 577b5761679da90e691acc939ebbe7879fff5f31 ]

There are no DT bindings and driver support for a "rockchip,rt5651"
codec.  Replace "rockchip,rt5651" by "realtek,rt5651", which matches the
"simple-audio-card,name" property in the "rt5651-sound" node.

Fixes: 0a3c78e251b3a266 ("arm64: dts: rockchip: Add support for rk3399 excavator main board")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/abc6c89811b3911785601d6d590483eacb145102.1727358193.git.geert+renesas@glider.be
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
index 808ea77f951d7..0d495716df6d1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
@@ -159,7 +159,7 @@
 	status = "okay";
 
 	rt5651: rt5651@1a {
-		compatible = "rockchip,rt5651";
+		compatible = "realtek,rt5651";
 		reg = <0x1a>;
 		clocks = <&cru SCLK_I2S_8CH_OUT>;
 		clock-names = "mclk";
-- 
2.43.0



