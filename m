Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9222123CF;
	Tue, 12 Nov 2024 10:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407217; cv=none; b=EejdlbOWeWnq5Mwhxv5L3syngIDqzQ2rIBJKNVVfZY5p0kSig+WAWZP8VEVbEUmSf9HDazn/+nojwYHMb4QPCfFBOsN0Bhnm41EjDlnXYo3ehMDVjnPLWRURnOdMzCuWc+Z9EOm8Dnz8flIQz1FONRrOwu5D2H8lKAR/AZEc6iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407217; c=relaxed/simple;
	bh=LVT9DY9np2SR81yPLYSBc0yZ2lsQtRbo6vg+ayk0w9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiZqiDDcCc3n9TITcB9cNt0HIVBntmBWHxrbW0NKlGcZyGFPnqd0oXdGjU1pl+XpHmLM6+AwnaAKwmKvsOGDkX+Ywc+0raf88IA+VOteRaQo7oQ8imQvQuYNxLlbXZM9lmAoxXavPjdu3Yq4oRDXKENekPUyH5L+EjrI+c9Z658=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIL16wSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIL16wSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF039C4AF0B;
	Tue, 12 Nov 2024 10:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407217;
	bh=LVT9DY9np2SR81yPLYSBc0yZ2lsQtRbo6vg+ayk0w9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIL16wSAApLuYtRnqseSyfSndgUEjq/I6ZLkgHvgf4haztiSLldNCA3Yj32dgqfNI
	 C9cQYGRV8hA/Moe41GXTJrcB0ouZrJ+wDMlw9GThCjAtebUoYsFneBtlGnDZ0anLWB
	 ArmxrnymHbwrrLWldNnJQsakvVKg5R1tUKI8ZIdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/98] arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-eaidk-610
Date: Tue, 12 Nov 2024 11:20:16 +0100
Message-ID: <20241112101844.323635425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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
index d1f343345f674..1f156f5a8666a 100644
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



