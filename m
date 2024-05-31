Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B30D17FAD3
	for <patches@lists.linux.dev>; Fri, 31 May 2024 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187837; cv=none; b=VNXSM5vZpCt2AxyrdPbS2NxJWm4Kzc2Bm1HHAOVu7wyTAFhagGARmBIlJndDRqhKY48C0omMqV3xK8LxQWthgJG7xpYqUZajnwU+Ivd/OnNLjcV5iTPeErbkv0ZckZXh/qz1V1UoFlYBIDLyjEPEiIlzrwX2ddw2gs7siTYRbn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187837; c=relaxed/simple;
	bh=WB9IrZhQaBiWvCtxLVin3lFQLCeXldDe0NZh3MqrvXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa4NPFvC75AOrhJpzzIn8fLUjCt2IBAGTcvdVCVB+J/2SmXl1KbtactXXpVvuNskWNEkblJT5KMOzEd/HOatfXmPJ2TCM1G4hC5eT6Jn1Dx9JTty52ZyutX57atttmBzu2EzBw2QZ4oPjT+XQxU6QJBnVAjI9ZLU7ixSO1Wo4FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vidn01yA; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vidn01yA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187836; x=1748723836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WB9IrZhQaBiWvCtxLVin3lFQLCeXldDe0NZh3MqrvXI=;
  b=Vidn01yAD3QTRjD6ph8dfiEqtnbTqGVnvJ1w5O0LAhde5soAtIBByYEC
   N9QvIUIIYeBEzH+Ul7qexECMRmKkZPAqINK8ODMc6IKSBwSbdW98fKwND
   VtGYBxin9Hs9506YeHW+C/o3D3mRJ6qfxQYUqqU8fJ43shV2BSYZiHcJl
   qT1ByD36kkbz1hT5QxqD1d5B2PhBSAdOAC0YymokGy0mbrU1cofh+yvwi
   RQ5yOh9tJxhanoFIuaKuE9yuGFou18GvFRnQawqbPFyhAMKtPkNSQl5W9
   f4k1TlZcWBdsFNojj05yC9eDFbM7ZvFuzf0Z/xbvktIO7rLmYJqEWRI+o
   A==;
X-CSE-ConnectionGUID: ndQXTKaCSHyBIudoDHGS9Q==
X-CSE-MsgGUID: aWWu3TAsQyWLzx5JTYCmRg==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13871840"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13871840"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:12 -0700
X-CSE-ConnectionGUID: gX6ewXi+QAOe88AJ0eEeNw==
X-CSE-MsgGUID: puFRbaN9R+W99loEwhSs+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36355384"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 05/11] platform/x86: intel_turbo_max_3: Switch to new Intel CPU model defines
Date: Fri, 31 May 2024 13:37:01 -0700
Message-ID: <20240531203706.233365-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240531203706.233365-1-tony.luck@intel.com>
References: <20240531203706.233365-1-tony.luck@intel.com>
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
 drivers/platform/x86/intel/turbo_max_3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/turbo_max_3.c b/drivers/platform/x86/intel/turbo_max_3.c
index 892140b62898..79a0bcdeffb8 100644
--- a/drivers/platform/x86/intel/turbo_max_3.c
+++ b/drivers/platform/x86/intel/turbo_max_3.c
@@ -114,8 +114,8 @@ static int itmt_legacy_cpu_online(unsigned int cpu)
 }
 
 static const struct x86_cpu_id itmt_legacy_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,	NULL),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,	NULL),
 	{}
 };
 
-- 
2.45.0

