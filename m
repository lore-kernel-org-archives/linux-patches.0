Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E5216D9A9
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982507; cv=none; b=UR1R+SLZ6NWSMVbbXl/VHUKVLgxgHEjJYUNXcuGREUxuK4ArL9opC0jOchO/5rzs5hrAXMvEgfnSyN5z5JZ7a7vDMWoNgD+bOviUcDR0nXVKHAJ0KhCEiTRCpIUGHxPpWwMi8lkz9ePMCMCSZzAe5Msyn0l2KucS3rkW7+J7lp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982507; c=relaxed/simple;
	bh=Bj1Hh9P4phH3tXz7fAUpe9Zp5qNwRqIfye9t/fF1o6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWNUbpU0F1NirS7nhS/AxqBBXwrko/TvqYMsw52uJuekk6nm8Vdtaz54Ju4GTmRVKULxU7eEUAEbxg/u8dnd7wsu32USUTFKzqZBqE7SXys5rU16o7jGEGd1Pze2RvFVOfsFz0bnN/AEigYJB6ILqKuAIKelrMiszBra3KeBj/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E5Hbc4OR; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5Hbc4OR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982506; x=1745518506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bj1Hh9P4phH3tXz7fAUpe9Zp5qNwRqIfye9t/fF1o6k=;
  b=E5Hbc4ORuuxTvSD9ZFi79WOOSbJeqoOdTYEWDda1TbhPk2HMBT19Dugq
   WGWl1WrIoxLHdMvZSSFeLy5yBaAvQkVcu18t2NICmkzbD8ClfeXv4cAKU
   dV/3klNaUsVkzNESfZ2AXhxtXiz3kw4ax3PjRfaT72qr7vqg7LsY0IbIW
   EiZen0nZnPRVwJxV3SHEtupYkjh8ma/CA3aIHt6PZDXmISDCwh4pk5gB/
   BKZhpXOO/Pxd8HitHtm0HyFNzAREQX7cgsyTHwCYzbbRDQ+RIlcXNh5Mr
   dSyiBBKKoQbwSwnkyQw21xrdbk1KjsJkr/anr+r6Wi7NNqOQZKIvZq7yJ
   A==;
X-CSE-ConnectionGUID: ywG36KqmRDSb+ZTLuEXPfw==
X-CSE-MsgGUID: xEfBw9aXSz+v9ZovZsuKgA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481786"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481786"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:53 -0700
X-CSE-ConnectionGUID: g9KL3PctSRGzgFMrYZHuPQ==
X-CSE-MsgGUID: 3ViPB0/LTzGJ4dCuXhhMOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262578"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:53 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 10/71] PCI: PM: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:14:52 -0700
Message-ID: <20240424181452.41346-1-tony.luck@intel.com>
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

