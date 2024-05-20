Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D4313C9BD
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245215; cv=none; b=Asrwc0tbBRPv8Uk3AUdnickzwbmcynfq0mUgTDLVFfMLrt/SbPFOoyRbjkgJkPoanykINp5CLFkOvVwENmf0i6RGfB1QVw9Uk8DDzWF0C4ONcRpwjaOxU4Hxy5wTiTMs5awLChqSPmwGSPJMolQqJ+dfJ5dWrgUDQ+ziN/x8jX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245215; c=relaxed/simple;
	bh=PBr5qbc4Ss4oqMBYAxjj4UdSDANT6hrIS0/VoPySkL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDhiTZV1HpiThQ+TaSKm4Vv3z29dNsBVCbj8cUluGc9yTiEpX5JPG0m+TGVCTAK7IhRmd+NzwAznVhEWKfVi7QtuQVGfWsOPNxXOC60z2yfqXeLWzcosdKBho2IR6b5I8oG1uaAy/24V9BHcHwcfoHdO8JJQeY59gh5G48udwwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZoFyrC2D; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZoFyrC2D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245213; x=1747781213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PBr5qbc4Ss4oqMBYAxjj4UdSDANT6hrIS0/VoPySkL0=;
  b=ZoFyrC2DjbqZZJuWgMobS1X5xBlTD71LSpIPaTmseeI/lw4NzhtMt2bG
   lkMO7paZAWey5JdAPqZwxGPes7bFdNymqp91vONQUfRPC2q7igN7VDX7C
   8ZF3CdKxlG8HOXv0Dv9L2IlSgcRzrYOo41tqpiPyK8atoMsMLNpetarqs
   sUi8HGDuH/wKI9q0H6X0C67kBltDM63RKYjCMNTcJ2R3ta5P2mHpMs6Ig
   pv0LTnMRdzJZjrAlYqARtnleLxSs61bMDk7w1GL/S1+dgpvejYVPihLEY
   vmwFdWGU2EcJIfDdA3FZ+czs33F85t1RPgTdGQ8JULlM2n3cWOQSG72Nx
   g==;
X-CSE-ConnectionGUID: 3oaXAau1RXeBNUIAqZCYIA==
X-CSE-MsgGUID: IK5nifd5TQKATIuFS13lKA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199992"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199992"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
X-CSE-ConnectionGUID: nptkOWmKSM6BWb7h4XSrXg==
X-CSE-MsgGUID: 7g7XCoOAQa+0UHw/cvqnhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593519"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 44/49] platform/x86: ISST: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:15 -0700
Message-ID: <20240520224620.9480-45-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 .../platform/x86/intel/speed_select_if/isst_if_common.c   | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 713c0d1fa85f..21e15e679fc3 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -719,10 +719,10 @@ static struct miscdevice isst_if_char_driver = {
 };
 
 static const struct x86_cpu_id hpm_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_D,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	NULL),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_D,	NULL),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	NULL),
 	{}
 };
 
-- 
2.45.0

