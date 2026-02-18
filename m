Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7A13093DE
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 19:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771442266; cv=none; b=NN/f0l0bh2zji/nZ8NfMLHOLamGW/awv/wZAZVLabIpv2O+m6b6NS+5JQMmCOYdpI2YjIcqSqD9Bi+jgH85J8CkvsDgVRiSKypXIcSQRewrnW1QRfBcLfHiYBdq7DgeavlQmD944n/fyhXgfEIKpeCbTWVnYkYyxPufTVT/66ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771442266; c=relaxed/simple;
	bh=yj27m7958L79j5EUfkqy/3VqQJISmyZLtOGRrs2pc+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IpQI2WgtBUTFG93Tv5wDd+DdnPFHyyCa4HWU2I3GNmkQRvLlR3f6ZdHKVq+O2yVHlhoy9O5RCmvWaxuXTmDkx/ntCrnH8D6seRnYklYwoCFMsY/25F5LQXJimjMJwOoY0HUxtp8auFbO93av6DYtaKfxS8Lq6A0IKi8edUUpyeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lt6Wdzog; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lt6Wdzog"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771442265; x=1802978265;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yj27m7958L79j5EUfkqy/3VqQJISmyZLtOGRrs2pc+I=;
  b=Lt6Wdzog/fYpw4vR6Y0QFgD0LpSsDIpo0P8pF6lfVJEhZxoeb2CNp5fy
   AsOhg12A7LqivXVpVVVveF3d2N/K0GJVkDYkH3TQkeYXcLowhLeZo2bDx
   alONO/OSXoDgO9CUsEWSaKwhPqD+M/oqpUFzWd7WO0pZdoz8bQXc00L51
   YafE1SLKC6RrwRjNLJo/qbXRUL3840S8Z382EcFffUD2/0g9i65OZ0vvw
   PgGlPT8gIgJc15zmMa9SsSp8Ojrm6hweLlVDS7ArZt8oy8W3hhhxK/6tX
   8NfcJUVsRwVfQuyITaoN/ExwBXhRPj7WmqMcgT6yF2th4rJgVlQqjvmLf
   g==;
X-CSE-ConnectionGUID: OGjVsnQ5TQGuWgqCcsf3bg==
X-CSE-MsgGUID: L/PCq2ueTY6lfZ7FWNrdfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="83629920"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="83629920"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 11:17:44 -0800
X-CSE-ConnectionGUID: ZMJB1HPxQu6a0EqFyoIoBQ==
X-CSE-MsgGUID: 1WWC1q82RjOj+cx/waJ8/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="212603531"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 11:17:44 -0800
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
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH] MAINTAINERS: Include x86 maintainers in resctrl submissions
Date: Wed, 18 Feb 2026 11:32:03 -0800
Message-ID: <4274c478922c01f9ceebc805acf991f10a95519f.1771442788.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
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
filesystem code.

Add the x86 maintainer alias, x86@kernel.org, to the resctrl section to
ensure x86 maintainers are included in associated resctrl submissions.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dc82a6bd1a61..7b4f2b66a2ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22149,6 +22149,7 @@ F:	tools/testing/selftests/net/rds/
 RDT - RESOURCE ALLOCATION
 M:	Tony Luck <tony.luck@intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
+M:	x86@kernel.org
 R:	Dave Martin <Dave.Martin@arm.com>
 R:	James Morse <james.morse@arm.com>
 R:	Babu Moger <babu.moger@amd.com>
-- 
2.50.1

