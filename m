Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689C238F83
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 19:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L5K9YXoD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696535746; x=1728071746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xRdIGrMu0iispDmD5LNO95ypugEOWAVy/AAjlhz/WJk=;
  b=L5K9YXoDZcDMvBc2S2xAAuwsn+trj2ibyCPZuIA7KyCCKEU3IoZsFZ3X
   2rPztvh/wvMPTQID/z8FBr6tgcVeEKde7JddwMoY7yd0J/dV+ELgcY9+i
   r9l42GRseA3+cRaVBSWNKXojEQGel0GfwplWiLlzT98LeiCljLbAInY4k
   D7CPgw1wq7n/6nuWK6sCbh0sY3L5d2eal5eBHSdHCd8CBfz9FMWfNlOnR
   +7oYS21ALRz4VoLkVwJvaBKnpErdBva6jp5xf3eaXlcxFbOQ5vbcOhd62
   6SiH+RiuNQXQ7GTs9OVpOUs/slydYsOe+SVGf83nXkQ1ZYbbs0ncetuyu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="386432532"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="386432532"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="755600113"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="755600113"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:43 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: ilpo.jarvinen@linux.intel.com,
	hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	pengfei.xu@intel.com
Subject: [PATCH v4 0/9] IFS support for GNR and SRF
Date: Thu,  5 Oct 2023 12:51:28 -0700
Message-Id: <20231005195137.3117166-1-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230929202436.2850388-1-jithu.joseph@intel.com>
References: <20230929202436.2850388-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes in v4
   Ilpo Järvinen
    - Changed the dev_err/warn printk format specifiers to more
       appropriate ones (patch 5, 6)
    - Add defines for array generation (patch 9)

v3 submission
Link: https://lore.kernel.org/lkml/20230929202436.2850388-1-jithu.joseph@intel.com/

Changes in v3
   Ilpo Järvinen
    - Added Reviewed-by tags wherever provided
    - In function validate_ifs_metadata() (patch 6)
        - Add != 0 to next line for clarity
    - In function ifs_load_firmware() (patch 5)
        - return -EINVAL instead of -BADFD
    - In function ifs_test_core() (patch 4)
        - initialize activate.gen0.rsvd = 0
        - use if instead of conditional operator
    - alignment change in ifs_scan_hashes_status_gen2 (patch 3)

v2 submission
Link: https://lore.kernel.org/lkml/20230922232606.1928026-1-jithu.joseph@intel.com/

Changes in v2
   Ilpo Järvinen
    - Use GENMASK_ULL() / FIELD_GET() for bitops (patch 01)
    - Avoid mixing u8 type and bitfields in certain MSR structure
       scenarios (patch03 also suggested by Dave Hansen)
    - Expand bitfield structures to use consistent genx naming (patch 04)
    - Replace goto with do / while (patch 03)
    - general formatting (multiple patches)
        - remove un-necessary parenthesis
        - reformat commit message to use whole allowed 72 columns
        - alignment changes
    Other change
     - fold v1 04/10 and 05/10 into v2 patch 04/09 to satisfy build
        constraints due to consistent genx naming

v1 submission:
Link: https://lore.kernel.org/lkml/20230913183348.1349409-1-jithu.joseph@intel.com/

This series adds In Field Scan(IFS) support for newer CPUs like Granite
Rapids(GNR) and Sierra Forest(SRF).

There are changes in the IFS image loading and test flow to support
these new CPUs.

Note to reviewers:
 - patch 1/9 adds a bit mask to arch/x86/.../msr-index.h,
  hence x86 maintainers are cc-d.
 - patch 4/9 modifies an existing tracepoint, cc Steven Rostedt
 - Rest are localized to IFS driver

Jithu Joseph (9):
  platform/x86/intel/ifs: Store IFS generation number
  platform/x86/intel/ifs: Refactor image loading code
  platform/x86/intel/ifs: Gen2 scan image loading
  platform/x86/intel/ifs: Gen2 Scan test support
  platform/x86/intel/ifs: Validate image size
  platform/x86/intel/ifs: Metadata validation for start_chunk
  platform/x86/intel/ifs: Add new CPU support
  platform/x86/intel/ifs: Add new error code
  platform/x86/intel/ifs: ARRAY BIST for Sierra Forest

 arch/x86/include/asm/msr-index.h         |   1 +
 drivers/platform/x86/intel/ifs/ifs.h     |  64 ++++++++-
 include/trace/events/intel_ifs.h         |  16 +--
 drivers/platform/x86/intel/ifs/core.c    |  15 ++-
 drivers/platform/x86/intel/ifs/load.c    | 158 +++++++++++++++++++++--
 drivers/platform/x86/intel/ifs/runtest.c |  72 +++++++++--
 6 files changed, 286 insertions(+), 40 deletions(-)


base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
-- 
2.25.1

