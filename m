Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815EC35C1A0;
	Wed, 20 May 2026 17:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297482; cv=none; b=mWijparVmJZBX1LWbdLlaGwT5NBHuOcKgH9A9k5a1+hfJ2d/NKZUR9af13tu3UvFugiHHYRRckwhYexCHEZo5XP84RTCDklRoQeQncD3Bda1Xv0QXeCpbLLZCUH0vWumHsiTnFcFEkjBRAD7+9oe4Yd/GFY04DZ2eJbxeokQhh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297482; c=relaxed/simple;
	bh=WSs0proA4pVZUB4bVEHydbaQSrx44H7ffM20dTtDLmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgHYoa1A/uVjxud07z28Wz3vU+Kj7XN/LWhAXrJruTCFZuht0KzgaLcFeUYqYuyUYyN3whk0A9rJU5S2BFAXW46dje6tgJqyPOGIxaHuMquxKhFuP+J4jJTxFl17B6MePByk6+5+tscrvm4W3M/4NIBazOvse2ElvO6Id/p10Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3kZKjk7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3kZKjk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E703F1F000E9;
	Wed, 20 May 2026 17:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297481;
	bh=UpZrHIlP6fEGqpREuuae1TyjBNgfAdywwvHRBZFOl8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3kZKjk7DZmSsTSKEJGWucMoOPJfY9gdsix65x2fDn/pn/oTjEgt1olbJ3mrZle6u
	 amvaq9poSuLRbWHHftJOk/SXC9ILlvTTHxqpkqwYDLESCkplB7C1lqB0ezZVrFWixy
	 XaBDRxXI4yTvT/r0q7kju/YZJWwzOZW/DguPtVKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/957] ASoC: Intel: avs: Include CPUID header at file scope
Date: Wed, 20 May 2026 18:08:52 +0200
Message-ID: <20260520162135.621612929@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed S. Darwish <darwi@linutronix.de>

[ Upstream commit 7f78e0b46e9984e955cb73ffada8dace8b4dd059 ]

Commit

    cbe37a4d2b3c ("ASoC: Intel: avs: Configure basefw on TGL-based platforms")

includes the main CPUID header from within a C function.  This works by
luck and forbids valid refactoring inside that header.

Include the CPUID header at file scope instead.

Remove the COMPILE_TEST build flag so that the CONFIG_X86 conditionals can
be removed.  The driver gets enough compilation testing already on x86.

For clarity, refactor the CPUID(0x15) code into its own function without
changing any of the driver's logic.

Fixes: cbe37a4d2b3c ("ASoC: Intel: avs: Configure basefw on TGL-based platforms")
Suggested-by: Borislav Petkov <bp@alien8.de>		# CONFIG_X86 removal
Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/all/20250612234010.572636-3-darwi@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/Kconfig   |  2 +-
 sound/soc/intel/avs/tgl.c | 37 ++++++++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/sound/soc/intel/Kconfig b/sound/soc/intel/Kconfig
index 412555e626b81..63367364916ae 100644
--- a/sound/soc/intel/Kconfig
+++ b/sound/soc/intel/Kconfig
@@ -95,7 +95,7 @@ config SND_SOC_INTEL_KEEMBAY
 
 config SND_SOC_INTEL_AVS
 	tristate "Intel AVS driver"
-	depends on X86 || COMPILE_TEST
+	depends on X86
 	depends on PCI
 	depends on COMMON_CLK
 	select ACPI_NHLT if ACPI
diff --git a/sound/soc/intel/avs/tgl.c b/sound/soc/intel/avs/tgl.c
index 4649d749b41e0..a7123639de431 100644
--- a/sound/soc/intel/avs/tgl.c
+++ b/sound/soc/intel/avs/tgl.c
@@ -7,6 +7,7 @@
 //
 
 #include <linux/pci.h>
+#include <asm/cpuid/api.h>
 #include "avs.h"
 #include "debug.h"
 #include "messages.h"
@@ -38,28 +39,38 @@ static int avs_tgl_dsp_core_stall(struct avs_dev *adev, u32 core_mask, bool stal
 	return avs_dsp_core_stall(adev, core_mask, stall);
 }
 
-static int avs_tgl_config_basefw(struct avs_dev *adev)
+/*
+ * Succeed if CPUID(0x15) is not available, or if the nominal core crystal clock
+ * frequency cannot be enumerated from it.  There is nothing to do in both cases.
+ */
+static int avs_tgl_set_xtal_freq(struct avs_dev *adev)
 {
-	struct pci_dev *pci = adev->base.pci;
-	struct avs_bus_hwid hwid;
+	unsigned int freq;
 	int ret;
-#ifdef CONFIG_X86
-	unsigned int ecx;
-
-#include <asm/cpuid/api.h>
 
 	if (boot_cpu_data.cpuid_level < CPUID_LEAF_TSC)
-		goto no_cpuid;
+		return 0;
 
-	ecx = cpuid_ecx(CPUID_LEAF_TSC);
-	if (ecx) {
-		ret = avs_ipc_set_fw_config(adev, 1, AVS_FW_CFG_XTAL_FREQ_HZ, sizeof(ecx), &ecx);
+	freq = cpuid_ecx(CPUID_LEAF_TSC);
+	if (freq) {
+		ret = avs_ipc_set_fw_config(adev, 1, AVS_FW_CFG_XTAL_FREQ_HZ, sizeof(freq), &freq);
 		if (ret)
 			return AVS_IPC_RET(ret);
 	}
-#endif
 
-no_cpuid:
+	return 0;
+}
+
+static int avs_tgl_config_basefw(struct avs_dev *adev)
+{
+	struct pci_dev *pci = adev->base.pci;
+	struct avs_bus_hwid hwid;
+	int ret;
+
+	ret = avs_tgl_set_xtal_freq(adev);
+	if (ret)
+		return ret;
+
 	hwid.device = pci->device;
 	hwid.subsystem = pci->subsystem_vendor | (pci->subsystem_device << 16);
 	hwid.revision = pci->revision;
-- 
2.53.0



