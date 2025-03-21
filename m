Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041192327AE
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598985; cv=none; b=MzgUTYcqs7K297w54viGy3kCY1iAsZK9P434DIbYn257lk8cPjveKqc+WF8InPnm+iFTWwX31ottu/CanmzeyY9R2Aaqxx7aEA/BCReE70Xg3ZW7Q6dtmn1m4rkm3nfUWMVtmVNsm/BR1f4H28snoBYyv6wJO51fj8H11/Bl7EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598985; c=relaxed/simple;
	bh=bE1sllvr9lOs6GOzkJd2hz5aTdVvawCduXr1ml5IkQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqlJw8Fp4l1+gm1dpBYAZIDA7apf5mCfHi0mrpaSWO5NOWdJBAL+wYJGyVzkMWHScZpC8415gIkEgoAfuTFs1fGJdU9peAQO7Br21vFDlTIBptYT+EDQE+yyeKB2yRUXbWQCPTQxhfRI/OUKR44jiFYncBelbar826p60VMQWc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ts68x1jL; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ts68x1jL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598984; x=1774134984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bE1sllvr9lOs6GOzkJd2hz5aTdVvawCduXr1ml5IkQM=;
  b=Ts68x1jLS4lUIcTyGR5uahxD7Xl0JFAQn7pimeF8NTEedzosrlAqiQ4o
   pkU8NUVOHm8lhPsizEJkVFtxYIAtXF0UHs12pQvVvQ0RWPXorzPnip7Jl
   F++DDU8EWfKee8lgEIiLe4O1dQmxKz3sQXQLIlq0fi46vEWFjndMqiQKw
   XC7w9RdlRTJwjyT+IdNJthuq0dnJ2aakr5ae1iqwmh8eluta9usDz1aL1
   Qy5NlHTks7XMgA/FQbtVTKzU/jF9XuQK9i1DEEraekzJInH+2cQx66eX4
   +4HzLFM/IY6Uc45bGzxcfqbDMe6YdLmH32irc3HX2nBt5UA2L5DujQWfg
   w==;
X-CSE-ConnectionGUID: 4W9EYd3iRIS1sz+CKLeBcg==
X-CSE-MsgGUID: 6eu+3uU4RE+wuFasWjrlhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604582"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604582"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:21 -0700
X-CSE-ConnectionGUID: 6O3yoI/pSFGxYQgRWOUHcQ==
X-CSE-MsgGUID: yQPjjR9FR7O99WQORDqyVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354306"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 06/16] x86/resctrl: Prepare for resource specific event ids
Date: Fri, 21 Mar 2025 16:15:56 -0700
Message-ID: <20250321231609.57418-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250321231609.57418-1-tony.luck@intel.com>
References: <20250321231609.57418-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Event ids ought to be specific to each resource. Keep enum resctrl_event_id
for event ids in the RDT_RESOURCE_L3. But change the type in generic
areas to unsigned int so that new resources can have their own event
ids.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 3a100007301d..422f36573db7 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -69,13 +69,13 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
 
 /**
  * struct mon_evt - Entry in the event list of a resource
- * @evtid:		event id
+ * @evtid:		per resource event id
  * @name:		name of the event
  * @configurable:	true if the event is configurable
  * @list:		entry in &rdt_resource->evt_list
  */
 struct mon_evt {
-	enum resctrl_event_id	evtid;
+	unsigned int		evtid;
 	char			*name;
 	bool			configurable;
 	struct list_head	list;
@@ -84,7 +84,7 @@ struct mon_evt {
 /**
  * struct mon_data - Monitoring details for each event file.
  * @rid:             Resource id associated with the event file.
- * @evtid:           Event id associated with the event file.
+ * @evtid:           Per resource event id associated with the event file.
  * @sum:             Set when event must be summed across multiple
  *                   domains.
  * @domid:           When @sum is zero this is the domain to which
@@ -97,7 +97,7 @@ struct mon_evt {
  */
 struct mon_data {
 	unsigned int rid;
-	enum resctrl_event_id evtid;
+	unsigned int evtid;
 	unsigned int sum;
 	unsigned int domid;
 };
@@ -124,7 +124,7 @@ struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_mon_domain	*d;
-	enum resctrl_event_id	evtid;
+	unsigned int		evtid;
 	bool			first;
 	struct cacheinfo	*ci;
 	int			err;
-- 
2.48.1

