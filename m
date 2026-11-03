Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793741002;
	b=gOLB0vhAmtvG+Lk0A5Ms8d9LqRY/t5UuPDuDOBrJcpJyRAeQOeSvcYQSIEvPsWg5lYG2
	 3ws5Oc1Je0AKG/oGt8VsHks6magLgtQeilly55pFPDkvgm7PirQy3u3iycFFjtTQ5XqK8
	 8UsiEKe/lLYbf7dTshGavanK5bzcePGacYAgzu8lwwlMwBit0P47BRV1mdaAqhMYL9F88
	 ZYFCL2L5/1c+XSQvYDP3M5RkPnMfFHdZZW3FoIbs1rhRV+hd7oriVH3gOJ3PHaJsVlj6R
	 oL7yYr+gPlgat7IBG9Ie9r1lxrqqg3hfTeb2pqmlqnUFs/NNZdK7n+erNHMutbzgnBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793741002;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3oGDVZCbhDYSAm8svmjDBj8www6GvSfpJIKzPDKRcqA=;
	b=gtTAh+a/dLs5e8Dn7/sP3rdSNYyIm76p2LuTw56stULScYNUj4OEoJdipxrImp0LVZoO
	 Ya9tPstcEFJdCqg9G39VVbXJ3Q6yv0EizJGq3qWSIyRGAFXLBo8pRYrwnCv3Wnmpf7cG6
	 2uHpncO/6vd1J56KwguVowXBes+clg5onfYLySsIcugqSNXOWbgol+f76dGf2xpp5A/57
	 sFMvNo3X3nQbIAQmAve1p5zoAWB2+M9Tu+4s0NZLfeWd54xaFyqNzrdmAX/z2jzta1yfZ
	 n8qwQR00GyobKRCHosxR/EDIX+nFgWZjDYDwvCDvV0hyTjcOn1owb/bjMN7djeO1q/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eGqshn8K;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3292606EE87
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 21:23:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3292606EE87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eGqshn8K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793741001; x=1825277001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MW56v4zMC4f37LZGqlv+/gFWWRjTDR661pjk1iSp824=;
  b=eGqshn8Kq1cujPpYdrzyDr0XpROaxoMmBi8/F9txtx+zzmQbgy5r6twS
   O0g6JljzAvL1WdOEWa1paXlj4p7jLJC2ggACIYJKNhfhgm+MvpKLfUhEV
   GDufapMMV9yJqSTlPoOljWAzjbwaF6oK2TGlkMDMG+5TaQub3eTfyB+kj
   D4y4c/4fpEAN1O4KR880PNelFRaN2yCCvLG0DWuMMJpdy24PHpMcdE8j5
   m8vUAZakzz6Dwyv0f7/3PHW3TL0cW623Ocm/wKj44yQQD0WJCSkPWjupH
   BTiMAENzRtejv5JCgvwslYru+NQstQTGItC5aB0aYdLSaGrnIqqnDGiD+
   g==;
X-CSE-ConnectionGUID: gSGv/r1qRS+3w26le0gVMA==
X-CSE-MsgGUID: ib5T/DIQSBWp2f6/QzhL/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2393544"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2393544"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:12 -0800
X-CSE-ConnectionGUID: cmbyD4tfQ9upZJfM21RFBg==
X-CSE-MsgGUID: WakLz13mQza9jxSML+2SoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6624599"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.124])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:11 -0800
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
Subject: [RFC PATCH v2 11/11] fs/resctrl: Document asymmetric L2 allocation options
Date: Tue,  3 Nov 2026 13:22:54 -0800
Message-ID: <20261103212254.18314-12-tony.luck@intel.com>
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

The rdt= kernel parameter accepts separate options for asymmetric L2 CAT and
CDP. On asymmetric systems, info/L2/cbm_mask represents the minimum cache
bitmask across domains.

Document the l2cat_asym and l2cdp_asym options and clarify the meaning of
cbm_mask.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 ++-
 Documentation/filesystems/resctrl.rst           | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..a16f84bed8f9 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6460,7 +6460,8 @@ Kernel parameters
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, smba, bmec, abmc, sdciae, energy[:guid],
+			l2cat_asym, l2cdp_asym, mba, smba, bmec, abmc, sdciae,
+			energy[:guid],
 			perf[:guid].
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 524ad062a6d9..241461e0612b 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -91,6 +91,9 @@ related to allocation:
 "cbm_mask":
 		The bitmask which is valid for this resource.
 		This mask is equivalent to 100%.
+		On systems that support asymmetric, per-domain,
+		cache allocation bitmasks this is the minimum
+		mask across all domains.
 "min_cbm_bits":
 		The minimum number of consecutive bits which
 		must be set when writing a mask.
-- 
2.56.0

