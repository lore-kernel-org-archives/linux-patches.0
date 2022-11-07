Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E6B15C94
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 22:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861693; x=1699397693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DyrS883OR7AFX4gN5EeEXTzT5dUJ/TdR0BLm14KTOTM=;
  b=Zz7F7BdNyFk3YKxkwrO3CckYcVLAN9/CfNHXERZLqz0FZxk8FjALKBvH
   dZrHnzGQ1qJfFRzN+86k1oBS+6E1/xI/HqEVDnNpRlQFJVtWh96RwrGx0
   fNOgOwywycOQlntiiGi+gT7R26V6jbmGtnJF9slDOoLWzux9kg8BT81/W
   Kdjn7bJXsvJ3WQPfi0mt/jYzlAKVTOdPxDE9j6dDM3NzlvTb7r1sh9WDg
   R5+2bqnQ8Drf/CzB2X/vxYLfz1QlvmOh4bLNHmxLsIi9qZtBAil0UUpV8
   HXE3l1cnJ0/bd8G6i3Db4ub5mD/Tho1S8EPDWKUbCI092T+Q6adG9XE2j
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311697437"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311697437"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:50 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811013001"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811013001"
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
Subject: [PATCH v2 14/14] Revert "platform/x86/intel/ifs: Mark as BROKEN"
Date: Mon,  7 Nov 2022 14:53:23 -0800
Message-Id: <20221107225323.2733518-15-jithu.joseph@intel.com>
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

