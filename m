Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F385412C522;
	Tue, 30 Apr 2024 10:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473788; cv=none; b=b1PgY0K8BuuIu7Z5HklQw99Gd/FKlzPKL3IL52Ed+Cykya7p3utMjwxThp6nvcTXhRPCPPrbTs/58avnsc93+9zFiGV2nLqvSR91PSe+rhM8qPPOiKgRdoEujai1l2FdBpq8Ko17Kdt+TMKVNMOM0AbIKgHmYBqikpL5WFHt834=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473788; c=relaxed/simple;
	bh=6B3mMClnh3UMRRhBTXFaMZ+EHLX/GS+nm9AN7vMI57Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhbTDei1T2YrhMPxoJdRAcFogrx355m5oNLIGqhHtJhq0eSREpzoKFTY16eqajWfDQU1JCtKLvLycJRzsgjFgGs2Gt/3AFWHFxATZIh07zgFr8MbJGjKDnNVRBhk+jZuJuS4uHiaGnFnQ+ofKjIuj3WCwPHZ6q1d40iwAh2N3hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDub6lAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDub6lAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB79C2BBFC;
	Tue, 30 Apr 2024 10:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473787;
	bh=6B3mMClnh3UMRRhBTXFaMZ+EHLX/GS+nm9AN7vMI57Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDub6lAMD1dGeGJkn+eeZC7io9dqjcavCsJ7wSwfo4wderhYHdMD1hLo4N62rKacC
	 JBDG+jOfVffbPfJx9oxsseNbR99EtWbkpZ/60Ek5V0yMsrolL5eQvfNfXF+RcT7sjj
	 ivJaqmO4Nb34lzyx9E8gLsQ5V9YrKwJj+eKpcJyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iskander Amara <iskander.amara@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/77] arm64: dts: rockchip: fix alphabetical ordering RK3399 puma
Date: Tue, 30 Apr 2024 12:39:17 +0200
Message-ID: <20240430103042.257882267@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iskander Amara <iskander.amara@theobroma-systems.com>

[ Upstream commit f0abb4b2c7acf3c3e4130dc3f54cd90cf2ae62bc ]

Nodes overridden by their reference should be ordered alphabetically to
make it easier to read the DTS. pinctrl node is defined in the wrong
location so let's reorder it.

Signed-off-by: Iskander Amara <iskander.amara@theobroma-systems.com>
Reviewed-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240308085243.69903-2-iskander.amara@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 945a7c857091 ("arm64: dts: rockchip: enable internal pull-up on PCIE_WAKE# for RK3399 Puma")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 6750b8100421c..b79017c41ce56 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -426,15 +426,6 @@
 	gpio1830-supply = <&vcc_1v8>;
 };
 
-&pmu_io_domains {
-	status = "okay";
-	pmu1830-supply = <&vcc_1v8>;
-};
-
-&pwm2 {
-	status = "okay";
-};
-
 &pinctrl {
 	i2c8 {
 		i2c8_xfer_a: i2c8-xfer {
@@ -466,6 +457,15 @@
 	};
 };
 
+&pmu_io_domains {
+	status = "okay";
+	pmu1830-supply = <&vcc_1v8>;
+};
+
+&pwm2 {
+	status = "okay";
+};
+
 &sdhci {
 	/*
 	 * Signal integrity isn't great at 200MHz but 100MHz has proven stable
-- 
2.43.0



