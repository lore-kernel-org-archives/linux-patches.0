Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FCE262A3
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 17:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731604823; cv=none; b=pP6E4GjNHqWMLcIK4ynimCxq1bEPv+cGaXXCT2b70/Jzxqf/bzVNPEtS5vjEfDq3x1Wpb5vKv4MGOdx1IjSU4+qtVdT9lGWkiAhvLGNMW0YTmy171YzJ58O7vhUStAiqZRyYi4hjxcKC4TzOT8+YQksrd86+0YsEGtFiAH1psBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731604823; c=relaxed/simple;
	bh=VqRxKvfwYM+lk3sS6fthdC2m4HT9EX34z0YML3BsgT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUmEBoWXyGXWIAOiJdzQ/QM8ypRgkwmBOO55vQluA5TfHJkuzzcpo5CRMOuIH890S5YM1WyP6PVLIDyDDjlpD0w9/gJHTWeCoz2/Dzh0YZqWM31G3WSZwfqcdIJYuIB9nsCs9vAnlRotgO1vuzHDTlZVNKZCYzMk5iHmrN9s6dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OoW6108+; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OoW6108+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731604822; x=1763140822;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VqRxKvfwYM+lk3sS6fthdC2m4HT9EX34z0YML3BsgT0=;
  b=OoW6108+cu6uTY48DYDnuYvlvJOvUosIZhdGKTkLQQhSHBNPXO2iQP+Y
   D7R9Q3lJn2cz31awHUKbipyZfzAC0oRIHeKaaGh1RoGBkBQiH4b6Gf+6N
   0rmqCc8jLYTfhsKOt0DooZ4ldN+aDvVF2ArVNaFrBD5Bt2/ZT00rzXA+P
   yGJ+FKxQdentv/UbkRxpM5PjZbYuzFZs9V7gBsyASgCZelzLl7cB41gfY
   /M3bho+TtUIOjy86kVkLfbFr7NlvpNebq33XRT5IRzO8h8vRMVdhFUcHU
   SFck8rWaDYc6+dIVA63LpyUC/tEFHZ+Xb5PFuIZKgWaoYbrS8e5O56mR0
   w==;
X-CSE-ConnectionGUID: 23PedMzfS0eOo4URhbrFag==
X-CSE-MsgGUID: nQhnWqSTTSC/Ls1/bf/WQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="31473881"
X-IronPort-AV: E=Sophos;i="6.12,154,1728975600"; 
   d="scan'208";a="31473881"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2024 09:20:21 -0800
X-CSE-ConnectionGUID: 0bFQ7wIlSq2k3eFPQHjKaQ==
X-CSE-MsgGUID: Y27T1/QMS/OrePR64tjsmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,154,1728975600"; 
   d="scan'208";a="87844306"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2024 09:20:21 -0800
Date: Thu, 14 Nov 2024 09:20:19 -0800
From: Tony Luck <tony.luck@intel.com>
To: Peter Newman <peternewman@google.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v8 3/7] x86/resctrl: Refactor mbm_update()
Message-ID: <ZzYxUwwEEIOGdmT6@agluck-desk3>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-4-tony.luck@intel.com>
 <f4845fee-3f91-4e78-a186-a7bdc58f7873@intel.com>
 <ZzUvA2XE01U25A38@agluck-desk3>
 <CALPaoCi94amaO4ALGhLPn=zWEJ3STJWyYid4L+kMjXYf9wKqAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALPaoCi94amaO4ALGhLPn=zWEJ3STJWyYid4L+kMjXYf9wKqAQ@mail.gmail.com>

On Thu, Nov 14, 2024 at 11:31:25AM +0100, Peter Newman wrote:
> At least for the purposes of reporting the mbps rate to userspace, my
> users will record from the files one per second, so it would be fine
> to just report Unavailable (or Unassigned when it's clear that the
> error is because counter wasn't unassigned) whenever either the
> current or previous reading was not successful. Then they can assume
> the value or error reported always refers to the most
> recently-completed one-second window.

First hack at keeping status for memory bandwidth values. Simple
state machine.  Compile tested.


diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 6345ab3e0890..80de5c6b0754 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -359,14 +359,22 @@ struct rftype {
 			 char *buf, size_t nbytes, loff_t off);
 };
 
+enum mbm_state_status {
+	MBM_INVALID,
+	MBM_ONE_VALUE,
+	MBM_VALID
+};
+
 /**
  * struct mbm_state - status for each MBM counter in each domain
  * @prev_bw_bytes: Previous bytes value read for bandwidth calculation
  * @prev_bw:	The most recent bandwidth in MBps
+ * @status:	Validity of @prev_bw
  */
 struct mbm_state {
-	u64	prev_bw_bytes;
-	u32	prev_bw;
+	u64			prev_bw_bytes;
+	u32			prev_bw;
+	enum mbm_state_status	status;
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index da4ae21350c8..767a526af2f5 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -670,6 +670,17 @@ static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	if (WARN_ON_ONCE(!m))
 		return;
 
+	if (rr->err || !rr->val) {
+		m->status = MBM_INVALID;
+		return;
+	}
+
+	if (m->status == MBM_INVALID) {
+		m->status = MBM_ONE_VALUE;
+		m->prev_bw_bytes = rr->val;
+		return;
+	}
+
 	cur_bytes = rr->val;
 	bytes = cur_bytes - m->prev_bw_bytes;
 	m->prev_bw_bytes = cur_bytes;
@@ -677,6 +688,7 @@ static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	cur_bw = bytes / SZ_1M;
 
 	m->prev_bw = cur_bw;
+	m->status = MBM_VALID;
 }
 
 /*
@@ -781,6 +793,9 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	if (WARN_ON_ONCE(!pmbm_data))
 		return;
 
+	if (pmbm_data->status != MBM_VALID)
+		return;
+
 	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
 	if (!dom_mba) {
 		pr_warn_once("Failure to get domain for MBA update\n");
@@ -801,6 +816,9 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 		cmbm_data = get_mbm_state(dom_mbm, entry->closid, entry->mon.rmid, evt_id);
 		if (WARN_ON_ONCE(!cmbm_data))
 			return;
+		if (cmbm_data->status != MBM_VALID)
+			return;
+
 		cur_bw += cmbm_data->prev_bw;
 	}
 
