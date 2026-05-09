Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ADC2F5498;
	Sat,  9 May 2026 18:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778352877; cv=none; b=t1704kxeL/FS1496eMHq7RxzSW6+7lxD8ZkII6Cms1rv/h0+ypfXXphP89NGaKZPqe3V7wvo2iHaWW8QUN2VNXjc6CUJ4i7EzzRRf1QZHvzhWmHAFYzWqOJUbrmWdclgch1PLuyff10BIs8gthB30nvg1RqeNemnwoS4vf5tM0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778352877; c=relaxed/simple;
	bh=wB0QzVmRY3bN/ymPNzDcZmDQEKqGAJZ7FLMYjPm6+U4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYMiPGjiTTB6Gq7QsWnHzdWB+7L71tWqQmnKYmEf8PUtXALoz/0/t4vsPwfHkXI6dLJ1NzLU7bDdntT7IEW5KE/ZPFtzlRFBOo36M0rX959nTRgbvTxGdMi9mBvpCNt+97ii6loMOh9C/V77q9ycJ7qnTj2XUG8NGvOgnl5zlz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FQpJ2lFJ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FQpJ2lFJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778352876; x=1809888876;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wB0QzVmRY3bN/ymPNzDcZmDQEKqGAJZ7FLMYjPm6+U4=;
  b=FQpJ2lFJK3qofLBfSTdofO6GMdQEvp91fIuuEhvas54CA9D2ydWRml1V
   SsbZyekOWR+uapDiU2acS914URpehm36xrvqn/UayhHUGOdHuq8mUVXPX
   sJAjk9aanDhw303sMCayn+G1zzJNO0bt+EaNUp0naIutn26OMPvIzitji
   n1mBC3zzSU9/ZdLboYLWplnTpWVStb1e6OF1GODyZmyrxi6/aNjqdO41x
   GrRrJiSrsRtlw5gB40+f8WuT/qUVTNTar48BU6SoEtwbyB90LZfDZMGYr
   lx9TQWBvFwQDKA8M9EX0pLSnbQb1vinsqGsPAKv+mmP/PJTZ8WG5a46WG
   Q==;
X-CSE-ConnectionGUID: p1TXB9E1T4OAlWTazZfc0g==
X-CSE-MsgGUID: fNc5UEC+RNOCj47RG+zaFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11781"; a="82916377"
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="82916377"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 11:54:35 -0700
X-CSE-ConnectionGUID: kufbSBxxSuCnNvqOiSnoug==
X-CSE-MsgGUID: Tzs8YUCBS0a+1OmzLJXPTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="236086303"
Received: from igk-lkp-server01.igk.intel.com (HELO bdf09bfdbd5f) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 09 May 2026 11:54:32 -0700
Received: from kbuild by bdf09bfdbd5f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wLmom-000000007X7-3PsA;
	Sat, 09 May 2026 18:54:28 +0000
Date: Sat, 9 May 2026 20:53:45 +0200
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
Message-ID: <202605092051.BqXDw4a6-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on v7.1-rc2]
[also build test ERROR on linus/master next-20260508]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tony-Luck/fs-resctrl-Free-mon_data-structures-on-rdt_get_tree-failure/20260509-184342
base:   v7.1-rc2
patch link:    https://lore.kernel.org/r/20260507201730.16509-1-tony.luck%40intel.com
patch subject: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260509/202605092051.BqXDw4a6-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260509/202605092051.BqXDw4a6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605092051.BqXDw4a6-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/resctrl/rdtgroup.c: In function 'rdt_get_tree':
>> fs/resctrl/rdtgroup.c:2883:17: error: implicit declaration of function 'mon_put_kn_priv' [-Wimplicit-function-declaration]
    2883 |                 mon_put_kn_priv();
         |                 ^~~~~~~~~~~~~~~
   fs/resctrl/rdtgroup.c: At top level:
   fs/resctrl/rdtgroup.c:3144:13: warning: conflicting types for 'mon_put_kn_priv'; have 'void(void)'
    3144 | static void mon_put_kn_priv(void)
         |             ^~~~~~~~~~~~~~~
>> fs/resctrl/rdtgroup.c:3144:13: error: static declaration of 'mon_put_kn_priv' follows non-static declaration
   fs/resctrl/rdtgroup.c:2883:17: note: previous implicit declaration of 'mon_put_kn_priv' with type 'void(void)'
    2883 |                 mon_put_kn_priv();
         |                 ^~~~~~~~~~~~~~~


vim +/mon_put_kn_priv +2883 fs/resctrl/rdtgroup.c

  2784	
  2785	static int rdt_get_tree(struct fs_context *fc)
  2786	{
  2787		struct rdt_fs_context *ctx = rdt_fc2context(fc);
  2788		unsigned long flags = RFTYPE_CTRL_BASE;
  2789		struct rdt_l3_mon_domain *dom;
  2790		struct rdt_resource *r;
  2791		int ret;
  2792	
  2793		DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
  2794	
  2795		cpus_read_lock();
  2796		mutex_lock(&rdtgroup_mutex);
  2797		/*
  2798		 * resctrl file system can only be mounted once.
  2799		 */
  2800		if (resctrl_mounted) {
  2801			ret = -EBUSY;
  2802			goto out;
  2803		}
  2804	
  2805		ret = setup_rmid_lru_list();
  2806		if (ret)
  2807			goto out;
  2808	
  2809		ret = rdtgroup_setup_root(ctx);
  2810		if (ret)
  2811			goto out;
  2812	
  2813		ret = rdt_enable_ctx(ctx);
  2814		if (ret)
  2815			goto out_root;
  2816	
  2817		ret = schemata_list_create();
  2818		if (ret)
  2819			goto out_schemata_free;
  2820	
  2821		ret = closid_init();
  2822		if (ret)
  2823			goto out_schemata_free;
  2824	
  2825		if (resctrl_arch_mon_capable())
  2826			flags |= RFTYPE_MON;
  2827	
  2828		ret = rdtgroup_add_files(rdtgroup_default.kn, flags);
  2829		if (ret)
  2830			goto out_closid_exit;
  2831	
  2832		kernfs_activate(rdtgroup_default.kn);
  2833	
  2834		ret = rdtgroup_create_info_dir(rdtgroup_default.kn);
  2835		if (ret < 0)
  2836			goto out_closid_exit;
  2837	
  2838		if (resctrl_arch_mon_capable()) {
  2839			ret = mongroup_create_dir(rdtgroup_default.kn,
  2840						  &rdtgroup_default, "mon_groups",
  2841						  &kn_mongrp);
  2842			if (ret < 0)
  2843				goto out_info;
  2844	
  2845			rdtgroup_assign_cntrs(&rdtgroup_default);
  2846	
  2847			ret = mkdir_mondata_all(rdtgroup_default.kn,
  2848						&rdtgroup_default, &kn_mondata);
  2849			if (ret < 0)
  2850				goto out_mongrp;
  2851			rdtgroup_default.mon.mon_data_kn = kn_mondata;
  2852		}
  2853	
  2854		ret = rdt_pseudo_lock_init();
  2855		if (ret)
  2856			goto out_mondata;
  2857	
  2858		ret = kernfs_get_tree(fc);
  2859		if (ret < 0)
  2860			goto out_psl;
  2861	
  2862		if (resctrl_arch_alloc_capable())
  2863			resctrl_arch_enable_alloc();
  2864		if (resctrl_arch_mon_capable())
  2865			resctrl_arch_enable_mon();
  2866	
  2867		if (resctrl_arch_alloc_capable() || resctrl_arch_mon_capable())
  2868			resctrl_mounted = true;
  2869	
  2870		if (resctrl_is_mbm_enabled()) {
  2871			r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
  2872			list_for_each_entry(dom, &r->mon_domains, hdr.list)
  2873				mbm_setup_overflow_handler(dom, MBM_OVERFLOW_INTERVAL,
  2874							   RESCTRL_PICK_ANY_CPU);
  2875		}
  2876	
  2877		goto out;
  2878	
  2879	out_psl:
  2880		rdt_pseudo_lock_release();
  2881	out_mondata:
  2882		if (resctrl_arch_mon_capable()) {
> 2883			mon_put_kn_priv();
  2884			kernfs_remove(kn_mondata);
  2885		}
  2886	out_mongrp:
  2887		if (resctrl_arch_mon_capable()) {
  2888			rdtgroup_unassign_cntrs(&rdtgroup_default);
  2889			kernfs_remove(kn_mongrp);
  2890		}
  2891	out_info:
  2892		kernfs_remove(kn_info);
  2893	out_closid_exit:
  2894		closid_exit();
  2895	out_schemata_free:
  2896		schemata_list_destroy();
  2897		rdt_disable_ctx();
  2898	out_root:
  2899		rdtgroup_destroy_root();
  2900	out:
  2901		rdt_last_cmd_clear();
  2902		mutex_unlock(&rdtgroup_mutex);
  2903		cpus_read_unlock();
  2904		return ret;
  2905	}
  2906	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
