Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D529180
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 07:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646118100; x=1677654100;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=35HJmXKfxBi/prrSB2I1QkaptGFdsXRKRkwKG2qraxI=;
  b=U8Hr2WStR7aa7P2QnKvkGL5Xj3yhlKjtzwq+QelWgryKAzBgsiS85YrT
   bfyf46j8emvYmj/XgqF46ntdl0nzLj6bafuVQlKgWezCqSbcL4ZmnPXFH
   Xa4qAueRxJUU6ur92xqL0kqzY8DO39UixgXVxz+ZeDIZybR9nbcQYdmLx
   6OnNVW+tnJjYUlrXBBNJeH8nZKv1blMjdi4CLzKoWD8ezcEPV+L7Ei7Qz
   ugTLSWx5CkarUz2ac5kZ9Vyi+DqSeRV90N3xSPnuAgmavQseF1ed85qQU
   8DpaHNPWmrrTA0pR9Qfgs8qsOzVIRLnRyvcKi0ERkr0ZAFwkiKEzBGxk9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="313793810"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="313793810"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 23:01:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="708950428"
Received: from lkp-server01.sh.intel.com (HELO 2146afe809fb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 28 Feb 2022 23:01:30 -0800
Received: from kbuild by 2146afe809fb with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nOwVm-00005R-0Y; Tue, 01 Mar 2022 07:01:30 +0000
Date: Tue, 1 Mar 2022 15:00:55 +0800
From: kernel test robot <lkp@intel.com>
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: kbuild-all@lists.01.org, David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Oliver Glitta <glittao@gmail.com>,
	Faiyaz Mohammed <faiyazm@codeaurora.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Yury Norov <yury.norov@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Matteo Croce <mcroce@microsoft.com>, Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Zqiang <qiang.zhang@windriver.com>
Subject: Re: [PATCH v2] mm/slub: initialize stack depot in boot process
Message-ID: <202203011429.a87fKdU7-lkp@intel.com>
References: <Yh2Uxh9DMndwjGcb@ip-172-31-19-208.ap-northeast-1.compute.internal>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh2Uxh9DMndwjGcb@ip-172-31-19-208.ap-northeast-1.compute.internal>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Hyeonggon,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on vbabka/slub-stackdepot-v1]
[also build test ERROR on linus/master v5.17-rc6 next-20220228]
[cannot apply to hnaz-mm/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Hyeonggon-Yoo/mm-slub-initialize-stack-depot-in-boot-process/20220301-113825
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git slub-stackdepot-v1
config: m68k-randconfig-r014-20220301 (https://download.01.org/0day-ci/archive/20220301/202203011429.a87fKdU7-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/dd9dbeec7444b13b510dc4a863e9593d1799f965
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Hyeonggon-Yoo/mm-slub-initialize-stack-depot-in-boot-process/20220301-113825
        git checkout dd9dbeec7444b13b510dc4a863e9593d1799f965
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash arch/m68k/coldfire/ mm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/irq.h:21,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/m68k/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from include/linux/kernel_stat.h:9,
                    from arch/m68k/kernel/asm-offsets.c:16:
>> include/linux/slab.h:769:5: warning: no previous prototype for 'slab_stack_depot_init' [-Wmissing-prototypes]
     769 | int slab_stack_depot_init(void) { return 0; }
         |     ^~~~~~~~~~~~~~~~~~~~~
--
   In file included from include/linux/irq.h:21,
                    from arch/m68k/coldfire/vectors.c:14:
>> include/linux/slab.h:769:5: warning: no previous prototype for 'slab_stack_depot_init' [-Wmissing-prototypes]
     769 | int slab_stack_depot_init(void) { return 0; }
         |     ^~~~~~~~~~~~~~~~~~~~~
   arch/m68k/coldfire/vectors.c:43:13: warning: no previous prototype for 'trap_init' [-Wmissing-prototypes]
      43 | void __init trap_init(void)
         |             ^~~~~~~~~
--
   In file included from include/linux/irq.h:21,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/m68k/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from arch/m68k/coldfire/intc-simr.c:16:
>> include/linux/slab.h:769:5: warning: no previous prototype for 'slab_stack_depot_init' [-Wmissing-prototypes]
     769 | int slab_stack_depot_init(void) { return 0; }
         |     ^~~~~~~~~~~~~~~~~~~~~
   arch/m68k/coldfire/intc-simr.c:177:13: warning: no previous prototype for 'init_IRQ' [-Wmissing-prototypes]
     177 | void __init init_IRQ(void)
         |             ^~~~~~~~
--
   In file included from include/linux/irq.h:21,
                    from include/linux/gpio/driver.h:7,
                    from arch/m68k/coldfire/gpio.c:12:
>> include/linux/slab.h:769:5: warning: no previous prototype for 'slab_stack_depot_init' [-Wmissing-prototypes]
     769 | int slab_stack_depot_init(void) { return 0; }
         |     ^~~~~~~~~~~~~~~~~~~~~
   arch/m68k/coldfire/gpio.c:19:5: warning: no previous prototype for '__mcfgpio_get_value' [-Wmissing-prototypes]
      19 | int __mcfgpio_get_value(unsigned gpio)
         |     ^~~~~~~~~~~~~~~~~~~
   arch/m68k/coldfire/gpio.c:25:6: warning: no previous prototype for '__mcfgpio_set_value' [-Wmissing-prototypes]
      25 | void __mcfgpio_set_value(unsigned gpio, int value)
         |      ^~~~~~~~~~~~~~~~~~~
   arch/m68k/coldfire/gpio.c:50:5: warning: no previous prototype for '__mcfgpio_direction_input' [-Wmissing-prototypes]
      50 | int __mcfgpio_direction_input(unsigned gpio)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/m68k/coldfire/gpio.c:65:5: warning: no previous prototype for '__mcfgpio_direction_output' [-Wmissing-prototypes]
      65 | int __mcfgpio_direction_output(unsigned gpio, int value)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/m68k/coldfire/gpio.c:96:5: warning: no previous prototype for '__mcfgpio_request' [-Wmissing-prototypes]
      96 | int __mcfgpio_request(unsigned gpio)
         |     ^~~~~~~~~~~~~~~~~
   arch/m68k/coldfire/gpio.c:102:6: warning: no previous prototype for '__mcfgpio_free' [-Wmissing-prototypes]
     102 | void __mcfgpio_free(unsigned gpio)
         |      ^~~~~~~~~~~~~~
--
   In file included from include/linux/stackdepot.h:15,
                    from include/linux/page_ext.h:7,
                    from include/linux/mm.h:25,
                    from mm/page_alloc.c:19:
>> include/linux/slab.h:769:5: warning: no previous prototype for 'slab_stack_depot_init' [-Wmissing-prototypes]
     769 | int slab_stack_depot_init(void) { return 0; }
         |     ^~~~~~~~~~~~~~~~~~~~~
   mm/page_alloc.c:3820:15: warning: no previous prototype for 'should_fail_alloc_page' [-Wmissing-prototypes]
    3820 | noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
         |               ^~~~~~~~~~~~~~~~~~~~~~
--
   In file included from include/linux/stackdepot.h:15,
                    from include/linux/page_ext.h:7,
                    from include/linux/mm.h:25,
                    from mm/page_poison.c:4:
>> include/linux/slab.h:769:5: warning: no previous prototype for 'slab_stack_depot_init' [-Wmissing-prototypes]
     769 | int slab_stack_depot_init(void) { return 0; }
         |     ^~~~~~~~~~~~~~~~~~~~~
   mm/page_poison.c:102:6: warning: no previous prototype for '__kernel_map_pages' [-Wmissing-prototypes]
     102 | void __kernel_map_pages(struct page *page, int numpages, int enable)
         |      ^~~~~~~~~~~~~~~~~~
--
   In file included from include/linux/stackdepot.h:15,
                    from include/linux/page_ext.h:7,
                    from include/linux/mm.h:25,
                    from mm/slub.c:13:
>> include/linux/slab.h:769:5: warning: no previous prototype for 'slab_stack_depot_init' [-Wmissing-prototypes]
     769 | int slab_stack_depot_init(void) { return 0; }
         |     ^~~~~~~~~~~~~~~~~~~~~
>> mm/slub.c:651:5: error: redefinition of 'slab_stack_depot_init'
     651 | int slab_stack_depot_init(void)
         |     ^~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/stackdepot.h:15,
                    from include/linux/page_ext.h:7,
                    from include/linux/mm.h:25,
                    from mm/slub.c:13:
   include/linux/slab.h:769:5: note: previous definition of 'slab_stack_depot_init' with type 'int(void)'
     769 | int slab_stack_depot_init(void) { return 0; }
         |     ^~~~~~~~~~~~~~~~~~~~~
--
   In file included from include/linux/irq.h:21,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/m68k/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from include/linux/kernel_stat.h:9,
                    from arch/m68k/kernel/asm-offsets.c:16:
>> include/linux/slab.h:769:5: warning: no previous prototype for 'slab_stack_depot_init' [-Wmissing-prototypes]
     769 | int slab_stack_depot_init(void) { return 0; }
         |     ^~~~~~~~~~~~~~~~~~~~~


vim +/slab_stack_depot_init +651 mm/slub.c

   650	
 > 651	int slab_stack_depot_init(void)
   652	{
   653		if (init_stack_depot)
   654			stack_depot_init();
   655		return 0;
   656	}
   657	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
