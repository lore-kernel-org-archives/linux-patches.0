Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1E3250BF2;
	Tue, 29 Apr 2025 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945770; cv=none; b=bPaVopP645r48ciCxr+ZOLK3sgEz4JI0Vv9ZoCoCQHhv1uquphz4h5HfCyGhygh6QovOaLUzYiBVVGRafPUuUO6PuJntfVwFwSwc4lUQ2QjZWxeaGt09iXvIT/N4/mCPS3nRuXLEvnaIo6ACpYtjFCKwjJI2XEEnDbYDe8pvFgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945770; c=relaxed/simple;
	bh=8rXFOwAJ/EVxO9QHztEonMmn8Uq+fZzvKi4dUE5LAEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smnrGBc49Np8QHDqYHvI8YSgdmSLcsfbmWXpxX7u3LfUdBME2iZCNvWrOH64SSAEsPOESe0S2EKLwi5WVbT2q3S57HPGqqKcHHaptTXSDrGLDeu0vfgdUDcdP5k42cMcUpL4IWbKoldbjYxBVTzdFnabxhDYU36vEU9gUoIfB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbqMLo/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbqMLo/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17ED5C4CEE3;
	Tue, 29 Apr 2025 16:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945770;
	bh=8rXFOwAJ/EVxO9QHztEonMmn8Uq+fZzvKi4dUE5LAEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbqMLo/MpIETgxYA7dxE/Xg4jYKzmv4Gjy+Mn+aFnPw9LSh2ONObae9tZcxjAz04Y
	 Uj57IIm6tp3YqwagnfCOiS+No/xd8UVs3a5qH0igunnTrAFEkQBVbLgLrzNRAP/SOG
	 tOmtXCbvAOoV8hVlUUDv0CK7zBJ35YTV65sqJ4AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 043/311] cpufreq: fix compile-test defaults
Date: Tue, 29 Apr 2025 18:38:00 +0200
Message-ID: <20250429161122.788940231@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit a374f28700abd20e8a7d026f89aa26f759445918 ]

Commit 3f66425a4fc8 ("cpufreq: Enable COMPILE_TEST on Arm drivers")
enabled compile testing of most Arm CPUFreq drivers but left the
existing default values unchanged so that many drivers are enabled by
default whenever COMPILE_TEST is selected.

This specifically results in the S3C64XX CPUFreq driver being enabled
and initialised during boot of non-S3C64XX platforms with the following
error logged:

	cpufreq: Unable to obtain ARMCLK: -2

Commit d4f610a9bafd ("cpufreq: Do not enable by default during compile
testing") recently fixed most of the default values, but two entries
were missed and two could use a more specific default condition.

Fix the default values for drivers that can be compile tested and that
should be enabled by default when not compile testing.

Fixes: 3f66425a4fc8 ("cpufreq: Enable COMPILE_TEST on Arm drivers")
Cc: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig.arm | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index d4d625ded285f..0d46402e30942 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -76,7 +76,7 @@ config ARM_VEXPRESS_SPC_CPUFREQ
 config ARM_BRCMSTB_AVS_CPUFREQ
 	tristate "Broadcom STB AVS CPUfreq driver"
 	depends on (ARCH_BRCMSTB && !ARM_SCMI_CPUFREQ) || COMPILE_TEST
-	default ARCH_BRCMSTB
+	default y if ARCH_BRCMSTB && !ARM_SCMI_CPUFREQ
 	help
 	  Some Broadcom STB SoCs use a co-processor running proprietary firmware
 	  ("AVS") to handle voltage and frequency scaling. This driver provides
@@ -88,7 +88,7 @@ config ARM_HIGHBANK_CPUFREQ
 	tristate "Calxeda Highbank-based"
 	depends on ARCH_HIGHBANK || COMPILE_TEST
 	depends on CPUFREQ_DT && REGULATOR && PL320_MBOX
-	default m
+	default m if ARCH_HIGHBANK
 	help
 	  This adds the CPUFreq driver for Calxeda Highbank SoC
 	  based boards.
@@ -133,7 +133,7 @@ config ARM_MEDIATEK_CPUFREQ
 config ARM_MEDIATEK_CPUFREQ_HW
 	tristate "MediaTek CPUFreq HW driver"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	default m
+	default m if ARCH_MEDIATEK
 	help
 	  Support for the CPUFreq HW driver.
 	  Some MediaTek chipsets have a HW engine to offload the steps
@@ -256,7 +256,7 @@ config ARM_TEGRA194_CPUFREQ
 	tristate "Tegra194 CPUFreq support"
 	depends on ARCH_TEGRA_194_SOC || ARCH_TEGRA_234_SOC || (64BIT && COMPILE_TEST)
 	depends on TEGRA_BPMP
-	default ARCH_TEGRA
+	default ARCH_TEGRA_194_SOC || ARCH_TEGRA_234_SOC
 	help
 	  This adds CPU frequency driver support for Tegra194 SOCs.
 
-- 
2.39.5



