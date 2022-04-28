Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E42E1364
	for <patches@lists.linux.dev>; Thu, 28 Apr 2022 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651160349; x=1682696349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=09faArqF0ybDa7yJRCawo2WfNEh4ZJlwmYaJ5Yj+Yxg=;
  b=D6r4jsEdhtl8URd09InoN6FMKQAt4+hU3TKxDTB7l3DsGC3RFRGkraG3
   xLgdr59GymHW+tSFzyMgYPv06LLDJAPpf0Slp3nEgOSfPIBJ5rGmaiCyl
   vXF2PoUowqvRF4D/CiB3E5ZkmL7Krtl5ITxFXXrmsYT8MUfYg29MjiHgd
   jH4Hd+QmbYLArClzGMw+neVH+c+5ck/RXJDpdvsE+DOAoEz5YMkDfjwL1
   2SrM9izMz6gRNfh+8MS25JOB2/jFYbvJlnVJ6KqtJT5X2cQ5VjRArlwNH
   DsrHaEZ9E7TUzF4xNPlGhSRxrDT6C3ETUf/A3fTIsbKjXcdhqdIIIGZcp
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="352759577"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="352759577"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:39:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="559734318"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:39:00 -0700
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
Subject: [PATCH v5 02/10] x86/msr-index: Define INTEGRITY_CAPABILITIES MSR
Date: Thu, 28 Apr 2022 08:38:41 -0700
Message-Id: <20220428153849.295779-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428153849.295779-1-tony.luck@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The INTEGRITY_CAPABILITIES MSR is enumerated by bit 2 of the
CORE_CAPABILITIES MSR.

Add defines for the CORE_CAPS enumeration as well as for the integrity
MSR.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/msr-index.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ee15311b6be1..c3dc7ae32f1f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -76,6 +76,8 @@
 
 /* Abbreviated from Intel SDM name IA32_CORE_CAPABILITIES */
 #define MSR_IA32_CORE_CAPS			  0x000000cf
+#define MSR_IA32_CORE_CAPS_INTEGRITY_CAPS_BIT	  2
+#define MSR_IA32_CORE_CAPS_INTEGRITY_CAPS	  BIT(MSR_IA32_CORE_CAPS_INTEGRITY_CAPS_BIT)
 #define MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT_BIT  5
 #define MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT	  BIT(MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT_BIT)
 
@@ -154,6 +156,11 @@
 #define MSR_IA32_POWER_CTL		0x000001fc
 #define MSR_IA32_POWER_CTL_BIT_EE	19
 
+/* Abbreviated from Intel SDM name IA32_INTEGRITY_CAPABILITIES */
+#define MSR_INTEGRITY_CAPS			0x000002d9
+#define MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT	4
+#define MSR_INTEGRITY_CAPS_PERIODIC_BIST	BIT(MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT)
+
 #define MSR_LBR_NHM_FROM		0x00000680
 #define MSR_LBR_NHM_TO			0x000006c0
 #define MSR_LBR_CORE_FROM		0x00000040
-- 
2.35.1

