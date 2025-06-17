Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B250C2E8E10;
	Tue, 17 Jun 2025 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177786; cv=none; b=EKcoCFWRT1+XbO3pJCjbvfJA5YI12YFF+pShzcvO3qadkDop5CvPdbeQkpiFirZboZnVFUwy/KnibkjMV+2HKPbjBOpDG999ojiXW+pnQXbvDS0K1aYZcS4+K8+z4l15RKRpZYmcvt6fDlhksdgxcbwPd1QuhqiIQi2liDRfurM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177786; c=relaxed/simple;
	bh=bQQVny4vHOsqRdx2iArXo7MK7R0sGnUKWMMv0WxNvs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxLVLKF5cjkS31ibeJXkSpUOOZyg63mTVN1Vw96RlifbkoKNYfXhl0HvOBNUwPcwcSam7xR+oNWVn7+TZ3XLzQ10qxKdv+wMmZ4w/b1zzfyHtVOpVc6tDpnIpAOoybx9wauoffSsNA6wtOP22RULEoo7xAYHh1OrIdRzAnZt1gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npfwkoVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npfwkoVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C3EC4CEF0;
	Tue, 17 Jun 2025 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177786;
	bh=bQQVny4vHOsqRdx2iArXo7MK7R0sGnUKWMMv0WxNvs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npfwkoVTS14j8FK2TrdVrMHd9tHkc5/t6XgzNI5a8H72t8oWp9jnopKqdu6+iXNZ5
	 0VRLk+pPqQaoP/jzLX3zhOeDrPtpGYcS6R8mVYPi20LgpmLnOhobA/GkDlia/PRDf5
	 lS5p82kGD3kY36zENNleVqK4tpktHwsAjjpxOPAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 363/780] arm64: dts: rockchip: Move SHMEM memory to reserved memory on rk3588
Date: Tue, 17 Jun 2025 17:21:11 +0200
Message-ID: <20250617152506.241111342@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 8ecd096d018be8a6bd3bd930f3a41a85db66a67d ]

0x0 to 0xf0000000 are SDRAM memory areas where 0x10f000 is located.
So move the SHMEM memory of arm_scmi to the reserved memory node.

Fixes: c9211fa2602b ("arm64: dts: rockchip: Add base DT for rk3588 SoC")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20250401090009.733771-2-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index 1e18ad93ba0eb..c52af310c7062 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -439,16 +439,15 @@
 		#clock-cells = <0>;
 	};
 
-	pmu_sram: sram@10f000 {
-		compatible = "mmio-sram";
-		reg = <0x0 0x0010f000 0x0 0x100>;
-		ranges = <0 0x0 0x0010f000 0x100>;
-		#address-cells = <1>;
-		#size-cells = <1>;
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
 
-		scmi_shmem: sram@0 {
+		scmi_shmem: shmem@10f000 {
 			compatible = "arm,scmi-shmem";
-			reg = <0x0 0x100>;
+			reg = <0x0 0x0010f000 0x0 0x100>;
+			no-map;
 		};
 	};
 
-- 
2.39.5



