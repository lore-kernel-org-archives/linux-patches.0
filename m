Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6352025A337;
	Tue, 25 Mar 2025 12:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905876; cv=none; b=eKnJTvycy6qu2i1s+HLD74xW/JBgefdAVSq7ujkv0QwFAicXoxls8sAp1//S7x8KNUoWtUzhySbZ7wURrnjwMHWq+r5A0nmRLmqRVI+CqDhTYAZFFp7qEKvDnocp4ZP9bR1Qx76GAWd7r2LUU1Q2omsyssqF0CY1Q3zqbf4spWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905876; c=relaxed/simple;
	bh=s1T7PwRzoAXdQnxH2+zjbWJi10fL88bJ3x3tSnEA3Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiEao1Vx8SWJ0ge1/ThX82GOzM6Tt/x4OawGr9u5C24ZTi8FOhvNecktk7Fm2WQjWNEq5171IO+V8opocc2MYolTLkyVghiEfUz0eiINih6ga+3rApp+mbPo4/p63MtJbSG45m6teiSFoWOmSB5gfPxqrOrX4CellrcMoxdRQfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuGabRU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuGabRU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1431EC4CEE9;
	Tue, 25 Mar 2025 12:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905876;
	bh=s1T7PwRzoAXdQnxH2+zjbWJi10fL88bJ3x3tSnEA3Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuGabRU9su7N5ODdjdvhwXny03GsiamegMAIvXpwCdHZMkEUuCYrhmMM+vkX78Bfu
	 lf4wxQ3k+ymDWvufE0SCR4IYUaLqJe1NJpCeGyMvAC+VsiO7wRYFz8jfa1y2m/lpAH
	 EkVIA8JT3YwkdbSW7J/Oziatv5AxcfaE7NSJ1hHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 013/119] arm64: dts: rockchip: Remove undocumented sdmmc property from lubancat-1
Date: Tue, 25 Mar 2025 08:21:11 -0400
Message-ID: <20250325122149.403820259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 43c854c65e47d2f3763345683b06257b4d12e4e3 ]

Property "supports-sd" isn't documented anywhere and is unnecessary for
mainline driver to function. It seems a property used by downstream
kernel was brought into mainline.

This should be reported by dtbs_check, but mmc-controller-common.yaml
defaults additionalProperties to true thus allows it. Remove the
property to clean the devicetree up and avoid possible confusion.

Fixes: 8d94da58de53 ("arm64: dts: rockchip: Add EmbedFire LubanCat 1")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Link: https://lore.kernel.org/r/20250228163117.47318-2-ziyao@disroot.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
index 61dd71c259aac..ddf84c2a19cfa 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
@@ -512,7 +512,6 @@ &sdhci {
 
 &sdmmc0 {
 	max-frequency = <150000000>;
-	supports-sd;
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
-- 
2.39.5



