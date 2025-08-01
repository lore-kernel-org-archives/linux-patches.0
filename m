Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE010288C81
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 16:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754064036; cv=none; b=KxTC3hpuCjFVDoH2QaOxNE46y74vuqxXcqU3ZFtc9BTseGHp0ioFa9ugHkvElu90lkx/K4k8ntPKgl7O0ApKg+6RNwWsASS97nNb5bP75vra1Chw6BeP6GipmH9f4AghFJSp+aXx5rK7QuZ4Pw1LwvllEODiJ0J/qmksApGZMik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754064036; c=relaxed/simple;
	bh=ZUY87GzRvFHQkF0nij+YKn4SpY1J6OfNu611Gs2XbSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VrDYnuDIw/y4kal7WMQ5ufxGsDO8qvIuXVL2u4QdXTt3Ub4XZmmKA9H+jXtOthCVHgOJ6EOpyCzsPRDWzhbJrWG7N4sIg+YNXKmmKd1JTxousguv7LbuS5rI2hUzK9pDWem1DYsDN8zLwwvf6OKMor53GvxazvhECNjJDjYtPvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g6QCCxpv; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g6QCCxpv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754064035; x=1785600035;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZUY87GzRvFHQkF0nij+YKn4SpY1J6OfNu611Gs2XbSo=;
  b=g6QCCxpv/BsKwyzUMnEXwSZwlCM3vTG8lD8E9WwA7qNIlIdSwKinoRTY
   /dWWvDklgqRtL3/P6MxELnrXBKEN74hb4m4YhGuN/L/agKbZxXbpb2vqw
   tLpP4Dg+9IoHggJXQfkbtnTW6gzlU9Fw63tbJioTzyQXSYYkYaJC6rOxS
   4LSECOQSTyU9d4JQ09DYdZ270b2/oCTd9IxBXLtVMhetq2DKOgoKdFzER
   FFmBF654pScYW8lkvjap64qlL9vH45SVpihu7bE+SJzAdvlIxqA7cCDGM
   /OiUq8+dYlXywpoEVKUr4yXhZwpquZlDHzRn9U7lvWianTzC7ooJJY3uI
   A==;
X-CSE-ConnectionGUID: FsRjnvnBRj6R1GIlS4ttoQ==
X-CSE-MsgGUID: 0gAOLMfOTrqvP5R1stOMPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="59036581"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="59036581"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 09:00:34 -0700
X-CSE-ConnectionGUID: qPoyF8sqQe2T1llBeQa1Jg==
X-CSE-MsgGUID: 4xK55f8ASlOjs8PQqHvWMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163610857"
Received: from bjrankin-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.217])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 09:00:34 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add CPU model numbers for Novalake
Date: Fri,  1 Aug 2025 09:00:27 -0700
Message-ID: <20250801160028.4799-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Novalake has both desktop and mobile versions.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Note this patch is on top of earlier Wildcatlake patch:
Link: https://lore.kernel.org/all/20250730150437.4701-1-tony.luck@intel.com/

 arch/x86/include/asm/intel-family.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 5367dcbf5b30..e345dbdf933e 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -152,6 +152,9 @@
 
 #define INTEL_WILDCATLAKE_L		IFM(6, 0xD5)
 
+#define INTEL_NOVALAKE			IFM(18, 0x01)
+#define INTEL_NOVALAKE_L		IFM(18, 0x03)
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_ATOM_BONNELL		IFM(6, 0x1C) /* Diamondville, Pineview */
-- 
2.50.1

