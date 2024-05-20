Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AFC13C3E2
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245213; cv=none; b=K6t7D06NJNpJ8+cIPhJuLbn/0F9CqEREo9g6Mr4SFnRJUw+eqJpWmix7VshxjRRNRBo3ntu5R5klBVRSiDwihh/JQTPV44L2/vjprtIgtkGd5ChWRs/o4S8LVT8zTLH8BS0wdzowXn1pZSlg4KgByhd8BYCuyyvZOG4LvtEErDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245213; c=relaxed/simple;
	bh=tMaJ9LquKdyqtIrCznQawsIwTZJVDk5Gf87ol/G8gIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzMVCdabyZOCBc9OhROd/kwg+0NHmY3GJ+JTHhY3lqB4csbzVKFhHU8SxBGKeOBW1CKiWo+I9TW3ajycx4MEbrjyUB0Aec19+kUDSQ5tdPlrumsXWd4YzNxB1SpkARJERoEZxbMSzBBBxM71UNnEN6+JnOx8kYfnEbWhtMQqUQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=inwLqgsQ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="inwLqgsQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245210; x=1747781210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tMaJ9LquKdyqtIrCznQawsIwTZJVDk5Gf87ol/G8gIM=;
  b=inwLqgsQpVW9Mh8zUX3G2ohT81hTq2Pp7BHYJNQqzbMahyGOYIB6a6PA
   VzapbW6HP1JtDA6Hz0wO62WvysmAEi9PZofdRX6ABP0pVNsTJHoqeJv+e
   AStXO87NvElpxmJFOkqU6VvvMVHewK4sMi6hR48LMLh/EyXTR29MWvw/y
   g9ZjnHv19eLIeJNsCKadPHiWnsst0G5Li8NmEHUDjLawb/V9VApWadfs+
   pNE3z+iBScp1gqSBuMI1Tq3vFhnINw7qmhV5EUINrUWDSiBA6onOLLNGf
   NSLoeUi3wB+NacSNtIo+cmX2NQJIqZnksE+czuyTj3McR8Gpx9bblmbU1
   w==;
X-CSE-ConnectionGUID: Bps+EWpfSYySr3KwVTG7kg==
X-CSE-MsgGUID: A6jYpOXvSNqnUO8co8ghHw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199868"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199868"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
X-CSE-ConnectionGUID: wwPHbdJoRQGiEM90Rv7ckw==
X-CSE-MsgGUID: Ljne8m3+TIaOHBGZftr0Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593483"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
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
Subject: [PATCH v6 33/49] x86/cpu: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:04 -0700
Message-ID: <20240520224620.9480-34-tony.luck@intel.com>
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

New CPU #defines encode vendor and family as well as model.

Update INTEL_CPU_DESC() to work with vendor/family/model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/cpu_device_id.h |  8 ++--
 arch/x86/events/intel/core.c         | 64 ++++++++++++++--------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 54a71c669ce9..df07d3776db8 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -277,10 +277,10 @@ struct x86_cpu_desc {
 	u32	x86_microcode_rev;
 };
 
-#define INTEL_CPU_DESC(model, stepping, revision) {		\
-	.x86_family		= 6,				\
-	.x86_vendor		= X86_VENDOR_INTEL,		\
-	.x86_model		= (model),			\
+#define INTEL_CPU_DESC(vfm, stepping, revision) {		\
+	.x86_family		= VFM_FAMILY(vfm),		\
+	.x86_vendor		= VFM_VENDOR(vfm),		\
+	.x86_model		= VFM_MODEL(vfm),		\
 	.x86_stepping		= (stepping),			\
 	.x86_microcode_rev	= (revision),			\
 }
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 94206f8cd371..d3294ef18aef 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5187,35 +5187,35 @@ static __init void intel_clovertown_quirk(void)
 }
 
 static const struct x86_cpu_desc isolation_ucodes[] = {
-	INTEL_CPU_DESC(INTEL_FAM6_HASWELL,		 3, 0x0000001f),
-	INTEL_CPU_DESC(INTEL_FAM6_HASWELL_L,		 1, 0x0000001e),
-	INTEL_CPU_DESC(INTEL_FAM6_HASWELL_G,		 1, 0x00000015),
-	INTEL_CPU_DESC(INTEL_FAM6_HASWELL_X,		 2, 0x00000037),
-	INTEL_CPU_DESC(INTEL_FAM6_HASWELL_X,		 4, 0x0000000a),
-	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL,		 4, 0x00000023),
-	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_G,		 1, 0x00000014),
-	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_D,		 2, 0x00000010),
-	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_D,		 3, 0x07000009),
-	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_D,		 4, 0x0f000009),
-	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_D,		 5, 0x0e000002),
-	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_X,		 1, 0x0b000014),
-	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 3, 0x00000021),
-	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 4, 0x00000000),
-	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 5, 0x00000000),
-	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 6, 0x00000000),
-	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 7, 0x00000000),
-	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		11, 0x00000000),
-	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_L,		 3, 0x0000007c),
-	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE,		 3, 0x0000007c),
-	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE,		 9, 0x0000004e),
-	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE_L,		 9, 0x0000004e),
-	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE_L,		10, 0x0000004e),
-	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE_L,		11, 0x0000004e),
-	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE_L,		12, 0x0000004e),
-	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE,		10, 0x0000004e),
-	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE,		11, 0x0000004e),
-	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE,		12, 0x0000004e),
-	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE,		13, 0x0000004e),
+	INTEL_CPU_DESC(INTEL_HASWELL,		 3, 0x0000001f),
+	INTEL_CPU_DESC(INTEL_HASWELL_L,		 1, 0x0000001e),
+	INTEL_CPU_DESC(INTEL_HASWELL_G,		 1, 0x00000015),
+	INTEL_CPU_DESC(INTEL_HASWELL_X,		 2, 0x00000037),
+	INTEL_CPU_DESC(INTEL_HASWELL_X,		 4, 0x0000000a),
+	INTEL_CPU_DESC(INTEL_BROADWELL,		 4, 0x00000023),
+	INTEL_CPU_DESC(INTEL_BROADWELL_G,	 1, 0x00000014),
+	INTEL_CPU_DESC(INTEL_BROADWELL_D,	 2, 0x00000010),
+	INTEL_CPU_DESC(INTEL_BROADWELL_D,	 3, 0x07000009),
+	INTEL_CPU_DESC(INTEL_BROADWELL_D,	 4, 0x0f000009),
+	INTEL_CPU_DESC(INTEL_BROADWELL_D,	 5, 0x0e000002),
+	INTEL_CPU_DESC(INTEL_BROADWELL_X,	 1, 0x0b000014),
+	INTEL_CPU_DESC(INTEL_SKYLAKE_X,		 3, 0x00000021),
+	INTEL_CPU_DESC(INTEL_SKYLAKE_X,		 4, 0x00000000),
+	INTEL_CPU_DESC(INTEL_SKYLAKE_X,		 5, 0x00000000),
+	INTEL_CPU_DESC(INTEL_SKYLAKE_X,		 6, 0x00000000),
+	INTEL_CPU_DESC(INTEL_SKYLAKE_X,		 7, 0x00000000),
+	INTEL_CPU_DESC(INTEL_SKYLAKE_X,		11, 0x00000000),
+	INTEL_CPU_DESC(INTEL_SKYLAKE_L,		 3, 0x0000007c),
+	INTEL_CPU_DESC(INTEL_SKYLAKE,		 3, 0x0000007c),
+	INTEL_CPU_DESC(INTEL_KABYLAKE,		 9, 0x0000004e),
+	INTEL_CPU_DESC(INTEL_KABYLAKE_L,	 9, 0x0000004e),
+	INTEL_CPU_DESC(INTEL_KABYLAKE_L,	10, 0x0000004e),
+	INTEL_CPU_DESC(INTEL_KABYLAKE_L,	11, 0x0000004e),
+	INTEL_CPU_DESC(INTEL_KABYLAKE_L,	12, 0x0000004e),
+	INTEL_CPU_DESC(INTEL_KABYLAKE,		10, 0x0000004e),
+	INTEL_CPU_DESC(INTEL_KABYLAKE,		11, 0x0000004e),
+	INTEL_CPU_DESC(INTEL_KABYLAKE,		12, 0x0000004e),
+	INTEL_CPU_DESC(INTEL_KABYLAKE,		13, 0x0000004e),
 	{}
 };
 
@@ -5232,9 +5232,9 @@ static __init void intel_pebs_isolation_quirk(void)
 }
 
 static const struct x86_cpu_desc pebs_ucodes[] = {
-	INTEL_CPU_DESC(INTEL_FAM6_SANDYBRIDGE,		7, 0x00000028),
-	INTEL_CPU_DESC(INTEL_FAM6_SANDYBRIDGE_X,	6, 0x00000618),
-	INTEL_CPU_DESC(INTEL_FAM6_SANDYBRIDGE_X,	7, 0x0000070c),
+	INTEL_CPU_DESC(INTEL_SANDYBRIDGE,	7, 0x00000028),
+	INTEL_CPU_DESC(INTEL_SANDYBRIDGE_X,	6, 0x00000618),
+	INTEL_CPU_DESC(INTEL_SANDYBRIDGE_X,	7, 0x0000070c),
 	{}
 };
 
-- 
2.45.0

