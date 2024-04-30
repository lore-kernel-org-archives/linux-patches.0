Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A924B181D13
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495899; cv=none; b=YE60rblhi669DoN2u7/oOabsH7HjTRo5r7Iw3lEo1dvdAGgzcVriSvGyjfmut7WV6O2FgWsQIxSo2B7g4htmzm4LLwVBSAVJbPBAc8sHDrSbWy2Fn28BslUwgUW/m5aQjXf9arpWzMSkwSY87W7Ug7/tPNcYN4LNA1I65Emzj4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495899; c=relaxed/simple;
	bh=7eZ3KCFeL78AbH6r5Dbnh9EHFylKrjKmvHvWxMZrAck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3o5XFUC/9SGcnfvoghxEWxijwPTpmxdcVbO+V5G2nK50kUrPA7qpirHCOuc+bzOhbrdUT//D6znOv6pYgXaCWdETQpSW7rF2kEsj222/2/JfbWQFP5A2X0rOqheQZaLI76YSftedqEiYa4N3qhZ5ylLerY0EqUKvelL5puZmK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cHN63bNO; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cHN63bNO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495898; x=1746031898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7eZ3KCFeL78AbH6r5Dbnh9EHFylKrjKmvHvWxMZrAck=;
  b=cHN63bNOgDdlkbjuamxqfvqWFiK06eX2qNkIyIbKpRbjCccIQeEXMqCY
   1egCMsRGK8Pmo2ulHnkHQs7sFaadCQurgt15by1E45pnpx8BHirnY8N9l
   CXy+QIYo+c/nzHp5tl3jcy5WSaN45A5tL59dkWcri5rSsA3heq0AXezC0
   8IvkQ9OdYYhv1sKPI32+ia51F3vAiFdMUkwsLx/4OD9ipRn1uzTjUPVnL
   DEy0nDwzRLHS24PO7uo8tBfH1QdW63vy94P5/GUwQivAsGDaZeNg8z+4c
   xVTkAGe9IVdHfLMef5lrWJnqGMienYB0H9kcKb3rU8bdysjX/HGXOIfeg
   w==;
X-CSE-ConnectionGUID: lOrb85U3R+67CuS7ktf+xA==
X-CSE-MsgGUID: 2X5/pg0BRZOk38UpPtsxlw==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075648"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075648"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
X-CSE-ConnectionGUID: 58y99aPkTaKGEjq+lLQrow==
X-CSE-MsgGUID: JSFjaa5XRyC+srejU/pRtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515434"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v5 12/47] ASoC: Intel: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:25 -0700
Message-ID: <20240430165100.73491-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/platform_data/x86/soc.h         | 12 ++++++------
 drivers/thermal/intel/intel_soc_dts_thermal.c |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/platform_data/x86/soc.h b/include/linux/platform_data/x86/soc.h
index a5705189e2ac..f981907a5cb0 100644
--- a/include/linux/platform_data/x86/soc.h
+++ b/include/linux/platform_data/x86/soc.h
@@ -20,7 +20,7 @@
 static inline bool soc_intel_is_##soc(void)			\
 {								\
 	static const struct x86_cpu_id soc##_cpu_ids[] = {	\
-		X86_MATCH_INTEL_FAM6_MODEL(type, NULL),		\
+		X86_MATCH_VFM(type, NULL),			\
 		{}						\
 	};							\
 	const struct x86_cpu_id *id;				\
@@ -31,11 +31,11 @@ static inline bool soc_intel_is_##soc(void)			\
 	return false;						\
 }
 
-SOC_INTEL_IS_CPU(byt, ATOM_SILVERMONT);
-SOC_INTEL_IS_CPU(cht, ATOM_AIRMONT);
-SOC_INTEL_IS_CPU(apl, ATOM_GOLDMONT);
-SOC_INTEL_IS_CPU(glk, ATOM_GOLDMONT_PLUS);
-SOC_INTEL_IS_CPU(cml, KABYLAKE_L);
+SOC_INTEL_IS_CPU(byt, INTEL_ATOM_SILVERMONT);
+SOC_INTEL_IS_CPU(cht, INTEL_ATOM_AIRMONT);
+SOC_INTEL_IS_CPU(apl, INTEL_ATOM_GOLDMONT);
+SOC_INTEL_IS_CPU(glk, INTEL_ATOM_GOLDMONT_PLUS);
+SOC_INTEL_IS_CPU(cml, INTEL_KABYLAKE_L);
 
 #undef SOC_INTEL_IS_CPU
 
diff --git a/drivers/thermal/intel/intel_soc_dts_thermal.c b/drivers/thermal/intel/intel_soc_dts_thermal.c
index 9c825c6e1f38..718c6326eaf4 100644
--- a/drivers/thermal/intel/intel_soc_dts_thermal.c
+++ b/drivers/thermal/intel/intel_soc_dts_thermal.c
@@ -36,7 +36,7 @@ static irqreturn_t soc_irq_thread_fn(int irq, void *dev_data)
 }
 
 static const struct x86_cpu_id soc_thermal_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT, BYT_SOC_DTS_APIC_IRQ),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT, BYT_SOC_DTS_APIC_IRQ),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, soc_thermal_ids);
-- 
2.44.0

