Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7768217E900;
	Fri, 10 Jan 2025 06:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736491571; cv=none; b=eW8p1vj3O8bsBOLJTA2J3BD3ERLmPfXX9VFV0r5S/N55RSVM6aynZvOBHLH3Qtadr/g4+Hfh7aK4BSHleEktzWIWd+W1i39ozid4dokdIeGui8J7P1R2QexRF9PwXPRQ0ifgVbTdKqnMK3SbfV2ZnuxzV/26jKtJa5Y4CHOtFIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736491571; c=relaxed/simple;
	bh=6dmzstW44IAUR04IDgAawau5VVF0AhG+00wYPVgGUIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+7YaSSPYEoV1GEL76K6ZFXS9ILxHIhu63ZTzj3w4YkKNtz4UNMbAjHx7O1PBDvnUZsgCFeTaF4KCNCfrgUth+cH3POx7SQOr/q4hNbr91j4XOYle0IVNBN16sMm7tYpMzI4lXE+3wW+EefH97P9T9NTvtXsBh/w3a9vLzpsAzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ri+YNWK+; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ri+YNWK+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736491569; x=1768027569;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6dmzstW44IAUR04IDgAawau5VVF0AhG+00wYPVgGUIY=;
  b=Ri+YNWK+1cx8axpiw0kY7TA87GTi4diBWQzHzKmIoFfP42cp3YD52znv
   58EKtU2xIxH+AcfXJD6rYsT7u940Yl4tK1Tsphv1M3DjK7q0pZQzmwvz2
   U05dyrg3gLitkDCpEUUJCZwoxsRziPagblAfbEu0O3DQkG2PBdSwOBfaq
   3zl96AAb8iX8qkr6JTgf3NnwqNp8h03oIglMXEOk7fmqiBBogGWwQ1pmC
   R1LKCDCTSx+l708kwcBtpLIsxaGIIqKWxhZx1NI5cfbnmeMBN5YTaqm1w
   0NRevWdca+V1R/rm81JNb74UYGQ45KAV17IpOWywu0sRPuvKInxRSbklO
   A==;
X-CSE-ConnectionGUID: rI0AzT/NRTWs7753wHOsSw==
X-CSE-MsgGUID: N2kirbqDSC6bXIeqhyEnEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="47770133"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="47770133"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 22:46:09 -0800
X-CSE-ConnectionGUID: pFvYg7W3Q0SHO+nUmoaOOw==
X-CSE-MsgGUID: EndMgAunTj6HSuR1WUvR0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103534561"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 09 Jan 2025 22:46:06 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tW8mR-000IfL-1X;
	Fri, 10 Jan 2025 06:46:03 +0000
Date: Fri, 10 Jan 2025 14:45:52 +0800
From: kernel test robot <lkp@intel.com>
To: Stephen Boyd <sboyd@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 4/4] clk: Make debugfs code into a loadable kernel module
Message-ID: <202501101445.zIwSpQgC-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on fac04efc5c793dccbd07e2d59af9f90b7fc0dca4]

url:    https://github.com/intel-lab-lkp/linux/commits/Stephen-Boyd/clk-Prepare-clk_debug_create_one-to-be-split-off/20250108-085933
base:   fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
patch link:    https://lore.kernel.org/r/20250108005854.2973184-5-sboyd%40kernel.org
patch subject: [PATCH 4/4] clk: Make debugfs code into a loadable kernel module
config: parisc-randconfig-001-20250110 (https://download.01.org/0day-ci/archive/20250110/202501101445.zIwSpQgC-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250110/202501101445.zIwSpQgC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501101445.zIwSpQgC-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/clk/clk.c: In function 'clk_core_debug_create_one':
>> drivers/clk/clk.c:3513:13: error: 'struct clk_core' has no member named 'dentry'
    3513 |         core->dentry = clk_hw_debug_create_one(hw);
         |             ^~
   drivers/clk/clk.c:3515:47: error: 'struct clk_core' has no member named 'dentry'
    3515 |                 core->ops->debug_init(hw, core->dentry);
         |                                               ^~
   drivers/clk/clk.c: In function 'clk_debug_register':
>> drivers/clk/clk.c:3529:29: error: 'struct clk_core' has no member named 'debug_node'
    3529 |         hlist_add_head(&core->debug_node, &clk_debug_list);
         |                             ^~
   drivers/clk/clk.c: In function 'clk_core_debug_remove_one':
   drivers/clk/clk.c:3536:29: error: 'struct clk_core' has no member named 'debug_node'
    3536 |         hlist_del_init(&core->debug_node);
         |                             ^~
   drivers/clk/clk.c:3537:38: error: 'struct clk_core' has no member named 'dentry'
    3537 |         debugfs_remove_recursive(core->dentry);
         |                                      ^~
   drivers/clk/clk.c:3538:13: error: 'struct clk_core' has no member named 'dentry'
    3538 |         core->dentry = NULL;
         |             ^~
   In file included from include/linux/container_of.h:5,
                    from include/linux/kernel.h:22,
                    from include/linux/clk.h:13,
                    from drivers/clk/clk.c:9:
   drivers/clk/clk.c: In function 'clk_hw_debug_for_each_init':
>> include/linux/container_of.h:20:54: error: 'struct clk_core' has no member named 'debug_node'
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
>> include/linux/compiler_types.h:483:27: error: expression in static assertion is not an integer
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
                    from ./arch/parisc/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:324,
                    from include/linux/err.h:5,
                    from include/linux/clk.h:12:
>> include/linux/stddef.h:16:33: error: 'struct clk_core' has no member named 'debug_node'
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
>> include/linux/list.h:1157:42: error: 'struct clk_core' has no member named 'debug_node'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                                          ^~
   include/linux/list.h:1144:19: note: in definition of macro 'hlist_entry_safe'
    1144 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
>> include/linux/list.h:1157:42: error: 'struct clk_core' has no member named 'debug_node'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                                          ^~
   include/linux/list.h:1144:35: note: in definition of macro 'hlist_entry_safe'
    1144 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
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
>> include/linux/container_of.h:20:54: error: 'struct clk_core' has no member named 'debug_node'
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
>> include/linux/compiler_types.h:483:27: error: expression in static assertion is not an integer
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
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
>> include/linux/stddef.h:16:33: error: 'struct clk_core' has no member named 'debug_node'
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
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3562:9: note: in expansion of macro 'hlist_for_each_entry'
    3562 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
   drivers/clk/clk.c: In function 'clk_hw_debug_exit':
>> include/linux/container_of.h:20:54: error: 'struct clk_core' has no member named 'debug_node'
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
>> include/linux/compiler_types.h:483:27: error: expression in static assertion is not an integer
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
>> include/linux/stddef.h:16:33: error: 'struct clk_core' has no member named 'debug_node'
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
>> include/linux/list.h:1157:42: error: 'struct clk_core' has no member named 'debug_node'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                                          ^~
   include/linux/list.h:1144:19: note: in definition of macro 'hlist_entry_safe'
    1144 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
>> include/linux/list.h:1157:42: error: 'struct clk_core' has no member named 'debug_node'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                                          ^~
   include/linux/list.h:1144:35: note: in definition of macro 'hlist_entry_safe'
    1144 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
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
>> include/linux/container_of.h:20:54: error: 'struct clk_core' has no member named 'debug_node'
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
>> include/linux/compiler_types.h:483:27: error: expression in static assertion is not an integer
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
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~
>> include/linux/stddef.h:16:33: error: 'struct clk_core' has no member named 'debug_node'
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
   include/linux/list.h:1157:20: note: in expansion of macro 'hlist_entry_safe'
    1157 |              pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
         |                    ^~~~~~~~~~~~~~~~
   drivers/clk/clk.c:3574:9: note: in expansion of macro 'hlist_for_each_entry'
    3574 |         hlist_for_each_entry(core, &clk_debug_list, debug_node)
         |         ^~~~~~~~~~~~~~~~~~~~


vim +3513 drivers/clk/clk.c

06c1e876918854 Stephen Boyd       2025-01-07  3505  
06c1e876918854 Stephen Boyd       2025-01-07  3506  static void clk_core_debug_create_one(struct clk_core *core)
06c1e876918854 Stephen Boyd       2025-01-07  3507  {
06c1e876918854 Stephen Boyd       2025-01-07  3508  	struct clk_hw *hw = core->hw;
06c1e876918854 Stephen Boyd       2025-01-07  3509  
22ece94fca2e92 Stephen Boyd       2025-01-07  3510  	if (!clk_hw_debug_create_one)
06c1e876918854 Stephen Boyd       2025-01-07  3511  		return;
06c1e876918854 Stephen Boyd       2025-01-07  3512  
94dffe79bcc703 Stephen Boyd       2025-01-07 @3513  	core->dentry = clk_hw_debug_create_one(hw);
8a26bbbb932021 Greg Kroah-Hartman 2018-05-29  3514  	if (core->ops->debug_init)
06c1e876918854 Stephen Boyd       2025-01-07  3515  		core->ops->debug_init(hw, core->dentry);
4dff95dc9477a3 Stephen Boyd       2015-04-30  3516  }
b2476490ef1113 Mike Turquette     2012-03-15  3517  
4dff95dc9477a3 Stephen Boyd       2015-04-30  3518  /**
6e5ab41b1064ee Stephen Boyd       2015-04-30  3519   * clk_debug_register - add a clk node to the debugfs clk directory
6e5ab41b1064ee Stephen Boyd       2015-04-30  3520   * @core: the clk being added to the debugfs clk directory
4dff95dc9477a3 Stephen Boyd       2015-04-30  3521   *
6e5ab41b1064ee Stephen Boyd       2015-04-30  3522   * Dynamically adds a clk to the debugfs clk directory if debugfs has been
6e5ab41b1064ee Stephen Boyd       2015-04-30  3523   * initialized.  Otherwise it bails out early since the debugfs clk directory
4dff95dc9477a3 Stephen Boyd       2015-04-30  3524   * will be created lazily by clk_debug_init as part of a late_initcall.
4dff95dc9477a3 Stephen Boyd       2015-04-30  3525   */
8a26bbbb932021 Greg Kroah-Hartman 2018-05-29  3526  static void clk_debug_register(struct clk_core *core)
4dff95dc9477a3 Stephen Boyd       2015-04-30  3527  {
4dff95dc9477a3 Stephen Boyd       2015-04-30  3528  	mutex_lock(&clk_debug_lock);
4dff95dc9477a3 Stephen Boyd       2015-04-30 @3529  	hlist_add_head(&core->debug_node, &clk_debug_list);
06c1e876918854 Stephen Boyd       2025-01-07  3530  	clk_core_debug_create_one(core);
4dff95dc9477a3 Stephen Boyd       2015-04-30  3531  	mutex_unlock(&clk_debug_lock);
b2476490ef1113 Mike Turquette     2012-03-15  3532  }
035a61c314eb3d Tomeu Vizoso       2015-01-23  3533  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
