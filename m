Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F96F3D89
	for <patches@lists.linux.dev>; Fri,  6 May 2022 22:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651877659; x=1683413659;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a9Sj55r0oDzPq8XuV+WBmGfDvwQYjjBRUJ/HaL14VLQ=;
  b=FOxEbSqIRTDnRY99XroHz7OfeO6BNOdalgZ49HhkmgisG8V3sPpkCbx5
   /ZD+KvLcKsDi9anWzCZ/e66bNZNjnXvMymBwfW0Y2MfK/34rt0zvs2mId
   ZJIMoFilx2Lx/SSmj6ip2cxViAx46LDaDHkw0PM+FbzwPG4Hsu3jJf9Ki
   Qud7gs9CPmYlD4GsK/gwdpEVFKrx5sNK5MztJqgoRAW53ane90qb7fJ5P
   jMvcwe7CZnnpPLHkZN6Hwtb01t5nLnKIrMyMMeKFLGSE/uZ5bHfb5nYwZ
   ylklhxySeEtmmgTfzVySfypVpk8EbAhoIDDDqTt8w9FWbvO2nPOKYyqCC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="355030691"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="355030691"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:18 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="695383620"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:17 -0700
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
Subject: [PATCH v7 02/12] x86/msr-index: Define INTEGRITY_CAPABILITIES MSR
Date: Fri,  6 May 2022 15:54:00 -0700
Message-Id: <20220506225410.1652287-3-tony.luck@intel.com>
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

The INTEGRITY_CAPABILITIES MSR is enumerated by bit 2 of the
CORE_CAPABILITIES MSR.

Add defines for the CORE_CAPS enumeration as well as for the integrity
MSR.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
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

