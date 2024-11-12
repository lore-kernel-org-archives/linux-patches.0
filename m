Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1021F26E3;
	Tue, 12 Nov 2024 10:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407547; cv=none; b=hHdsQCAsOeJ4d/2Jr/fjOTw3e+XUA67OzivZTFtyMI2lNQwVmycPzbhAeep+IrPwtgrYvf+OWrO16ONLGDqug0nBuOCQ9heLaAb6liWGdjH3JRqF5fXQBqJk3t/diBTHUFdyVX06jApeb07asabZVRGqaJQ3cViEGH+h4j9m0fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407547; c=relaxed/simple;
	bh=fAOoZVtrjCpM1ftfzAWAf7ahMLssDyH2hTzLZy2PuT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CByxVvuwH7AuPGpPx0tNHmpAOLomit7y02Z5HgG8ffQJp5Q8eBswZW8n3SLqkxhduo0CvD+dK+DlvsFTNbDkr5pROMYBHIfHepUPqAMuniTr3iIxSiFDPf740I+1NScCKHgl7sozdfhM6FoWemfOCNtYKFzQtH6ttOz2fdYLeIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0plkk4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0plkk4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731F0C4CECD;
	Tue, 12 Nov 2024 10:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407546;
	bh=fAOoZVtrjCpM1ftfzAWAf7ahMLssDyH2hTzLZy2PuT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0plkk4BA7ViRLJ2rINZG/JHVTHhh7ZClgTA3HWLY8E1ZjLNN0SsIxbOWH9Q+3s6a
	 G8WMU0fcpu9s1tja24m/7VT8E6/2ExRyDW/h6OKsL/WaOjnDLF2Ov6kWrRQRwui43J
	 dfaQsRug1XmR3uvCAtUD08/ax9TRHjqmcr3VVoMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/119] arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-eaidk-610
Date: Tue, 12 Nov 2024 11:20:09 +0100
Message-ID: <20241112101848.767365478@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2f39bba3b4f037d6c3c9174eed5befcef1c79abb ]

There are no DT bindings and driver support for a "rockchip,rt5651"
codec.  Replace "rockchip,rt5651" by "realtek,rt5651", which matches the
"simple-audio-card,name" property in the "rt5651-sound" node.

Fixes: 904f983256fdd24b ("arm64: dts: rockchip: Add dts for a rk3399 based board EAIDK-610")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/a9877b8b1bd0de279d2ec8294d5be14587203a82.1727358193.git.geert+renesas@glider.be
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-eaidk-610.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-eaidk-610.dts b/arch/arm64/boot/dts/rockchip/rk3399-eaidk-610.dts
index 6464ef4d113dd..6c1043d678dda 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-eaidk-610.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-eaidk-610.dts
@@ -541,7 +541,7 @@
 	status = "okay";
 
 	rt5651: audio-codec@1a {
-		compatible = "rockchip,rt5651";
+		compatible = "realtek,rt5651";
 		reg = <0x1a>;
 		clocks = <&cru SCLK_I2S_8CH_OUT>;
 		clock-names = "mclk";
-- 
2.43.0



