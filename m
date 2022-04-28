Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E090A1362
	for <patches@lists.linux.dev>; Thu, 28 Apr 2022 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651160345; x=1682696345;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KNI6TywIBrtMzHC0wppg8qEsX62tIPxK1F8eBPhI0zQ=;
  b=If2uAnZjH7wR12/8JE1TYj9KY0BMivgO3s3tCfA9TB9VLZvjggLBdwIG
   vna6Y28I9QvA9Qkkc7cz0/9pXRVvCKH9UzgAKADlpWkYsAZdtjnFrM4m+
   jkomAg7BIn2YQUVaF2fAXcG19x1xRo4u97yQl30G4Rv//HIdeCogYTwUV
   qro5qJPzQz+q6YL4MCFtGvOpEgnmx8DR6bq6kISrTJGNl3gZfm/cyEix2
   Z4mCzGLRxvoIoi9Ku8FQRNLeoynd+mOYJMHpwxbOm+AexJ3VA3/Y0I3+N
   DQNPFS8vhFVww1vExPbfwyCTSpiNnjHlfNKJKAKTk6eYQRyqQIMMqv89Y
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="352759575"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="352759575"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:39:00 -0700
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="559734311"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:38:59 -0700
From: Tony Luck <tony.luck@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	andriy.shevchenko@linux.intel.com,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	rostedt@goodmis.org,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [PATCH v5 00/10] Introduce In Field Scan driver
Date: Thu, 28 Apr 2022 08:38:39 -0700
Message-Id: <20220428153849.295779-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422200219.2843823-1-tony.luck@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hopefully this is close enough to done to begin discussion on which
maintainer tree will take this series.

Choices:
1) Hans/Mark take it into the platform-drivers tree
   Needs an Ack from x86 maintainers on parts 1 & 2
2) X86 maintainers take it into TIP
   Needs Ack from Hans/Mark on parts 2-10

TL;DR this driver loads scan test files that can check whether silicon
in a CPU core is still running correctly. It is expected that these tests
would be run several times per day to catch problems as silicon ages.

Changes since v4:

Greg Kroah-Hartman
------------------
 "Cute way to do this, but I don't see you ever have any more devices
 added to this list in this series."

 Removed the enum, arrays, loops, and count of test types discovered.
 Now just check for enumeration of the single test type that is being
 deployed on Sapphire Rapids.


Jithu Joseph (7):
  x86/microcode/intel: Expose collect_cpu_info_early() for IFS
  platform/x86/intel/ifs: Read IFS firmware image
  platform/x86/intel/ifs: Check IFS Image sanity
  platform/x86/intel/ifs: Authenticate and copy to secured memory
  platform/x86/intel/ifs: Add scan test support
  platform/x86/intel/ifs: Add IFS sysfs interface
  platform/x86/intel/ifs: add ABI documentation for IFS

Tony Luck (3):
  x86/msr-index: Define INTEGRITY_CAPABILITIES MSR
  platform/x86/intel/ifs: Add stub driver for In-Field Scan
  trace: platform/x86/intel/ifs: Add trace point to track Intel IFS
    operations

 .../ABI/testing/sysfs-platform-intel-ifs      |  39 ++
 MAINTAINERS                                   |   8 +
 arch/x86/include/asm/cpu.h                    |  18 +
 arch/x86/include/asm/msr-index.h              |   7 +
 arch/x86/kernel/cpu/intel.c                   |  32 ++
 arch/x86/kernel/cpu/microcode/intel.c         |  59 +---
 drivers/platform/x86/intel/Kconfig            |   1 +
 drivers/platform/x86/intel/Makefile           |   1 +
 drivers/platform/x86/intel/ifs/Kconfig        |  13 +
 drivers/platform/x86/intel/ifs/Makefile       |   3 +
 drivers/platform/x86/intel/ifs/core.c         |  80 +++++
 drivers/platform/x86/intel/ifs/ifs.h          | 123 +++++++
 drivers/platform/x86/intel/ifs/load.c         | 262 ++++++++++++++
 drivers/platform/x86/intel/ifs/runtest.c      | 332 ++++++++++++++++++
 drivers/platform/x86/intel/ifs/sysfs.c        | 147 ++++++++
 include/trace/events/intel_ifs.h              |  38 ++
 16 files changed, 1111 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-ifs
 create mode 100644 drivers/platform/x86/intel/ifs/Kconfig
 create mode 100644 drivers/platform/x86/intel/ifs/Makefile
 create mode 100644 drivers/platform/x86/intel/ifs/core.c
 create mode 100644 drivers/platform/x86/intel/ifs/ifs.h
 create mode 100644 drivers/platform/x86/intel/ifs/load.c
 create mode 100644 drivers/platform/x86/intel/ifs/runtest.c
 create mode 100644 drivers/platform/x86/intel/ifs/sysfs.c
 create mode 100644 include/trace/events/intel_ifs.h


base-commit: af2d861d4cd2a4da5137f795ee3509e6f944a25b
-- 
2.35.1

