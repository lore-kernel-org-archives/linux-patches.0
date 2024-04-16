Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF0713B794
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302409; cv=none; b=h4KsWsxkOXN6JguI++uZVs/T1Xqgu6HukcN6/leKIeVFlLTYbz8IIx+JRwLQmvzXsX4eBhriyNtFUoH0cz7c54ApfNIv3t0nWFIlaQ/GMjmJMoNwqJ/q0sknI7WNK4m2YgJDJiUJU/0X1cWUG2MK3mSMz5n+Rfij5p2WNVHtUNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302409; c=relaxed/simple;
	bh=CIcz5Nw2dfWca2jMW3VzowmJZ/HfcnGQaEE9Ffmx768=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yq/lXn5MB9JZRNxjGKYSANLsTDfF+oMyU/b+D+1hnfbKlTAxpipzGmPPfmLmy89gLyYe2Q008xab7vq5Bh/cQBaJuPUZx8KwWKjIYdLZnG0PkZwUqdrR7+L7Bm18kPpMdw3TiSIA8ke1E7ZRkVqEALKE3ep3YaVRQxj0YodRhqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ORqVT+/O; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ORqVT+/O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302407; x=1744838407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CIcz5Nw2dfWca2jMW3VzowmJZ/HfcnGQaEE9Ffmx768=;
  b=ORqVT+/O1sMiitlVW9jtF/u39QGR1GjSDiY7BcYjYW7sqSLbsk1VbG6j
   U8Tm95reytBKrruFHHNh6iHO59V/e7aNMAnif3pCNkL99qSw+wRf6OCO9
   Tgay4M2EHOK3xcpPak1NS62S99AIedPc11lB+06or93Q4n18XdcQ3E1jh
   2djT3wsRmhOOjfY6vxFlsv7fGUUqhrKpKy6A7oo2oBJs+mrZBkvaPRKfD
   MfAZnH+BmMPgfgh0UYAQU0uPVZ/alecPhyJ/g/qvgcJI+zsJg14eBkrWL
   xaI2BA9J3F+3GJr1y2sXIFL+m33mETlycIEwK+vjozekcaaL05e4yUbBa
   A==;
X-CSE-ConnectionGUID: fS7SEFZ1RDywh8noIM5q+A==
X-CSE-MsgGUID: +qLz3HhiQ8CKwCbeh0hi+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914753"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914753"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
X-CSE-ConnectionGUID: D3+EexuIT+WYPVZaPH/YaQ==
X-CSE-MsgGUID: C1rjBy67SHeoHMmKEwVnPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871941"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:59 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 19/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/intel_epb.c
Date: Tue, 16 Apr 2024 14:19:21 -0700
Message-ID: <20240416211941.9369-20-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/intel_epb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_epb.c b/arch/x86/kernel/cpu/intel_epb.c
index f18d35fe27a9..30b1d63b97f3 100644
--- a/arch/x86/kernel/cpu/intel_epb.c
+++ b/arch/x86/kernel/cpu/intel_epb.c
@@ -204,12 +204,12 @@ static int intel_epb_offline(unsigned int cpu)
 }
 
 static const struct x86_cpu_id intel_epb_normal[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,
-				   ENERGY_PERF_BIAS_NORMAL_POWERSAVE),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT,
-				   ENERGY_PERF_BIAS_NORMAL_POWERSAVE),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,
-				   ENERGY_PERF_BIAS_NORMAL_POWERSAVE),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L,
+		      ENERGY_PERF_BIAS_NORMAL_POWERSAVE),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,
+		      ENERGY_PERF_BIAS_NORMAL_POWERSAVE),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P,
+		      ENERGY_PERF_BIAS_NORMAL_POWERSAVE),
 	{}
 };
 
-- 
2.44.0

