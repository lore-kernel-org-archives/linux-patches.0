Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3D5250BF2;
	Tue, 29 Apr 2025 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945767; cv=none; b=KmS58jcZquz36qgU/zRd0ExiPZLt4n8eJeuo7+My1XHBf3QvkN1BnP1dpk/U3YWHx71YbT9bGMeMIb6yfPy4khD16vNo30D7+0EhwPZRJ8F7dGSzJXgi8ZHHJp/EPI/H1Ob2GsbwZOt1cxk15E1eN2TMaxNHOUIuAcBf9icEoMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945767; c=relaxed/simple;
	bh=wLaVp3v2XUQ9tJbW9U8jjx+aV7znrg5Tp+87LPAxiak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyFJfP0O4mkVeb9GLNIJzAs3Tg8KbIVEVg8kMS0q2STATutpfuQxRra2hZ5bCwEUdp8O2jvZQjoofRawsDR0OCvXo9w8b/UkB6SMPuJIQzwGE0ldoHoQjuFmD2EDeYw1VBGQGoGGYJnS07UDEuoISg/9+Aj6Pwb/kFsoTwLpZQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuuugWe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuuugWe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C071C4CEE3;
	Tue, 29 Apr 2025 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945767;
	bh=wLaVp3v2XUQ9tJbW9U8jjx+aV7znrg5Tp+87LPAxiak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuuugWe4wmAW6GYWoplrCs9ilXeCimb6291mdsY08JvpsJ2Sd89VWUkQ1dXPYsa/w
	 fy2MSh3x4A/L30X+XbKba1DzCmkk53V1Hsj4QGuwQzGNo6q8LztBS18kfYnX/f6RFV
	 I7a35J+hRoA1oKWDnC8YiM22y2b8b7PjMylg/yPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 042/311] cpufreq: Do not enable by default during compile testing
Date: Tue, 29 Apr 2025 18:37:59 +0200
Message-ID: <20250429161122.748385287@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit d4f610a9bafdec8e3210789aa19335367da696ea ]

Enabling the compile test should not cause automatic enabling of all
drivers.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: a374f28700ab ("cpufreq: fix compile-test defaults")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig.arm | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 4f9cb943d945c..d4d625ded285f 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -76,7 +76,7 @@ config ARM_VEXPRESS_SPC_CPUFREQ
 config ARM_BRCMSTB_AVS_CPUFREQ
 	tristate "Broadcom STB AVS CPUfreq driver"
 	depends on (ARCH_BRCMSTB && !ARM_SCMI_CPUFREQ) || COMPILE_TEST
-	default y
+	default ARCH_BRCMSTB
 	help
 	  Some Broadcom STB SoCs use a co-processor running proprietary firmware
 	  ("AVS") to handle voltage and frequency scaling. This driver provides
@@ -181,7 +181,7 @@ config ARM_RASPBERRYPI_CPUFREQ
 config ARM_S3C64XX_CPUFREQ
 	bool "Samsung S3C64XX"
 	depends on CPU_S3C6410 || COMPILE_TEST
-	default y
+	default CPU_S3C6410
 	help
 	  This adds the CPUFreq driver for Samsung S3C6410 SoC.
 
@@ -190,7 +190,7 @@ config ARM_S3C64XX_CPUFREQ
 config ARM_S5PV210_CPUFREQ
 	bool "Samsung S5PV210 and S5PC110"
 	depends on CPU_S5PV210 || COMPILE_TEST
-	default y
+	default CPU_S5PV210
 	help
 	  This adds the CPUFreq driver for Samsung S5PV210 and
 	  S5PC110 SoCs.
@@ -214,7 +214,7 @@ config ARM_SCMI_CPUFREQ
 config ARM_SPEAR_CPUFREQ
 	bool "SPEAr CPUFreq support"
 	depends on PLAT_SPEAR || COMPILE_TEST
-	default y
+	default PLAT_SPEAR
 	help
 	  This adds the CPUFreq driver support for SPEAr SOCs.
 
@@ -233,7 +233,7 @@ config ARM_TEGRA20_CPUFREQ
 	tristate "Tegra20/30 CPUFreq support"
 	depends on ARCH_TEGRA || COMPILE_TEST
 	depends on CPUFREQ_DT
-	default y
+	default ARCH_TEGRA
 	help
 	  This adds the CPUFreq driver support for Tegra20/30 SOCs.
 
@@ -241,7 +241,7 @@ config ARM_TEGRA124_CPUFREQ
 	bool "Tegra124 CPUFreq support"
 	depends on ARCH_TEGRA || COMPILE_TEST
 	depends on CPUFREQ_DT
-	default y
+	default ARCH_TEGRA
 	help
 	  This adds the CPUFreq driver support for Tegra124 SOCs.
 
@@ -256,14 +256,14 @@ config ARM_TEGRA194_CPUFREQ
 	tristate "Tegra194 CPUFreq support"
 	depends on ARCH_TEGRA_194_SOC || ARCH_TEGRA_234_SOC || (64BIT && COMPILE_TEST)
 	depends on TEGRA_BPMP
-	default y
+	default ARCH_TEGRA
 	help
 	  This adds CPU frequency driver support for Tegra194 SOCs.
 
 config ARM_TI_CPUFREQ
 	bool "Texas Instruments CPUFreq support"
 	depends on ARCH_OMAP2PLUS || ARCH_K3 || COMPILE_TEST
-	default y
+	default ARCH_OMAP2PLUS || ARCH_K3
 	help
 	  This driver enables valid OPPs on the running platform based on
 	  values contained within the SoC in use. Enable this in order to
-- 
2.39.5



