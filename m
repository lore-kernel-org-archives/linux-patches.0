Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D596D82C60;
	Tue, 29 Apr 2025 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947635; cv=none; b=S09zmz6iAD+BO+OXgaYTn+HZKQGWHEiupMfoCqoZmGIMRbdyxS1FrNwMCxQJU+ny5Tsxyjs8XTr/0cjpzM3/C46BKg2JfkP97qZTpxnZwJAzvAmsLXNeD0mAZj01UNz2nhfRmjkehCOeub5h63NTB7ijDwo+pZSCcHHfa3Sis9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947635; c=relaxed/simple;
	bh=R+VoeLLeDuJnBfVhiVhjg+mcJcAB9846Urxyn9NZAbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIU1nJ8gAg3Sgit6avmGZEvAOkFjNPNBNiRXikdvymGgMRi69KOj87scmkMwACGhP/Fcg8gu2byfeYCyCpvhejSDay403QIFKW1AENkNENanvzy55vGLDIY/yH5pzUVdXECPoMlAm3MPGZ1N1OOavrf43WfvyVGVomfZpRj5eDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHBn79wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHBn79wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9C5C4CEE3;
	Tue, 29 Apr 2025 17:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947635;
	bh=R+VoeLLeDuJnBfVhiVhjg+mcJcAB9846Urxyn9NZAbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHBn79wp/o5TNF9/jV9Syzi1eiQ3Hdhja8/R3xbQQ7EXynqOMM6ljHDZgfi7HF5+m
	 6ItUHX9Eb4bMxqQugl5PZwxC9AfOt2BpG9G6fgQct6qZyWp6k/PIbpjxOeKcyQeuQO
	 BlksfqssxrO6Yy9YXrPwJKaf92Qizv1Cz32cI1Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/280] cpufreq: Do not enable by default during compile testing
Date: Tue, 29 Apr 2025 18:39:59 +0200
Message-ID: <20250429161117.489149103@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e67b2326671c9..f6e6066e2e64b 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -67,7 +67,7 @@ config ARM_VEXPRESS_SPC_CPUFREQ
 config ARM_BRCMSTB_AVS_CPUFREQ
 	tristate "Broadcom STB AVS CPUfreq driver"
 	depends on (ARCH_BRCMSTB && !ARM_SCMI_CPUFREQ) || COMPILE_TEST
-	default y
+	default ARCH_BRCMSTB
 	help
 	  Some Broadcom STB SoCs use a co-processor running proprietary firmware
 	  ("AVS") to handle voltage and frequency scaling. This driver provides
@@ -172,7 +172,7 @@ config ARM_RASPBERRYPI_CPUFREQ
 config ARM_S3C64XX_CPUFREQ
 	bool "Samsung S3C64XX"
 	depends on CPU_S3C6410 || COMPILE_TEST
-	default y
+	default CPU_S3C6410
 	help
 	  This adds the CPUFreq driver for Samsung S3C6410 SoC.
 
@@ -181,7 +181,7 @@ config ARM_S3C64XX_CPUFREQ
 config ARM_S5PV210_CPUFREQ
 	bool "Samsung S5PV210 and S5PC110"
 	depends on CPU_S5PV210 || COMPILE_TEST
-	default y
+	default CPU_S5PV210
 	help
 	  This adds the CPUFreq driver for Samsung S5PV210 and
 	  S5PC110 SoCs.
@@ -205,7 +205,7 @@ config ARM_SCMI_CPUFREQ
 config ARM_SPEAR_CPUFREQ
 	bool "SPEAr CPUFreq support"
 	depends on PLAT_SPEAR || COMPILE_TEST
-	default y
+	default PLAT_SPEAR
 	help
 	  This adds the CPUFreq driver support for SPEAr SOCs.
 
@@ -224,7 +224,7 @@ config ARM_TEGRA20_CPUFREQ
 	tristate "Tegra20/30 CPUFreq support"
 	depends on ARCH_TEGRA || COMPILE_TEST
 	depends on CPUFREQ_DT
-	default y
+	default ARCH_TEGRA
 	help
 	  This adds the CPUFreq driver support for Tegra20/30 SOCs.
 
@@ -232,7 +232,7 @@ config ARM_TEGRA124_CPUFREQ
 	bool "Tegra124 CPUFreq support"
 	depends on ARCH_TEGRA || COMPILE_TEST
 	depends on CPUFREQ_DT
-	default y
+	default ARCH_TEGRA
 	help
 	  This adds the CPUFreq driver support for Tegra124 SOCs.
 
@@ -247,14 +247,14 @@ config ARM_TEGRA194_CPUFREQ
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



