Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FA71802DA
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495897; cv=none; b=Bo63nhEcFW1XSISRz1W5JLpAQCKeMPclzMqcWXiFNLYi6Nu+JlusEQvFlFt5C4DWbYwVAZtLKmEEpQ1CN+qgKPRc29LxcbOi5vyuLtfL2mXVYxUz2p94K4X0+blN7rxysr2CvecjnvSU+HAg8o/+Okjd1RteWCZZiLdcRCAccR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495897; c=relaxed/simple;
	bh=Bj1Hh9P4phH3tXz7fAUpe9Zp5qNwRqIfye9t/fF1o6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9nfgrNjT4XX9lZ4rl3ZDDCWFMAc/t1DEimmLT7sLTCQ9254rrbkN+jfu7QWmImhGrEpExOy3fnIjQWgPlxsS9HfvWzC5wNPaaiJHrpC+Uqi0x1bmyrUnH8vsrcaZcLHVRq0DrYYVXI3ngsbwN2uxBAJ1M3/KebY1RQG3XLlSI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OxF7jAF9; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OxF7jAF9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495896; x=1746031896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bj1Hh9P4phH3tXz7fAUpe9Zp5qNwRqIfye9t/fF1o6k=;
  b=OxF7jAF94Mv5Y3O2//sszH+RXBOEukHaGQpF+SoQ4zVU1+bFYc2/WiyD
   GU9v9QNAy11WMkViHHZG8ospJmRTNQWHIeiU8ACBhInXA1HaN4OlNhNpt
   dO0czZ3clCIo6M9ShZN77B3b+saYuupraX0vcXJAMSBKxonB+DLb+ttTG
   T2dN+OpHF1vX2hmmZ9sa5pBpcFYcvxIQ9b0klOj6SOk05rRxHPOhPH3sO
   Wo9z3kCtASSbG+ljCGL8HuZVJaZESXoCJamo/VCIl+Egg7VQfqyy/VNZ1
   mylI8gby3cm8kkiVZ85EOhofr+4qyQZVf0GOyZmeAXCeFv1Xug8GtoXXM
   g==;
X-CSE-ConnectionGUID: hULsHtVrRriMAWAh+1kNzA==
X-CSE-MsgGUID: NDSzpfZpSju4/JKMrSHfdA==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075627"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075627"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
X-CSE-ConnectionGUID: O+FKssEiQsmf8kRxHnkg0g==
X-CSE-MsgGUID: B/igJF10SH2+nMITYpg+yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515428"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v5 10/47] PCI: PM: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:23 -0700
Message-ID: <20240430165100.73491-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci-mid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-mid.c b/drivers/pci/pci-mid.c
index fbfd78127123..bed9f0755271 100644
--- a/drivers/pci/pci-mid.c
+++ b/drivers/pci/pci-mid.c
@@ -38,8 +38,8 @@ pci_power_t mid_pci_get_power_state(struct pci_dev *pdev)
  * arch/x86/platform/intel-mid/pwr.c.
  */
 static const struct x86_cpu_id lpss_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SALTWELL_MID, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, NULL),
+	X86_MATCH_VFM(INTEL_ATOM_SALTWELL_MID, NULL),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, NULL),
 	{}
 };
 
-- 
2.44.0

