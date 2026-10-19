Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792447684;
	b=PYiIoS11CRvszMZInarTgVe53QOY5cCN2W8q1WVikxPajkKdBEMZTkGcXmQ5TUj/w1xN
	 1ja+qWjrF0Rxg29uYqEwYMXfHVRP5A9GLGg2daUu/fkOj+g+vB/C9n5IRi7GYl3BuMMmy
	 hycf4LUhfdtod43aCI8RA7+lKjgUnfAMDMFiFq0m4eNyZgHoewxbvVS4gy2Taoy5C5bcf
	 Rq6wlJxiuo9DwtO/2sl9Kw3SC/ga05SdTe5JPV9tN9JdnrL+lYqoZ1FyeywtLyQSfapR/
	 wRd087kMixGssX8lJfzLlWsXT2X58RqUeWX7IKEV/lnO7EWplJkm7q8Y00qmoxRIRnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792447684;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/FPJ2/D1pxAq4Poeoujsv1hkt1afRQIoxiL4Q5tPTKs=;
	b=xMxtsNztiKkHlLJVJOCcc1XxDilHFT1Ac1YvqZ+TLt7T8GSHe/xtrZdzvJ3Jx+5ucWKn
	 iTHxbcg0OE1esOxCgmTa8i1YxFCjpE2aF295u+3j3mXW34dq63N5HKDbsCQQbS7GT0q4k
	 z8GN2DXjyQ0Wjx/TzcFmgrHhvJnP+mcyBYZTL9tQN9vVhciWVYjbtW1nB3OijZXkbqG7T
	 PqCrOB5ETL/vGMbSvvQ1gYeYko33iGP74bxkFcRxSZLLsG0QIaQUb2nBuIlGgvyukM5sm
	 KgSstMZsBE0ILDln6X/iGEX/cwfFM4w/mENyIsLltviV06fmJ5j17BEgoutXymgFfMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5286260A260C
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 22:08:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5286260A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792447683; x=1823983683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KvuwGj3mCzkgntkJ/PO10vy/kUzqNCehZSltuxALbMQ=;
  b=H/YvZVWV17iSyb6zjO+qcbrq+er3PQYvNVDNwnpegiYQXiBfLf/Uh4yE
   vY9+4tKyEkx/bI4mzhXTqQq1a/ey4eSXPf0cE11EmAfGPq131CZem+mIq
   buNlNmmaPDxGkByJsxpYIWnV4doMGPKUBH9O72aGKof+kI36V/zpNf6pS
   DnfruFPJCdWHmRnHJ9RaLhPFJ/iP4MGhPSLbfw7inBV4jah4ssVFb+IyM
   7xlNgrbhKFhG6QU9N9Pfi0skj2AwelhWkIEx4DcbUPSnZ/VNUq1zX7oVu
   ls09KVHtaMllYjqU+hEFNiw9/gC7RpRO7ddmkQNbgSwNPhM17R5RwGLiW
   A==;
X-CSE-ConnectionGUID: k/M+qwkfTpOuJIShovZbiA==
X-CSE-MsgGUID: V0ndVCR0TEezHVpnH78j4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1144233"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1144233"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:08:00 -0700
X-CSE-ConnectionGUID: 2HgFPwesQ3mnqgPk7B8PGg==
X-CSE-MsgGUID: 0pmN44VhS1WMVZx5J3l3qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2708352"
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
Subject: [RFC PATCH v2 09/10] arm_mpam: resctrl: Require monitoring components to cover the same CPUs
Date: Mon, 19 Oct 2026 15:07:43 -0700
Message-ID: <a5509d45ef186a273dfc07fdcaae82998a5a4ce6.1792443633.git.reinette.chatre@intel.com>
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

A monitoring domain records the component that backs each of its
monitoring events and takes its ID from one of these components. The
domain represents the CPUs of one L3 cache, while each event's counters
are read from the event's own component.

If the components of a monitoring domain covered different CPUs, the
counts of an event would not belong to the CPUs that the domain
represents. This is not expected to happen: every class picked for
monitoring covers all CPUs and has components that correspond to the
L3 caches.

Fail setting up the monitoring domain, with a warning, if the components
backing its events do not all cover the same CPUs. Compare each
component with the one found before it, instead of naming the events,
so that the check applies to any monitoring event.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/resctrl/mpam_resctrl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 36a924734484..c3ea61a40bb2 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1664,6 +1664,12 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
 		if (WARN_ON_ONCE(!mon_comp))
 			return -EFAULT;
 
+		/* All components of a monitoring domain cover the same CPUs */
+		if (WARN_ON_ONCE(any_mon_comp &&
+				 !cpumask_equal(&any_mon_comp->affinity,
+						&mon_comp->affinity)))
+			return -EFAULT;
+
 		dom->mon_comp[eventid] = mon_comp;
 		any_mon_comp = mon_comp;
 	}
-- 
2.55.0

