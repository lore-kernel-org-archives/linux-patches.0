Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCCB18C92F;
	Wed,  4 Dec 2024 11:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733310126; cv=none; b=r/zKOxRgXZXl60OV1DCXZSsSxDtzaauryLgUV+w9dSLtj68YubtA89fyW4/MOuEvYJPN9049RUfyzpTcMJaOKD7W19EDEZQqKz+E98TEPUqc9RgjBIKn+cWhm8++8wHPd4aRE6WTQdevid4KImu8kdpdYbeyU+6y0SzcKCuG6ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733310126; c=relaxed/simple;
	bh=RiCweuB8rkuhzPPyg5St6zFsmso3G0CQ0fGJY7lokf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGOItFZ8j3msQP6BZrvETdE8g18ER1CYQW773wK54foGDqbw/HtBH7OcDjp5wSpjornirN87wHVmTI+CknrHveMBEYyug4/ot5GDFhRPMwqFVzsxtNynUUmnr0NvcVxssZ2tVgk7sD8FttOZO3vpVjeGyazQQgR66FynR9p8A1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EPto0+Fj; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EPto0+Fj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733310124; x=1764846124;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RiCweuB8rkuhzPPyg5St6zFsmso3G0CQ0fGJY7lokf8=;
  b=EPto0+Fj4LTdxXsDeRUnB2CoSZZrrFqlQoch2qrzCG5p5R0NmFxvE8qt
   d7s0Ov31iKoM+S5uYhNJ9IA545E4v2nJjoZG55zBCtYY236KsaU3B0aH8
   dhCXwsjF4jljhwbXC5ns9rNArEs9r7nEBm5lJF66zfNxPA6fbC/dmNGol
   P+7rLN5C7Z0ybVBWINyKagKzk1zR0ZMs7a/Y/STEjS22VA9FqOrWqZbjA
   E8EmOuVmKBYKB8po1ibbWtf6MiPY2lAVq5uzuv7V01xW6MXVwudAErFaf
   aZYh4qRDqonM0Z2/Oxc80g6nkeg/C4+YElsER7N0vGIcZrO47A0DyViJY
   w==;
X-CSE-ConnectionGUID: 4sTdGdy+R8Wv2yOaqSgnSA==
X-CSE-MsgGUID: QPhk3djrQRSUuvJJgZBTgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="51102121"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="51102121"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 03:02:04 -0800
X-CSE-ConnectionGUID: WT/cDZSmTn6v81Zc4iWBog==
X-CSE-MsgGUID: gyJESw+5Rmai01xO4XTjXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93594678"
Received: from lkp-server02.sh.intel.com (HELO 1f5a171d57e2) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 04 Dec 2024 03:02:02 -0800
Received: from kbuild by 1f5a171d57e2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tIn8H-0002uP-0g;
	Wed, 04 Dec 2024 11:01:31 +0000
Date: Wed, 4 Dec 2024 19:00:44 +0800
From: kernel test robot <lkp@intel.com>
To: Stephen Boyd <swboyd@chromium.org>, Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, devicetree@vger.kernel.org
Subject: Re: [PATCH] of: Hide of_default_bus_match_table[]
Message-ID: <202412041839.pjv6awcS-lkp@intel.com>
References: <20241204000415.2404264-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204000415.2404264-1-swboyd@chromium.org>

Hi Stephen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 40384c840ea1944d7c5a392e8975ed088ecf0b37]

url:    https://github.com/intel-lab-lkp/linux/commits/Stephen-Boyd/of-Hide-of_default_bus_match_table/20241204-123701
base:   40384c840ea1944d7c5a392e8975ed088ecf0b37
patch link:    https://lore.kernel.org/r/20241204000415.2404264-1-swboyd%40chromium.org
patch subject: [PATCH] of: Hide of_default_bus_match_table[]
config: sparc-allnoconfig (https://download.01.org/0day-ci/archive/20241204/202412041839.pjv6awcS-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241204/202412041839.pjv6awcS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412041839.pjv6awcS-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/of/platform.c:27:34: warning: 'of_default_bus_match_table' defined but not used [-Wunused-const-variable=]
      27 | static const struct of_device_id of_default_bus_match_table[] = {
         |                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/of_default_bus_match_table +27 drivers/of/platform.c

    26	
  > 27	static const struct of_device_id of_default_bus_match_table[] = {
    28		{ .compatible = "simple-bus", },
    29		{ .compatible = "simple-mfd", },
    30		{ .compatible = "isa", },
    31	#ifdef CONFIG_ARM_AMBA
    32		{ .compatible = "arm,amba-bus", },
    33	#endif /* CONFIG_ARM_AMBA */
    34		{} /* Empty terminated list */
    35	};
    36	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
