Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BF2C5D2
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 23:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676418359; x=1707954359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eiS3IxaAsk6x7BayF1DCQxveYExshrK1kKyFW8zL/CQ=;
  b=hp3GBOYZqwZ3M6mPyYU86CkDWifK7aevTJV4n52mu0YSqmcJESltHjpg
   U00N6YESJvCTosSEPuM9EVuK8u9ECZ6Oc8eYDGvfZylx36S7tMyOa5/MI
   NtdVxV/gY4ufK1o4QqGM9qy1pt1Cm5GfEt/9W8UV3alA1mnCxUwc6RWsy
   mgU5EHLmRE/RbVhUMYBJxm3D/oRCtVEVHP4R6N5Ja3YFjbB/oGqGkeO/r
   8MwUBARMuTaXt1faeHXotPlQAUM435DY5SDRK3Cr779p2VgI8tAXgdvdN
   B5f19DtKhR70HtybFLfNW4NMX5UDgRjaonl2i3pGoPLy3GdxmEAPbKjUy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417523058"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="417523058"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 15:45:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="669391026"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="669391026"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 15:45:58 -0800
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
Subject: [PATCH v2 7/7] Documentation/ABI: Update IFS ABI doc
Date: Tue, 14 Feb 2023 15:44:26 -0800
Message-Id: <20230214234426.344960-8-jithu.joseph@intel.com>
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

Array BIST test doesn't need an IFS test image to operate unlike
the SCAN test. Consequently current_batch and image_version
files are not applicable for Array BIST IFS device instance,
clarify this in the ABI doc.

Also given that multiple tests are supported, take the opportunity
to generalize descriptions wherever applicable.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/ABI/testing/sysfs-platform-intel-ifs | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-ifs b/Documentation/ABI/testing/sysfs-platform-intel-ifs
index 55991983d0d0..c0cc5ef0739a 100644
--- a/Documentation/ABI/testing/sysfs-platform-intel-ifs
+++ b/Documentation/ABI/testing/sysfs-platform-intel-ifs
@@ -21,15 +21,16 @@ Date:		Nov 16 2022
 KernelVersion:	6.2
 Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
 Description:	Additional information regarding the last test. The details file reports
-		the hex value of the SCAN_STATUS MSR. Note that the error_code field
+		the hex value of the STATUS MSR for this test. Note that the error_code field
 		may contain driver defined software code not defined in the Intel SDM.
 
 What:		/sys/devices/virtual/misc/intel_ifs_<N>/image_version
 Date:		Nov 16 2022
 KernelVersion:	6.2
 Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
-Description:	Version (hexadecimal) of loaded IFS binary image. If no scan image
-		is loaded reports "none".
+Description:	Version (hexadecimal) of loaded IFS test image. If no test image
+		is loaded reports "none". Only present for device instances where a test image
+		is applicable.
 
 What:		/sys/devices/virtual/misc/intel_ifs_<N>/current_batch
 Date:		Nov 16 2022
@@ -39,3 +40,4 @@ Description:	Write a number less than or equal to 0xff to load an IFS test image
 		The number written treated as the 2 digit suffix in the following file name:
 		/lib/firmware/intel/ifs_<N>/ff-mm-ss-02x.scan
 		Reading the file will provide the suffix of the currently loaded IFS test image.
+		This file is present only for device instances where a test image is applicable.
-- 
2.25.1

