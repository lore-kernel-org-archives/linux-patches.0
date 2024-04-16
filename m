Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76AF14A4E6
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302534; cv=none; b=RKtG7diSSiJTdERu4guvzsqfxcwROKm8F3e6gAeRpq9LCgEJiX+iJEg4tMwB61J+G/Fk+YqzsQyd5h7hfZf4bvRsNJNs6sdZkiQL3ebZTeBhxW7wrAUgo1FAUHGkYzl93wtF52pbfNeV5rQPyCfPk99ujsAVQjziOuBq+gjX9O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302534; c=relaxed/simple;
	bh=K0SMUkbNdaQTs8egvbi/pMmubWEho1P85u2CzO6rIlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoE+RsjXz3I6BcNvra0cPJhcxothLXsZYR4mevtmLM+4yWBswhM6EqatCGkt25mbneM1HW9BcTWo4IBfC9Ov4cSxzZMZVfR0m+pOrtULV4GXmz9GitxDC4M7MMkIUKC4owBbJ89CkG9i/Z8w356JzET/F98aN7O8jdk+YN08fOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fVKndPtJ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fVKndPtJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302533; x=1744838533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K0SMUkbNdaQTs8egvbi/pMmubWEho1P85u2CzO6rIlk=;
  b=fVKndPtJ8MswbsfW1oJVj0OlvTkx8Acfmz1TCxl3ZOjPZq0e4IrEwzWO
   Ct2DsS+VEphV5Oma96d3wdHVEAp3gFU+aj7BGPJ3+BSV6w0kw1MEWbbVk
   7SnXd57YpQoLn5Mtmdwco6vfjt4qclCxLSnrQLFGGOgtwTBsVnyYWrt23
   j8R5V1tKDU2B6/WsC36RyZN/UWwJdsRZMzeZQJ6jFEZn8OrHIHQVP4FIj
   bG6wzkFoo8aWd74IHL4vrd99KG+a4Hljo16NB3wzo7V9ViayAvFlaf4ld
   cVGqUzEe/kkEr/85BDjVF+nNIp/LZeJAMDXB03idjnLItk18bVEGddOfT
   Q==;
X-CSE-ConnectionGUID: SeP9gk4kSp6HC1N+fYcvnA==
X-CSE-MsgGUID: 6PlvhrbcRauWDm6z8X0Lew==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19328783"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19328783"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:13 -0700
X-CSE-ConnectionGUID: dvcak7n4TbSjBuxFQunMYg==
X-CSE-MsgGUID: TKjU1AsDR4aHNfOM12QMXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="27071921"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:13 -0700
From: Tony Luck <tony.luck@intel.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	James Morse <james.morse@arm.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Robert Richter <rric@kernel.org>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3 47/74] x86/cpu/vfm: Update drivers/edac/sb_edac.c
Date: Tue, 16 Apr 2024 14:22:11 -0700
Message-ID: <20240416212211.9547-1-tony.luck@intel.com>
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
2.44.0

