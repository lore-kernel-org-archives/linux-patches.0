Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793839074;
	b=XN+3Np2+UGQPeEj4zI2oD1NeeZFx1nRH4Yb/IUGJ6Ku0xhxl7T5WayLvceoQ9NLfOSVr
	 kZyfEW56FCNRYyEb2z+hyOd90o+Qrg5NuAZwyHXAv+ZwKP3qBEZ4KFPNgppYVY6tYiMu0
	 xv84e+1Ge9IJqo3WIrXHvZdDprp1wvFhTwurOtqfNKCWyyR3se5wArVPu5NPDNsS2vdB4
	 /Iw6OVbqPNqMo+GLr6c9nZH2Ekio53x1R+YWCe2ohS1c5RVzHsv1fO3eHRvELFVBcrVZm
	 K+/90G/Zphk9M+FTaBov1Jhh18cohovXaK6mxrvRI/VPhPLo6YkwwOUeDyC3mSTdn8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793839074;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Vpb41zcJVGYE44AvbnXqBZTI4bGUMjrzPqgcCq7kR3A=;
	b=L6/2JJfrslRKQAEwTUw7tYXUe6MWBju678i2Qg9Hh2gm7cOJM4GXfEU7Gik+vE5DWhcw
	 UbJ8Djhuv4DOpPFy8F+UAqXO5/ZHENyhGBvmeISZABUk45xQT3ULR6yRCn+u+gzbWzziv
	 np2t9xzY4zVRSWoZHTwEAtlEOZiiWhOL3O4cHE9V1LfeEsQIycjvbTUgqUhFM30h8UXOG
	 /fd70eYbREh6pulfrueHyWd4PMrExJvXWi/RkGY4JTVCneDYj4MVIPePOMhKmpPFZMQkN
	 qp8J85bDat08JFWAY61I4Z2M1T5LYWMd6JG2UHlphJAY67A2X9FGNPwnvAJsiO77J8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Vvt3n5e5;
	arc=none smtp.remote-ip=192.198.163.19
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162D5606A31B
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 00:37:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 162D5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Vvt3n5e5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793839074; x=1825375074;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GYNcMJfNAnvDIKFOA6xoGlRUzTahIzzwSi38f6HW67c=;
  b=Vvt3n5e5wdUAcV7Wd/qoVBDhBWFkung9OlF8j2lRtfYRcz41vQKwKuYj
   eEcea7OVdgy4T+xSVn2cY+WV6AOPcHG1WhrC3GgowO+2Jk9jPfCkEaFU/
   fPDZODm0dvA2rKfOLJsjbNvq11GRDiZGjm/wfCp1K8Ew4PVy8jzZla0yq
   J7OTa+HDpdIfBcJkzgo6e1lj47EV+buISi9LXQXSnJP01gFkODvkKJ4qB
   8y7nUVl5ii2psfhlT+vAwrVuarGOyjQ3srLUuiYXjeHiuKR29gkd0AeCy
   PzMl+WYh29ga19+kZX0+2zVvxy3xx49PTO3pNVZilrhbFinD/i/E2Pyvl
   A==;
X-CSE-ConnectionGUID: 9xIs9d+6TGOg14XHXRRAPA==
X-CSE-MsgGUID: A13byQkyTJWjR7Ne1ksbUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2717823"
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="2717823"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:37:53 -0800
X-CSE-ConnectionGUID: NFdWQiMHQAqeFftS6eFpTw==
X-CSE-MsgGUID: rCsCTnJuR/Gt0nWbkQiYSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="7413708"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:37:52 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH] MAINTAINERS: Add Ben Horgan as fs/resctrl reviewer
Date: Wed,  4 Nov 2026 16:37:47 -0800
Message-ID: <c68cbba4455d3f5e65c38b76b3daadc04217abca.1793838993.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
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

The resctrl filesystem provides the user interface to the resource control
features of multiple architectures, among them Arm's MPAM. Ben Horgan,
MPAM maintainer, has consistently helped keep MPAM's requirements in view,
both in discussions about new resctrl features and in review of resctrl
changes.

Add Ben Horgan as a reviewer so that he is copied on resctrl submissions.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Position entry to avoid conflict with RISC-V change in same area:
https://lore.kernel.org/lkml/20261104-dfustini-atl-sc-cbqri-dt-v10-6-1636a003a3c0@kernel.org/
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..04bdbba16138 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23460,6 +23460,7 @@ RDT - RESOURCE ALLOCATION
 M:	Tony Luck <tony.luck@intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
 M:	x86@kernel.org
+R:	Ben Horgan <ben.horgan@arm.com>
 R:	Dave Martin <Dave.Martin@arm.com>
 R:	James Morse <james.morse@arm.com>
 R:	Babu Moger <babu.moger@amd.com>
-- 
2.56.0

