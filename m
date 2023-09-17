Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11616FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552CBC433C8;
	Sun, 17 Sep 2023 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979856;
	bh=Mg+BzEhSfTcVMNguMzNBOste06SrRX/lnJAEW74VTvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwZj0On4xp8Rs14u9c3fgHJOZOrXeK9/oYeM+qrt97NFF8ca8HwelUMXAaPrjtF/U
	 IRo/1fGGdZglzHUn8/9avT0ymGzT8rySep3FkRw2YWPemN/44y3kGb6TCDJ9M1+ZuN
	 cQKruKNTRuhReemAL+0lyiNjaJ0XjVzmBMPeqv78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sameer Pujar <spujar@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.5 026/285] arm64: tegra: Update AHUB clock parent and rate
Date: Sun, 17 Sep 2023 21:10:26 +0200
Message-ID: <20230917191052.552459715@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sameer Pujar <spujar@nvidia.com>

commit dc6d5d85ed3a3fe566314f388bce4c71a26b1677 upstream.

I2S data sanity test failures are seen at lower AHUB clock rates
on Tegra234. The Tegra194 uses the same clock relationship for AHUB
and it is likely that similar issues would be seen. Thus update the
AHUB clock parent and rates here as well for Tegra194, Tegra186
and Tegra210.

Fixes: 177208f7b06d ("arm64: tegra: Add DT binding for AHUB components")
Cc: stable@vger.kernel.org
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra186.dtsi |    3 ++-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi |    3 ++-
 arch/arm64/boot/dts/nvidia/tegra210.dtsi |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -135,7 +135,8 @@
 			clocks = <&bpmp TEGRA186_CLK_AHUB>;
 			clock-names = "ahub";
 			assigned-clocks = <&bpmp TEGRA186_CLK_AHUB>;
-			assigned-clock-parents = <&bpmp TEGRA186_CLK_PLL_A_OUT0>;
+			assigned-clock-parents = <&bpmp TEGRA186_CLK_PLLP_OUT0>;
+			assigned-clock-rates = <81600000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0x02900800 0x02900800 0x11800>;
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -231,7 +231,8 @@
 				clocks = <&bpmp TEGRA194_CLK_AHUB>;
 				clock-names = "ahub";
 				assigned-clocks = <&bpmp TEGRA194_CLK_AHUB>;
-				assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLA_OUT0>;
+				assigned-clock-parents = <&bpmp TEGRA194_CLK_PLLP_OUT0>;
+				assigned-clock-rates = <81600000>;
 				status = "disabled";
 
 				#address-cells = <2>;
--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -1386,7 +1386,8 @@
 			clocks = <&tegra_car TEGRA210_CLK_D_AUDIO>;
 			clock-names = "ahub";
 			assigned-clocks = <&tegra_car TEGRA210_CLK_D_AUDIO>;
-			assigned-clock-parents = <&tegra_car TEGRA210_CLK_PLL_A_OUT0>;
+			assigned-clock-parents = <&tegra_car TEGRA210_CLK_PLL_P>;
+			assigned-clock-rates = <81600000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0x702d0000 0x702d0000 0x0000e400>;


