Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEBD1CBE8F;
	Tue, 12 Nov 2024 10:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407582; cv=none; b=mp+Of1pdiquTWhjPEvdQ3hWaywhtmFXmUdTAVn2GbdhKueq7iac5X+/lu8fbUANDdxhB18M9Yr4qBxJuSckEajsiNtuFUgwMnze8Hh6BiG+m8HdUv0bi2ZG+bgBSDzXSk21baOUrOVHTzqUS1XYjelxCfmjB7gsSkDbu27cT+yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407582; c=relaxed/simple;
	bh=9uZaIeP0TagOgJn4304BToeqfqXpVj8W5pMH/cXWPw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ap4zMJ0r+jBWH64UEomOpZmWMYb8E3p7PaxknLmVLjJyZxAsCSUM/2jk5UM+r1y6xps3JpxWLs8TwClAgfEXHmmFfJR9b7R6ZR3oUalwwDUqTgFB3C2LJkhKnpp7xDcANdy6vWrau3MFOZJGcIBRMF9EyWTvX0vC5IM8Hlkagew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3rAYJ89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3rAYJ89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC588C4CECD;
	Tue, 12 Nov 2024 10:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407582;
	bh=9uZaIeP0TagOgJn4304BToeqfqXpVj8W5pMH/cXWPw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3rAYJ89iL1pnlFEiG6cZEmszwijUlV7ki0BWsN6mPRSoQAABHOzJxjpbV6KVLy4P
	 8Fl4+vN5sgXVxXCzGLfdFSv8VzPsdaC7alp70uG1OYtD0umnxJm6qKc4Ga+s+cBvCR
	 USKDvuABc+4tYmVl+n4Io1NLix7x/TydaEWTKjBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/119] arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-sapphire-excavator
Date: Tue, 12 Nov 2024 11:20:10 +0100
Message-ID: <20241112101848.805650170@linuxfoundation.org>
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
index dbec2b7173a0b..31ea3d0182c06 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
@@ -163,7 +163,7 @@
 	status = "okay";
 
 	rt5651: rt5651@1a {
-		compatible = "rockchip,rt5651";
+		compatible = "realtek,rt5651";
 		reg = <0x1a>;
 		clocks = <&cru SCLK_I2S_8CH_OUT>;
 		clock-names = "mclk";
-- 
2.43.0



