Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1F513A259
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245203; cv=none; b=G3JCOS41J7Y8DmlfE/vj8Blm5dk/kscKSKXwKfneFO3uSY4uYvWictWEDIrqu5dWd9aAO/eQTO9ynHDbwbe0NPBXIKN3lOEYdDxtABX1L1xcW8upEBqMLdkZs6LCPJR0Zzggo3XozGYEeI9GdY5dnum2lI2cTajArY9q319Dy4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245203; c=relaxed/simple;
	bh=XfoA0pauCDfOJgfi1sYfYTOnSD8UB46WDQ7JXbYpI7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwsK00vXoT5LhrYjQAhsFhpEb6FS1ts2nT9hSGh1g4DOH2C7tGXJ914axJXhXnCEsXY4ipe3qD1LJaJcdGm6buUyHbSPBGUo6q84k6qa1ptgPbZANgyg2A6mv2fCr9h6wq6o8wjGSzTtS4pRii/KTvlx8T3/3x4XY/DFLCy1MB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PLFayXJ4; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PLFayXJ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245201; x=1747781201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XfoA0pauCDfOJgfi1sYfYTOnSD8UB46WDQ7JXbYpI7A=;
  b=PLFayXJ45CMII32/48EndtiRawl+Pabi3m6n6BJ6vHh3HCcXwHCa4lTW
   ujq1e4S9RfJhSSIppOCg7td+BYoYbQIFyEmlXKObNNwTid6ccnCkZs8BE
   qMSZzJyY2Qnd06OJE5fyhLHz+5coPW0Jjo0CXWBpjzFUiWCzk4Xvd4i/c
   i82pOrhG2SxqSr+xwqVdzcF3y3Idv6pVcj9f53oLE0daSyWs7P27AJLYt
   2sJXnSA1pEwS9jfXLqF+kHeEP0Hm82S02SCViY1bhCxMwKChwVZ3NtN3L
   mpY648DoOD9Q1urEgXKxiSj9Dfw77GXcgs1MKeb3E0tlalD/kFOc2T5tN
   Q==;
X-CSE-ConnectionGUID: tBLksktCTH6FLbEUMou4Lw==
X-CSE-MsgGUID: YIsVEiupS/KXd/O3c7iqng==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199588"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199588"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:36 -0700
X-CSE-ConnectionGUID: khRuJN/sTaOQz/5AsH70ow==
X-CSE-MsgGUID: jYiVDghcQ22y+MW9XAmbrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593406"
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
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v6 08/49] KVM: x86/pmu: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:39 -0700
Message-ID: <20240520224620.9480-9-tony.luck@intel.com>
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
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a593b03c9aed..938d01bede80 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -34,16 +34,16 @@ EXPORT_SYMBOL_GPL(kvm_pmu_eventsel);
 
 /* Precise Distribution of Instructions Retired (PDIR) */
 static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_D, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_X, NULL),
 	/* Instruction-Accurate PDIR (PDIR++) */
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
 /* Precise Distribution (PDist) */
 static const struct x86_cpu_id vmx_pebs_pdist_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
-- 
2.45.0

