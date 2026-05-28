Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F0027FD75
	for <patches@lists.linux.dev>; Thu, 28 May 2026 13:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779976645; cv=none; b=JAQ1XYXF8pz5DyVcoqI8tnx0mzUhnYBPNQnANO6xaT7Ksa8ry7MzyTQ5y8yVm0/08Pb75Aiv1iSEfN8fBwokabPmgbh4gJQgpKtljNoKnkB5xEghzLNUTHTavCJY0Eihpm6mBX4jcjPfbxMgYy66IdmMXyF/c1eQozbbK7y3MmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779976645; c=relaxed/simple;
	bh=mVHqo6VGXdQMVuWeSoAjUKxZmufIClnD09sxMSYcgqU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UGS8lCWfpjShBPNgrGYdSjNX4LMAFfWwAFYXPsG9kEhoHT3KDSPTyAAxupiYoqOz1tfo3YJnBTV8FX287p921oa04aQEAeiug2oZlOLYvJfJ8SjcQwAfr4U0s60h7WL4QozRdG/ujE45RHW0xkCIxuywxfw9NRRyTY7+SDFufoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S3XjnwTU; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S3XjnwTU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779976644; x=1811512644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mVHqo6VGXdQMVuWeSoAjUKxZmufIClnD09sxMSYcgqU=;
  b=S3XjnwTU3jY716xwcBPmfqB6iPAYekFHdNx+6Id0VunYpLL7IC3j4O++
   Cl7ZGifyJkhM+gW7jxybdasKmpt4RSiPPz2sA581ulidSqV2n2yWDKSCX
   NAIP8LfeYPllPkDRpgeTaYPwL1A+y3PkDq2/YUeeNSrmcHStxMot/jPzT
   4G1i21HTwQGaoTRRVGTXVbLbvX7mktwp4gqpYtI5p7YDe9y1wP0mKxbo6
   hXiNc2Djdy623MqLnq0yMXFY6/H0S/X98v5gmUNEUlcR/43SI0Geltxbw
   3gbn4JQ/h9zTAO1/K/orSbfHQTPXuOfIrnPcDIii7tW7Xdq9RYMXkHdWw
   w==;
X-CSE-ConnectionGUID: KIMiQ2jDRuS9rf4drOMOOQ==
X-CSE-MsgGUID: ccIyiKOtSRS6YSp5pMT3Bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80543108"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="80543108"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 06:57:23 -0700
X-CSE-ConnectionGUID: 19wc1tISQqKqBPmjiG6xDg==
X-CSE-MsgGUID: gItaf1w9T5W6NY8M3B6lHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="280668211"
Received: from chenyu-dev.sh.intel.com ([10.239.62.107])
  by orviesa001.jf.intel.com with ESMTP; 28 May 2026 06:57:19 -0700
From: Chen Yu <yu.c.chen@intel.com>
To: reinette.chatre@intel.com
Cc: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>
Subject: Re: [PATCH v3 3/9] fs/resctrl: Fix use-after-free during unmount
Date: Thu, 28 May 2026 21:48:10 +0800
Message-Id: <20260528134810.337000-1-yu.c.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <0a48bc36304da0fce4525672cca5f41c3d8ae678.1779476724.git.reinette.chatre@intel.com>
References: <0a48bc36304da0fce4525672cca5f41c3d8ae678.1779476724.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 22 May 2026 12:15:07 -0700, Reinette Chatre wrote:
> When the mutex is released, the reader wakes up, observes that RDT_DELETED
> is not set for the default group, and dereferences the already-freed
> file private data.

I wonder if a code call sequence could be added in the commit log,
which would be helpful to quickly understand the race condition:

CPU 0 (read mon_data file)          CPU 1 (umount)
--------------------------          --------------

rdtgroup_kn_lock_live()
  rdtgrp = &rdtgroup_default
  waitcount++
  break_active_protection()
                                    mutex_lock()
                                    mon_put_kn_priv()
                                      kfree(mon_data)
                                    mutex_unlock()
  mutex_lock()
  rdtgrp->flags & RDT_DELETED?
    // no -- never set for default
  return rdtgrp

md = of->kn->priv  // UAF: freed


I did not find issues in current implementation,

Reviewed-by: Chen Yu <yu.c.chen@intel.com>
