Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D1E39847;
	Tue,  2 Jul 2024 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940619; cv=none; b=peC0EoIkNUlMT1PfusI9fvSIdI1rZ2F3hFzjDvxAgPmtwcVIkRuUCi4m79b+tiuXaw2pEWVLq+a1OW5QOJuH5xZ0shtfzW19rueLRNKD5pgve3qPUajxMYCpbuGpPJwpofCNQuqaWAKQdoC98prObFqtBAmimXDMeagAv1B1Sx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940619; c=relaxed/simple;
	bh=6qV1Zq4lxHusgA7cwV4KOzN5yTqMHtltNiM3C2M1xTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qp4M566sLIueNu31xfNE0tgHXh5UzfQZpulQAWNb6CcQnMeRRh0fyX50+7MhtQTUPib59fsTmZEgl1yBaG2EreEJWP5fgTgkPvOnQCMRda7ZdFBSl6dY7Ut4QmjF7s+l39Nuwkwh2qzAce179iEB9KaxF7RARqeMp1MUhPMiN74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLG5OCfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLG5OCfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F38C4AF07;
	Tue,  2 Jul 2024 17:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940619;
	bh=6qV1Zq4lxHusgA7cwV4KOzN5yTqMHtltNiM3C2M1xTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLG5OCfR9xvktGuCx83vnJSc+i+ZRFR0rL2TdsWVZTKjyG62wUw55LIO3zGNUuEkh
	 /eThB6ZsSmjDL6000mKKLStVMpcFuxbdBugsd1kXUxfcZrBuxMT02C2sYE4stJTIQG
	 Pk0zA/UBQKZqOzgCuvsiRfukXn2E/E8MmGmodVY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 209/222] ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node
Date: Tue,  2 Jul 2024 19:04:07 +0200
Message-ID: <20240702170251.975913171@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit cca46f811d0000c1522a5e18ea48c27a15e45c05 ]

'#sound-dai-cells' is required to properly interpret
the list of DAI specified in the 'sound-dai' property,
so add them to the 'hdmi' node for 'rk3066a.dtsi'.

Fixes: fadc78062477 ("ARM: dts: rockchip: add rk3066 hdmi nodes")
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/8b229dcc-94e4-4bbc-9efc-9d5ddd694532@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rockchip/rk3066a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rockchip/rk3066a.dtsi b/arch/arm/boot/dts/rockchip/rk3066a.dtsi
index 30139f21de64d..15cbd94d7ec05 100644
--- a/arch/arm/boot/dts/rockchip/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3066a.dtsi
@@ -128,6 +128,7 @@
 		pinctrl-0 = <&hdmii2c_xfer>, <&hdmi_hpd>;
 		power-domains = <&power RK3066_PD_VIO>;
 		rockchip,grf = <&grf>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 
 		ports {
-- 
2.43.0



