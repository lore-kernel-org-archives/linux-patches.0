Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179D43D89
	for <patches@lists.linux.dev>; Fri,  6 May 2022 22:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651877665; x=1683413665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z5FZPzcnm4iGFKmgA6F8JRxrUCFwdulp9PZjuNmmimo=;
  b=Sda3cMaHOvGXyrrJ6lB6kGQnd8Q502lux4BnAVbL6JPKCie/4NZUsaLc
   /6MqPm5yhKKUJFwFoemFNCDo6fBfzE4kd4uiNOgfRhnMV19jKJFNBMK3B
   zhbtOduQh62I1uh85GYnOVhUsq6WK19OY5PzF1D9ASCza6FsLSD4w04g0
   eJsfTm2r05ACwq4PFi3WS8UV2I5luQ1d/6s+F0YlN2WZ03nZCCcrAuIHm
   BV7KI1bTq/GukG74Tz6WZbkNA4nv3uIIXF7UQTzET2Kzz1eWZxnwNS4dy
   MzEBiJqUt9JTVVd01Leh/gpwb5s3Qp2LNPu52ae4765QdVHk/VE2uPJAz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="355030711"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="355030711"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="695383654"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:21 -0700
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
Subject: [PATCH v7 12/12] Documentation: In-Field Scan
Date: Fri,  6 May 2022 15:54:10 -0700
Message-Id: <20220506225410.1652287-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506225410.1652287-1-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add documentation for In-Field Scan (IFS). This documentation
describes the basics of IFS, the loading IFS image, chunk
authentication, running scan and how to check result via sysfs.

The CORE_CAPABILITIES MSR enumerates whether IFS is supported.

The full  github location for distributing the IFS images is
still being decided. So just a placeholder included for now
in the documentation.

Future CPUs will support more than one type of test. Plan for
that now by using a "_0" suffix on the ABI directory names.
Additional test types will use "_1", etc.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/x86/ifs.rst            |   2 +
 Documentation/x86/index.rst          |   1 +
 drivers/platform/x86/intel/ifs/ifs.h | 110 +++++++++++++++++++++++++++
 3 files changed, 113 insertions(+)
 create mode 100644 Documentation/x86/ifs.rst

diff --git a/Documentation/x86/ifs.rst b/Documentation/x86/ifs.rst
new file mode 100644
index 000000000000..97abb696a680
--- /dev/null
+++ b/Documentation/x86/ifs.rst
@@ -0,0 +1,2 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. kernel-doc:: drivers/platform/x86/intel/ifs/ifs.h
diff --git a/Documentation/x86/index.rst b/Documentation/x86/index.rst
index 91b2fa456618..9d8e8a73d57b 100644
--- a/Documentation/x86/index.rst
+++ b/Documentation/x86/index.rst
@@ -35,6 +35,7 @@ x86-specific Documentation
    usb-legacy-support
    i386/index
    x86_64/index
+   ifs
    sva
    sgx
    features
diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 720bd18a5e91..73c8e91cf144 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -4,6 +4,116 @@
 #ifndef _IFS_H_
 #define _IFS_H_
 
+/**
+ * DOC: In-Field Scan
+ *
+ * =============
+ * In-Field Scan
+ * =============
+ *
+ * Introduction
+ * ------------
+ *
+ * In Field Scan (IFS) is a hardware feature to run circuit level tests on
+ * a CPU core to detect problems that are not caught by parity or ECC checks.
+ * Future CPUs will support more than one type of test which will show up
+ * with a new platform-device instance-id, for now only .0 is exposed.
+ *
+ *
+ * IFS Image
+ * ---------
+ *
+ * Intel provides a firmware file containing the scan tests via
+ * github [#f1]_.  Similar to microcode there is a separate file for each
+ * family-model-stepping.
+ *
+ * IFS Image Loading
+ * -----------------
+ *
+ * The driver loads the tests into memory reserved BIOS local to each CPU
+ * socket in a two step process using writes to MSRs to first load the
+ * SHA hashes for the test. Then the tests themselves. Status MSRs provide
+ * feedback on the success/failure of these steps. When a new test file
+ * is installed it can be loaded by writing to the driver reload file::
+ *
+ *   # echo 1 > /sys/devices/virtual/misc/intel_ifs_0/reload
+ *
+ * Similar to microcode, the current version of the scan tests is stored
+ * in a fixed location: /lib/firmware/intel/ifs.0/family-model-stepping.scan
+ *
+ * Running tests
+ * -------------
+ *
+ * Tests are run by the driver synchronizing execution of all threads on a
+ * core and then writing to the ACTIVATE_SCAN MSR on all threads. Instruction
+ * execution continues when:
+ *
+ * 1) All tests have completed.
+ * 2) Execution was interrupted.
+ * 3) A test detected a problem.
+ *
+ * Note that ALL THREADS ON THE CORE ARE EFFECTIVELY OFFLINE FOR THE
+ * DURATION OF THE TEST. This can be up to 200 milliseconds. If the system
+ * is running latency sensitive applications that cannot tolerate an
+ * interruption of this magnitude, the system administrator must arrange
+ * to migrate those applications to other cores before running a core test.
+ * It may also be necessary to redirect interrupts to other CPUs.
+ *
+ * In all cases reading the SCAN_STATUS MSR provides details on what
+ * happened. The driver makes the value of this MSR visible to applications
+ * via the "details" file (see below). Interrupted tests may be restarted.
+ *
+ * The IFS driver provides sysfs interfaces via /sys/devices/virtual/misc/intel_ifs_0/
+ * to control execution:
+ *
+ * Test a specific core::
+ *
+ *   # echo <cpu#> > /sys/devices/virtual/misc/intel_ifs_0/run_test
+ *
+ * when HT is enabled any of the sibling cpu# can be specified to test
+ * its corresponding physical core. Since the tests are per physical core,
+ * the result of testing any thread is same. All siblings must be online
+ * to run a core test. It is only necessary to test one thread.
+ *
+ * For e.g. to test core corresponding to cpu5
+ *
+ *   # echo 5 > /sys/devices/virtual/misc/intel_ifs_0/run_test
+ *
+ * Results of the last test is provided in /sys::
+ *
+ *   $ cat /sys/devices/virtual/misc/intel_ifs_0/status
+ *   pass
+ *
+ * Status can be one of pass, fail, untested
+ *
+ * Additional details of the last test is provided by the details file::
+ *
+ *   $ cat /sys/devices/virtual/misc/intel_ifs_0/details
+ *   0x8081
+ *
+ * The details file reports the hex value of the SCAN_STATUS MSR.
+ * Hardware defined error codes are documented in volume 4 of the Intel
+ * Software Developer's Manual but the error_code field may contain one of
+ * the following driver defined software codes:
+ *
+ * +------+--------------------+
+ * | 0xFD | Software timeout   |
+ * +------+--------------------+
+ * | 0xFE | Partial completion |
+ * +------+--------------------+
+ *
+ * Driver design choices
+ * ---------------------
+ *
+ * 1) The ACTIVATE_SCAN MSR allows for running any consecutive subrange of
+ * available tests. But the driver always tries to run all tests and only
+ * uses the subrange feature to restart an interrupted test.
+ *
+ * 2) Hardware allows for some number of cores to be tested in parallel.
+ * The driver does not make use of this, it only tests one core at a time.
+ *
+ * .. [#f1] https://github.com/intel/TBD
+ */
 #include <linux/device.h>
 #include <linux/miscdevice.h>
 
-- 
2.35.1

