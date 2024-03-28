Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06152127B67
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643310; cv=none; b=b7hsde/wiviWT/VkMLo8n0tlgMW8SAtnjRmNoIVawW/Pt72cN9Sx1P+hIC9eXVbDLGFXEoa943uaPAS4CvfH/Kpy1S9a3Whdq9MMegjw9+VUVnbqLDlder/xTGAWT7RigQxWsLU2BeFziClEvkBb5mel5L4efXCiZQoPzrbjPaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643310; c=relaxed/simple;
	bh=CIcz5Nw2dfWca2jMW3VzowmJZ/HfcnGQaEE9Ffmx768=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP5rafrkDKDUmO0Ddm6USSfA7TfasUJgXtsT2n08UDrgsgzFexS9/IUDWs0KRdU79naSk+OdLW6N7LQ6CeEVlPjdmGD1yny/CgSPJ+y92E6S5bwO6mZd9/+7EOSDjonhmDwCeiRqHKjT/KpcwSRlPthw8Y1NvSuVYwAnM+t33kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ICMidDeT; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ICMidDeT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643307; x=1743179307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CIcz5Nw2dfWca2jMW3VzowmJZ/HfcnGQaEE9Ffmx768=;
  b=ICMidDeT4XQ0xwiL9SIXXJZhg0J8eXf2kJFtH1Gb5sbebp7cfjGxJnUX
   zuYAKajq3t+PqAA6F8+b6/F3H6MuJ/CM0Z57li6yayKzrzxKcKasYBYdv
   DhBRAlo1GzRWt3LsB3mpV7RsBPNYXVLHiZXyfoaNLZHq78dAIwrm/Mvto
   kGI2KYpVpZkTHFscdlBTOF9MlPwi+zV2ZpSgvOhh5GXtQ3cTsjLUsfxmS
   7Ltq5B+TamZnGR0ho+9Zcq/buh6rY87FfRDjnAbemLGiO+YR45az3AGdw
   f7TqV2BxkUTBLplcn4iLNWhM46o25qbLGOj/cKNsfjc05wov1MpMPW/E9
   Q==;
X-CSE-ConnectionGUID: qISntTueQhSwuKplfd6vNw==
X-CSE-MsgGUID: O101FmSGT8mUn32RhnVArg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294741"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294741"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726008"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 19/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/intel_epb.c
Date: Thu, 28 Mar 2024 09:27:13 -0700
Message-ID: <20240328162820.242778-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
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

