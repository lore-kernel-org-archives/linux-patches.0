Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794886593;
	b=lZMzsHrd46Li/s1L7FqoU4QLYmX25TH4lSRPwDVJztRAxOKlUdb7iQ6K6O4h6sufJhDs
	 ObEVB4qcMBcG/mtJeuXj4m/n3C3ccak2CEPfWtBcQ1+W/VSwJu4378PXoG+gZE05EJ/AE
	 DpeY0/1HyBT3MhS3MtrS9bsg5o5A0BIWzJ6gv3lpS1mkPQx752+ZZN8DH6pa5V3A1r7eX
	 Pzfbb+F7KboECW8luk4HHxaYBNuhDpNBiTH0hft/P8bcryLsJNwgK/20p0o4MoDk5mOkZ
	 xEve68hFZ5pfLYxVDjCz1IJrPSKxr3Gi8rsmgR0SO9K/Ubs4oc7DJ778zxDg2FHjnAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794886593;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=dSLf2LTiNtQC3p4vX6VQ3IQVNmBzkisDh8Hpz5xzqNw=;
	b=WYrR3LRphw0BQ74GWhqcgTt0+AIepDrJ6EeFT9qgSV3y60Az698tHCtejzReTwarJl3t
	 ZF6ICyLAz+ioy+MS4LRvara4Qa0YddX23M1QOw6bDUKf9/Tptl3Gk5UkMfPdY0YPgcGUC
	 Mqshx8f/x/skimMYGVRuobefWr1/G0uaWnwu8LBhge3fu1iH9cdZv3rW/1yH7ybJc9YTb
	 b87pBZgh7AXfG8OjakcHirnt4J+jLMWdaSPjYw6aJcLKYHLKFcVd8vERPz177JurKGWAK
	 mrMggJ4m/YMde87Yb9vipwaUvF2Yz/LUOSrvBbIrEk7A3Q6pTAlNHHQY0oaljGrQUog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IcYia+4C;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF2D606A323;
	Tue, 17 Nov 2026 03:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EF2D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IcYia+4C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794886593; x=1826422593;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding:in-reply-to;
  bh=4FBjm49gA65DGtEjbVkxm3YsLT31o/1ZsnxQ/paQWrM=;
  b=IcYia+4Cn3L/o0GehTe5Ap8na3n2rOiqIYh1wCMUsVYk9Hpp0OCwpCuA
   JIe9d4jSF6g3WMug/yKebd9vAnUi7CG7T5PBj3lgI2rUHUwxy6BJy7pd/
   NqHI4GECXaszjw/ReTzUpEcCCHxc1MKAc8+l2pFUNMQP9C3RSeJ5ck414
   Im+iDDbBoeF+DYRKcf7XB/9VUtR3dKgKIi1c6lsc+mtLjMuLM2DjgyVRl
   N3mXLvv2dXTIcY44qfzMv/OEc4K6xBtpSCirgPaP4sv/lowdlWtoyUF3H
   pRZSR8bEkS7cuW4TLjD0XKYIFtJckkuAxRIXGh0NF4QOPBk8KPOIlTYRv
   Q==;
X-CSE-ConnectionGUID: cupZAVbdRhS5a63e2JMwAQ==
X-CSE-MsgGUID: MJl3jVG+QaWnnfA8fuy76Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11968"; a="3514824"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3514824"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 19:36:32 -0800
X-CSE-ConnectionGUID: lplMVgfySv+H8oS5TJx3zQ==
X-CSE-MsgGUID: unj4XYIBRlOQXRoTBztMpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="10235007"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 19:36:27 -0800
Date: Tue, 17 Nov 2026 11:36:24 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Chen Yu <yu.c.chen@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>, linux-kernel@vger.kernel.org,
	ben.horgan@arm.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, bp@alien8.de, tglx@linutronix.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	patches@lists.linux.dev, reinette.chatre@intel.com,
	yi1.lai@intel.com
Subject: Re: [PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA
 configuration check
Message-ID: <202611171056.912725cf-lkp@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e1aeee81a38a33ca889db68e4c645f935e4e6cd.1793834224.git.reinette.chatre@intel.com>


Hello,

kernel test robot noticed a 4.4% regression of stress-ng.sockfd.ops_per_sec on:

commit: 12a0f554b3d62eb1270d6d60e9c6ab2c07dbbe35 ("[PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check")
url: https://github.com/intel-lab-lkp/linux/commits/Reinette-Chatre/x86-fs-resctrl-Remove-unused-non-linear-bandwidth-delay-mapping/20261104-161329
patch link: https://lore.kernel.org/all/7e1aeee81a38a33ca889db68e4c645f935e4e6cd.1793834224.git.reinette.chatre@intel.com/
patch subject: [PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: sockfd
	cpufreq_governor: performance


If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202611171056.912725cf-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261117/202611171056.912725cf-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-r02/sockfd/stress-ng/60s

commit: 
  0d4f0ec1db ("x86,fs/resctrl: Remove unused non-linear bandwidth delay mapping")
  12a0f554b3 ("[PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check")

0d4f0ec1dbca25be 12a0f554b3d62eb1270d6d60e9c
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  56484401            -4.4%   54013430        stress-ng.sockfd.ops
    940555            -4.4%     899375        stress-ng.sockfd.ops_per_sec
   3901263            -1.5%    3841842        stress-ng.time.involuntary_context_switches
   2386355 ±  6%     -10.4%    2138169 ±  5%  stress-ng.time.voluntary_context_switches


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


