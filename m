Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBCE82C60;
	Tue, 29 Apr 2025 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947639; cv=none; b=iSbHXyhU3x+ICEZfIm6tzFR6ZGTtoJDeR4RWiOXolWkiaVfVgAgt/WWnCm+666rickeIjXpJQDOiTUFNtJrvv/K6lAE8oCD8Bj1N0CuevjzzZqYVCYt27z8oCIVHeYxWf7MH6i6goONVNbVJQ/2DsLscPFzirhmGF1yMpCaAwSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947639; c=relaxed/simple;
	bh=XEgV/arYb4KvN1lYw5GrhHeB0j4d+2ZrvJi6rVBgAS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alx/uST2cuUhDXQVGL/Uny6Y8VD5QwsgEy88z5XquGk0s25oPy1LCoBoiEnzDe3zCSSG/XyUnI+NjALdCssscKeoCh1zc1Z/icqPKG+8HYn+VmeMzZrSVRyU9q3OuSHas8Zss0Vjbab18mBonjl3jfM/CJOjzzaHaNuOF6S3PoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGkXv7cN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGkXv7cN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4CCC4CEE3;
	Tue, 29 Apr 2025 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947639;
	bh=XEgV/arYb4KvN1lYw5GrhHeB0j4d+2ZrvJi6rVBgAS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGkXv7cN3BRMuMTNZ/rezP8WlmV1s5Uikgd+4iwTj0sOlGYJcXKPprfHTUS2rz1nb
	 2WjhB6CzefXzpmoAbXaEB5mrRHD1BxkA37DwUb6tiLlJiX2jjVZT33ljTDUYPIfW5V
	 1QIC20gaxpORCaaDPVHXTPhMevjyGWAosdriYkVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/280] cpufreq: fix compile-test defaults
Date: Tue, 29 Apr 2025 18:40:00 +0200
Message-ID: <20250429161117.528235976@linuxfoundation.org>
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
index f6e6066e2e64b..71f4b612dd971 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -67,7 +67,7 @@ config ARM_VEXPRESS_SPC_CPUFREQ
 config ARM_BRCMSTB_AVS_CPUFREQ
 	tristate "Broadcom STB AVS CPUfreq driver"
 	depends on (ARCH_BRCMSTB && !ARM_SCMI_CPUFREQ) || COMPILE_TEST
-	default ARCH_BRCMSTB
+	default y if ARCH_BRCMSTB && !ARM_SCMI_CPUFREQ
 	help
 	  Some Broadcom STB SoCs use a co-processor running proprietary firmware
 	  ("AVS") to handle voltage and frequency scaling. This driver provides
@@ -79,7 +79,7 @@ config ARM_HIGHBANK_CPUFREQ
 	tristate "Calxeda Highbank-based"
 	depends on ARCH_HIGHBANK || COMPILE_TEST
 	depends on CPUFREQ_DT && REGULATOR && PL320_MBOX
-	default m
+	default m if ARCH_HIGHBANK
 	help
 	  This adds the CPUFreq driver for Calxeda Highbank SoC
 	  based boards.
@@ -124,7 +124,7 @@ config ARM_MEDIATEK_CPUFREQ
 config ARM_MEDIATEK_CPUFREQ_HW
 	tristate "MediaTek CPUFreq HW driver"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	default m
+	default m if ARCH_MEDIATEK
 	help
 	  Support for the CPUFreq HW driver.
 	  Some MediaTek chipsets have a HW engine to offload the steps
@@ -247,7 +247,7 @@ config ARM_TEGRA194_CPUFREQ
 	tristate "Tegra194 CPUFreq support"
 	depends on ARCH_TEGRA_194_SOC || ARCH_TEGRA_234_SOC || (64BIT && COMPILE_TEST)
 	depends on TEGRA_BPMP
-	default ARCH_TEGRA
+	default ARCH_TEGRA_194_SOC || ARCH_TEGRA_234_SOC
 	help
 	  This adds CPU frequency driver support for Tegra194 SOCs.
 
-- 
2.39.5



