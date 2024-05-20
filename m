Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9242A13BAEF
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245210; cv=none; b=pYQ4/AMtcWg2wVG/9QsUqiKg2KvvUORmUT9rwUYtQHI2bXBC+9SBxygybH1HH4nc024wM6my/Vvvb6+dw9VoaamkcfXj/BudA9ww9DsWo0i8WmUaq7yQ1bpVdV2tzW/MhzbNQ3pD3oB4jh/lW0YVyjYOKoO9yurkq19ZgLjqYak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245210; c=relaxed/simple;
	bh=lbpkB4zBQpI4GcfCpRLlxtqxYH5hSB0ZDHxIhsLKKBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzEbzvKf09/SU3+0JGdR177nrGtcQEbxYoARPl7AADtl+ur+cJfi4TrM7kMsAeKIielAyx3LyzYtm4HebNsxQiCubVoUrDaf7fDssQbq4cUB3WCp4+Jfc2nRbYggvGNDH6yh7X0+ZdJ/uzuXYGjW8uuEaS36J5iOJoISX97hBZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F0tPAoTC; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F0tPAoTC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245209; x=1747781209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lbpkB4zBQpI4GcfCpRLlxtqxYH5hSB0ZDHxIhsLKKBA=;
  b=F0tPAoTCjr6DfPl3hXbo4NYXPoNQX4I1I9JytShGiLT9Z1zwAhluWWGj
   9i3pwfq8GCvRPTHHpEDQiXigAOhCSOigWXDczCh8xCBDIgReOlFVT5mSG
   SABYgx9o8YBBQxpsnfJzWBRhhOYdfcW6gByTjqwBtSDWpYs47CC7cSNj0
   VB5hDD+gOmlrSIGi+8CBErX5dQJzgRkrpaewdDstKN5z5pJEfpdJo0KNM
   F9jKLlciooIMRqiwdM3KYu2AYuS0U6sAo0VNPvSByVPm+s/kUB1DT+M4P
   QtgonXdvDyXRGlCbYgis2Yi1CJum33tdHpFOxn+AIQp0kBGTUdSpvsm7h
   g==;
X-CSE-ConnectionGUID: xVm+Rk0LS4abFLMyPQggIg==
X-CSE-MsgGUID: pkml5ZPBSG2rJFCOcyEfMg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199830"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199830"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
X-CSE-ConnectionGUID: O4y47AxMTaynDCoGD+QjFA==
X-CSE-MsgGUID: DK/YWFaeRTu19v5t14xv2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593470"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
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
Subject: [PATCH v6 29/49] x86/PCI: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:00 -0700
Message-ID: <20240520224620.9480-30-tony.luck@intel.com>
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
 arch/x86/pci/intel_mid_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 8edd62206604..933ff795e53e 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -216,7 +216,7 @@ static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
 }
 
 static const struct x86_cpu_id intel_mid_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, NULL),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, NULL),
 	{}
 };
 
@@ -243,7 +243,7 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 		model = id->model;
 
 	switch (model) {
-	case INTEL_FAM6_ATOM_SILVERMONT_MID:
+	case VFM_MODEL(INTEL_ATOM_SILVERMONT_MID):
 		polarity_low = false;
 
 		/* Special treatment for IRQ0 */
-- 
2.45.0

