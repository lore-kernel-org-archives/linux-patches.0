Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443056;
	b=Aq6OCfifUFzu/t535ddfzomR3+0GUhLZ+vBoVJufdVHPOgP0HvcLPdWEsfSwDqhErSmm
	 /hVIsrT9OcdPSH+jeoTj3wBrtsCf7VAh3jn5PCS6RcBfHPcCBrtTkhjN4xh73OmRuejuw
	 7cgqT2tdHpHhd8lQKJV8xpd0DJw/pmQz+qotlYKqVq2guBJYRS/tc2H4V3RZcU95z+zv1
	 mz2Ds/soB1OYRLdmhy97NezoJrhVwBqK5lX26YABoj5vSO0z2tHIjEx3a6TKaIf7QUIC7
	 EJzdV9cxwJrS4EC0sTkb5VnCQx4Aaoz7L0NzFXln2F9RGU8V/EQKQ9TL9suP23bUExw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443056;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PX0Ux4l98L8xvo7tBfYBHCx/KaUx8ITkoXvqIWv6vQY=;
	b=kdUHHl5pqEXsz80hhZMdrWCdr6U1MFzAXNqQwjp7JrSSUWO1CDKfE9rsx4GwFxDucTAs
	 HwSOAgk0a0n1Hmacr+iKuVEPEvQnQFfNCxF66oA+8Gif/iYUh6+f9HP14eOmOYw2JW6Yi
	 MrDTpZPugBJVySuFpRlfIaFkxvzRA9iv1x/SlYkZNH3h6e52OtEWua8MQK/3DS/94lfmT
	 CMVU2m27GRvbkI+sWyF7j+F1aRK9BHpG1vRQ/PDjZDdTO9HGMdW57nQOg7+hAkRnIVd/d
	 Dc7t1sp1HfNSGTMADeHG+srf2e+DYUzqAFqfhhFiSi7+UJDntcOKGrkAfwZ6UvSyarQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="Ed16YUw/";
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1F860A2600
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A1F860A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ed16YUw/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443056; x=1823979056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1IB3esYd7ATSNi2S34LjPKibbEY3B/eSQhbp/8PZJ/A=;
  b=Ed16YUw/qWtF80cmw5+xnfx0vxcNEImbAaZ6CvXs9liEwN6/w7r6UP6R
   kEU8dWPBhA+en2wQD7pKV4XutrJX4H6T51fiELuFQadvCa8twb9QXgqsu
   27Ni0z6rBx113Y4mxLhvmRh/Z78wPp5CN9fLE/Q8BE1P87Z+ov3HPVPxP
   oKgSbnCL7vLfJjQR5SL/vh486KNwWYWCc9iqFriepMm/EtKbj+hFdqBYX
   EPIVWQy9g5u0WnNjtol5PgKtvghsLzlKK5/SFb6RPX7XdZ1TDxVy1J+tO
   kwE1uN0qyyS3feOgE+7OsY6EBUPCdcDyP+BaB2x2hivAlo1BGRm617HVZ
   g==;
X-CSE-ConnectionGUID: CMNVomoJR/yBYaiman1p4Q==
X-CSE-MsgGUID: bb+Z6kbMReGpMYhZnjrIew==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131196"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131196"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:50 -0700
X-CSE-ConnectionGUID: LAGf6ADNQW6mlYgc7jP0WA==
X-CSE-MsgGUID: A3OZ5WnHQ1ORpucMBUtynw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008650"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:50 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v14 10/24] x86/resctrl: Honor rdt={perf|energy} options to force enable AET events
Date: Mon, 19 Oct 2026 13:50:17 -0700
Message-ID: <20261019205031.16977-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
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

resctrl can disable a feature the platform supports, for example because
of an erratum or, for Application Energy Telemetry (AET), because an event
group has insufficient RMIDs. The "rdt=" kernel command line option lets
the user force such a feature on anyway, and also lets the user disable
supported features they do not need.

resctrl enumerates AET once, on first mount. Enumeration skips an event
group that is marked disabled. An event group with insufficient RMIDs is
marked disabled even when the user forced it on, but this happens after
the test for forced off when enumeration begins for an event group.

This will be broken when AET is enumerated on every mount. The disable mark
recorded for insufficient RMIDs on one mount causes the event group to be
skipped on the next, ignoring the user's explicit rdt= request to enable it.

In preparation for enumerating AET on every mount, skip a disabled event
group only if the user has not forced it on. As a result, when the command
line both disables and enables the same event group, for example
"rdt=!perf,perf:<guid>", enabling now takes precedence. This matches how
rdt= handles the other resctrl features.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	New commit message. Dropped previous supplied Reinette RB tag.
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 66cd8c2c7a51..9f0829a82cb0 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -262,7 +262,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int skipped_events = 0;
 
-	if (e->force_off)
+	if (e->force_off && !e->force_on)
 		return false;
 
 	if (!group_has_usable_regions(e, p))
-- 
2.56.0

