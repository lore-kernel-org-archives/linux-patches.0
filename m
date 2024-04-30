Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB161C2322
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495909; cv=none; b=CYKHLrK2t8Sl8RFVVXGwAH6SwDvbswBfmwF6e6PNRutPLc5Ejnrb8PW66VCBT4gbqXSN1wz1EVACvoH435qtbv0fU0Tk54kAXkUo3yMFTV5NmDP3CnILkWKliKvuANP162IAtE73tdtjzbOvC4COiPCHICRLwaZfygQfinTdNnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495909; c=relaxed/simple;
	bh=WV3qnx6+50b42Jf/GqLJUpAXvV6x1yHw3SQJ/gD5Xpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOuT9RsFDPCytUwxHDF1Po+wlluvr0IQKZEvdXxLKmQohIbPRrMqcuSohiTUipabsdLMMpInyM/ohIHMT2xAwYd+S91qUTqhfIWe6jn+MCKaS3rjfgNHgntZWK9iAKcVClez2AXKXPa1VSjC0rjtqiyQoxHbD9bpB4k7OE2RB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V0kh7Pjx; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V0kh7Pjx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495908; x=1746031908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WV3qnx6+50b42Jf/GqLJUpAXvV6x1yHw3SQJ/gD5Xpk=;
  b=V0kh7PjxeZjmH91ALRrlnT8mZxYDOOPMxEQ8ORFMFM0PSqzWBBaQ2VHi
   XyB1nv0nN7PF64/lqssw3rDPW6QqLVlrdopFsvOEUX2rS0Eg+YVMCj6wm
   x/HUUNeOdwyHm5rNncKXui6mi5xz9G3slsjrNO2pfGEslOrtO1mGrZ24s
   4b9G9q1dF5RriSAUDuerI8r79p0sbu03uaKPt1huaK9l6gCJRrT/BDkrp
   FFCoIZt6hwH1w5G3Ou2kuvJJal7aBbiNtbrYpj5gQqefCPxEmm+9E3CsD
   JULL3gG5ncdQjm/StftCDR6TPBBPq9BnEuEu5ICUQpimwtW1QfvGSGuxs
   A==;
X-CSE-ConnectionGUID: epxUKbT6SR6c9D+K8KS/8g==
X-CSE-MsgGUID: f6jUchi2RlSclonV+Ztk9g==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075740"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075740"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: UtJUUPUgQoeMnAiBNcUzog==
X-CSE-MsgGUID: 8F0oLzPiQDmNnewkKjSlqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515507"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 36/47] EDAC/skx: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:49 -0700
Message-ID: <20240430165100.73491-36-tony.luck@intel.com>
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
---
 drivers/edac/skx_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index 0a862336a7ce..af3fa807acdb 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -164,7 +164,7 @@ static struct res_config skx_cfg = {
 };
 
 static const struct x86_cpu_id skx_cpuids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(SKYLAKE_X, X86_STEPPINGS(0x0, 0xf), &skx_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_SKYLAKE_X, X86_STEPPINGS(0x0, 0xf), &skx_cfg),
 	{ }
 };
 MODULE_DEVICE_TABLE(x86cpu, skx_cpuids);
-- 
2.44.0

