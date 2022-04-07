Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DE52598
	for <patches@lists.linux.dev>; Thu,  7 Apr 2022 19:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649358863; x=1680894863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=fqThAvr1I3L7T9wbCSFNkzuXDhoOwY6Ol47Y2zn/xYA=;
  b=Spf0FzF3P2WU84I+N+xAAM7Y5Pp3VbNrfzrWZKv/vwlzI4pnvuZSH29O
   hPSkW8efYA+rVXfGIpJNlLdOK441f3i2bkhSMS/vhJ6R6D50pDteSGhyw
   q/r3tpy1TCsA1MzbtqHJNL2up09RF6i2eiZ7blCYrAIWY06+zyDyTN4dV
   +9I2a9VHTuJ++C0XPm4ck8CtZNx2kzAuOUxZSVagTx5jKKWYzD/+jg4ik
   +UM80TSRH4tLmwvzN2q2y2vOD0UW2tsQNAXJrzaryIHPnyrziYfXXQBIP
   UnwPniOq9xsrShZ9pLL1mQtZmAq+ucFIPY+LP+WCAEeP0RzWcEmnCgkE/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="322111013"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="322111013"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:14:19 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="571193732"
Received: from coffy.sc.intel.com ([10.3.79.166])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:14:18 -0700
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
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [PATCH v2 09/10] platform/x86/intel/ifs: add ABI documentation for IFS
Date: Thu,  7 Apr 2022 12:13:46 -0700
Message-Id: <20220407191347.9681-10-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407191347.9681-1-jithu.joseph@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Add the sysfs attributes in ABI/testing for In-Field Scan.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 .../ABI/testing/sysfs-platform-intel-ifs      | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-ifs

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-ifs b/Documentation/ABI/testing/sysfs-platform-intel-ifs
new file mode 100644
index 000000000000..54dc6cd75484
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-intel-ifs
@@ -0,0 +1,54 @@
+What:		/sys/devices/platform/intel_ifs/run_test
+Date:		April 07, 2022
+KernelVersion:	5.19.0
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	echo <cpu#> to trigger ifs test for all online cores.
+		For e.g to test cpu5 do echo 5 > /sys/devices/platform/intel_ifs/run_test
+
+What:		/sys/devices/platform/intel_ifs/status
+Date:		April 07, 2022
+KernelVersion:	5.19.0
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	The status of the last test. It can be one of "pass", "fail"
+		or "untested".
+
+What:		/sys/devices/system/cpu/cpu#/ifs/details
+Date:		April 07, 2022
+KernelVersion:	5.19.0
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Additional information regarding the last test. The details file reports
+		the hex value of the SCAN_STATUS MSR. Note that the error_code field
+		may contain driver defined software code not defined in the Intel SDM.
+
+What:		/sys/devices/platform/intel_ifs/image_version
+Date:		April 07, 2022
+KernelVersion:	5.19.0
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Version of loaded IFS binary image.
+
+What:		/sys/bus/platform/drivers/intel_ifs/bind
+Date:		April 07, 2022
+KernelVersion:	5.19.0
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	echo "intel_ifs" to reload IFS image.
+
+What:		/sys/module/intel_ifs/parameters/noirq
+Date:		April 07, 2022
+KernelVersion:	5.19.0
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	IFS tunable parameter that user can modify before
+		the scan run if they wish to override default value.
+
+		When set, system interrupts are not allowed to interrupt an IFS. The
+		default state for this parameter is set.
+
+What:		/sys/module/intel_ifs/parameters/retry
+Date:		April 07, 2022
+KernelVersion:	5.19.0
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	IFS tunable parameter that user can modify before scan run
+		if they wish to override default value.
+
+		Maximum retry counter when the test is not executed due to an
+		event such as interrupt. The default value is 5, it can be set to any
+		value from 1 to 20.
-- 
2.17.1

