Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792447689;
	b=pmGoIu9i/raKUE/6L6ZQVg3MWZ0Ko1o17SoKik9ZYryJC2wzjRPGPFSQKUf4STgA797E
	 ulQoF5Wg0xW1W7JFZd7A6Uq3mw2pswFu18BwO664yLr5gSIwEfaAq0X8MJSpZLo45YgUB
	 lI2E+qzkDZGIcxdxfRe2fLiYF9LvYRVK84EJTBPpia1TX9kgY1+g0IuPGgJG4QWQoK+nA
	 AS84cciMvP2kM+qw5uXN/5aEdQgqpVYshA9N5Em0mP1UNJ/MK5PzlPCSba41R6bkUNCXo
	 iROzACJZBx9npddZXRifQwMQWzzB8C1Oms9QmSHfkAHnzDz9n6+byF5aBg1ORf7zvZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792447689;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7KRFoez2MHK6RdePaMAxh33RzW/2GI6fZB4kUeE4dvY=;
	b=0JOs4us651V8iOXEO+KWaV1y0xWyTBefWjBgJonMQo4xn+GbKpLEbIHpu5LQ1Q7g5ddw
	 SYFhtwzX/mLGBQGZiii/wiVhQ+hWpAO5cj0/4i+zFfrGxRU46qAlZx6HtibhdqlIgMOc7
	 9Se31HikPVjlXvmXOMuuWCdSc608A+HHQIhkpMhq5xueVexQMRha4NuAeN6aHPvYOe1qe
	 53NmoFCKz4bXZbizdL/HpBK0/GQgX03iFaKhzlkCGF0ovVWC88qrNk9d7NAFLqkCbvMPM
	 HOc3yrcLbpnlxcvPRLQ+ej93T1Awrn+sJk+jfKsIHPVIjSH0Ry8ScdrF3mhNswUrJ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B0F60A260D
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 22:08:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52B0F60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792447683; x=1823983683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KSmmFCGJg8FWLkt7bylQR8X3wY+9QEqWerUrD4M3uL4=;
  b=iUvNmK0FJdPKCym43KJ1Io29Be1248h2hAjP4m+RwPCVJZidCKcfLqF2
   zLAw6VQQQLFzd1HIgzJPEj3mdFAqEg6/1Paiww/wQpawNMvw1aO0pjo/W
   1fLsK7aObGNamPbr71aBJlJcq7fBPy62Cg4Pdvz3/9r/h6SH32GP5Eaui
   UtaNv8vfcslLsMorPukY4ULAW592fuw9+D1HfGQ+RKNbCOJIvgHlwlD/j
   yRuCfrwoI2mVriviACCDrWDfoilRkjoNd5OO2blrvsK5C0vd6axFnbDLh
   E2n+juw8kv/EmoW4ul0QMnGYxQLCW0ngPaUzJtsdvUsyHBigQ+EJeSRT/
   Q==;
X-CSE-ConnectionGUID: 04vbJlBUTg6boCT9WnsDuQ==
X-CSE-MsgGUID: aOe3VYuxRxuSYkpOyDyuZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1144226"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1144226"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:08:00 -0700
X-CSE-ConnectionGUID: u8smdNEJRP+wDnO1uhFLgQ==
X-CSE-MsgGUID: AAzRo9G0TPq8G3hxomZ2sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2708349"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:59 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH v2 08/10] arm_mpam: resctrl: Require a component for each monitoring event
Date: Mon, 19 Oct 2026 15:07:42 -0700
Message-ID: <3384e5bedb29e3a0bd7fa383939db8ca70c4a733.1792443633.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1792443633.git.reinette.chatre@intel.com>
References: <cover.1792443633.git.reinette.chatre@intel.com>
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

Setting up a monitoring domain looks up, for each monitoring event, the
component of the event's class that contains the CPU and records it in
the domain. Reading and resetting the event's counters in the domain
then use the recorded component.

If an event's class has no component for the CPU, the domain is still
set up as long as another event's class has one, and the event is left
without a component. Reading or resetting the event's counters in that
domain then dereferences a NULL component. This is not expected to
happen since only classes that cover all possible CPUs are picked for
monitoring.

Fail setting up the monitoring domain, with a warning, if an event's
class has no component for the CPU, so that every event of a monitoring
domain has a component.

Keep the check that at least one component was found. It now only fails
if no event has a class, and so captures that a resource that supports
monitoring has at least one monitoring event with a class.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/resctrl/mpam_resctrl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 63c5bf45856d..36a924734484 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1661,9 +1661,11 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
 			continue;       // dummy resource
 
 		mon_comp = find_component(mon->class, cpu);
+		if (WARN_ON_ONCE(!mon_comp))
+			return -EFAULT;
+
 		dom->mon_comp[eventid] = mon_comp;
-		if (mon_comp)
-			any_mon_comp = mon_comp;
+		any_mon_comp = mon_comp;
 	}
 	if (WARN_ON_ONCE(!any_mon_comp))
 		return -EFAULT;
-- 
2.55.0

