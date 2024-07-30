Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739481A616E;
	Tue, 30 Jul 2024 16:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356249; cv=none; b=qlhDI5nxF1QD8vrpSnHm6Ru6Pon1D+hOL8+MRH3wStV3ZrxlJR9+S9TcCy4jCzPK/1IB9/SBdjIz3ctkBjy+VgRbstKKqvpELfxOxjOm/VVe5Hk8O1NrD8mHqia4FDGYQmimjd3556Xnkzl/DQeF45BGKaJh5lSu8ngr62EtPk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356249; c=relaxed/simple;
	bh=VaYpcPmBKjAWYTq0hiU42527OuOwm3Nq9nkDRjB5fNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI5gNz2ZO+lnzmKuJlQW2SppJwlzmqb8oOfYhxoDeNkModOdoP7QjtnJz0duAnMPxfKnBFHFZt2VtgFtZkloooOqpdd7C+j/cOhJ59/7E4X1bgpjvOKJeWQ1iqtXyJkBnrycTnC9fWqJFAGEnEij8M6BL7D+ZMgUbQTTMlwgfEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbiARWno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbiARWno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10C5C32782;
	Tue, 30 Jul 2024 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356249;
	bh=VaYpcPmBKjAWYTq0hiU42527OuOwm3Nq9nkDRjB5fNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbiARWnoXgj2C3aGDfmmlhLeWj4sqQOsJESXIOtzcbFwkjfouVW1AJcE0hiNx/OJt
	 dZhXXRzb5v8rV19SuhCbBEXL/N5p2agcsK8nlXhVOu03Lf5iOBvYkarpJ7k/22e1I7
	 l2Zups9ooxwBsVn4G+bX78o4H381v344p8sO4Cbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 133/809] arm64: dts: rockchip: fix pmu_io supply for Lunzn Fastrhino R6xS
Date: Tue, 30 Jul 2024 17:40:09 +0200
Message-ID: <20240730151729.869000714@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit cfeac8e5d05815521f5c5568680735a92ee91fe4 ]

Fixes pmu_io_domains supply according to the schematic. Among them,
the vccio3 is responsible for the io voltage of sdcard. There is no
sdcard slot on the R68S, and it's connected to vcc_3v3, so describe
the supply of vccio3 separately.

Fixes: c79dab407afd ("arm64: dts: rockchip: Add Lunzn Fastrhino R66S")
Fixes: b9f8ca655d80 ("arm64: dts: rockchip: Add Lunzn Fastrhino R68S")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20240630150010.55729-4-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dts  | 4 ++++
 arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r68s.dts  | 4 ++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dts b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dts
index 58ab7e9971dbc..b5e67990dd0f8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dts
@@ -11,6 +11,10 @@ aliases {
 	};
 };
 
+&pmu_io_domains {
+	vccio3-supply = <&vccio_sd>;
+};
+
 &sdmmc0 {
 	bus-width = <4>;
 	cap-mmc-highspeed;
diff --git a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
index 8f587978fa3b6..82577eba31eb5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
@@ -397,8 +397,8 @@ vcc5v0_usb_otg_en: vcc5v0-usb-otg-en {
 &pmu_io_domains {
 	pmuio1-supply = <&vcc3v3_pmu>;
 	pmuio2-supply = <&vcc3v3_pmu>;
-	vccio1-supply = <&vccio_acodec>;
-	vccio3-supply = <&vccio_sd>;
+	vccio1-supply = <&vcc_3v3>;
+	vccio2-supply = <&vcc_1v8>;
 	vccio4-supply = <&vcc_1v8>;
 	vccio5-supply = <&vcc_3v3>;
 	vccio6-supply = <&vcc_1v8>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r68s.dts b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r68s.dts
index e1fe5e442689a..a3339186e89c8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r68s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r68s.dts
@@ -102,6 +102,10 @@ eth_phy1_reset_pin: eth-phy1-reset-pin {
 	};
 };
 
+&pmu_io_domains {
+	vccio3-supply = <&vcc_3v3>;
+};
+
 &sdhci {
 	bus-width = <8>;
 	max-frequency = <200000000>;
-- 
2.43.0



