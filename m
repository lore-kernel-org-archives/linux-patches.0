Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5105648E89
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 23:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695425419; x=1726961419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gbtu9N7LZW1zLX1/C0Ce7/4J0um5aPagttSF5AF81qM=;
  b=lOss4XQQJdwEpfQjJQSGcJev/lhu6V4rVNYOZGUw19Yse2HD1WyCvVTv
   fUwE3wwXxDzsZHqpsLJN7QGTATMRqq18w7mds+z1NJiwiqtig5p//GmNA
   MfQaY7GSFmTaFpyfZkEvGOm5N1B8214DyF4bmryeQIf4IbuooWQ1aOj9n
   kBnOL3mhyPywYgJL3xEaGsfTPeCNfPJ3rPSj+ZZlkYNTmFuiaAL8WjJzi
   mDdle9gWm3pITd7IenfY7Snpf/Y+jz4OoNTuzzgVoCsmKEFGDLMTFeD1Y
   Go87KRgbKOIE3RcsuhH/80ha1FYDmydNaczZGpZ2LEI0Qpn2IiY2phN0R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="411896979"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="411896979"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="921350846"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="921350846"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:13 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	pengfei.xu@intel.com,
	ilpo.jarvinen@linux.intel.com
Subject: [PATCH v2 7/9] platform/x86/intel/ifs: Add new CPU support
Date: Fri, 22 Sep 2023 16:26:04 -0700
Message-Id: <20230922232606.1928026-8-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230922232606.1928026-1-jithu.joseph@intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com>
 <20230922232606.1928026-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Granite Rapids(GNR) and Sierra Forest(SRF) cpuids to x86 match table
so that IFS driver can be loaded for those.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 4ff2aa4b484b..0c8927916373 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -18,6 +18,9 @@
 static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
 	X86_MATCH(SAPPHIRERAPIDS_X),
 	X86_MATCH(EMERALDRAPIDS_X),
+	X86_MATCH(GRANITERAPIDS_X),
+	X86_MATCH(GRANITERAPIDS_D),
+	X86_MATCH(ATOM_CRESTMONT_X),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
-- 
2.25.1

