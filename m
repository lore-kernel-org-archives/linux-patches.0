Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793741007;
	b=I54WtjesTv0G6OaKu4sU248txLuTelg0tWej1vNTGF5FuBfY0DXDIzNJMBq9kZOz0IUV
	 piugsGCihC7XYjgWPIztXVKBMpsnGDMduYdLJR8eiLFYZ+Mukgd1IUKVIfezLmbmfvMY8
	 5sRvf428WQWCBaLtPeBWxiJxeuxsJ+uRTIpOqzHiiBzQ8F0apNbpFs1SftZQNOodJUPuO
	 2OYfT9T9QmYKShDtXkVgt6X6IsDWGp54Ob9p6K0a8+RqtAX1ideFMLRsCm9T8WT/RbDVY
	 eeBZ3DgkZPxsDXAAlwSp8PbNgUUC6ZBrLXQXMLSZ3HA0Cmx/3oSEQYFzAEjVAH2iPzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793741007;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qwFCnqxhI3HCa7IEzFiD/bkQACIPFRKxiXo1fSbcp3U=;
	b=ur6057ca1Bm+gg9pUaAf2sSEcCNg0211pFyHpjKq1VdnwQ5WspXlpX0rif3n8GRHWG62
	 BRmEGCVRPtavLpmaReXeYHEuoAGFtfFtb+KsKUSKam6+qKgBNiME3Cj9aS2ojfXPq7sLg
	 tdvO18kMj+vwlGDpQkM3bvqSriwbfvbTaKEA8ySr/DQbmFPksAEHRl5mIyg2WnF+iNUCM
	 gevZ33ybkojfI3iVh/qV/02Vp+hU7moSlsjDGwUqu90wS9A9g2PzT8skewyup+2b1wMT0
	 F2Uuc4wv3OB4Q7OB3hyek0NwUaOqTdrRsSrXr1R1p4adFxtS6v/gOdeZon9NKcy5phw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YgPbeuoX;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A92606D815
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 21:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55A92606D815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YgPbeuoX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793740997; x=1825276997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ySFhl5S4vdesBmOfLe0QvgEJ1WbFvYAQaaCxyAR2HME=;
  b=YgPbeuoXo9crrcm9cAI+mfuO1iENrZF3cHEcyWQCHrYiTB2a3s2wX5vQ
   nx99iw/Tx+qkn/eumyGgFbkNaieEjgTXyC4wxCft/I346kU8foOGngF9l
   z5rNqd2xSwk+NONakvREjYlfMrIxo04CgOhBsrltm+jRRfegV15iaVyN5
   YL789MkPGcnmckhSt9qrp47IkLsNhGD1zP4Z25i+x5GwTqbimljk+MAMY
   764R6VoAsUB2ezHoQEhkfAwpdCd2Yd5En+q0BTZOH4YpqBPKiX3ARzBNx
   lokZcs11Dou2oL2LGpHN1HKXPHqKWdg8wN+7NhiYvf19/pXVc+95tS7BS
   Q==;
X-CSE-ConnectionGUID: hWHPy5LsSimOXXTTVBJNnw==
X-CSE-MsgGUID: kFAKoX0zQ4O2sRYStI2/jA==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2393534"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2393534"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:11 -0800
X-CSE-ConnectionGUID: tYbgpQ7uTbKRM/o5KYevog==
X-CSE-MsgGUID: Sun0kJu6Tsuv0YjgKQ0E6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6624591"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.124])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:10 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH v2 09/11] x86/resctrl: Accept asymmetric RDT allocation features
Date: Tue,  3 Nov 2026 13:22:52 -0800
Message-ID: <20261103212254.18314-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103212254.18314-1-tony.luck@intel.com>
References: <20261103212254.18314-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some systems expose asymmetric allocation features without setting the
X86_FEATURE_RDT_A bit for symmetric allocation.

Allow resctrl to probe allocation resources when either the symmetric or
asymmetric allocation feature is enabled.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 197d50b795bc..aa0bb32d191e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1063,7 +1063,8 @@ static __init bool get_rdt_alloc_resources(void)
 	if (rdt_alloc_capable)
 		return true;
 
-	if (!cpu_feature_enabled(X86_FEATURE_RDT_A))
+	if (!cpu_feature_enabled(X86_FEATURE_RDT_A) &&
+	    !cpu_feature_enabled(X86_FEATURE_RDT_A_ASYM))
 		return false;
 
 	if (rdt_cpu_has(X86_FEATURE_CAT_L3)) {
-- 
2.56.0

