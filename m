Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B04174ED4
	for <patches@lists.linux.dev>; Tue, 28 May 2024 18:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716922062; cv=none; b=pwGj+ACfo1TMSGSh2K8f73MC9A5BwH00m7742ldPfEDXvFURtzUaqO8mCJ2xwNuq8WUcLegGNzopnoADANAWjk5TjLtVJgpBGU8bq87/2SPx3v+Lqm86eIWhnldxiQJ3CpNmbAIjkfaUO0atLJxHWB0N0VNKmz4XSGYW0VlkQvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716922062; c=relaxed/simple;
	bh=mv/DdbZyo6eomJ/rc6S48OLZws5x/hvaTKemElND+wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ko3m/xZxwPFk3OwH4YsBAoQ0EvhAU49sDbgfLLx92Zvky4r5iT+gKMff1ZQ5NzWnjDtMaCDXuFMGjVm/tpHnOE5tMUBkndIqn69qAqqTgDHX64djCvRdds0D2DiTACJutzPkS/y4k+NfXanHaAXcpqf3YkGA7DUhfGRwUS+q1yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A1w6NZWt; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A1w6NZWt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716922060; x=1748458060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mv/DdbZyo6eomJ/rc6S48OLZws5x/hvaTKemElND+wk=;
  b=A1w6NZWtdJqHsBZAE4r4Yd0knVjXeDsir9X8nsiHq0VbRB6GvHuahCLL
   Kgh10BLxleGAkGUL3ZwnGtz/nHUrsAXWIAOeFuJ9a2jeXfmvn/8clrWxS
   61VKpDSy1jPF//WWXQcBym25bQTJzd/O9ZbHt0r7LJDCDECrzrS/0Bk4u
   c4HfZ1y0GCffeSKi4IXGLHYqd6wr5fXUyCQ90ayCb5o9emXvJKwvQwQtA
   TCp0RTe2CeE3scLoie3/+vUCYywTNSuStc4zHyzfJbFeVgO7A9ixokNg5
   i418659nRLFLlzaiLHBiSFEOH/YW4gl5/iQSOUromQbVdPu/WQGhjnhHr
   w==;
X-CSE-ConnectionGUID: tgoqETbjS1yobkXPnMGQ4g==
X-CSE-MsgGUID: 8ssGmbxXRm6NF/WW1GnYBA==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="17121569"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="17121569"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 11:47:31 -0700
X-CSE-ConnectionGUID: owEPKT1fSsamN5emdtsNUQ==
X-CSE-MsgGUID: zVn8l6NsSlqAnxkuaCBFIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="72605181"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 11:47:30 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6/8] ACPI: LPSS: Switch to new Intel CPU model defines
Date: Tue, 28 May 2024 11:47:18 -0700
Message-ID: <20240528184720.56259-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528184720.56259-1-tony.luck@intel.com>
References: <20240528184720.56259-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/x86/lpss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/x86/lpss.c b/drivers/acpi/x86/lpss.c
index 148e29c2c526..258440b899a9 100644
--- a/drivers/acpi/x86/lpss.c
+++ b/drivers/acpi/x86/lpss.c
@@ -338,8 +338,8 @@ static const struct lpss_device_desc bsw_spi_dev_desc = {
 };
 
 static const struct x86_cpu_id lpss_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	NULL),
 	{}
 };
 
-- 
2.45.0

