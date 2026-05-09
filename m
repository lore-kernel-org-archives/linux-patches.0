Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D46382F25;
	Sat,  9 May 2026 20:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778358393; cv=none; b=BPfLS950SmbQS6Z++Th+vHSOkvUQ9uwra1CtedlGczUDgosiYWRLczLavNcH0BvqK8ajov436sm/PYA8MF3mkLQOSv271/QDt/rp/FRRP2rPrBQC8DFeLxlW1Ds9DprNskNa7ao9w9Kp2gysASvwE3y7xwPzkcyemlDDGRO4jw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778358393; c=relaxed/simple;
	bh=BCAhu6P+OEPmpiBGED/pZUCfpsEB5RTHKw4vOBGQqj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZHWpAOXB5FDJGvniEXwddbgPn34qNtc1IVbWxvME4FNRr+PR2FqlCaVxyFfNNO9iU6dFyzZ+YY0xwE8O+c/i5S+23lxoS4dcub4lfJ1oHNiQfnYjQ7+v3x7d2OrelgNAQFuZorFqhvTQhHP/YLXB/m8m55cBM5P12DMkO6sCg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PwJvuPyX; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PwJvuPyX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778358390; x=1809894390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BCAhu6P+OEPmpiBGED/pZUCfpsEB5RTHKw4vOBGQqj4=;
  b=PwJvuPyXW+FiGN3i6MAcwF/Qka+RAE/FyJdVt1Aejzs4/ukTS1dxLucg
   zlHSf8oc844tGOSaEI6509sTzkke7m177QCQigY1Tc4zcXQvNAkC2iRmf
   OGEt+VZphQs/x/HUs2MvSx9rC1MyPi6MEVVQYSB2nQ7BxmqOIK22CS1DN
   kf6UOyOAmZSW5Ho9/xIOD9WqF52lYD4jYICHk2j/H4hYEPjfyufNuoB5d
   QTSmibFGpoqG5vCjXfA80jmxaUilnoRsiqBsto0Hm3SxwHVTh3eboZPDo
   24o0SACoq8PkOt/K04mUhMq/v6u8TLz7LK5ADrUWJJlo+mJ2wHoJtthzR
   Q==;
X-CSE-ConnectionGUID: eJQeMUskQMim+kvwkxOKKA==
X-CSE-MsgGUID: Bc3L+/rdSUGE36xCxKUKsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11781"; a="79326784"
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="79326784"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 13:26:30 -0700
X-CSE-ConnectionGUID: Rh2BmJVMRGWIadO7A00tyQ==
X-CSE-MsgGUID: h8uZU722TM2Qq3pNCY5Z5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="242032511"
Received: from lkp-server01.sh.intel.com (HELO 82327192134e) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 09 May 2026 13:26:26 -0700
Received: from kbuild by 82327192134e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wLoFj-000000001OH-1blV;
	Sat, 09 May 2026 20:26:23 +0000
Date: Sun, 10 May 2026 04:25:45 +0800
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
Message-ID: <202605100458.mxl1D57O-lkp@intel.com>
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
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260510/202605100458.mxl1D57O-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260510/202605100458.mxl1D57O-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605100458.mxl1D57O-lkp@intel.com/

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
