Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5981F7065;
	Tue,  3 Dec 2024 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238166; cv=none; b=hRxbY7Cv0lUT+NAQgGvTNxyUeGEgnflbdl6t0DrrSajhSCfAWo6V+HHvsLfwsp4vEgmp5N4fTlfcm2HmYwty4WEcjF+wqIIipeTbiiasakkpnDxxbc5aNE5+00cT5T1qEsjrJ81Hewy8xhsppNU8+A/VtwNu4x9ds8mzLbfZhQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238166; c=relaxed/simple;
	bh=Vwt0M0d/d7s3VKB9Ebb+cJPZDguY/PEpXFZbpzY0cQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CU/lp0hWizO3rSeJy+A7+Hq5LS9RVUgGRicqN/8/XPgyizQwqTfR2uelseITRCtft7UXr9TtJXw1dJr9DglrrDQAmEZtFO+mfZiazOde/qww7FZL/6AzId4TtIj4svsVOUF6uqDp04MzbguAn8w+M3jkRMi1lUZ9vKFEY8rtfL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXyg3VV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXyg3VV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE44C4CECF;
	Tue,  3 Dec 2024 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238166;
	bh=Vwt0M0d/d7s3VKB9Ebb+cJPZDguY/PEpXFZbpzY0cQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXyg3VV4xxdnQrJBVHu/t/pNv7c0RrU67Hj9vcHjmJWulPN5q2Dti6YKz6yz4dMtR
	 O/m3HPqiLn99oec8Q1ms8WarvEVcPbGW6hRvt1CjnF4DIcCpljBgwyyZ8BgH/FsX2o
	 UkJGEq2YAKnvePBXLX+9e7jQN6FIWSpdL+XNybic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 185/817] arm64: dts: ti: k3-j721e: Fix clock IDs for MCSPI instances
Date: Tue,  3 Dec 2024 15:35:57 +0100
Message-ID: <20241203144002.953098981@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anurag Dutta <a-dutta@ti.com>

[ Upstream commit ab09a68f3be04b2f9d1fc7cfc0e2225025cb9421 ]

The clock IDs for multiple MCSPI instances across wakeup domain
in J721e are incorrect when compared with documentation [1]. Fix
the clock ids to their appropriate values.

[1]https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j721e/clocks.html

Fixes: 76aa309f9fa7 ("arm64: dts: ti: k3-j721e: Add MCSPI nodes")

Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Link: https://lore.kernel.org/r/20241023104532.3438851-3-a-dutta@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
index 6b6ef6a306142..e71696a8bb833 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
@@ -654,7 +654,7 @@ mcu_spi0: spi@40300000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 274 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 274 0>;
+		clocks = <&k3_clks 274 1>;
 		status = "disabled";
 	};
 
@@ -665,7 +665,7 @@ mcu_spi1: spi@40310000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 275 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 275 0>;
+		clocks = <&k3_clks 275 1>;
 		status = "disabled";
 	};
 
@@ -676,7 +676,7 @@ mcu_spi2: spi@40320000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 276 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 276 0>;
+		clocks = <&k3_clks 276 1>;
 		status = "disabled";
 	};
 
-- 
2.43.0



