Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C7662A
	for <patches@lists.linux.dev>; Fri,  6 May 2022 01:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651801250; x=1683337250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y6AdNcL23AXH/PwccmO/lGBoL6djloRm+NY0sn6Dk+I=;
  b=Gg0VHZCX0Z7GDyx8zSrZormIXkMNNpXaAUoVbk8notVh4QAlaQRKxbqm
   0QAtkp45UHVHs2voVOZQZrvuAxTeVh664j3ay/NKK7XHQilfsywZafuMp
   ECt6K9AoFJdSWI8xMgibawo++v4nG6iNJwSKaekCWqD6En7z8/Pl7FbGV
   b1aU5vlvuazFdGDKqGWiM0EOD9w3ilEwE66lptKwcXUiQjnLBtdX637ov
   SUKX9m8DaF+0RbyQZ/MbysHipVa4VahbxT2HdCKn6MBhwG/mi1qy1Ia1c
   Zm/hvz+ieW7v3c42dHeNNRxbhPcIa4eYUoyO9cbnlDVvtPzTrk+KNow+/
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328858658"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="328858658"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:40:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537645062"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:40:48 -0700
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
Subject: [PATCH v6 11/11] platform/x86/intel/ifs: add ABI documentation for IFS
Date: Thu,  5 May 2022 18:40:35 -0700
Message-Id: <20220506014035.1173578-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506014035.1173578-1-tony.luck@intel.com>
References: <20220428153849.295779-1-tony.luck@intel.com>
 <20220506014035.1173578-1-tony.luck@intel.com>
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
Acked-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../ABI/testing/sysfs-platform-intel-ifs      | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-ifs

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-ifs b/Documentation/ABI/testing/sysfs-platform-intel-ifs
new file mode 100644
index 000000000000..486d6d2ff8a0
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-intel-ifs
@@ -0,0 +1,39 @@
+What:		/sys/devices/virtual/misc/intel_ifs_<N>/run_test
+Date:		April 21 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Write <cpu#> to trigger IFS test for one online core.
+		Note that the test is per core. The cpu# can be
+		for any thread on the core. Running on one thread
+		completes the test for the core containing that thread.
+		Example: to test the core containing cpu5: echo 5 >
+		/sys/devices/platform/intel_ifs.<N>/run_test
+
+What:		/sys/devices/virtual/misc/intel_ifs_<N>/status
+Date:		April 21 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	The status of the last test. It can be one of "pass", "fail"
+		or "untested".
+
+What:		/sys/devices/virtual/misc/intel_ifs_<N>/details
+Date:		April 21 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Additional information regarding the last test. The details file reports
+		the hex value of the SCAN_STATUS MSR. Note that the error_code field
+		may contain driver defined software code not defined in the Intel SDM.
+
+What:		/sys/devices/virtual/misc/intel_ifs_<N>/image_version
+Date:		April 21 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Version (hexadecimal) of loaded IFS binary image. If no scan image
+		is loaded reports "none".
+
+What:		/sys/devices/virtual/misc/intel_ifs_<N>/reload
+Date:		April 21 2022
+KernelVersion:	5.19
+Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
+Description:	Write "1" (or "y" or "Y") to reload the IFS image from
+		/lib/firmware/intel/ifs/ff-mm-ss.scan.
-- 
2.35.1

