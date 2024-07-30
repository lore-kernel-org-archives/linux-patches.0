Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B772F1917DB;
	Tue, 30 Jul 2024 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355875; cv=none; b=jHEzbK6KJ4CcsZh7tLHxSuY990NpnK2oV2z0jJ4HWn0u6PxAg8WTthqU+TAnWR3LfgYHV1ajtK4kGp966ERDWq5wc5rNphWDVvwENncuqo25EPMyMu1NpmWB0iCkHlNJIEAK3gfu3U/b6F+Dq4IsAnd7Er35s0jB1B/A67dfEGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355875; c=relaxed/simple;
	bh=DRiDqLy0PT6MT422iL1Z/bWJ8nZ9uiX8574SO9OPoW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnSGvKbGb/JxkXDIHYYKtGcJ1CqjpJ9w2nb3p2KsLjAFxBRptSsDR51klVWfk4S0s3Tn6ZSbLC/PRFIH3BAr0q5xT6jJyGsl3VjH+obaVPRmVewZP9syQtjI2mJVSYgrOeM9vagha1Y4OmTBOlUjsyRsWaDj7NkerKFW4Pghy0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EI5/kV9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EI5/kV9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27801C32782;
	Tue, 30 Jul 2024 16:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355875;
	bh=DRiDqLy0PT6MT422iL1Z/bWJ8nZ9uiX8574SO9OPoW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EI5/kV9YXwYIMmtN10MF9Rhse+SNUNXiV1FiLn6TqIzD9DfazoEMXUs7dcCHL0oT/
	 P75nxrFQaaRa02F6hKZicWu3MbaZlb2/NGc22quvFOfkcXMhG5k+Ppt37oWYe1zsia
	 Ed+4pWi22LxXB/Hr6U80CPo077BHV33FlatwDKo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/568] arm64: dts: rockchip: fix pmu_io supply for Lunzn Fastrhino R6xS
Date: Tue, 30 Jul 2024 17:43:25 +0200
Message-ID: <20240730151643.707310267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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



