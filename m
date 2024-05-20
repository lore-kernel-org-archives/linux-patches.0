Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BC73D3BC
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245204; cv=none; b=nDSpVgd73wfU+mpHo7itSC2d7r0RyWtSnxCeQ3vH3gpsxjDGUbk4BQNQ9Uf6fyQaQMkjtzunv+VqljOLmIPUVhV+8Y5/ZoU5EJl1VDyCCPMEXy+qJWQvhBS5LWCY4yGlWudhR6vL0+uSPZYAZEFyTErtohQEfi/0l5lVXVI2kHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245204; c=relaxed/simple;
	bh=UCxMtBp8JAc8kiqTmHIGiN2JeFnF21tMXCqSLt0G2gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+pcnnb2FKqSXqeuQO4Sq9/Jxn1E8bJjb+OjMWnKKrWrKrcnKWuuncFa/iZnfpxD/NZYJzDnDVTXcgqPkom2gdLxry7mmsbrYrdNQAPvFrf9f0HR/mwb/6CsIHqUSWdCj/aEvV20DhWbCs1nMoSPDGsH2TO8R2fOUBkjRalOgRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nn1aAEcV; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nn1aAEcV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245202; x=1747781202;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UCxMtBp8JAc8kiqTmHIGiN2JeFnF21tMXCqSLt0G2gM=;
  b=nn1aAEcVLfSJHG1Sdc1iZfWIxWy1gvLzIndLsDniN3Kr4SIGOxJcwJox
   Efzsapi9YEo1Q4cidbtJAM2a1gJw0vKAUdTD3VoLd1XBEf3tWOA+wuxhA
   0O/34TTuFfwancL0VLLseqALeJ5rP7XLSEQn1JFKbEQqSF2VwucMXxac3
   Hk3aB3WTzeloT7jI9KZNg0ryIyO60eFaIRB5k4zbvn4NULgIaufVc8kSY
   xXYQFtX9OOkplI44ISwLurMv7E2eRQNXrpdG+HbKA5Okfr/kz19Jk6zRL
   ZI+shDX3XwxMIv0Q+36Iwpbjigtg9VqviXhqBnhhxDHP2YDe8O/RiZq6o
   w==;
X-CSE-ConnectionGUID: mZbkWfesQdSIo7ydBxQJAw==
X-CSE-MsgGUID: DW73z5KuTDKm47vUirySMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199635"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199635"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:36 -0700
X-CSE-ConnectionGUID: rlYlv6GQSsq8AeKfMtVR6Q==
X-CSE-MsgGUID: 8GvZ7HJCTVCdtTTPSvXKeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593418"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:36 -0700
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
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v6 12/49] PCI: PM: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:43 -0700
Message-ID: <20240520224620.9480-13-tony.luck@intel.com>
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
2.45.0

