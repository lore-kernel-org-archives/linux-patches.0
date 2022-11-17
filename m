Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BF3EB05
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 04:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668657658; x=1700193658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yvUNacKCFJ1BVbBYtYVdkZ8/ge4T+GWmlXe8+ILX1X8=;
  b=CS32w58WX4toT22jzyOq4oW+UgRPggvlwXCMof8tJOSrtjw0hOiPtp4i
   rsplpn6FdKt0G5ZVoM9Vgs1glBGWDc4MI9oXXAZxwz9vUn/q3HDAhGvAC
   KfAU3gxIj0L7kefIqY7GrVXiqqunPRcYdCLt7r4B7cJbHYXYWBJdGGg6N
   qbeDTcjY+nWek1KGROfcJFPBM+02Zt9aK+urIb+PS2w+hlWnSzgdoZK57
   tU0FZk+pnG3izmsruLmfemf4qVGIh+z5Ke8/rmjLUNlLly08ELlbVyMgl
   5+y91ocqyHrJHfk9gAfMh1yIOTwnxPuSeFpJTZbkXBAqKAPdSIvOYlnX/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="399038875"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="399038875"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="590462640"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="590462640"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:54 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH v3 00/16] IFS multi test image support and misc changes
Date: Wed, 16 Nov 2022 19:59:19 -0800
Message-Id: <20221117035935.4136738-1-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107225323.2733518-1-jithu.joseph@intel.com>
References: <20221107225323.2733518-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes in v3
 - Rebased ontop of v6.1-rc5
 - Added reviewed-by tags from Sohil and Hans
 Boris
   - Moved dynamic memory allocation from scan_chunks_sanity_check()
      to driver init (patch 4)
   - Split v2's Expose microcode_sanity_check(), into 2 separate patches
      (patch 7 and patch8).
   - Add kerneldoc style comment to intel_microcode_sanity_check() and
      change parameter name to hdr_type instead of hdr_ver (patch 8)
   - Remove ifs_ prefix from static functions (patch 10, patch11)
   - Rename macro names more appropriately (patch10, patch8, patch12)
   - Remove obvious "what" from certain commit messages
   - Fix typos and wordings
  Dave
   - Use union to describe ifs meta_data structure and use u32 types
  Sohil
   - Use unsigned int to store current_batch (patch 11, patch 14)
   - Fix an inadvertent mistake in microcode_sanity_check (patch 7)
   - Fix wordings

v2 patches available from
Link: https://lore.kernel.org/lkml/20221107225323.2733518-1-jithu.joseph@intel.com/

Changes in v2
 - Rebased ontop of v6.1-rc4
 Boris
   - Moved exported functions (microcode_sanity_check(),
      find_matching_signature ) from microcode/intel.c to cpu/intel.c 
      (patch4,6)
   - Removed microcode metadata specific code changes to
      microcode_sanity_check() (patch6)
   - Moved find_meta_data() from common to IFS driver (Patch 8)
  Sohil
   - Dropped portions of Patch2 from v1 and folded remaining to Patch12
   - Rewording multiple commits
   - Avoid meta prefix in fields of metadata_header (patch8)
   - Defining MICROCODE_HEADER_VER* into common location (patch6, 9)
   - Elaborating error messages w.r.t processor flags (patch9)
   - Changed sysfs_emit() parameter (patch 11)

v1 patches available from
Link: https://lore.kernel.org/lkml/20221021203413.1220137-1-jithu.joseph@intel.com/

Initial implementation of IFS driver assumed a single IFS test image
file with a fixed name.

Subsequently, it became evident that supporting more than one
test image file is needed to provide more comprehensive
test coverage. (Test coverage in this scenario refers to testing
more transistors in the core to identify faults).

This series makes the driver aware of multiple scan test image files,
modifies IFS test image file headers to make it fully compatible
with microcode headers and adds a few other bug fixes and changes.

Patch organization:
Patches 1, and 2: bug fixes
Patch 3: Removes image loading during init path 
Patch 4: Move memory allocation from load to init path
Patch 5, 6, 7, 8: exports a couple of microcode/intel.c functions
                  for use by driver

Rest of them are IFS driver changes
Patch 9,10 and 12: microcode/IFS metadata section related
Patches 11: IFS header format changes to make it fully compatible
           to intel microcode header format
Patches 13, 14 and 15: native support for multiple scan test image files
Patch 16: reverts the broken flag

Ashok Raj (1):
  platform/x86/intel/ifs: Add metadata support

Jithu Joseph (15):
  platform/x86/intel/ifs: Remove unused selection
  platform/x86/intel/ifs: Return a more appropriate Error code
  platform/x86/intel/ifs: Remove image loading during init
  platform/x86/intel/ifs: Remove memory allocation from load path
  x86/microcode/intel: Reuse find_matching_signature()
  x86/microcode/intel: Use appropriate type in microcode_sanity_check()
  x86/microcode/intel: Reuse microcode_sanity_check()
  x86/microcode/intel: Add hdr_type to intel_microcode_sanity_check()
  x86/microcode/intel: Use a reserved field for metasize
  platform/x86/intel/ifs: Use generic microcode headers and functions
  platform/x86/intel/ifs: Add metadata validation
  platform/x86/intel/ifs: Remove reload sysfs entry
  platform/x86/intel/ifs: Add current_batch sysfs entry
  Documentation/ABI: Update IFS ABI doc
  Revert "platform/x86/intel/ifs: Mark as BROKEN"

 arch/x86/include/asm/cpu.h                    |   2 +
 arch/x86/include/asm/microcode_intel.h        |   5 +-
 drivers/platform/x86/intel/ifs/ifs.h          |  27 ++-
 arch/x86/kernel/cpu/intel.c                   | 141 +++++++++++
 arch/x86/kernel/cpu/microcode/intel.c         | 146 +-----------
 drivers/platform/x86/intel/ifs/core.c         |  14 +-
 drivers/platform/x86/intel/ifs/load.c         | 218 ++++++++++--------
 drivers/platform/x86/intel/ifs/runtest.c      |  10 +-
 drivers/platform/x86/intel/ifs/sysfs.c        |  41 ++--
 .../ABI/testing/sysfs-platform-intel-ifs      |  30 +--
 drivers/platform/x86/intel/ifs/Kconfig        |   4 -
 11 files changed, 356 insertions(+), 282 deletions(-)


base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
-- 
2.25.1

