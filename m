Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFC312D1F1;
	Tue, 30 Apr 2024 11:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476156; cv=none; b=ss17lDWwzUGBw0a2K0HPGTmbK4NvVRDyvEQ890zkzbN3W5VM1WcXNAiheQnlR8nK6YRg3lz4GhDu8yyzPKn9C8uvEaoQDVRbRHl4rgVYLu/EBXyGAPWn02hsVcl04WJkXj+9qa91IphUSMbCppZGziMzw66RPplta7woop5V2ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476156; c=relaxed/simple;
	bh=i/yR1hRtB94Pc+m5rqVYOUAnMsoPfOP5loAGqEMeLgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqOwovMAj1PXdnm2sHCvA9pdxKNM5xIwsMvHc0vPRi61JeFcvrlYKxmMuzJoC8/IPrZq2T4YIfaYQEjD0rN53fS//cdtbdZ/850Rv+kXEUJQi0pau5h/uFrmj67TfAEWxoo+xhahBffZQOhkcSFKWBwY6ucDYEOMcvVQwX8n53I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmGCQ2dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmGCQ2dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFB8C2BBFC;
	Tue, 30 Apr 2024 11:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476156;
	bh=i/yR1hRtB94Pc+m5rqVYOUAnMsoPfOP5loAGqEMeLgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmGCQ2dgq++B54nt2ldtqRsemXx2iCOQbwyU4gpGn5UPsqm4t3VdtqBMft5yzAitT
	 OgqLDftiglvhnux3Wj7GcTgUwdk/stdeK01XLWK0uziEYi1N7k6WiepNcZbogXGv0n
	 zcYw+07jMB2VRxdEOKHJmA39EYFTKWEgGKKd4a4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iskander Amara <iskander.amara@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/107] arm64: dts: rockchip: fix alphabetical ordering RK3399 puma
Date: Tue, 30 Apr 2024 12:40:12 +0200
Message-ID: <20240430103046.193748002@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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
index 365fa9a3c5bfb..ecef3d9b0b93e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -425,15 +425,6 @@
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
@@ -465,6 +456,15 @@
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



