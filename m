Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515B217E47C
	for <patches@lists.linux.dev>; Fri, 31 May 2024 20:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187836; cv=none; b=CVMi944yySRRHcRSHHr53K/h2b0V6qlONThErGXr1YBBScO0WT8cFXUEEfQTP5Bcg2VYTY0lJTMmLh5j1+GxGmQ6/vqFZuR17ElNM0p1ZNl7DQOHchqX1Q9cYDLfEvYwCI3cGUYF9du+A8cHOyKZ7vb6ZkFlhBj6GbIIhW2bkLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187836; c=relaxed/simple;
	bh=sOqZyHOaT5a0l8XCc8dAZljiRy7fauzwISe5OXzMWko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDeo4m9hVncxgGDuFsNtBEaCP5b5sjHHpM44MDgF2r1hPQwLEFp5ucDAf/h/n2U3BzatplyvCGQsPH2yeIVRcV0UTvSTfihJ0Fgg+YjO68Scb7BwihZMIUBltIMvqfS1BOGPKAem+XiLbcaKBeKJKHAKTGPCSfobjudLFa8SkxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gyqV3IlP; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gyqV3IlP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187834; x=1748723834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sOqZyHOaT5a0l8XCc8dAZljiRy7fauzwISe5OXzMWko=;
  b=gyqV3IlP2XEKj1JkqnzpgscxpnR869FpABL0F1naDw/NKkxDXE26OK/v
   7fbiDJzJbmXY7aYFhhj+F10LNujjDAfoqI7Au3IjPbtFXv/4IAMizVDLE
   Om86B5J0t++2zKNDZQNPVJrpTRlJOcnMCQWnOYQpoODgWlIH0JABbKIun
   BP9lAlyCRMypXhIA2RHZr3FR6gfb43ztDuwv8P6jcn0TcFtl9yCky7d8R
   zNRdxuZY3N8QHeFysGjBzomFjl2/Zzr3zEkQy8lhIw9O950wa2cAZDbua
   wjAwRR/7BPxb+J+Tsqtsf43rzmY+TjJSscpOfcbZmjmYq6fVHHWvF1QMC
   A==;
X-CSE-ConnectionGUID: 7c8Wqd+vRkWwUN69g8GbJg==
X-CSE-MsgGUID: 0tMKvSfST4yc3Syz0Z/cPg==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13871828"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13871828"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:11 -0700
X-CSE-ConnectionGUID: heBKNJT+QL2CKT+2huO8ng==
X-CSE-MsgGUID: Z8CZGAMUTta+zyMZ61VfJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36355367"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 02/11] platform/x86: intel_telemetry: Switch to new Intel CPU model defines
Date: Fri, 31 May 2024 13:36:58 -0700
Message-ID: <20240531203706.233365-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240531203706.233365-1-tony.luck@intel.com>
References: <20240531203706.233365-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/telemetry/debugfs.c | 4 ++--
 drivers/platform/x86/intel/telemetry/pltdrv.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel/telemetry/debugfs.c b/drivers/platform/x86/intel/telemetry/debugfs.c
index 1d4d0fbfd63c..70e5736c44c7 100644
--- a/drivers/platform/x86/intel/telemetry/debugfs.c
+++ b/drivers/platform/x86/intel/telemetry/debugfs.c
@@ -308,8 +308,8 @@ static struct telemetry_debugfs_conf telem_apl_debugfs_conf = {
 };
 
 static const struct x86_cpu_id telemetry_debugfs_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&telem_apl_debugfs_conf),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&telem_apl_debugfs_conf),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&telem_apl_debugfs_conf),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&telem_apl_debugfs_conf),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, telemetry_debugfs_cpu_ids);
diff --git a/drivers/platform/x86/intel/telemetry/pltdrv.c b/drivers/platform/x86/intel/telemetry/pltdrv.c
index 06311d0e9451..767a0bc6c7ad 100644
--- a/drivers/platform/x86/intel/telemetry/pltdrv.c
+++ b/drivers/platform/x86/intel/telemetry/pltdrv.c
@@ -177,8 +177,8 @@ static struct telemetry_plt_config telem_glk_config = {
 };
 
 static const struct x86_cpu_id telemetry_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&telem_apl_config),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&telem_glk_config),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&telem_apl_config),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&telem_glk_config),
 	{}
 };
 
-- 
2.45.0

