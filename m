Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E3915C97
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 22:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861693; x=1699397693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ieAw6DOi25+M/PVVeqIKsG7UFRjhjw4Kz3UXCTTfxEQ=;
  b=RnPb+uxWCUPwKZCdoyiT2LsBwL4iOLX2kS2dxG02XSJigjmTYipTbQJd
   Z4t4cSenoreP8OfR1+cZJ7wuAZOWpnsUxZJHACKV62/r8o4WnVu7zA9Sj
   oagfOHh+t+6rNurMblMRH4oRSmnEN5wVT25cO9V/rimPxcO1+1dqt11OL
   qLmYi211MqjgUL92CdVncyto8nkuGVuaqV3D/dPRxNCeXLXOU+VPy3upy
   cHalis0TzIh89KH+VzegCkVIS17pnnLffQhLKIE08ucjUt/N2jiRuAJLT
   xUhzt6OXGOVyhTM09E5kfaNgj8TOWcnXM/FFa+tHRFCor0jLW8+ctg/F1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311697432"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311697432"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811012997"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811012997"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:49 -0800
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
Subject: [PATCH v2 13/14] Documentation/ABI: Update IFS ABI doc
Date: Mon,  7 Nov 2022 14:53:22 -0800
Message-Id: <20221107225323.2733518-14-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107225323.2733518-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove reload documentation and add current_batch documentation.
Update the kernel version and date for all the entries.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 .../ABI/testing/sysfs-platform-intel-ifs      | 30 ++++++++++---------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-ifs b/Documentation/ABI/testing/sysfs-platform-intel-ifs
index 486d6d2ff8a0..f74df3abee57 100644
--- a/Documentation/ABI/testing/sysfs-platform-intel-ifs
+++ b/Documentation/ABI/testing/sysfs-platform-intel-ifs
@@ -1,39 +1,41 @@
 What:		/sys/devices/virtual/misc/intel_ifs_<N>/run_test
-Date:		April 21 2022
-KernelVersion:	5.19
+Date:		Sept 30 2022
+KernelVersion:	6.2
 Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
 Description:	Write <cpu#> to trigger IFS test for one online core.
 		Note that the test is per core. The cpu# can be
 		for any thread on the core. Running on one thread
 		completes the test for the core containing that thread.
 		Example: to test the core containing cpu5: echo 5 >
-		/sys/devices/platform/intel_ifs.<N>/run_test
+		/sys/devices/virtual/misc/intel_ifs_<N>/run_test
 
 What:		/sys/devices/virtual/misc/intel_ifs_<N>/status
-Date:		April 21 2022
-KernelVersion:	5.19
+Date:		Sept 30 2022
+KernelVersion:	6.2
 Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
 Description:	The status of the last test. It can be one of "pass", "fail"
 		or "untested".
 
 What:		/sys/devices/virtual/misc/intel_ifs_<N>/details
-Date:		April 21 2022
-KernelVersion:	5.19
+Date:		Sept 30 2022
+KernelVersion:	6.2
 Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
 Description:	Additional information regarding the last test. The details file reports
 		the hex value of the SCAN_STATUS MSR. Note that the error_code field
 		may contain driver defined software code not defined in the Intel SDM.
 
 What:		/sys/devices/virtual/misc/intel_ifs_<N>/image_version
-Date:		April 21 2022
-KernelVersion:	5.19
+Date:		Sept 30 2022
+KernelVersion:	6.2
 Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
 Description:	Version (hexadecimal) of loaded IFS binary image. If no scan image
 		is loaded reports "none".
 
-What:		/sys/devices/virtual/misc/intel_ifs_<N>/reload
-Date:		April 21 2022
-KernelVersion:	5.19
+What:		/sys/devices/virtual/misc/intel_ifs_<N>/current_batch
+Date:		Sept 30 2022
+KernelVersion:	6.2
 Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
-Description:	Write "1" (or "y" or "Y") to reload the IFS image from
-		/lib/firmware/intel/ifs/ff-mm-ss.scan.
+Description:	Write a number less than or equal to 0xff to load an IFS test image.
+		The number written treated as the 2 digit suffix in the following file name:
+		/lib/firmware/intel/ifs_<N>/ff-mm-ss-02x.scan
+		Reading the file will provide the suffix of the currently loaded IFS test image.
-- 
2.25.1

