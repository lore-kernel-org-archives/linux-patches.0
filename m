Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ABD15C94
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 22:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861686; x=1699397686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MHFgE7gyjINPZEVbivHQy+5kAf7Oj4xtRrBdTlwN9uw=;
  b=Mda7H3FMwm3Mh2rfFOUjYeqPMKxRAbPZsYwy4b+zPaz2eqauKeHHFy9u
   Sla5VUk1cmU4AVk0a8UovTam/o7AD+MPPTVarkdSuWWS7UF+R/v8MXDXk
   +sqQkbxsrzpvxkihaydomhxM5ZtsC+LiygHaHFHoPmf5cTeOReWPox+V/
   Mi5a04rvmwTepQffYAGBKfETTcH/1JvYHazXyYEUFgu6y/n/6n7FzPfP7
   vL/kDHdq+xqnRM6ysr6D1bctREMrnKTixhtWJVnaSfEtwg5EETHhyuaN2
   nagc8zAznbpk5AnPu39eFeVugGcpi+t5ddPl6MoBMrpxHYFUa4RMgdB/C
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311697386"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311697386"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811012952"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811012952"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:44 -0800
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
Subject: [PATCH v2 01/14] platform/x86/intel/ifs: Remove unused selection
Date: Mon,  7 Nov 2022 14:53:10 -0800
Message-Id: <20221107225323.2733518-2-jithu.joseph@intel.com>
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

CONFIG_INTEL_IFS_DEVICE is not used anywhere. The selection in
Kconfig is therefore pointless. Delete it.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
index c341a27cc1a3..89152d46deee 100644
--- a/drivers/platform/x86/intel/ifs/Kconfig
+++ b/drivers/platform/x86/intel/ifs/Kconfig
@@ -4,7 +4,6 @@ config INTEL_IFS
 	# Discussion on the list has shown that the sysfs API needs a bit
 	# more work, mark this as broken for now
 	depends on BROKEN
-	select INTEL_IFS_DEVICE
 	help
 	  Enable support for the In Field Scan capability in select
 	  CPUs. The capability allows for running low level tests via
-- 
2.25.1

