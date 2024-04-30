Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E0517B4EB
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495901; cv=none; b=AytsH9sOuPn97tvNRAvtnKpqOenGN4MjpvzS539ggH9cZlUPtME+2OkbVW+Jlr4RFXUysUZCCRgtePnu2sZI5KvGHOtguW3lUuE8RYgYzpef4UTuBvntVQb13h1xbWiYA+ysbpcK+qqgscT3HtyY9rIeX+6r2awU8ZZ+c9iUk1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495901; c=relaxed/simple;
	bh=DjW81tHfP000Qq9cwTltickR0vyQ37yeIrDTrxUYdMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFfVLPfCSE9NBboamjQKV5DLl2qh8l0Ggvsa54jYbqdCuD/SvjEQpoHa2d8nwQI6LdODFKtyFiokjO6P2nKilpQFIt/wxYwoXEvyK4vttcZjxk8ZDFhMUmPeTi91wL8QkyUr305tNlHnGzzRswBwp+WAR8o0YgFOqR3qbICVV8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VZ8OaMKG; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VZ8OaMKG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495899; x=1746031899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DjW81tHfP000Qq9cwTltickR0vyQ37yeIrDTrxUYdMQ=;
  b=VZ8OaMKG9ddMqjp178JnPdAxIzFt0lj+50TiGNMJA8V7Y2xDuFlqusjk
   u8J9ylpfqap14l3czKzjo+HJQxvybXxx6v+5Pd7ZwxGqVT/3j6W9N8jVB
   Lwe0d4blrEViQcaafpg2zS1BD+vzlDBSAH+SFKO1FR2WuMOqmEN66lRaU
   gUyNhRoVZy+vFWU7S3xHYZK8+K+0/l2h0GIsud38Mx3xJPEtd7+pHTfgu
   mnQ/RpuSKNIKoap19Ufa5vVMf+3EwROGH9q9CCrx87nhmzWLPKNcYpNCy
   d6PNfcGHxwVRU2QG7EErpZXiA57qzG1SLp5JmQF8HVe25Ee1WsudW3oZi
   g==;
X-CSE-ConnectionGUID: Tb+MVOlKSqej6C1F3CoC2A==
X-CSE-MsgGUID: PpQl4dd0Q1+ofCJGO833Pw==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075679"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075679"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
X-CSE-ConnectionGUID: VNOcgkTeShOfHc02yxWK2A==
X-CSE-MsgGUID: /17gissDQeike9vi2lazcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515454"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:17 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v5 19/47] platform/x86: intel: telemetry: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:32 -0700
Message-ID: <20240430165100.73491-19-tony.luck@intel.com>
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
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/telemetry/pltdrv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
2.44.0

