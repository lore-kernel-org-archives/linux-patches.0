Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AD91C68A5
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495913; cv=none; b=Ltf6RfVL9GVDbqY4wdC5kTcW219AytJ1RZM4G2lTSS+u6IHl2Sl+597r7+ELjQ1PzNubD377ALg3nt9IWJXWOZ63cWpTvkR8qWM1+1IFn/8fgTUpzol6/X1wTAO75U8+B79lV2slHK/Hcz1vmusFHgxeCTzW2W/NcNqLx+443Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495913; c=relaxed/simple;
	bh=xK5hwg6ILPkC2v4d4nuHc6WucRElJH7HgJqquuK12yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZeP72mbmFv8G+qzbm96F9C4Qm1n7ASeMgs189XSNUDwFcHEct/HGYT8GgGfaL13Jz6+Z96a91BQsPVzP8VLK4VFwf4dS4oUYTuA/bsr04lb7AUTZgIseZ9n9xFpUr9aKP7va9KPqJSD4PWGH/FWE01kHGZxGpxYaTgizcbytOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iXGbfzgu; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iXGbfzgu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495911; x=1746031911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xK5hwg6ILPkC2v4d4nuHc6WucRElJH7HgJqquuK12yY=;
  b=iXGbfzgu3HHHbNtg+Y1KE9IB2KjHAnUTits0y4KRzolhwgsIRDOP1n4Y
   lIyUs7qz4kV4F5kC1yNOzJCjp+XQYMg96myJwFOfyvSLk1tT3FtU1QEY0
   saxftz2m0FIruwcw2cqbsD8bgdA9H67SRf8mYBdpMWDW+mKlZw81XOcxE
   tgDcHMczAJ+C+fNG6pbd3kwg3ADrbDMt3ClRn5wgBoyguhYS6pcdhCdLL
   krBNhShSP5KC3H6QlNmW21T/TuSy4GSIE4kBk6jAsvHtHEc55e35mMDZJ
   galG4BmOZchvKUYB+/8zv7Z+tdaASnNAIWrjxQ62HqtUAR7SnGzD/F3dK
   A==;
X-CSE-ConnectionGUID: LvL7tpiRTc+akaUH8sd5Gw==
X-CSE-MsgGUID: Skw3ldVVRGm/eorOpN0h3w==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075762"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075762"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: y0ZVF9PoRYW+VcEpLNNWnA==
X-CSE-MsgGUID: i6DXGELcQuawBGsMwjQcgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515509"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 37/47] extcon: axp288: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:50 -0700
Message-ID: <20240430165100.73491-37-tony.luck@intel.com>
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
 drivers/extcon/extcon-axp288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp288.c
index a703a8315634..d3bcbe839c09 100644
--- a/drivers/extcon/extcon-axp288.c
+++ b/drivers/extcon/extcon-axp288.c
@@ -108,7 +108,7 @@ struct axp288_extcon_info {
 };
 
 static const struct x86_cpu_id cherry_trail_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	NULL),
 	{}
 };
 
-- 
2.44.0

