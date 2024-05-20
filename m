Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C958A13B792
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245212; cv=none; b=T7tP91a7uVldUNMGY8DjrwamtCwFVvrsqh0CyBoIf6DIxLM3c9LauzTq/UjxdwfggdGu6cNUVoc6iMK1HdY6Y9Wqatepc443ji6GeqlwAoCLXWTs/lxGPoVTTqr/P6OkPDtkX/YSqGvXBAdK9t0X+xqKWILoz/hps6smwVvLQtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245212; c=relaxed/simple;
	bh=yvG8vVOFiUlIL/SKzVALgFIjKhQFvNcZtyEQuh9ZrVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkacAbI0xUMsiqQA5hJ89o6j/KXf3JEzPO5dc+ySOJMqoxJ0NZQYzvHDpYhDgMxf2kVfrv6f/eu9AlJdrjeqTYgylc/YvFAGEdxDfWPNEkAlTeOvvtM8KLsDrxiigfodnylKk86j60p7iutxkSVA7u2hQT9fT8zSlF5JwoDS8Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=COQHyulL; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="COQHyulL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245211; x=1747781211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yvG8vVOFiUlIL/SKzVALgFIjKhQFvNcZtyEQuh9ZrVQ=;
  b=COQHyulLmn7CU7LgRlfYg0axg9kwFzKOKmBNcxuy1rYykgk20+rWDN21
   h1N56j0qjwE/7PRguoII2ajWe7FylCevGcZrS/SliMuvw10LRZFSaAGlL
   0xsmuI+E8tywx8+w2dE69pc2xpGthnueEuGrx0UzQ0uQfVftIz+aKfJWr
   rV29J44Q/qWFbIzQzc0HXEG/m4omtC6g6xevbrpJJfJey0CjTlyYLOOAA
   xoFDJ/UKQk5/8+Tev80mT55z5lQggGpXe0FltYYQ6M05L7qFVCKtpgG56
   u1uudPG8kUvy9QwEB3b7+z2KLjvAWxtCkQ9/5nO6+Tm7emxcDa8J2l9bb
   A==;
X-CSE-ConnectionGUID: EHqdc7IoSAOCddcLQcBC8w==
X-CSE-MsgGUID: W208KBYbRuuV5Lp9QF6MXA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199914"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199914"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
X-CSE-ConnectionGUID: yStxYKhOQCKRJBCtnmc/fw==
X-CSE-MsgGUID: BT5RpVzmSqifu12udtCIkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593495"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
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
	patches@lists.linux.dev
Subject: [PATCH v6 37/49] EDAC/sb_edac: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:08 -0700
Message-ID: <20240520224620.9480-38-tony.luck@intel.com>
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
---
 drivers/edac/sb_edac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 26cca5a9322d..cbc92d3683e6 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -3546,13 +3546,13 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev, enum type type)
 }
 
 static const struct x86_cpu_id sbridge_cpuids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE_X, &pci_dev_descr_sbridge_table),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X,	  &pci_dev_descr_ibridge_table),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X,	  &pci_dev_descr_haswell_table),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,	  &pci_dev_descr_broadwell_table),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D,	  &pci_dev_descr_broadwell_table),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,  &pci_dev_descr_knl_table),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,  &pci_dev_descr_knl_table),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE_X,	&pci_dev_descr_sbridge_table),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE_X,	&pci_dev_descr_ibridge_table),
+	X86_MATCH_VFM(INTEL_HASWELL_X,		&pci_dev_descr_haswell_table),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	&pci_dev_descr_broadwell_table),
+	X86_MATCH_VFM(INTEL_BROADWELL_D,	&pci_dev_descr_broadwell_table),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNL,	&pci_dev_descr_knl_table),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNM,	&pci_dev_descr_knl_table),
 	{ }
 };
 MODULE_DEVICE_TABLE(x86cpu, sbridge_cpuids);
-- 
2.45.0

