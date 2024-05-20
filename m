Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498AA13B2BC
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245208; cv=none; b=p5sgJjg2M2GL99aW2G7AGJHV7LVBgK+pnDLU/cT1MVYUZvXd1HfMfnzUTdtdPMr3ASI7AeSU0MtOxOsSGQUpUhiXMgWciHjGrWZB91mGyKdcn60D8NoK5Nm4eo73AS6+sIjlZSNxVArBf5tPO9cFq3aF0Xm8QlckgnLpGxT6kqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245208; c=relaxed/simple;
	bh=PQHhBRWTyJ7lXAnwUF6T1t71Eh1K9Um/FsP12CRYfhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bm32N1eQds4sKpcDPPaMv1QsZ/ozF797Ew2d7WuqGn/lHufXX5Azq+4EnT0UW5Mc/EBy8ghWh0V5VRXilMJ/Q9nO2IJXgLfiJBroGWLXQ3uOwO97ISOw6A//SYRxij7ETBktfFc6UNabGne0tGfY+pMUkyTJZySoJsVZWAjXzSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LKlbU6+4; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LKlbU6+4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245206; x=1747781206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PQHhBRWTyJ7lXAnwUF6T1t71Eh1K9Um/FsP12CRYfhs=;
  b=LKlbU6+4pcOEpu6lu6P5cW6KqgbpIIwZ/vo5G0Fik/LO7jsrn+e/vmiW
   EEofgQZhZiMDMLeJc/x84d7es9P4EVqKjeHtmQvptqhMzBNL93y0UO4Q0
   n5Zt2gyvlw+R/PeZ8jTsoCy+S+QAyfM5ZvCL+PyVMVWKx2EErEPa+MDM5
   dj1yoBZNeLUt7PgZihLfs1+ZFIYwOjceRQU9LCIK4aZwXfmWjia2d9FyJ
   BP4Yc09HnGy/sKS7medvH8s3atd8Zq7UHSzHyP8Of64WbiJ6qmDUHkcHA
   fyu1QMgGdVMyX5ARTi8se0rKqlYP0m3FHr5xP79VsGofE08WjhwLMPw7z
   w==;
X-CSE-ConnectionGUID: SRy+zx2PQvCDXaraHnoh/g==
X-CSE-MsgGUID: LhGk/9sFRJSHi8lIhLkvnw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199758"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199758"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
X-CSE-ConnectionGUID: hgJ5Tr7QR8W9CQr8QmhazQ==
X-CSE-MsgGUID: MUEH5rC1RmW5u4N+LO9a7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593451"
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
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 23/49] platform/x86: p2sb: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:54 -0700
Message-ID: <20240520224620.9480-24-tony.luck@intel.com>
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
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/p2sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index 3bf5d2243491..31f38309b389 100644
--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -24,7 +24,7 @@
 #define SPI_DEVFN_GOLDMONT	PCI_DEVFN(13, 2)
 
 static const struct x86_cpu_id p2sb_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT, P2SB_DEVFN_GOLDMONT),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT, P2SB_DEVFN_GOLDMONT),
 	{}
 };
 
-- 
2.45.0

