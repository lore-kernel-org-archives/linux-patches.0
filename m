Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C890191F8C;
	Sat, 11 Jan 2025 11:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736596368; cv=none; b=jTRmrzwua37AO9RFZX3e0j17JesZYv1HAoqpWqpFuDL1ZFX4dlnP9S8Ky65Wr+T8L7u7ZbFxk49RramG2S7rSYZtDNq84PELvA5lRpQRaTmi8zWQl0wcuZiQeW27o4rFzdkdCVlz4xv0RfTj4g27ruGv3ay+xwbfYclPqHGSzis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736596368; c=relaxed/simple;
	bh=NEy6N5q7Don72bKMckkLHKWsfhI8exHCyedHsyfC5Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCuaVGLoA78GsSIfwJhCceDaABzdqII+ow5G8EMequZMJCWBEF0WnkvrwmT2VhrvNiB2Rrx3SaYX89boXlAGgvZtSwdHHx6LfCJ+FxpL6y1tHGhk+RHgn08VGQKbajJAtTVzbn2cLO3Da6ZBvTegu47eMwcfItpPWmL1nyL8ATM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OGV07D0M; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OGV07D0M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736596367; x=1768132367;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NEy6N5q7Don72bKMckkLHKWsfhI8exHCyedHsyfC5Wo=;
  b=OGV07D0MwB1qqJEgDXZIA7g4XMeMNknQNnvhDt7ZDbSjb5Zbe2/eLoDY
   JGZLu8OHYzMUuUSCYTMbxzrEo31wxNhFOFyJsl4FjnZb7wc2Trvio52V9
   GqrbIGOMb+T07zF+LKNOGMd3476fJ0KEiisU8iNFLueZpAfuwUlzmUScE
   qDQw0T57OG6jFBOTkfHQWJfzfFzuMou3xPIG5UbfpR8CnfifFkGQKR5n6
   AlHTv/OAtJTWZtAp1IjD6UUjoL8gMqx5KnJJNSwdkKQRpTA9IZn5aMU1T
   OHqppk1p//aUqWlfGUhFzztu7rrvPrm1aYzv8IsVrUAAWXAPV+l0VObGB
   Q==;
X-CSE-ConnectionGUID: GgMcmvAZQimruUnquuuOjA==
X-CSE-MsgGUID: fsW22/ipT3SIhf2UMce2DA==
X-IronPort-AV: E=McAfee;i="6700,10204,11312"; a="40650243"
X-IronPort-AV: E=Sophos;i="6.12,307,1728975600"; 
   d="scan'208";a="40650243"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2025 03:52:47 -0800
X-CSE-ConnectionGUID: 1tL/sQojRCGUhTBfv22fjg==
X-CSE-MsgGUID: LiHEs8xwRrGcSPd8E6FdbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104850295"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 11 Jan 2025 03:52:44 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tWa2j-000KbP-1a;
	Sat, 11 Jan 2025 11:52:41 +0000
Date: Sat, 11 Jan 2025 19:51:41 +0800
From: kernel test robot <lkp@intel.com>
To: Stephen Boyd <sboyd@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 4/4] clk: Make debugfs code into a loadable kernel module
Message-ID: <202501111916.yahwykQO-lkp@intel.com>
References: <20250108005854.2973184-5-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108005854.2973184-5-sboyd@kernel.org>

Hi Stephen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on fac04efc5c793dccbd07e2d59af9f90b7fc0dca4]

url:    https://github.com/intel-lab-lkp/linux/commits/Stephen-Boyd/clk-Prepare-clk_debug_create_one-to-be-split-off/20250108-085933
base:   fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
patch link:    https://lore.kernel.org/r/20250108005854.2973184-5-sboyd%40kernel.org
patch subject: [PATCH 4/4] clk: Make debugfs code into a loadable kernel module
config: loongarch-randconfig-r054-20250111 (https://download.01.org/0day-ci/archive/20250111/202501111916.yahwykQO-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250111/202501111916.yahwykQO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501111916.yahwykQO-lkp@intel.com/

All warnings (new ones prefixed by >>):

                    from include/linux/kernel.h:22,
                    from include/linux/clk.h:13,
                    from drivers/clk/clk.c:9:
   drivers/clk/clk.c: In function 'clk_hw_debug_for_each_init':
   include/linux/container_of.h:20:54: error: 'struct clk_core' has no member named 'debug_node'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                                                      ^~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1155:20: note: in expansion of macro 'hlist_entry_safe'
    1155 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:483:27: error: expression in static assertion is not an integer
     483 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1155:20: note: in expansion of macro 'hlist_entry_safe'
    1155 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/posix_types.h:5,
                    from include/uapi/linux/types.h:14,
                    from include/linux/types.h:6,
                    from include/linux/kasan-checks.h:5,
                    from include/asm-generic/rwonce.h:26,
                    from ./arch/loongarch/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:324,
                    from include/linux/err.h:5,
                    from include/linux/clk.h:12:
   include/linux/stddef.h:16:33: error: 'struct clk_core' has no member named 'debug_node'
      16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
         |                                 ^~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:23:28: note: in expansion of macro 'offsetof'
      23 |         ((type *)(__mptr - offsetof(type, member))); })
         |                            ^~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1155:20: note: in expansion of macro 'hlist_entry_safe'
    1155 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/mutex.h:15,
                    from include/linux/notifier.h:14,
                    from include/linux/clk.h:14:
   include/linux/list.h:1157:42: error: 'struct clk_core' has no member named 'debug_node'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                                          ^~
   include/linux/list.h:1144:19: note: in definition of macro 'hlist_entry_safe'
    1144 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/list.h:1157:42: error: 'struct clk_core' has no member named 'debug_node'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                                          ^~
   include/linux/list.h:1144:35: note: in definition of macro 'hlist_entry_safe'
    1144 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
>> include/linux/container_of.h:19:24: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      19 |         void *__mptr = (void *)(ptr);                                   \
         |                        ^
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:20:35: error: invalid type argument of unary '*' (have 'int')
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                                   ^~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:20:54: error: 'struct clk_core' has no member named 'debug_node'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                                                      ^~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:21:35: error: invalid type argument of unary '*' (have 'int')
      21 |                       __same_type(*(ptr), void),                        \
         |                                   ^~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |                       __same_type(*(ptr), void),                        \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:483:27: error: expression in static assertion is not an integer
     483 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
--
   include/linux/container_of.h:23:28: note: in expansion of macro 'offsetof'
      23 |         ((type *)(__mptr - offsetof(type, member))); })
         |                            ^~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   drivers/clk/clk.c: In function 'clk_hw_debug_exit':
   include/linux/container_of.h:20:54: error: 'struct clk_core' has no member named 'debug_node'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                                                      ^~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1155:20: note: in expansion of macro 'hlist_entry_safe'
    1155 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:483:27: error: expression in static assertion is not an integer
     483 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1155:20: note: in expansion of macro 'hlist_entry_safe'
    1155 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/stddef.h:16:33: error: 'struct clk_core' has no member named 'debug_node'
      16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
         |                                 ^~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:23:28: note: in expansion of macro 'offsetof'
      23 |         ((type *)(__mptr - offsetof(type, member))); })
         |                            ^~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1155:20: note: in expansion of macro 'hlist_entry_safe'
    1155 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/list.h:1157:42: error: 'struct clk_core' has no member named 'debug_node'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                                          ^~
   include/linux/list.h:1144:19: note: in definition of macro 'hlist_entry_safe'
    1144 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/list.h:1157:42: error: 'struct clk_core' has no member named 'debug_node'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                                          ^~
   include/linux/list.h:1144:35: note: in definition of macro 'hlist_entry_safe'
    1144 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
>> include/linux/container_of.h:19:24: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      19 |         void *__mptr = (void *)(ptr);                                   \
         |                        ^
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:20:35: error: invalid type argument of unary '*' (have 'int')
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                                   ^~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:20:54: error: 'struct clk_core' has no member named 'debug_node'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                                                      ^~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:21:35: error: invalid type argument of unary '*' (have 'int')
      21 |                       __same_type(*(ptr), void),                        \
         |                                   ^~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |                       __same_type(*(ptr), void),                        \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
         |                                        ^~~~~~~~~~~~
   include/linux/list.h:1145:22: note: in expansion of macro 'hlist_entry'
    1145 |            ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
         |                      ^~~~~~~~~~~
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:483:27: error: expression in static assertion is not an integer
     483 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:1134:40: note: in expansion of macro 'container_of'
    1134 | #define hlist_entry(ptr, type, member) container_of(ptr,type,member)


vim +19 include/linux/container_of.h

d2a8ebbf8192b8 Andy Shevchenko  2021-11-08   9  
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  10  /**
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  11   * container_of - cast a member of a structure out to the containing structure
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  12   * @ptr:	the pointer to the member.
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  13   * @type:	the type of the container struct this is embedded in.
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  14   * @member:	the name of the member within the struct.
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  15   *
7376e561fd2e01 Sakari Ailus     2022-10-24  16   * WARNING: any const qualifier of @ptr is lost.
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  17   */
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  18  #define container_of(ptr, type, member) ({				\
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08 @19  	void *__mptr = (void *)(ptr);					\
e1edc277e6f6df Rasmus Villemoes 2021-11-08  20  	static_assert(__same_type(*(ptr), ((type *)0)->member) ||	\
e1edc277e6f6df Rasmus Villemoes 2021-11-08  21  		      __same_type(*(ptr), void),			\
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  22  		      "pointer type mismatch in container_of()");	\
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  23  	((type *)(__mptr - offsetof(type, member))); })
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  24  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
