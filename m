Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D538A2D
	for <patches@lists.linux.dev>; Thu, 31 Mar 2022 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648749450; x=1680285450;
  h=subject:to:cc:from:date:message-id;
  bh=Tni5TvFdZxJ9Gt3pi48UQ12BLf0D4PuKmQOSgUQxUec=;
  b=HC3LQTPpv81Kq7urue17s3wToppJ1OU5I4os8rV0gR0Y5V7ntpfXiuUG
   QRlS01KaF41+U3AsbLVvC4rqC+CAF4kt80kA/6Y27fyu0bALSopoUsRde
   ftWDypQbm+KHOs+weU9YqHLvYcFLpSrYVdmQkOj2A+tIBDEnJYdlSxwAD
   fAYpgbIgX0tKw7OerBjXdrErpayLTZORvrDKX0teoftRF8u0kfy6l2+KU
   b4eLRhAw3awS3JH+wq5Cl5DexK2JIkqUK4A6FobYDTgS5IeCwVJwO8HCb
   5ORlV8PyROKw/DUzUY+GXR+0ytvzUh35lVwr/sFlyAaYW4EWTRzUsmU/P
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="242061507"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="242061507"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 10:57:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="840872318"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2022 10:57:28 -0700
Subject: [PATCH] [v2] x86/configs: Add x86 debugging Kconfig fragment plus docs
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,Dave Hansen <dave.hansen@linux.intel.com>,corbet@lwn.net,bp@suse.de,tglx@linutronix.de,x86@kernel.org,linux-doc@vger.kernel.org
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Thu, 31 Mar 2022 10:57:28 -0700
Message-Id: <20220331175728.299103A0@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>


Changes from v1:

 * Add actual .config fragment instead of just documenting it
 * Note that these partially x86-specific, but the rest can be
   used to test all tip contributions.

--

From: Dave Hansen <dave.hansen@linux.intel.com>

The kernel has a wide variety of debugging options to help catch
and squash bugs.  However, new debugging is added all the time and
the existing options can be hard to find.

Add a Kconfig fragment with the debugging options which tip
maintainers expect to be used to test contributions.

This should make it easier for contributors to test their code and
find issues before submission.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: linux-doc@vger.kernel.org
---

 b/Documentation/process/maintainer-tip.rst |   14 ++++++++++++++
 b/kernel/configs/x86_debug.config          |   17 +++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN Documentation/process/maintainer-tip.rst~0001-RFC-Documentation-process-Add-testing-section-to-tip Documentation/process/maintainer-tip.rst
--- a/Documentation/process/maintainer-tip.rst~0001-RFC-Documentation-process-Add-testing-section-to-tip	2022-03-31 10:52:55.718665861 -0700
+++ b/Documentation/process/maintainer-tip.rst	2022-03-31 10:52:55.722665862 -0700
@@ -437,6 +437,20 @@ in a private repository which allows int
 series for testing. The usual way to offer this is a git URL in the cover
 letter of the patch series.
 
+Testing
+^^^^^^^
+
+Code should be tested before submitting to the tip maintainers.  Anything
+other than minor changes should be built, booted and tested with
+comprehensive (and heavyweight) kernel debugging options enabled.
+
+These debugging options can be found in kernel/configs/x86_debug.config
+and can be added to an existing kernel config by running:
+
+	make x86_debug.config
+
+Some of these options are x86-specific and can be left out when testing
+on other architectures.
 
 Coding style notes
 ------------------
diff -puN /dev/null kernel/configs/x86_debug.config
--- /dev/null	2022-03-26 18:22:40.487999538 -0700
+++ b/kernel/configs/x86_debug.config	2022-03-31 10:53:10.318671042 -0700
@@ -0,0 +1,17 @@
+CONFIG_X86_DEBUG_FPU=y
+CONFIG_LOCK_STAT=y
+CONFIG_DEBUG_VM=y
+CONFIG_DEBUG_VM_VMACACHE=y
+CONFIG_DEBUG_VM_RB=y
+CONFIG_DEBUG_SLAB=y
+CONFIG_DEBUG_KMEMLEAK=y
+CONFIG_DEBUG_PAGEALLOC=y
+CONFIG_SLUB_DEBUG_ON=y
+CONFIG_KMEMCHECK=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
+CONFIG_GCOV_KERNEL=y
+CONFIG_LOCKDEP=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_SCHEDSTATS=y
+CONFIG_VMLINUX_VALIDATION=y
_
