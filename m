Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA9714F9EA
	for <patches@lists.linux.dev>; Thu, 16 May 2024 16:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715876975; cv=none; b=YQ73rf0om0FMbEnz6lkph3KvBA6fA788mwZpeiPThkJPxMeQiCcBpOM5VDugYbHo8RvDTNG7h5zB0NG4XrjVcM7QD2qcB3q94pJ0oaGt9DoeZsTv+yH76TTDlB1Ozi0KhOwHtOrvMtfs6/fcHm5YYKZ0MVbq+iOK8lmvKfycqwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715876975; c=relaxed/simple;
	bh=oH7jW/qEeaQFMv1KiZOCshAmxrfYFU2lxVVW+EBHAs8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q6P1z+p+WmCJynQ8WKiR8Rkx7aTM5QlrTs5R2vPHISNWtTxBfZejxl+iQlJiTFTKSkPQ599XWcj9zGmN55nJ3kNFTyQCA45Kn/7FgLED5tDTDLy/zWuudLEeu8wnVDrSLQEvaeDSTxl8/cLdnnwNMCDSQiKxbTvPtGVpIJ0STU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NAqCT0JW; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NAqCT0JW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715876973; x=1747412973;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oH7jW/qEeaQFMv1KiZOCshAmxrfYFU2lxVVW+EBHAs8=;
  b=NAqCT0JWkZwri7cOcYbDN2aYnmHf9zw1mG88gdLbO1c9HlqQ4YmaPndc
   eDW21SUjkoGc66yd1WbFxrwfo09qH83SYRXrF9stsELscpem2/R/nOHQW
   6c92kL70PLcdUcpb0oDT79Dbu8tODLcPdBIcTc4zVsQ0SCIU8THqAliXR
   clKYMc+ZtuezG7lSrsSUuI66IE5fnSAxv30Z/vWzgYdDRCPJh1Iz9GqUq
   xpxVWdGI2nCANuIZSXaRap/na6C6flEB4cuNAm4SFX5APti0uX4kHaouv
   +YIsOiotrfpl1wMYdPT4qpAs1g5V5ldWzXBt293iFzSi8EyUYCe6bAKqm
   w==;
X-CSE-ConnectionGUID: LI8lE4ayRF631qRSqmOP0w==
X-CSE-MsgGUID: KFKoeEH7TqaNAP4MRfFgeg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11871765"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="11871765"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 09:29:32 -0700
X-CSE-ConnectionGUID: SyNlay/xSGi25eLc74TvzA==
X-CSE-MsgGUID: 0rTHOyvpRi+TlH5j1E31vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="68936483"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 09:29:32 -0700
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
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL
Date: Thu, 16 May 2024 09:29:25 -0700
Message-ID: <20240516162925.79245-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Code in v.9 arch/x86/kernel/smpboot.c was changed by commit 4db64279bc2b
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
[2] = { .vendor = 0, .family = 6, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 0 },
[3] = { .vendor = 0, .family = 0, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 0 }
}

while the new code expands to:

static const struct x86_cpu_id intel_cod_cpu[] = {
[0] = { .vendor = 0, .family = 6, .model = 0x3F, .steppings = 0, .feature = 0, .driver_data = 0 },
[1] = { .vendor = 0, .family = 6, .model = 0x4F, .steppings = 0, .feature = 0, .driver_data = 0 },
[2] = { .vendor = 0, .family = 0, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 0 },
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

Fix by changing X86_VENDOR_INTEL to a non-zero value (4 was lowest
unused value, so I picked that).

Fixes: 644e9cbbe3fc ("Add driver auto probing for x86 features v4")
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Changes since v1:
1) More detailed commit description.
2) Changed "Fixes" tag. Commit 4db64279bc2b merely revealed a twelve
   year old gap in the implementation of x86_match_cpu().

 arch/x86/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index cb4f6c513c48..271c4c95bc37 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -175,10 +175,10 @@ struct cpuinfo_x86 {
 	unsigned		initialized : 1;
 } __randomize_layout;
 
-#define X86_VENDOR_INTEL	0
 #define X86_VENDOR_CYRIX	1
 #define X86_VENDOR_AMD		2
 #define X86_VENDOR_UMC		3
+#define X86_VENDOR_INTEL	4
 #define X86_VENDOR_CENTAUR	5
 #define X86_VENDOR_TRANSMETA	7
 #define X86_VENDOR_NSC		8
-- 
2.44.0

