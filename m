Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E135613EFEE
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302415; cv=none; b=fAKjiq8z07vbGMYP6wKtfssRQBMgGYejZZkJw02YnhnpgHQbLAnDCcDeFlX3osA8LjFlGj7ksenw/RRQ9xHmYM86S8yLcLkzNv3+n7oRpVDEhYAuiVo1dxIpNRbLEMUQpwjns8BAJbgq//9qU3gUf1tEeY0QhtQ6oevyTTk9YFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302415; c=relaxed/simple;
	bh=obhXYEmt6d4ZPBEnG583vH7Ox14Ir+rTrmmNAEgF6jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/1mVHQ7G8w6bF6D+JaXFIPaI7p0SrsmeGV17Fkf37u+d7YhbHGWNKbKj5kFK/TqDxwbvg76KfDGr1diYrsphwRWf1c/yjcmiLqU9KXHtLt3x4LB3feApknbpb7QI+3aXT3o25Jp7ZEjPdwx+LJNKP8Kh2/ILUNa2D5u68IJwRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P/6oMZ/E; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P/6oMZ/E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302414; x=1744838414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=obhXYEmt6d4ZPBEnG583vH7Ox14Ir+rTrmmNAEgF6jg=;
  b=P/6oMZ/ElV7sv/OskhPLoTUbxsq/EV1rGfVYSttO8D603cKns0n9Qsyg
   Tbe6CprdndUuVHVLwCWN7wqScjtJrrldzPlLkyl83iUZ7x39BAobFV+YW
   0qhkHcObA6TUhctBVSaaY6ISg3j5WAlnGdl3MREuAJXGuZ2ygwRUDiQzB
   DdO3vd20v89OxoJHs0/04II1rxvksDuFsfP/oYogWHe0Tzczuc469WuXD
   PBilX8npiPTc3Z+bPbD90FIn0ymNlp6XsuR5ZtDX0g2FtDp2bH/GGorIn
   IWtOFB3GdCX9DQURzKRajliz16lXkiewxBr0hKThnTQlQNH11IhK1Y6Fa
   w==;
X-CSE-ConnectionGUID: hLr7hLDHTKWX5w/FE0Uptw==
X-CSE-MsgGUID: s8zIivMhSZ23t5ywbPixtg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914828"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914828"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:02 -0700
X-CSE-ConnectionGUID: aLDOVuQbQLmAFipp3XT1Gw==
X-CSE-MsgGUID: yGJbytZUQOi4wI2Bs5YLNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22872027"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 33/74] x86/cpu/vfm: Update arch/x86/pci/intel_mid_pci.c
Date: Tue, 16 Apr 2024 14:19:35 -0700
Message-ID: <20240416211941.9369-34-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416211941.9369-1-tony.luck@intel.com>
References: <20240416211941.9369-1-tony.luck@intel.com>
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
2.44.0

