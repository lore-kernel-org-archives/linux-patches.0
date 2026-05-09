Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E67D2F8EB0;
	Sat,  9 May 2026 17:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778347356; cv=none; b=g61nvDPccUKVsjfI6Bugk8DaZWZuBj/MAJu+qpunGj7/rJ54hHVMNSD8KhzGgm0OFYNEnHlpiS/SjL5v7y0/AuDvijU6M79Sug4y4gdNwndJ4XUBY9WuYeKtSmCWHrWwNY72AgQZvF4lvnzZugFPBcqgaIRvadr2NfpEy6A9qxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778347356; c=relaxed/simple;
	bh=O8vE+Mf0eCUKoyKy4rk1rc9O/9ajmr4o0MyjdcHFPZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PPx/2Owgtp8E7NidLjCs5v5ufzAMeeM3Qf2YxZOWIRo3sbAWJiiw9Jh9Ksm+oZ4FXVHPDGWZY3yFQUsj9Wcs8ixfl2U5173+WiQoXJ6U0JCMMCiHWbtgA7v2tSX6p10Z+tw5odXk0Iln6C6K6XwuBrRGr18dIIaCgtQhv2UpB0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cf1N01jM; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cf1N01jM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778347355; x=1809883355;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O8vE+Mf0eCUKoyKy4rk1rc9O/9ajmr4o0MyjdcHFPZE=;
  b=Cf1N01jM5IpU2ceAUS5iApiRJW6eyf6wkJejakR92E+6LNN666x0uDAr
   EmhN6ALstUVZ4awBcJF6upma/zIwAdBLgtC6P9CTOjtvtZc4VBfkmEnUq
   nmoDWjXxji9WI8JBHCPyxG4piaFas74KKloTqwDe10+4Wyt7+0x3hh4K3
   m1JhUjWXiKeBMzd8L22CODEClH9a3k5zC6FxNvPgnf/874AGTtPNwX2Pm
   NVGbvcBo2ErW/9go7rnlLprDz20J7zME5fjGDjUbEKAAa5/dnO2yXGRbw
   ZpMUotbignF8wCCs/L+MX38R8pfpAQzhft6LhvXlxR34UF4f3NMwaY8K9
   Q==;
X-CSE-ConnectionGUID: Gk9h/xfCQFWQzdGncWHpnQ==
X-CSE-MsgGUID: gvjr4Vx7Q1uhIWZBr4dF7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11781"; a="90678159"
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="90678159"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 10:22:34 -0700
X-CSE-ConnectionGUID: evjPL7/hQRmgEds3pQR6hQ==
X-CSE-MsgGUID: kPCy12N0RnaPTMFjYBl01A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="241038482"
Received: from igk-lkp-server01.igk.intel.com (HELO bdf09bfdbd5f) ([10.211.93.152])
  by orviesa003.jf.intel.com with ESMTP; 09 May 2026 10:22:31 -0700
Received: from kbuild by bdf09bfdbd5f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wLlNk-000000007Wb-1Hzd;
	Sat, 09 May 2026 17:22:28 +0000
Date: Sat, 9 May 2026 19:21:43 +0200
From: kernel test robot <lkp@intel.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree()
 failure
Message-ID: <202605091918.1k5t3HFX-lkp@intel.com>
References: <20260507201730.16509-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507201730.16509-1-tony.luck@intel.com>

Hi Tony,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v7.1-rc2]
[also build test WARNING on linus/master next-20260508]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tony-Luck/fs-resctrl-Free-mon_data-structures-on-rdt_get_tree-failure/20260509-184342
base:   v7.1-rc2
patch link:    https://lore.kernel.org/r/20260507201730.16509-1-tony.luck%40intel.com
patch subject: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260509/202605091918.1k5t3HFX-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260509/202605091918.1k5t3HFX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605091918.1k5t3HFX-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/resctrl/rdtgroup.c: In function 'rdt_get_tree':
   fs/resctrl/rdtgroup.c:2883:17: error: implicit declaration of function 'mon_put_kn_priv' [-Wimplicit-function-declaration]
    2883 |                 mon_put_kn_priv();
         |                 ^~~~~~~~~~~~~~~
   fs/resctrl/rdtgroup.c: At top level:
>> fs/resctrl/rdtgroup.c:3144:13: warning: conflicting types for 'mon_put_kn_priv'; have 'void(void)'
    3144 | static void mon_put_kn_priv(void)
         |             ^~~~~~~~~~~~~~~
   fs/resctrl/rdtgroup.c:3144:13: error: static declaration of 'mon_put_kn_priv' follows non-static declaration
   fs/resctrl/rdtgroup.c:2883:17: note: previous implicit declaration of 'mon_put_kn_priv' with type 'void(void)'
    2883 |                 mon_put_kn_priv();
         |                 ^~~~~~~~~~~~~~~


vim +3144 fs/resctrl/rdtgroup.c

7168ae330e8105 James Morse 2025-05-15  3138  
7168ae330e8105 James Morse 2025-05-15  3139  /**
7168ae330e8105 James Morse 2025-05-15  3140   * mon_put_kn_priv() - Free all allocated mon_data structures.
7168ae330e8105 James Morse 2025-05-15  3141   *
7168ae330e8105 James Morse 2025-05-15  3142   * Called when resctrl file system is unmounted.
7168ae330e8105 James Morse 2025-05-15  3143   */
7168ae330e8105 James Morse 2025-05-15 @3144  static void mon_put_kn_priv(void)
7168ae330e8105 James Morse 2025-05-15  3145  {
7168ae330e8105 James Morse 2025-05-15  3146  	struct mon_data *priv, *tmp;
7168ae330e8105 James Morse 2025-05-15  3147  
7168ae330e8105 James Morse 2025-05-15  3148  	lockdep_assert_held(&rdtgroup_mutex);
7168ae330e8105 James Morse 2025-05-15  3149  
7168ae330e8105 James Morse 2025-05-15  3150  	list_for_each_entry_safe(priv, tmp, &mon_data_kn_priv_list, list) {
7168ae330e8105 James Morse 2025-05-15  3151  		list_del(&priv->list);
7168ae330e8105 James Morse 2025-05-15  3152  		kfree(priv);
7168ae330e8105 James Morse 2025-05-15  3153  	}
7168ae330e8105 James Morse 2025-05-15  3154  }
7168ae330e8105 James Morse 2025-05-15  3155  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
