Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0342123CF;
	Tue, 12 Nov 2024 10:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407220; cv=none; b=eozxikQnYJKND/flNFz+ajOAUAPrQSIxBZVeVIr9RGDV9rCqJjrM06suEwVt2+GA6B9mTqKP9p0T4GWS/FdDrNGi+RnsSkNGDfjwH5JcY/g9yZmFSAM7xjHYxY3m8+RrG8ICyrTQfsgEm9jtIlLoyFWqheK6cHgMFBPxyk74XAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407220; c=relaxed/simple;
	bh=iF4aGTEK0J/TaIgRMGPzl6Dk7+XQ6RjnTqZfbIFYEZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc34xbbxWPWi4UyRBdRZXr3Q5Xkc42ON70tbvq30axSY806dhNV9H6y/VrOT2nwxQoEcKys0WdvKbAH8uw4J12KRkYoyZIapoxkUHjh6c3Y2lwRg6zg8eBnLMkoE7u7qJJIV1/CVfl/jiRv1anT0nQ0IzNl3dzvgTiOL69rPMr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbitsCiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbitsCiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06314C4CECD;
	Tue, 12 Nov 2024 10:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407220;
	bh=iF4aGTEK0J/TaIgRMGPzl6Dk7+XQ6RjnTqZfbIFYEZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbitsCiDB1VvVGCBU6kRq7llySltiss8j8+PeNh/KvENqPUsIRTodx4Iee5BbPQiq
	 eGPSXG4WPbgLTXuyXsMNxrJKB/ZGeFGwsnsdefjmJq9X70C3tpIGLfpohPNnNd7G2p
	 Qobcdz7d6nJ714F0C0Lt2kQsMcA0D5Z6cfM1C6Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/98] arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-sapphire-excavator
Date: Tue, 12 Nov 2024 11:20:17 +0100
Message-ID: <20241112101844.361588049@linuxfoundation.org>
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



