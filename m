Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D671D14EC77;
	Fri, 15 Nov 2024 06:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653691; cv=none; b=seYah1H5RlFcvFPf9E45heSnbqXtg9BpkBr07udBa3TrZb5MyOURhGCQTAvV08bmOFyEKBWBZCVptLXET/ymCZZLwaxJZYbFYbtMXASWlTVjs4NVmKvJduig58ZFTfZETfhrC332oz2yaztZphoOTEaLWLQFxwkkPejE7ZLdUKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653691; c=relaxed/simple;
	bh=iXN7M5Vts4/2DbIygtVZsaYRgRBosELgDP9tX70hg9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTFCyjIBUm5uW2tzItGd4ZWiS0HzGiX/4h0TqVBSpVP5Wz3DSEAWqmQua/+VCaDCbGkMdR4WwIklbJF8GKLRcFrVrdQiJDAiOxzD/7OgszUNRANifn46u1iqJc9Uc+9WHSChcJZs9FKSCgX845L1a3CFCqeYGV6eAGrK0Cw2cwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00g9/RPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00g9/RPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483AEC4CECF;
	Fri, 15 Nov 2024 06:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653691;
	bh=iXN7M5Vts4/2DbIygtVZsaYRgRBosELgDP9tX70hg9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00g9/RPmmkh3321bFJ5Lwa+ihMc4uSAki5RoYtR/l4V+4J2J1vgrlRWqJ3CYMo30w
	 +a1j24EhYHp6H/wCkuuMNg7y5f12AT5ztGVnpID6PcGDL7cRHb+BemXm5x3EsYPWAG
	 Iv8wpSaQRJxIw7oj7BNK5hcCo1UssbvWI6ZvuFxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/82] arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-sapphire-excavator
Date: Fri, 15 Nov 2024 07:37:38 +0100
Message-ID: <20241115063725.617740372@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 73e269a8ae0cc..bcc4f31982e11 100644
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



