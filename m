Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B287C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 19:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646164576; x=1677700576;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=XLKybxN7zciO2WXoGtuDgQD2mqkuZlXQf8E59ZXt5Es=;
  b=Nk+4jgrbuSybSsLgr5ArpiqiGinc2aVmuGUa+UZJ6UBNyAPVoZTY6sOw
   TX7WYjWZagtItpXs0EfmPMMBGoh67sJ1fNl4Tx7Pc9qwqrNmM8JzJKr7w
   TxajvP9iuSJPZHgL9fDveB2DTVQUeyCKpPpefS5Jn6Bv84RziRQg1Yx8V
   vWI1NP7e1SNHocMuba+eGT6iVwORXUOuz1MhdVLdCeUeRPbN0F/rEUfKn
   ZcPtscVvoa2w+zJOMFKWkBqUhjenajrpIdvdy67yRXGbC3UcbyianaAEd
   Hv00et+GM4bgkQio8rdxjsLz+UZPCr2g6P64L/+Kc0Zds+n2gemEPFri/
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="233842076"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="233842076"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 11:55:54 -0800
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="630133180"
Received: from coffy.sc.intel.com ([10.3.79.166])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 11:55:54 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
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
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [RFC 09/10] platform/x86/intel/ifs: add ABI documentation for IFS
Date: Tue,  1 Mar 2022 11:54:56 -0800
Message-Id: <20220301195457.21152-10-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301195457.21152-1-jithu.joseph@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Add the sysfs attributes in ABI/stable for In-Field Scan.

Originally-by: Kyung Min Park <kyung.min.park@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/ABI/stable/sysfs-driver-ifs | 85 +++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-ifs

diff --git a/Documentation/ABI/stable/sysfs-driver-ifs b/Documentation/ABI/stable/sysfs-driver-ifs
new file mode 100644
index 000000000000..8b6b9472f57e
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-ifs
@@ -0,0 +1,85 @@
+What:		/sys/devices/system/cpu/ifs/run_test
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	echo 1 to trigger ifs test for all online cores.
+
+What:		/sys/devices/system/cpu/ifs/status
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	Global status. Shows the most serious status across
+		all cores (fail > untested > pass)
+
+What:		/sys/devices/system/cpu/ifs/image_version
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	Version of loaded IFS binary image.
+
+What:		/sys/devices/system/cpu/ifs/reload
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	echo 1 to reload IFS image.
+
+What:		/sys/devices/system/cpu/ifs/cpu_pass_list
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	List of cpus which passed the IFS test.
+
+What:		/sys/devices/system/cpu/ifs/cpu_fail_list
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	List of cpus which failed the IFS test.
+
+What:		/sys/devices/system/cpu/ifs/cpu_untested_list
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	List of cpus which could not be tested.
+
+What:		/sys/module/intel_ifs/parameters/noint
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	SAF tunable parameter that user can modify before
+		the scan run if they wish to override default value.
+
+		When set, system interrupts are not allowed to interrupt an IFS. The
+		default state for this parameter is set.
+
+What:		/sys/module/intel_ifs/parameters/retry
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	SAF tunable parameter that user can modify at
+		load time if they wish to override default value.
+
+		Maximum retry counter when the test is not executed due to an
+		event such as interrupt. The default value is 5, it can be set to any
+		value from 1 to 20.
+
+What:		/sys/devices/system/cpu/cpu#/ifs/run_test
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	IFS target core testing. echo 1 to trigger scan test on cpu#.
+
+What:		/sys/devices/system/cpu/cpu#/ifs/status
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	The status of IFS test on a specific cpu#. It can be one of "pass", "fail"
+		or "untested".
+
+What:		/sys/devices/system/cpu/cpu#/ifs/details
+Date:		Feb 28, 2022
+KernelVersion:	5.18.0
+Contact:	linux-kernel@vger.kernel.org
+Description:	The details file reports the hex value of the SCAN_STATUS MSR. Note that
+		the error_code field may contain driver defined software code not defined
+		in the Intel SDM.
+
-- 
2.17.1

