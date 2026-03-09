Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FD536214F
	for <patches@lists.linux.dev>; Mon,  9 Mar 2026 07:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773042252; cv=none; b=p8pY5HBkjH8QrQJON8rnvsKve8PENNkNFcZSSS9v33xmMLCFZGYOWAvoscVgIgbXfMSbw+KQEdllt8l1MPUWknhZVJXd5T5FA7cCXCG333DJHlJ/pyb12UWXqpJmtLkihCx3md2WYR0vvWMD1Sd1ui8dukGe+yFnzJ10q8fGu6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773042252; c=relaxed/simple;
	bh=xEq5fMK1YcgssmgKjI/pyHgBuMfD52qn66u/M7TR8gc=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=s/M3pUVx5tWDXqaCBqTWa/9ovU6PrWeiFd19nLj1Q1FgdMGnqLl6JwaO4Jgr8YiPaRrWuB2TggaE0OJqAIpIri9RuXxBfTUwbsgnIPuGwvvhYwGYPAcdZrKvCMiCSbvlDKK0FtqGBiLp+Ze/34VMfNjLbLCgYT5AVeRlL1jV3Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LnWwBQga; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LnWwBQga"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773042251; x=1804578251;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=xEq5fMK1YcgssmgKjI/pyHgBuMfD52qn66u/M7TR8gc=;
  b=LnWwBQgaoSljf91XtA2xDa+so0n0sJKuqC8KDeS5Tr/5XSJA6BGP8wop
   iEPmKDNgRdc+3iAXuTF0bK1OESUSaHJ1Ry/x9slms7FDkUCFdNqIXadYI
   ftXOZCMNESNH33GnnZM6c9eSK9JxMXxOJAoUEO4+rM8bPqAuIsxE/j/UW
   RUio7pkNvJ+owg3pyNxE85JA3H+7LCDvlZNP+KWA12PzuAxFUuwKO4kUu
   pw+r/sOPWpTWbjxNiw9SlqAj2l8veTpNcKxfVtnuJIzzkogkjmPVJyVLi
   iouziUji8CoCuAUQGENt7/DSSc8D8Zf07CN6qu9Q3WU3HAq6yUqIObjz3
   w==;
X-CSE-ConnectionGUID: CYTs9DV6QbKjDmA0plo9NQ==
X-CSE-MsgGUID: fdSm7X9hQxuAo9riAOmCrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="85147846"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="85147846"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 00:44:11 -0700
X-CSE-ConnectionGUID: LaeKcQtBQESpLF7TMlfeXQ==
X-CSE-MsgGUID: TYNkG1tIRPezcQMwbt477Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="223775705"
Received: from dalessan-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.153])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 00:44:05 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 9 Mar 2026 09:44:01 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, linux-kselftest@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 1/9] selftests/resctrl: Improve accuracy of cache
 occupancy test
In-Reply-To: <322603c3-24ef-4cd7-bbb5-8d5257256e24@intel.com>
Message-ID: <4de9a318-25f3-3a33-50dc-8d8b85930652@linux.intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com> <a43f404b9fdcf01d8c8cd825c17f39f95083c813.1772582958.git.reinette.chatre@intel.com> <db270056-a2b5-e5f0-1ed4-e652d67e90fe@linux.intel.com> <322603c3-24ef-4cd7-bbb5-8d5257256e24@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1312389537-1773042241=:971"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1312389537-1773042241=:971
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 6 Mar 2026, Reinette Chatre wrote:
> On 3/6/26 1:47 AM, Ilpo J=C3=A4rvinen wrote:
> > On Tue, 3 Mar 2026, Reinette Chatre wrote:
> >=20
> >> Dave Martin reported inconsistent CMT test failures. In one experiment
> >> the first run of the CMT test failed because of too large (24%) differ=
ence
> >> between measured and achievable cache occupancy while the second run p=
assed
> >> with an acceptable 4% difference.
> >>
> >> The CMT test is susceptible to interference from the rest of the syste=
m.
> >> This can be demonstrated with a utility like stress-ng by running the =
CMT
> >> test while introducing cache misses using:
> >>
> >>    stress-ng --matrix-3d 0 --matrix-3d-zyx
> >>
> >> Below shows an example of the CMT test failing because of a significan=
t
> >> difference between measured and achievable cache occupancy when run wi=
th
> >> interference:
> >>     # Starting CMT test ...
> >>     # Mounting resctrl to "/sys/fs/resctrl"
> >>     # Cache size :56623104
> >>     # Writing benchmark parameters to resctrl FS
> >>     # Benchmark PID: 3275
> >>     # Checking for pass/fail
> >>     # Fail: Check cache miss rate within 15%
> >>     # Percent diff=3D97
> >>     # Number of bits: 5
> >>     # Average LLC val: 501350
> >>     # Cache span (bytes): 23592960
> >>     not ok 1 CMT: test
> >>
> >> The CMT test creates a new control group that is also capable of monit=
oring
> >> and assigns the workload to it. The workload allocates a buffer that b=
y
> >> default fills a portion of the L3 and keeps reading from the buffer,
> >> measuring the L3 occupancy at intervals. The test passes if the worklo=
ad's
> >> L3 occupancy is within 15% of the buffer size.
> >>
> >> By not adjusting any capacity bitmasks the workload shares the cache w=
ith
> >> the rest of the system. Any other task that may be running could evict
> >> the workload's data from the cache causing it to have low cache occupa=
ncy.
> >>
> >> Reduce interference from the rest of the system by ensuring that the
> >> workload's control group uses the capacity bitmask found in the user
> >> parameters for L3 and that the rest of the system can only allocate in=
to
> >> the inverse of the workload's L3 cache portion. Other tasks can thus n=
o
> >> longer evict the workload's data from L3.
> >>
> >> Take the L2 cache into account to further improve test accuracy.
> >> By default the buffer size is the same as the L3 portion that the work=
load
> >> can allocate into. This buffer size does not take into account that so=
me
> >> of the workload's data may land in L2/L1. Address this in two ways:
> >>  - Reduce the amount of L2 cache the workload can allocate into to the
> >=20
> > "into to the" sounds wrong.
>=20
> How about:
>   "Reduce the workload's L2 cache allocation to the minimum on systems th=
at
>    support L2 cache allocation."

Works for me.

--=20
 i.

--8323328-1312389537-1773042241=:971--
