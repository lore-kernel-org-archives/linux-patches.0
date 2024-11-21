Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EDC18BB9A
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732209721; cv=none; b=qoKD3dm4XrZjkzA7FhE8Lk4o6K/MNajX9qmp50y7TCevnqWU8iWqJDERVf5ZU8qBYI4k0sgIbIP3Z/7JSchqDC2lJQHeexZWT9e+wAawB2buD/kIT2wro3/yl5zLD1BwpWwe/nsCLkXeFRKgFTAbJpRR2sd8EpdhlauxLKcgMAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732209721; c=relaxed/simple;
	bh=uZzvCXceCCMGBokvz6i2+tM5IXiCzvpjR3wsV/2zti0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCWfpaskVitpLkFRakXhtm9e7K0VFI+9ZAtF6hOwuRCxgFYn8Bnf/4oN4ydZdRZavPly26pz+ZIS8hfwBNBb0ebqr7fAtVlWexBhKCFB4UeGHXq+HuVfcMavEszsDwsiIWcks23rzwuarh8c22+3bEyo3rat1Ci1HQ+DDH/s45c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N5eNftqQ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N5eNftqQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732209719; x=1763745719;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uZzvCXceCCMGBokvz6i2+tM5IXiCzvpjR3wsV/2zti0=;
  b=N5eNftqQp2QIDK6kzjDZvfXl8nNjtZKKnB41gvXdmmIz+5yGCU1fyrJZ
   GRmijWhuF7VwIFsbTvdvJ+NHvOz3PABQrsZNclD01+4z236aosMfQWQXt
   hiCjyMR9brT1JFV+6c7GjvWdTLsRhQj1gTh+ZJ0Glsws2Na9zz9vOLxE3
   7dbK237uQv+m9tPjrJcoPuAWKTbanID4JJOTwGX3L583r0vuRxJicVdTt
   Wb0E9pweN6luC7zMdJrQ7nuJI9AmlttocNajpD9Jh72c0ek7hf4ACBuAU
   dH4CkEXTRwU8rppElpC0s0M52N53o/UsrXlPEO1Rr85bBZG3I4FmJi/u/
   w==;
X-CSE-ConnectionGUID: i/TSSqHzRyW7jTEgmhteeg==
X-CSE-MsgGUID: QGuTfYi3TruX0+yOSz4lfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="32580568"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="32580568"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:21:59 -0800
X-CSE-ConnectionGUID: XpRLyIZlQoqaQWkAYrTjjA==
X-CSE-MsgGUID: zPX9LWEsSpiCTXZsOPprLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="113597678"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:21:59 -0800
Date: Thu, 21 Nov 2024 09:21:58 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v9 1/9] x86/resctrl: Introduce resctrl_file_fflags_init()
 to initialize fflags
Message-ID: <Zz9sNkBj3Mpv2vO4@agluck-desk3>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-2-tony.luck@intel.com>
 <dd1d284f-2138-4e63-8bc5-2e55ff9f0a2d@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd1d284f-2138-4e63-8bc5-2e55ff9f0a2d@intel.com>

On Tue, Nov 19, 2024 at 04:38:15PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/13/24 4:17 PM, Tony Luck wrote:
> > From: Babu Moger <babu.moger@amd.com>
> > 
> > thread_throttle_mode_init() and mbm_config_rftype_init() both initialize
> > fflags for resctrl files.
> > 
> > Adding new files will involve adding another function to initialize
> > the fflags. This can be simplified by adding a new function
> > resctrl_file_fflags_init() and passing the file name and flags
> > to be initialized.
> > 
> > Consolidate fflags initialization into resctrl_file_fflags_init() and
> > remove thread_throttle_mode_init() and mbm_config_rftype_init().
> > 
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> Please place "Signed-off-by" tag before "Reviewed-by" tag. For reference,
> "Ordering of commit tags" in Documentation/process/maintainer-tip.rst

Hi Reinette,

I had misremembered what that Documentation file said. There is a
section that describes keeping the Signed-off-by: tags in the order
they were applied so that the commit comment describes the path that
the patch took before final acceptance. I thought that ordering applied
to other tags.

But while I was there refreshing my memory I also noted the section
about documenting changes made when adopting patches from other
people. So I've added:

[Tony: Drop __init attribute so resctrl_file_fflags_init() can be used
at run time]
> 
> Reinette

-Tony
