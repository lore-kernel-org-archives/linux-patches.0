Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A0513B287
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245207; cv=none; b=uDpcirMCGGxh+HnHSpLlo7BeByRDRly3CTcjIhROpCDcQKrBtsAruLY6J7y7DZjcKdznWOBLxYPdKX3AtPgUDqJzQo4HQbRDraeGYnGO2KhRSFeub19qKlEdbQ0J4bTnXG4DqPjgl1IQkgcRunLblAvljc4k0DfKijWJR3PDTZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245207; c=relaxed/simple;
	bh=8rfbntKG1DMkpDVnqu9bd2NfEh681lNQrvAAuh2G8x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVzdV2c1tgZcwmRGJJic30zmjCAphsNURKvDGulxB6yyLfnLrVi9SxPhVwVW9r1n7jZnRxQABMHRo2fFSb8GnTov9O+GNkSyHwksdUOMasXI6l6kOmvs1TptGFpp+/dObR87WORSv35uMsHf6n6bzFVJgsdOHjBJ3xyBvL9Ok8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CgyDtGjY; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CgyDtGjY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245206; x=1747781206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8rfbntKG1DMkpDVnqu9bd2NfEh681lNQrvAAuh2G8x0=;
  b=CgyDtGjYiL8lhLMn+xkc9HUgTn66aNEPeYklja1xdmCWqEKI4wOohrIn
   5jVqcYjOKoJfee/pz7ndybWtL3UEXtrxF/Wq/zx6wohPyzd+dk+0tvzya
   PErusWdgtA14W3NG3pVX3EtIn5b+0+f3x1WMicngRUf+yUN/Hf1Zk194u
   P/Skbea7jMa//1A10dgH8KrCYGkJroqwD9VsjkxwBpm0/RmOiHQDMJDmw
   /OdeJebncgxUge9JYAnGqahljhthGGjXEz5klG2pEuFYz7QVwvbkz5Jtr
   bQ95RLjtS0/lz92kKcFO9zsMljFuG829ujYASbbpB5HzT26zDqtmLqMri
   Q==;
X-CSE-ConnectionGUID: XWAZtrcORd+6tgx1ziaCJA==
X-CSE-MsgGUID: c/ABJUfxQh+uycSKMgStMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199736"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199736"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:37 -0700
X-CSE-ConnectionGUID: p7sV0lcQR9KdqobAN6+SLg==
X-CSE-MsgGUID: dWfWafuhR4+twVI5BMlcwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593445"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:37 -0700
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
Subject: [PATCH v6 21/49] platform/x86: intel: telemetry: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:52 -0700
Message-ID: <20240520224620.9480-22-tony.luck@intel.com>
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
2.45.0

