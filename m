Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5411922D8;
	Wed,  6 Nov 2024 08:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882603; cv=none; b=oIYlraElaSjfimk7uB4cbRWXpig5H1Rcch0Nuh1w0ozlc35RfX60KDGF+XCBkpc2CLcxt4REC/WO21iAJoXCYpzObF/TPyxgtC4O1J8C52RQqOUJuuzF/x5+khfA+miiCRnEUKwIp3hrwfVy9M1s8868dDehOHZAMLFZlHgWB8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882603; c=relaxed/simple;
	bh=2FaB9DZ+5bt0vHcem3FiA70mddNIj2sFcK506ZwMn/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5zlgTat+QL6S18EoUJBpbicTfyJV67uiJnUrl2YufZFFmt7PnG8ta422vI+cJjSVES3DW/uiVggo3J+23Nc2k4Nd0H8ckee3r9cL7nn9mL7eSdxYEbeNY7CIR3jAHC9qBxkq8kzY11IizGGZkazNgmYhZJkOEbMqLPPLyOsj3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hLmnbg+x; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hLmnbg+x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730882602; x=1762418602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2FaB9DZ+5bt0vHcem3FiA70mddNIj2sFcK506ZwMn/Q=;
  b=hLmnbg+xuE+p5i4UrDdaXcesY6QdwzJEabK+GcFnmVwYMM+V0C7TW+0F
   EyHTSIsmglWlRxM/EQH2SIjR3KN2HP3iZm0IntdVONmA6wsrSPgkMPiKg
   bOzt94u98n6YhaF3aZJV9jFkVO2WRu3xJTGxirxn+PuKesa8Ga+zVAUk9
   FVFIBS8MYW5JE76epZCt3ftYb2Aq7TbJ6dPGSzMD0OpHiWEbwy+iRPE6I
   lTD6kjNVOS5Soj4n876N6V3PhFEyEH4yA+MMOgfHgSHLqY8F7qcN1fzRX
   o/nNRBcutN8hOeMMV3HNLUwjBv47IRgGNnlt1H7bgMO9scryl0uIXxVvy
   A==;
X-CSE-ConnectionGUID: NGcJJ8Z+SharKQGdp4TkMA==
X-CSE-MsgGUID: /RXjRShLQLyhL3IQjQ1xsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30889103"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30889103"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:43:21 -0800
X-CSE-ConnectionGUID: FQSFjxl3TY2wyKbOXhKltw==
X-CSE-MsgGUID: IM4k9HfgRNW2rIV3li9lkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="115233886"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 06 Nov 2024 00:43:18 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8bdD-000n6B-37;
	Wed, 06 Nov 2024 08:43:15 +0000
Date: Wed, 6 Nov 2024 16:43:10 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Boris Brezillon <bbrezillon@kernel.org>,
	dri-devel@lists.freedesktop.org, Liviu Dudau <liviu.dudau@arm.com>,
	patches@lists.linux.dev, Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 2/3] iommu/io-pgtable-arm-v7s: Remove split on unmap
 behavior
Message-ID: <202411061634.3EtgZij8-lkp@intel.com>
References: <2-v3-b3a5b5937f56+7bb-arm_no_split_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v3-b3a5b5937f56+7bb-arm_no_split_jgg@nvidia.com>

Hi Jason,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8e929cb546ee42c9a61d24fae60605e9e3192354]

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-Gunthorpe/iommu-io-pgtable-arm-Remove-split-on-unmap-behavior/20241106-021511
base:   8e929cb546ee42c9a61d24fae60605e9e3192354
patch link:    https://lore.kernel.org/r/2-v3-b3a5b5937f56%2B7bb-arm_no_split_jgg%40nvidia.com
patch subject: [PATCH v3 2/3] iommu/io-pgtable-arm-v7s: Remove split on unmap behavior
config: arm-randconfig-004-20241106 (https://download.01.org/0day-ci/archive/20241106/202411061634.3EtgZij8-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241106/202411061634.3EtgZij8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411061634.3EtgZij8-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/iommu/io-pgtable-arm-v7s.c:823:18: warning: variable 'loopnr' set but not used [-Wunused-but-set-variable]
     823 |         unsigned int i, loopnr = 0;
         |                         ^
   1 warning generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for GET_FREE_REGION
   Depends on [n]: SPARSEMEM [=n]
   Selected by [y]:
   - RESOURCE_KUNIT_TEST [=y] && RUNTIME_TESTING_MENU [=y] && KUNIT [=y]


vim +/loopnr +823 drivers/iommu/io-pgtable-arm-v7s.c

e5fc9753b1a831 Robin Murphy    2016-01-26  810  
e5fc9753b1a831 Robin Murphy    2016-01-26  811  static int __init arm_v7s_do_selftests(void)
e5fc9753b1a831 Robin Murphy    2016-01-26  812  {
e5fc9753b1a831 Robin Murphy    2016-01-26  813  	struct io_pgtable_ops *ops;
e5fc9753b1a831 Robin Murphy    2016-01-26  814  	struct io_pgtable_cfg cfg = {
e5fc9753b1a831 Robin Murphy    2016-01-26  815  		.tlb = &dummy_tlb_ops,
e5fc9753b1a831 Robin Murphy    2016-01-26  816  		.oas = 32,
e5fc9753b1a831 Robin Murphy    2016-01-26  817  		.ias = 32,
4f41845b340783 Will Deacon     2019-06-25  818  		.coherent_walk = true,
4f41845b340783 Will Deacon     2019-06-25  819  		.quirks = IO_PGTABLE_QUIRK_ARM_NS,
e5fc9753b1a831 Robin Murphy    2016-01-26  820  		.pgsize_bitmap = SZ_4K | SZ_64K | SZ_1M | SZ_16M,
e5fc9753b1a831 Robin Murphy    2016-01-26  821  	};
76b8c2705cdd26 Jason Gunthorpe 2024-11-05  822  	unsigned int iova, size;
e5fc9753b1a831 Robin Murphy    2016-01-26 @823  	unsigned int i, loopnr = 0;

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
