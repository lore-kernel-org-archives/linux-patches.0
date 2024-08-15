Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813FE17BEAD;
	Thu, 15 Aug 2024 14:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731504; cv=none; b=AVZCMfxMHmDdM872HdtvR4qu8id8+cZCkBxBYbCkRTY6lyHtIFI/S0dEudjLs8J2+58kTUqtpV4R3cBKkgI8C9/0Cj8i89uVVMYptWbIGjp7udKZhahHN/et4tw7ZaroCQCe3e8cTBp3p5455xW1vlqff308Ok+Br23JQvQw8dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731504; c=relaxed/simple;
	bh=iD+G9MPpgEykq0WmY7qjGJTAr/UIFLOz+t1WdD6dKho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngleWaJ7g/s6Vahlv8e23uYxuMjTp4c76BbBVFGRWlED3JKYyqHraNBwfU6S7KHHIOVYZV4zkrlioIn4r+ulSvyJrZkCuDmqZLLyxsSmDMR4tvzSnfcowl+OA99tyEJPyFdXj5rozwaxqC5oS1l2bVaVgr2wnVc0O7zsue5RJeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2dhAEDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2dhAEDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C13C32786;
	Thu, 15 Aug 2024 14:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731504;
	bh=iD+G9MPpgEykq0WmY7qjGJTAr/UIFLOz+t1WdD6dKho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2dhAEDQ2W/CM6CCMl75ktuUSHF9oLQD77JjgYOPgCOsUpg9lEIb/fBWU8rRK+sQx
	 wop+wGt06pl2i4beBZoOQZHrYbu+7g7oIyedsNo0YThAtL09h8EjjV/khikl4JF28N
	 dvV63iQRhQD4xK+8rDZoaH1gziRIMVJLhN24mnX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/259] ASoC: Intel: Move soc_intel_is_foo() helpers to a generic header
Date: Thu, 15 Aug 2024 15:24:43 +0200
Message-ID: <20240815131908.581482308@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit cd45c9bf8b43cd387e167cf166ae5c517f56d658 ]

The soc_intel_is_foo() helpers from
sound/soc/intel/common/soc-intel-quirks.h are useful outside of the
sound subsystem too.

Move these to include/linux/platform_data/x86/soc.h, so that
other code can use them too.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211018143324.296961-2-hdegoede@redhat.com
Stable-dep-of: 9931f7d5d251 ("ASoC: Intel: use soc_intel_is_byt_cr() only when IOSF_MBI is reachable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/platform_data/x86/soc.h     | 65 +++++++++++++++++++++++
 sound/soc/intel/common/soc-intel-quirks.h | 51 ++----------------
 2 files changed, 68 insertions(+), 48 deletions(-)
 create mode 100644 include/linux/platform_data/x86/soc.h

diff --git a/include/linux/platform_data/x86/soc.h b/include/linux/platform_data/x86/soc.h
new file mode 100644
index 0000000000000..da05f425587a0
--- /dev/null
+++ b/include/linux/platform_data/x86/soc.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Helpers for Intel SoC model detection
+ *
+ * Copyright (c) 2019, Intel Corporation.
+ */
+
+#ifndef __PLATFORM_DATA_X86_SOC_H
+#define __PLATFORM_DATA_X86_SOC_H
+
+#if IS_ENABLED(CONFIG_X86)
+
+#include <asm/cpu_device_id.h>
+#include <asm/intel-family.h>
+
+#define SOC_INTEL_IS_CPU(soc, type)				\
+static inline bool soc_intel_is_##soc(void)			\
+{								\
+	static const struct x86_cpu_id soc##_cpu_ids[] = {	\
+		X86_MATCH_INTEL_FAM6_MODEL(type, NULL),		\
+		{}						\
+	};							\
+	const struct x86_cpu_id *id;				\
+								\
+	id = x86_match_cpu(soc##_cpu_ids);			\
+	if (id)							\
+		return true;					\
+	return false;						\
+}
+
+SOC_INTEL_IS_CPU(byt, ATOM_SILVERMONT);
+SOC_INTEL_IS_CPU(cht, ATOM_AIRMONT);
+SOC_INTEL_IS_CPU(apl, ATOM_GOLDMONT);
+SOC_INTEL_IS_CPU(glk, ATOM_GOLDMONT_PLUS);
+SOC_INTEL_IS_CPU(cml, KABYLAKE_L);
+
+#else /* IS_ENABLED(CONFIG_X86) */
+
+static inline bool soc_intel_is_byt(void)
+{
+	return false;
+}
+
+static inline bool soc_intel_is_cht(void)
+{
+	return false;
+}
+
+static inline bool soc_intel_is_apl(void)
+{
+	return false;
+}
+
+static inline bool soc_intel_is_glk(void)
+{
+	return false;
+}
+
+static inline bool soc_intel_is_cml(void)
+{
+	return false;
+}
+#endif /* IS_ENABLED(CONFIG_X86) */
+
+#endif /* __PLATFORM_DATA_X86_SOC_H */
diff --git a/sound/soc/intel/common/soc-intel-quirks.h b/sound/soc/intel/common/soc-intel-quirks.h
index a88a91995ce1a..a46be331c178e 100644
--- a/sound/soc/intel/common/soc-intel-quirks.h
+++ b/sound/soc/intel/common/soc-intel-quirks.h
@@ -9,34 +9,13 @@
 #ifndef _SND_SOC_INTEL_QUIRKS_H
 #define _SND_SOC_INTEL_QUIRKS_H
 
+#include <linux/platform_data/x86/soc.h>
+
 #if IS_ENABLED(CONFIG_X86)
 
 #include <linux/dmi.h>
-#include <asm/cpu_device_id.h>
-#include <asm/intel-family.h>
 #include <asm/iosf_mbi.h>
 
-#define SOC_INTEL_IS_CPU(soc, type)				\
-static inline bool soc_intel_is_##soc(void)			\
-{								\
-	static const struct x86_cpu_id soc##_cpu_ids[] = {	\
-		X86_MATCH_INTEL_FAM6_MODEL(type, NULL),		\
-		{}						\
-	};							\
-	const struct x86_cpu_id *id;				\
-								\
-	id = x86_match_cpu(soc##_cpu_ids);			\
-	if (id)							\
-		return true;					\
-	return false;						\
-}
-
-SOC_INTEL_IS_CPU(byt, ATOM_SILVERMONT);
-SOC_INTEL_IS_CPU(cht, ATOM_AIRMONT);
-SOC_INTEL_IS_CPU(apl, ATOM_GOLDMONT);
-SOC_INTEL_IS_CPU(glk, ATOM_GOLDMONT_PLUS);
-SOC_INTEL_IS_CPU(cml, KABYLAKE_L);
-
 static inline bool soc_intel_is_byt_cr(struct platform_device *pdev)
 {
 	/*
@@ -114,30 +93,6 @@ static inline bool soc_intel_is_byt_cr(struct platform_device *pdev)
 	return false;
 }
 
-static inline bool soc_intel_is_byt(void)
-{
-	return false;
-}
-
-static inline bool soc_intel_is_cht(void)
-{
-	return false;
-}
-
-static inline bool soc_intel_is_apl(void)
-{
-	return false;
-}
-
-static inline bool soc_intel_is_glk(void)
-{
-	return false;
-}
-
-static inline bool soc_intel_is_cml(void)
-{
-	return false;
-}
 #endif
 
- #endif /* _SND_SOC_INTEL_QUIRKS_H */
+#endif /* _SND_SOC_INTEL_QUIRKS_H */
-- 
2.43.0



