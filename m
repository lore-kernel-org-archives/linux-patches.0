Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F48E181328
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982523; cv=none; b=VljjJXZ79Mhc9KNWGV0T9Zn65EMAKsvNA3PUUVPVX2qGhWvXN8f2TH1elcET//O8U215qrL+zJ3JYkgRnGy+mfq2B1SHEYUs9Imul1h2Xcrqmk49Oa/m+sh1G6tI9qymP2sNA6nCoy+FJpRi+Zp8Fnc51Vl0WxC7zwr7T+8cmcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982523; c=relaxed/simple;
	bh=obhXYEmt6d4ZPBEnG583vH7Ox14Ir+rTrmmNAEgF6jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsZmnaJMsnp8mSuhF8D8ttjZWnSqE8BTgWxYcF+LmeByWvBzzfwNbh4B1Eu/D7bGttUZwB2gpA20yx7Fxnl9Sov1fntp22IOPTsIL73in3Zw0YQLECfU42GvgBjVkWkjYrelj0+6EtqqBdhi5p7uvouBXIXlB8hQMri1WT+/rbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B3cj5rbl; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B3cj5rbl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982521; x=1745518521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=obhXYEmt6d4ZPBEnG583vH7Ox14Ir+rTrmmNAEgF6jg=;
  b=B3cj5rblgcOnu7sbJn3nZ6XpbLriNwm3J5GbITYADQK568h/LFJSiUT8
   UimrECfPEpMig6AckfbBLfsuktxc41MaXrrG14A5hR+a+AStygTFKu4FY
   3ixfK4A+GOJElGXBZ0yGAnb0chM8TdAhDWg+udOQAG1qsGwjFU1vd6c9s
   ZA7+4QM0TYcJYtk7zzQMoLqYxBdEg0TGu4J1fnY18l+iD7RkmSGjljDDo
   9Mws2y9QAj7ajRGt8Dv/mCYy3lOqVed1nwWnUgMyzjLQ2fTCIBuyzcV/j
   tpnvl13t4cKwf82g375OYGIyREESPJrMq6PEZ4rhqMZT5EbQ5AGpr/E6O
   Q==;
X-CSE-ConnectionGUID: 53qc+dZmQrGYicwOPi57ew==
X-CSE-MsgGUID: 8Hfvtav/QaK73zxyTHQhLQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9503536"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9503536"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:20 -0700
X-CSE-ConnectionGUID: VcIiWi/bQZai5oz5I5U70w==
X-CSE-MsgGUID: lbQj+TPeSR6BAaCag2O2PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="55750130"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 42/71] x86/PCI: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:20 -0700
Message-ID: <20240424181520.41965-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
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

