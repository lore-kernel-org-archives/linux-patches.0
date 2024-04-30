Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5A612C805;
	Tue, 30 Apr 2024 11:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475245; cv=none; b=FEgQ/Pgaf04D2IprExmG1Dip0e9YYF9LP7vvc5U2xiME5rdGSIh4BJG55YlGDOCyALHG93d4uPSU01nH2kAiLk5/BSSm7i8NPu00FS5G6pXrJilJoqgID1B1ctS+Vw4iHN6kcdvXduMHp4RshmPgZGcWgjwsaqYgtYYaqp2S3qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475245; c=relaxed/simple;
	bh=S1tArmvi2Xu+7D3Lrh7MrDHu0MDKttTpEwEljJPPrY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tteqWeFRIlOvJHZ083VisYh24f+icPkQ1ilsPC8BaQPfksrmzX/SYbZgDaTE7Bj7k4fU1ZZ4InJad/swyDG9ouhMmHyhnEN6kh61hY68heYP26AXApJJYBOXvIvh2M42CkS+lBcsp7/Kl5p7PxBEFOctB/QqRCabG+2F9a7hefY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2CIWTCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2CIWTCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8E2C4AF18;
	Tue, 30 Apr 2024 11:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475245;
	bh=S1tArmvi2Xu+7D3Lrh7MrDHu0MDKttTpEwEljJPPrY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2CIWTCjxUDosZJDxi20two7VAuRfgW9MvpBxPzAsA0dfczImMiK9E0uBPrZqMiXa
	 qXho2mLheOlP80J5E7JdT2mlVEZre7tMqlEuBIfYDsF1wWT6N1lyTBMmoO50hYNVyg
	 5/f1luPXIEnx5vHm96P+jbuDNEpPSwyWZw5bbyCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iskander Amara <iskander.amara@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/186] arm64: dts: rockchip: fix alphabetical ordering RK3399 puma
Date: Tue, 30 Apr 2024 12:37:40 +0200
Message-ID: <20240430103058.260163775@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
index 9b9d70bf7f0ca..2979e6f4f96ce 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -401,15 +401,6 @@
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
@@ -448,6 +439,15 @@
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



