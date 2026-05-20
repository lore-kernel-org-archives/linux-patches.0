Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10C3F54DD;
	Wed, 20 May 2026 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294503; cv=none; b=p9FWkILA8eqHSucbzJFFtqRfc0HYrnfcEZB70AIC/2o03aKpr0uku9c7fufYPVSeGzWiv1WH+yUVANHSxhry9NhXfl7+zgMjYFLjLZPGavqfU7BZpcXiSks4e/bZlcvW1xttMOgweh2WEQp1BxHu3MIFVgajOzv9k+4ed1alGG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294503; c=relaxed/simple;
	bh=aOut4IAAQfYo0o4XgAvqzQ7d82AUnGjFrGJ49BQAit8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUr6MzX06U+GtzhWiIToOc25+t5gvF+twPEV7gf63T32+86z5ZYPYtvQ65k60/QwG+ftQaFm9oAF7JeNufwxvodh088ICJqz/YzwvSGduQZTnqlYDIOi4Da/X/GXxaoEiNfOGYWZTYFY53Eh0q1zVkKiHmyLmiK8XAd+vHqy4so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3diIZmO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3diIZmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1251F000E9;
	Wed, 20 May 2026 16:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294500;
	bh=clYL/opHpczheOvY8sqfJzZiFeCVsXJ2uH1m7ZWkkH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3diIZmOW2NUcZx9fV4ItrFtFacUmenMRMCzOVWkDMO8nTjARt3af985XF0NlV14w
	 k7obVx031+yZ4ckmVr7wD3NW97c/wV9Ld4IDZlrDGl56jT4oKg5MhLqoaxbz2LwrcO
	 d255dOZ9rZK6/yyfXWitGI5HJ9/2LWg7NiIdqM3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0063/1146] ASoC: Intel: avs: Check maximum valid CPUID leaf
Date: Wed, 20 May 2026 18:05:13 +0200
Message-ID: <20260520162149.791315328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed S. Darwish <darwi@linutronix.de>

[ Upstream commit 93a1f0e61329f538cfc7122d7fa0e7a1803e326d ]

The Intel AVS driver queries CPUID(0x15) before checking if the CPUID leaf
is available.  Check the maximum-valid CPU standard leaf beforehand.

Use the CPUID_LEAF_TSC macro instead of the custom local one for the
CPUID(0x15) leaf number.

Fixes: cbe37a4d2b3c ("ASoC: Intel: avs: Configure basefw on TGL-based platforms")
Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260327021645.555257-2-darwi@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/tgl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/tgl.c b/sound/soc/intel/avs/tgl.c
index afb0665161010..4649d749b41e0 100644
--- a/sound/soc/intel/avs/tgl.c
+++ b/sound/soc/intel/avs/tgl.c
@@ -11,8 +11,6 @@
 #include "debug.h"
 #include "messages.h"
 
-#define CPUID_TSC_LEAF 0x15
-
 static int avs_tgl_dsp_core_power(struct avs_dev *adev, u32 core_mask, bool power)
 {
 	core_mask &= AVS_MAIN_CORE_MASK;
@@ -49,7 +47,11 @@ static int avs_tgl_config_basefw(struct avs_dev *adev)
 	unsigned int ecx;
 
 #include <asm/cpuid/api.h>
-	ecx = cpuid_ecx(CPUID_TSC_LEAF);
+
+	if (boot_cpu_data.cpuid_level < CPUID_LEAF_TSC)
+		goto no_cpuid;
+
+	ecx = cpuid_ecx(CPUID_LEAF_TSC);
 	if (ecx) {
 		ret = avs_ipc_set_fw_config(adev, 1, AVS_FW_CFG_XTAL_FREQ_HZ, sizeof(ecx), &ecx);
 		if (ret)
@@ -57,6 +59,7 @@ static int avs_tgl_config_basefw(struct avs_dev *adev)
 	}
 #endif
 
+no_cpuid:
 	hwid.device = pci->device;
 	hwid.subsystem = pci->subsystem_vendor | (pci->subsystem_device << 16);
 	hwid.revision = pci->revision;
-- 
2.53.0



