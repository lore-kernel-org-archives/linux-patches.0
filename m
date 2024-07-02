Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C3915218A;
	Tue,  2 Jul 2024 17:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941200; cv=none; b=vFfqdtJ2kHt88XE0hSh4m27Hxy9/JLrAoQkSohTDrJyn/8mIkKR2LTS9wpLBCv7FrZooMOy3CASIj2K+PxH16OFOMAotAV6hzb8uQs/w+Jys/w17EweSfDDChPil02yD8dKo8Wa6/OsU/qhy6BxnrfdSgw5WWHvX5unayD64JQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941200; c=relaxed/simple;
	bh=e3Qc6NYa8bAg1arZhvNMoAJP8V4c6VoBKmSC1d6GXtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPtuvsxnoBElc2CWzc7jxaAZcJXHDuZXlRNJRke6Zjt5TZtyaOMFqD5+eNgzjOs8GZbKdLg/Y9Tv6agfjky7gAF51xJalyLYoVwGdAjcbE4Xy6+PRV8dTRfqv7S5Uxf68ftPOktx9wlIv5gvzZibSgXpRvUgSHylj4NHnkBOYgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D94VRVtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D94VRVtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61F7C4AF07;
	Tue,  2 Jul 2024 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941200;
	bh=e3Qc6NYa8bAg1arZhvNMoAJP8V4c6VoBKmSC1d6GXtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D94VRVtdl0awtTzhu+i6kwUZHdMEsI1WPBYGYWEkOapIorkeI5PQn/jzJzsMeL67N
	 dkSuRexR1mZJHr96yzyFCPdoB9PO1DunWmp7LtHiGOvZiyB8NM5CdKzt91RURRgNua
	 t4c+Tjb7zhJonQXp0dJUJxj5glkDSWvlAu67r4xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/163] ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node
Date: Tue,  2 Jul 2024 19:04:31 +0200
Message-ID: <20240702170239.004752698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index de9915d946f74..b98d5e357baf3 100644
--- a/arch/arm/boot/dts/rockchip/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3066a.dtsi
@@ -123,6 +123,7 @@
 		pinctrl-0 = <&hdmii2c_xfer>, <&hdmi_hpd>;
 		power-domains = <&power RK3066_PD_VIO>;
 		rockchip,grf = <&grf>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 
 		ports {
-- 
2.43.0



