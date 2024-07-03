Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6444194A6F;
	Wed,  3 Jul 2024 10:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004310; cv=none; b=YT9qEf7idXC7aJ1+8SJetpRiTjo9uRvLzm2W+zMZwLmTwZXRdN7OSaZTacQPZCs2SsfWSSjn/lwIHyBu3i3in+U/5yPZFmPERSfJMWDDVWLthj8TsiUx8JnYCIfyE9F43yCRHqEbT6LeFH0JHwchCsoZjWwc/92WbJG6e7kvo+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004310; c=relaxed/simple;
	bh=5SM6DP9uAp2JT09avHlRr8j5zYnrcCO3v7RLmpEJ+Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcaMXGX6RM3b+goCT5kmbDrN/vZlFyxrVgqn6YVaIqro1VBHIsiwNPwIqMbXRUSI0PYQzEDF1B7HsGETBRUfQFkCyhDv90Uie047Td4fLV0NZkWA2l2fStZIIzlFb2Hf2phSXf+p041eei7Tkvm/F62be1+72ZKVPIRfkAr5Cdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftcQDZ07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftcQDZ07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C10AC4AF0B;
	Wed,  3 Jul 2024 10:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004309;
	bh=5SM6DP9uAp2JT09avHlRr8j5zYnrcCO3v7RLmpEJ+Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftcQDZ07zf+rrtyRCZTsWjBjr5vyXcdfYlsxmjVmP2ZXVjb20TRXwBW892bKMKl15
	 /J4FOGXMcnBJnGfuDl1Xx0Tnrip9D1y81FMP2f7RsErTqdTHnA3L6aBL7XPv0odRYy
	 v5UsNNq6ZKMFT9/VUh0gmRv/47366fgvajwoPYUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/189] ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node
Date: Wed,  3 Jul 2024 12:40:49 +0200
Message-ID: <20240703102848.569429520@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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
 arch/arm/boot/dts/rk3066a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
index 1ac9deb3bd39a..055687d3153fb 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -124,6 +124,7 @@
 		pinctrl-0 = <&hdmii2c_xfer>, <&hdmi_hpd>;
 		power-domains = <&power RK3066_PD_VIO>;
 		rockchip,grf = <&grf>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 
 		ports {
-- 
2.43.0



