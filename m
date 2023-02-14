Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30934C5D4
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 23:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676418359; x=1707954359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sv9VY7ZhDkazi+PPN2tu+ANJj7RA9Fo3Wl/1+QS58MM=;
  b=FoGRDh8q5ie/E8aD7ozMpznyBqOh/cPzAvHFEETQvan4/503/zCIh1tv
   6M2zQwbJM3kMbF7nvBBMe8aw8xOm6UxToFX8uo3ioyrIyLzg9SySn/YUZ
   9mGXD9ULuSm9Vk2ou7t2jD5BzHrNG5/x4GNHsE8ebSWbN6fhZEs+kKQq7
   GEK6T2/DHFQkdwH1A20Xfcow4FxNCw7/KttB+E08dXKTYEhKu43q0kh1v
   0/oUBM9OeL3kfigeLUE9cRF5lIyI7p1y3HBRR2FzTz5O7VkXmu5m5feXz
   pqtltUquS1rSEc61wVTRB8fIrD4WKj7+m//9m6DvktCFOy3F1fyN865nm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417523047"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="417523047"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 15:45:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="669391023"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="669391023"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 15:45:57 -0800
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
	rostedt@goodmis.org,
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
Subject: [PATCH v2 6/7] platform/x86/intel/ifs: Update IFS doc
Date: Tue, 14 Feb 2023 15:44:25 -0800
Message-Id: <20230214234426.344960-7-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214234426.344960-1-jithu.joseph@intel.com>
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
 <20230214234426.344960-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Array BIST is the second test supported by IFS. Modify IFS doc
entry to be more general.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index e5375191b56d..00bc86db1193 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -17,7 +17,7 @@
  * In Field Scan (IFS) is a hardware feature to run circuit level tests on
  * a CPU core to detect problems that are not caught by parity or ECC checks.
  * Future CPUs will support more than one type of test which will show up
- * with a new platform-device instance-id, for now only .0 is exposed.
+ * with a new platform-device instance-id.
  *
  *
  * IFS Image
@@ -25,7 +25,10 @@
  *
  * Intel provides a firmware file containing the scan tests via
  * github [#f1]_.  Similar to microcode there is a separate file for each
- * family-model-stepping.
+ * family-model-stepping. IFS Images are not applicable for some test types.
+ * Wherever applicable the sysfs directory would provide a "current_batch" file
+ * (see below) for loading the image.
+ *
  *
  * IFS Image Loading
  * -----------------
@@ -35,7 +38,7 @@
  * SHA hashes for the test. Then the tests themselves. Status MSRs provide
  * feedback on the success/failure of these steps.
  *
- * The test files are kept in a fixed location: /lib/firmware/intel/ifs_0/
+ * The test files are kept in a fixed location: /lib/firmware/intel/ifs_<n>/
  * For e.g if there are 3 test files, they would be named in the following
  * fashion:
  * ff-mm-ss-01.scan
@@ -47,7 +50,7 @@
  * (e.g 1, 2 or 3 in the above scenario) into the curent_batch file.
  * To load ff-mm-ss-02.scan, the following command can be used::
  *
- *   # echo 2 > /sys/devices/virtual/misc/intel_ifs_0/current_batch
+ *   # echo 2 > /sys/devices/virtual/misc/intel_ifs_<n>/current_batch
  *
  * The above file can also be read to know the currently loaded image.
  *
@@ -69,16 +72,16 @@
  * to migrate those applications to other cores before running a core test.
  * It may also be necessary to redirect interrupts to other CPUs.
  *
- * In all cases reading the SCAN_STATUS MSR provides details on what
+ * In all cases reading the corresponding test's STATUS MSR provides details on what
  * happened. The driver makes the value of this MSR visible to applications
  * via the "details" file (see below). Interrupted tests may be restarted.
  *
- * The IFS driver provides sysfs interfaces via /sys/devices/virtual/misc/intel_ifs_0/
+ * The IFS driver provides sysfs interfaces via /sys/devices/virtual/misc/intel_ifs_<n>/
  * to control execution:
  *
  * Test a specific core::
  *
- *   # echo <cpu#> > /sys/devices/virtual/misc/intel_ifs_0/run_test
+ *   # echo <cpu#> > /sys/devices/virtual/misc/intel_ifs_<n>/run_test
  *
  * when HT is enabled any of the sibling cpu# can be specified to test
  * its corresponding physical core. Since the tests are per physical core,
@@ -87,18 +90,18 @@
  *
  * For e.g. to test core corresponding to cpu5
  *
- *   # echo 5 > /sys/devices/virtual/misc/intel_ifs_0/run_test
+ *   # echo 5 > /sys/devices/virtual/misc/intel_ifs_<n>/run_test
  *
  * Results of the last test is provided in /sys::
  *
- *   $ cat /sys/devices/virtual/misc/intel_ifs_0/status
+ *   $ cat /sys/devices/virtual/misc/intel_ifs_<n>/status
  *   pass
  *
  * Status can be one of pass, fail, untested
  *
  * Additional details of the last test is provided by the details file::
  *
- *   $ cat /sys/devices/virtual/misc/intel_ifs_0/details
+ *   $ cat /sys/devices/virtual/misc/intel_ifs_<n>/details
  *   0x8081
  *
  * The details file reports the hex value of the SCAN_STATUS MSR.
-- 
2.25.1

