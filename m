Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A231BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749BFC433EF;
	Tue,  7 Mar 2023 17:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211968;
	bh=s/dvdZtBG1rkP8FlFA7iqm6QiOMuD0KvmhhE4+MbH4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0gy5yeYt9BMLxeaRK6lcKyOyI3wlubg/GWEuvnVPkhtK+vhI8RJxHYLY7KOwC26j
	 u17+u/v1FqDrxPw68mNbF52zCwS77k95QDfiu66KRPUMIoi7UIz+G09rVYOJcMD3N/
	 X0ibyi10VnUIfVN4TvdMuAYdgK4gvdjPQW6KrbvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/885] arm64: tegra: Fix duplicate regulator on Jetson TX1
Date: Tue,  7 Mar 2023 17:49:28 +0100
Message-Id: <20230307170003.145071986@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 29bcc1eaca315326d1cc883fbe9b451d1f9e3fa5 ]

When the top-level regulators were renamed, the 1.2V camera regulator
accidentally ended up with the same DT node name as the 1.8V camera
regulator.

Fixes: 097e01c61015 ("arm64: tegra: Rename top-level regulators")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
index a44c56c1e56e5..634373a423ef6 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1666,7 +1666,7 @@ vdd_hdmi: regulator-vdd-hdmi {
 		vin-supply = <&vdd_5v0_sys>;
 	};
 
-	vdd_cam_1v2: regulator-vdd-cam-1v8 {
+	vdd_cam_1v2: regulator-vdd-cam-1v2 {
 		compatible = "regulator-fixed";
 		regulator-name = "vdd-cam-1v2";
 		regulator-min-microvolt = <1200000>;
-- 
2.39.2



