Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84806138497
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245201; cv=none; b=idhATGpG9fJTrBdp/w4RuUFblyxHOc5fQyVTL5IIO1zFaZkVkIpjxOHNN2vGpbqQ+Ue+4DN0/DnbwAavuqg3Dl+rmNbTNvznpPvFfbYO54gEsrBOZoViwoGMJvTjr4wAJ/MygFKyWn7X0iVjT+MnHTS7qsLZ0HSfKtvkHasgM1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245201; c=relaxed/simple;
	bh=uwrfu/RQXE+CPGny/VIfWFI+r++v83onQnRT6WNFLOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op7dnNSmfHN/jFyNsJbtc44cyZfHyYvJfKVHiliJPEEPo6q3vkvb+h6Oj8HHywyeQZO/5vzfXUF+k/EsyfxrH8IgEbtG69nzCJN6g6cy8qt9d8e9N+fQoPehDlbquArx0DT41iNUb0DCFN49KUMaWmCeyViRn5di74XwjDBT80E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CuHlyso7; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CuHlyso7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245200; x=1747781200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uwrfu/RQXE+CPGny/VIfWFI+r++v83onQnRT6WNFLOM=;
  b=CuHlyso7t6bOM2ppRr9iWiuNZD695ScQ++i5O+dO18IaM94ygoFKLNs1
   X1wBB2jKqllzCWUn4TLaaDKmbI+K22RWFjSYVAqOjj/ASAB8IRuBACvun
   Dj0ZRcenPkyH1rqKKDo7jdf7RjEow0EAOmbQLHASbHtq14AP0zL3goiRd
   WFjR8G3m8jFCg9dghm7TMX7I/eRPplowvxlBbtC+jA7cxK2auByDaqeE+
   l/yXcAFXAWS7FP7/smBRpMIzRxo57pCTZAl/WGdKSWDoLIIoQXIGHtn55
   1j7DVxGjDB0k8Dy/eU9CYJzqmcgCFkrw1XGgb9jCsVbBoiOxQGUw7EMii
   w==;
X-CSE-ConnectionGUID: jfoMLlRTRReKPZzlNztAmw==
X-CSE-MsgGUID: ai88r7VrQDW0t3cvfSGepg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199578"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199578"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:36 -0700
X-CSE-ConnectionGUID: ONS95sjIQoW2yWT/aoDaVQ==
X-CSE-MsgGUID: EIlSKc9cRMeYwJ3xQJKG7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593403"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
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
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 07/49] platform/x86: intel_scu_wdt: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:38 -0700
Message-ID: <20240520224620.9480-8-tony.luck@intel.com>
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
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel_scu_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_wdt.c b/drivers/platform/x86/intel_scu_wdt.c
index a5031a25632e..d0b6637861d3 100644
--- a/drivers/platform/x86/intel_scu_wdt.c
+++ b/drivers/platform/x86/intel_scu_wdt.c
@@ -50,7 +50,7 @@ static struct intel_mid_wdt_pdata tangier_pdata = {
 };
 
 static const struct x86_cpu_id intel_mid_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, &tangier_pdata),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, &tangier_pdata),
 	{}
 };
 
-- 
2.45.0

