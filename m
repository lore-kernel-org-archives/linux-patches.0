Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC4A397E83
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577750; cv=none; b=D8pcg+ndCz9gbIKsbNueRmB7jBt0K/q54uiz67guFJ7cZbeXpjZ0GKclWsrQt8eF2iWvJRrM54UI5+tFtL3FeuSYi12grrqJPu/K2ccaKQwQjw7LnC+YFGoJ7CkP8yOOeVz/188LUl/jGXRg/1VX0+o/3fMMIkxj6MHF4TWt308=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577750; c=relaxed/simple;
	bh=Yv5EcUWXDpIZAFAX7DJdvguRmY2SyKl2ADW+bcIYyWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vs4M8DabMRA5JUe/u4j4mXZbjbXcgKZv8vR8jneo/PA2aHyxkjI51YP+VmoFeeo7oGM6ZUI99aW2AhfcmHQ/VjjurZGo22VLVC53QTJfb/dGUOMEraBd+GGhXK4IbLeyV++YPQTkiTKR1y7Wdsg0lYo5JFY7dCviWarFS84/ETQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQ8TuyaM; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQ8TuyaM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577744; x=1807113744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yv5EcUWXDpIZAFAX7DJdvguRmY2SyKl2ADW+bcIYyWk=;
  b=kQ8TuyaMBWf1ZZ6jhqGKtxRpFJ/2Zjcywleny3sU0J/GnLZE/CPylplV
   qoa/oA63hS+t0HozumVl+uMhkiqg9sn/IPkPVj7ge9l9l4mCcIz8l7HPf
   JjgoWWGcFrmt7+Ehc6bY/uBTh5qraCQrOzeYB1dkz0mt0Ro/e6pNgHcvD
   fKQDZVwYA/nyxgRUh97pe3CDGiaocoFfSCGSEpilVV3ig3XvkBzdV6XkJ
   XtttJ43mA7LlinduA2u5gZdoKI4DerXqbm2qkfqaEipNP6zWSR4VOqke2
   Ha5W3df6xVUb5x9ZfEBsNZykzDrBIyWGVucFnCbUpKFOYMyracP1E0p5b
   g==;
X-CSE-ConnectionGUID: 6eoYyO/aSMefawyOiysumA==
X-CSE-MsgGUID: bKs/qRXwT+qYnBBQH/1S9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432643"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432643"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
X-CSE-ConnectionGUID: HYEMzCy7QbG62lW+ayVb3Q==
X-CSE-MsgGUID: 1owjR8IHQA2H3+ijhLJfdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119031"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 01/13] MAINTAINERS: Update resctrl entry
Date: Tue,  7 Apr 2026 09:01:58 -0700
Message-ID: <4c14dd82e81737c6413e10fe097475b1cc0886fc.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The x86 maintainers handle the resctrl filesystem and x86 architectural
resctrl code. Even so, the x86 maintainers are not part of the resctrl
section and not returned when scripts/get_maintainer.pl is run on resctrl
filesystem code. With patches flowing via x86 maintainers resctrl should
also ensure it follows the tip rules.

Add the x86 maintainer alias, x86@kernel.org, to the resctrl section to
ensure x86 maintainers are included in associated resctrl submissions.

Add a reference to the tip tree handbook to make it clear which rules
resctrl follows.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v1:
- Add reference to tip tree handbook to follow similar change to other
  tip subsystems:
  https://lore.kernel.org/all/20260305212215.3188399-1-dave.hansen@linux.intel.com/
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c14718adb2d8..ee218defa5f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22157,11 +22157,13 @@ F:	tools/testing/selftests/net/rds/
 RDT - RESOURCE ALLOCATION
 M:	Tony Luck <tony.luck@intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
+M:	x86@kernel.org
 R:	Dave Martin <Dave.Martin@arm.com>
 R:	James Morse <james.morse@arm.com>
 R:	Babu Moger <babu.moger@amd.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+P:	Documentation/process/maintainer-tip.rst
 F:	Documentation/filesystems/resctrl.rst
 F:	arch/x86/include/asm/resctrl.h
 F:	arch/x86/kernel/cpu/resctrl/
-- 
2.50.1

