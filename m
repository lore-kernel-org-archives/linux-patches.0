Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A261C2337;
	Tue,  2 Jul 2024 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941652; cv=none; b=u+bp+z76dPHonNsvMJPO3Brmq8j8eQScw2+hmdH2nZQ7O3mBaDRPnZl6SsLH4KZve2TzF9GaOVT1f81jDOHlZdv7bhKUC08qGHLOors9MujfMbP6UJp6Sk/JPMvCCH9K4vL8EWkp/DKrVT1kKqblcLVCJRkFXlwkxR8uzYQmaQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941652; c=relaxed/simple;
	bh=08eCHAD4+rpENnJB9jIFb1tA9tQoUMgclHTg1wi3STo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCWgtK9I+yWsY5r9cfaZX5e4toYK0j0bLV9HRbUA8NChqBvXpKbOe/yi/emrYPqkUi3SjvEl02I9GPybb+tnslJ14aVmY9WkzlGjDJcNEyfI2tcxZ3mLgMLzeW/n2jPa05y8V0VmVRnivpQ1KOVj+rKDx+wM+4cDKggmx9baqa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tn2QEKR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tn2QEKR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AA3C4AF4D;
	Tue,  2 Jul 2024 17:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941652;
	bh=08eCHAD4+rpENnJB9jIFb1tA9tQoUMgclHTg1wi3STo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tn2QEKR453aypN1k3sZII64wRoa3mhvPq93i9jhP7d2hLrq2lp8c/BmsuTlqdNtTy
	 MRBsPa3xvEok+99jkODEzo6APrsItkVZ6Gygoz+dZaBl6k8dLUPBSt6FEKBZ2QwSd0
	 /gTiA8KY+ASKbq3j8USrkgo8+H9wg8PR+erT5R3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/128] ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node
Date: Tue,  2 Jul 2024 19:05:27 +0200
Message-ID: <20240702170230.985902897@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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
index de9915d946f74..b98d5e357baf3 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -123,6 +123,7 @@
 		pinctrl-0 = <&hdmii2c_xfer>, <&hdmi_hpd>;
 		power-domains = <&power RK3066_PD_VIO>;
 		rockchip,grf = <&grf>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 
 		ports {
-- 
2.43.0



