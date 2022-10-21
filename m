Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86966AA5
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384558; x=1697920558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DyrS883OR7AFX4gN5EeEXTzT5dUJ/TdR0BLm14KTOTM=;
  b=P2bd/3VzVOfGmYFHv1XrhTs5nS7apC6XMMiOZMdE1W308d6qAOFbRHBo
   3GkfkngsHEwkYXO+6Zu11JgI89fOoh9Qzymftn6+96VaNsiXt9Gz+68lZ
   0MdtsOm4uxe4ja5dt26yMqhabQPnZCFUGCa7aWDnD8J2DUqPkd7OrPZkL
   igVqKTKcbE8Ie6az9KdV2eGFUyURmgFAi5g+JUXzNkmEg3OaIUKUxEn0l
   f1uJRZXdunpa+NmLNVfHTCq/bJqT8UaWzwyao5L1tsNqfQT/l1Md95Usw
   KfjuoZaTxy5eKR4CRkDNa4FJpZOvmrzXg5zG+xCeYliDbmcg58kGAaPdI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675939"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675939"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:37 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735701050"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735701050"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:37 -0700
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
	athenas.jimenez.gonzalez@intel.com
Subject: [PATCH 14/14] Revert "platform/x86/intel/ifs: Mark as BROKEN"
Date: Fri, 21 Oct 2022 13:34:13 -0700
Message-Id: <20221021203413.1220137-15-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021203413.1220137-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Issues with user interface [1] to load scan test images
has been addressed, so the following can be reverted.
commit c483e7ea10fa ("platform/x86/intel/ifs: Mark as BROKEN")

Link: https://lore.kernel.org/lkml/26102aca-a730-ddf8-d024-2e7367696757@redhat.com/ [1]

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
index 89152d46deee..3eded966757e 100644
--- a/drivers/platform/x86/intel/ifs/Kconfig
+++ b/drivers/platform/x86/intel/ifs/Kconfig
@@ -1,9 +1,6 @@
 config INTEL_IFS
 	tristate "Intel In Field Scan"
 	depends on X86 && CPU_SUP_INTEL && 64BIT && SMP
-	# Discussion on the list has shown that the sysfs API needs a bit
-	# more work, mark this as broken for now
-	depends on BROKEN
 	help
 	  Enable support for the In Field Scan capability in select
 	  CPUs. The capability allows for running low level tests via
-- 
2.25.1

