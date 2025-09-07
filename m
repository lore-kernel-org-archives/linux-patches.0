Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860221F63CD;
	Sun,  7 Sep 2025 20:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277625; cv=none; b=qicExepqvbIvzzU4l1h20FRe+79Knhlbzuca3G+c/V1cingECsUtoMRJRwar8Nqqskg2Y3kYz3aT+KXFe3BWp3wRM5JTelrdijrkWlZ9NXIjDf8Vf9ySBzHE2NoND7IXpyRTJGz9FMFEEP4eq2zfWMDbPYjdcrXe+RuHhRzqBWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277625; c=relaxed/simple;
	bh=F0iX5oX9EWX6wxQThbz6RqreE9OCml6hRmGKaF9S69A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoEOk5yT3IPUcM1SWCfTJGLs0IvPVsrDnzSpXMEAG1HKX3W8KPQqYjr7Embf/sVoYQ05Uy2aXftXA6GTIkVDy8I4l1s/gHpPL7aV3+MVnOqZ4+FQbE7an81ERr3dZsFSZoVRTYToTeBC2uA3KxPV9wafBEzV31vRkbnOYy4InwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT5/bPpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT5/bPpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BDAC4CEF0;
	Sun,  7 Sep 2025 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277625;
	bh=F0iX5oX9EWX6wxQThbz6RqreE9OCml6hRmGKaF9S69A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fT5/bPpIMoyzNGR8QUzoBrbxipOUYyCAKj3eOWbyagWSpMLjxZXJ7LrcRwujtXKWS
	 WDOZErHdO5X80yRKttvy4nu14QDUWbcYm5EMYX4M3uC9t8phSgU/jsSxBEEcx/cLDU
	 Rl0vBv625P6nMbfTY4cJ+/9PGl84EYf2Gs/Iq7Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 028/183] arm64: dts: rockchip: Add supplies for eMMC on rk3588-orangepi-5
Date: Sun,  7 Sep 2025 21:57:35 +0200
Message-ID: <20250907195616.446030837@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 2dea24df234940b27d378f786933dc10f33de6b8 ]

The eMMC description is missing both vmmc and vqmmc supplies.

Add them to complete the description.

Fixes: 236d225e1ee7 ("arm64: dts: rockchip: Add board device tree for rk3588-orangepi-5-plus")
Fixes: ea63f4666e48 ("arm64: dts: rockchip: refactor common rk3588-orangepi-5.dtsi")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20250821052939.1869171-1-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-orangepi-5.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5.dtsi
index 91d56c34a1e45..8a8f3b26754d7 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5.dtsi
@@ -365,6 +365,8 @@ &sdhci {
 	max-frequency = <200000000>;
 	mmc-hs400-1_8v;
 	mmc-hs400-enhanced-strobe;
+	vmmc-supply = <&vcc_3v3_s3>;
+	vqmmc-supply = <&vcc_1v8_s3>;
 	status = "okay";
 };
 
-- 
2.50.1



