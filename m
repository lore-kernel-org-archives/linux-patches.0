Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30BA1CD32
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245197; cv=none; b=Tz8zUKYB0sN/nQWf+Vf72g0aFNYeel446BLKyjFU3NqZq0vNbqam06ZCs+OqU0AR5RHdITDvAbsuglvpSX5ruMa43TbDIDHTNj8vupqzSAZAXBttnKxv9BlZfuwKvhYOiXycImuC89JYgbpTmfe3dL2Xn4X2Whcqdm5zHh/BKiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245197; c=relaxed/simple;
	bh=vRJh5U/RrkSoxKq+4A8MOsjvcQxfmvO221sw5F6FSYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZqiVRaMCye8DmnM82elrD25Rla5w7IxxcWZnVNf0hyqIavCRL49pKuBfHcXAyuvFwUVtYnV2gJFtPEq37oq34DqPIJS3d8sDWWSbtAGacqzMBk2jzTOM8AOjWHe+tS48JujVYyT8DIvh+eBVU+OZ2XrZ6YhL99krjBcgFtRphU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HPxaB/jm; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HPxaB/jm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245196; x=1747781196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vRJh5U/RrkSoxKq+4A8MOsjvcQxfmvO221sw5F6FSYo=;
  b=HPxaB/jmAulmcWh6AwWp3odtVFsPVbhDqjl08Ndj6FOPGHpde6zkmDc2
   I63XguWgS9sukFIAoZxhXg/NeMeQhcM/aHgHS7zfGoF8TnGYjEGehHlSb
   90mV8gON3onK0hgVpQDNcKAVi9H8LdMj8Hgtg95tS2y4S2ddBXhRXR4QB
   3QZ1h2ligEb3JI4V/rYIQ/gwjAIAOnGkE8lI3AY9C3MyHXI9MjJcRLNJR
   lW3H019Q3qd24be6WV+zmyAqnUYdxO1OOSb4EpgGpEV3PaSOdcbty5rSa
   gH7S9kzvg1fcAL4tS5aNWZ7Rn5pO28dDVD/pAoI663vtvWx1CQD7WLd8W
   w==;
X-CSE-ConnectionGUID: h5sdg/5OTMGURyFw2DBS1w==
X-CSE-MsgGUID: b7dcFI5QQaaNoXwbevKVvg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199519"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199519"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
X-CSE-ConnectionGUID: nDQUglqpRWGxPfR1FM+c6g==
X-CSE-MsgGUID: JPlKipRZQrSH5KHl65q4YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593386"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v6 02/49] x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL
Date: Mon, 20 May 2024 15:45:33 -0700
Message-ID: <20240520224620.9480-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Code in v6.9 arch/x86/kernel/smpboot.c was changed by commit 4db64279bc2b
("x86/cpu: Switch to new Intel CPU model defines") from old code:

 440 static const struct x86_cpu_id intel_cod_cpu[] = {
 441         X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X, 0),       /* COD */
 442         X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X, 0),     /* COD */
 443         X86_MATCH_INTEL_FAM6_MODEL(ANY, 1),             /* SNC */
 444         {}
 445 };
 446
 447 static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 448 {
 449         const struct x86_cpu_id *id = x86_match_cpu(intel_cod_cpu);

new code:

440 static const struct x86_cpu_id intel_cod_cpu[] = {
 441         X86_MATCH_VFM(INTEL_HASWELL_X,   0),    /* COD */
 442         X86_MATCH_VFM(INTEL_BROADWELL_X, 0),    /* COD */
 443         X86_MATCH_VFM(INTEL_ANY,         1),    /* SNC */
 444         {}
 445 };
 446
 447 static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 448 {
 449         const struct x86_cpu_id *id = x86_match_cpu(intel_cod_cpu);

On an Intel CPU with SNC enabled this code previously matched the rule
on line 443 to avoid printing messages about insane cache configuration.
The new code did not match any rules.

Expanding the macros for the intel_cod_cpu[] array shows that the old
is equivalent to:

static const struct x86_cpu_id intel_cod_cpu[] = {
[0] = { .vendor = 0, .family = 6, .model = 0x3F, .steppings = 0, .feature = 0, .driver_data = 0 },
[1] = { .vendor = 0, .family = 6, .model = 0x4F, .steppings = 0, .feature = 0, .driver_data = 0 },
[2] = { .vendor = 0, .family = 6, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 1 },
[3] = { .vendor = 0, .family = 0, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 0 }
}

while the new code expands to:

static const struct x86_cpu_id intel_cod_cpu[] = {
[0] = { .vendor = 0, .family = 6, .model = 0x3F, .steppings = 0, .feature = 0, .driver_data = 0 },
[1] = { .vendor = 0, .family = 6, .model = 0x4F, .steppings = 0, .feature = 0, .driver_data = 0 },
[2] = { .vendor = 0, .family = 0, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 1 },
[3] = { .vendor = 0, .family = 0, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 0 }
}

Looking at the code for x86_match_cpu():

36 const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
 37 {
 38         const struct x86_cpu_id *m;
 39         struct cpuinfo_x86 *c = &boot_cpu_data;
 40
 41         for (m = match;
 42              m->vendor | m->family | m->model | m->steppings | m->feature;
 43              m++) {
			...
 56         }
 57         return NULL;
 58 }
 59 EXPORT_SYMBOL(x86_match_cpu);

it is clear that there was no match because the ANY entry in the table
(array index 2) is now the loop termination condition (all of vendor,
family, model, steppings, and feature are zero).

So this code was working before because the "ANY" check was looking for
any Intel CPU in family 6. But fails now because the family is a wild
card. So the root cause is that x86_match_cpu() has never been able to
match on a rule with just X86_VENDOR_INTEL and all other fields set to
wildcards.

Fix by adding a new flags field to struct x86_cpu_id that has a bit set
to indicate that this entry in the array is valid. Update X86_MATCH*()
macros to set that bit. Chenge the end-marker check in x86_match_cpu()
to just check the flags field for this bit.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Borislav Petkov <bp@alien8.de>
Fixes: 644e9cbbe3fc ("Add driver auto probing for x86 features v4")
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
---
 include/linux/mod_devicetable.h      | 4 ++++
 arch/x86/include/asm/cpu_device_id.h | 2 ++
 arch/x86/kernel/cpu/match.c          | 4 +---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 7a9a07ea451b..ca3468ad06ff 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -690,6 +690,7 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 steppings;
 	__u16 feature;	/* bit index */
+	__u16 flags;
 	kernel_ulong_t driver_data;
 };
 
@@ -700,6 +701,9 @@ struct x86_cpu_id {
 #define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
+/* x86_cpu_id::flags */
+#define X86_CPU_ID_FLAG_ENTRY_VALID	BIT(0)
+
 /*
  * Generic table type for matching CPU features.
  * @feature:	the bit number of the feature (0 - 65535)
diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 970a232009c3..54a71c669ce9 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -79,6 +79,7 @@
 	.model		= _model,					\
 	.steppings	= _steppings,					\
 	.feature	= _feature,					\
+	.flags		= X86_CPU_ID_FLAG_ENTRY_VALID,			\
 	.driver_data	= (unsigned long) _data				\
 }
 
@@ -89,6 +90,7 @@
 	.model		= _model,					\
 	.steppings	= _steppings,					\
 	.feature	= _feature,					\
+	.flags		= X86_CPU_ID_FLAG_ENTRY_VALID,			\
 	.driver_data	= (unsigned long) _data				\
 }
 
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 8651643bddae..8e7de733320a 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -38,9 +38,7 @@ const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
 	const struct x86_cpu_id *m;
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	for (m = match;
-	     m->vendor | m->family | m->model | m->steppings | m->feature;
-	     m++) {
+	for (m = match; m->flags & X86_CPU_ID_FLAG_ENTRY_VALID; m++) {
 		if (m->vendor != X86_VENDOR_ANY && c->x86_vendor != m->vendor)
 			continue;
 		if (m->family != X86_FAMILY_ANY && c->x86 != m->family)
-- 
2.45.0

