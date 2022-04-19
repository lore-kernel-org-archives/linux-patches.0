Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEC91378
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650386353; x=1681922353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=utZCRiqF7ikdREFmewY7FaeGHvf/w59lzGJRIW68qQI=;
  b=PKA2cxKtrRj7MFvMI7Cy8lDjjkmeBzamtHpOsdHY24uzguZG/IHNp1vr
   8VtR3/JmCFL8zF+Ux3Us8QVzA9ca5KICMIu/+mC5/T5fv0LppL+LhymbZ
   N5clygoqhdJwq4RRgHT6Rs3kdL3MRqgGH26duZ9tae636WzUvGAgQqXSr
   NbIDOyARi2161DC0YQreOyf6czCLYVtw9j5ItJ21O6da7ha6nuN07tM0r
   p8JA/1DMtl8xmKGs4xu4htOYob9L+96zsdxy8aAg82GAJUxjaAt3Tkzmy
   qgg53Xxl2P/8zR3xX84yPtQV9ImwdW3kCnpbmph30RWl+b/J0/KNywocZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="244395743"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="244395743"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="554802177"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:10 -0700
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
Subject: [PATCH v3 11/11] platform/x86/intel/ifs: add ABI documentation for IFS
Date: Tue, 19 Apr 2022 09:38:59 -0700
Message-Id: <20220419163859.2228874-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419163859.2228874-1-tony.luck@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220419163859.2228874-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jithu Joseph <jithu.joseph@intel.com>

Add the sysfs attributes in ABI/testing for In-Field Scan.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../ABI/testing/sysfs-platform-intel-ifs      | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-ifs

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-ifs b/Documentation/ABI/testing/sysfs-platform-intel-ifs
new file mode 100644
index 000000000000..7a753c9f2dd7
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-intel-ifs
@@ -0,0 +1,39 @@
+What:		/sys/devices/platform/intel_ifs.<N>/run_test
+Date:		April 13, 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Write <cpu#> to trigger IFS test for one online core.
+		Note that the test is per core. The cpu# can be
+		for any thread on the core. Running on one thread
+		completes the test for the core containing that thread.
+		Example: to test the core containing cpu5: echo 5 >
+		/sys/devices/platform/intel_ifs.<N>/run_test
+
+What:		/sys/devices/platform/intel_ifs.<N>/status
+Date:		April 13, 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	The status of the last test. It can be one of "pass", "fail"
+		or "untested".
+
+What:		/sys/devices/system/cpu/cpu#/ifs.<N>/details
+Date:		April 13, 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Additional information regarding the last test. The details file reports
+		the hex value of the SCAN_STATUS MSR. Note that the error_code field
+		may contain driver defined software code not defined in the Intel SDM.
+
+What:		/sys/devices/platform/intel_ifs.<N>/image_version
+Date:		April 13, 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Version (hexadecimal) of loaded IFS binary image. If no scan image
+		is loaded reports "none".
+
+What:		/sys/bus/platform/drivers/intel_ifs.<N>/reload
+Date:		April 13, 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Write "1" > reload to reload IFS image from
+		/lib/firmware/intel/ifs/ff-mm-ss.scan.
-- 
2.35.1

