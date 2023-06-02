Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710A819E63
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685719059; x=1717255059;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=74UhatMK3UUnku/iBSUieKfKmyh3IZ573NQGhAHsK3w=;
  b=kKYAlg10Xgtb9Fbyu+RmgxdiCgLKrzVgenxcQo6R0PrrbuxQWUF5Cvy0
   qtCgLdTDGI2RB0tSDaCIpBKFxPwZHPQrZE7xJEZOSoLzL7aO8dbVdWg+t
   foGhUpKiEki5mXajTT79pD0pONAPEuEWkNcvGWso3GrHx+/Cejj5TmprD
   E5ZlMt5kGe2iDYrHUpBRC27XYY4QhQphohqfseQRP+oOTNhurppCcLOc+
   CevE+LD1f544FA/JzEBtJ0EjKuUDdSY0n3/oun32VaGET8TH62k22bBQy
   D72NPSgxCVxQMvi6tK7jFlEi9S6FUk2MJm/LVykgn8VqrgiE5IL1KY2Y9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="340522821"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="340522821"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 08:17:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="707887171"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="707887171"
Received: from jwerner6-mobl.ger.corp.intel.com (HELO localhost) ([10.252.55.111])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 08:17:35 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Andi Shyti <andi.shyti@linux.intel.com>, Nathan Chancellor
 <nathan@kernel.org>
Cc: joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
 tvrtko.ursulin@linux.intel.com, alan.previn.teres.alexis@intel.com,
 intel-gfx@lists.freedesktop.org, patches@lists.linux.dev,
 dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/pxp: Fix size_t format specifier
 in gsccs_send_message()
In-Reply-To: <ZHZQ1gAWjdDql4Oi@ashyti-mobl2.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230530-i915-pxp-size_t-wformat-v1-1-9631081e2e5b@kernel.org>
 <ZHZQ1gAWjdDql4Oi@ashyti-mobl2.lan>
Date: Fri, 02 Jun 2023 18:17:32 +0300
Message-ID: <87zg5hdhbn.fsf@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, 30 May 2023, Andi Shyti <andi.shyti@linux.intel.com> wrote:
> Hi Nathan,
>
> On Tue, May 30, 2023 at 11:37:56AM -0700, Nathan Chancellor wrote:
>> When building ARCH=i386 allmodconfig, the following warning occurs:
>> 
>>   In file included from include/linux/device.h:15,
>>                    from include/linux/node.h:18,
>>                    from include/linux/cpu.h:17,
>>                    from include/linux/static_call.h:135,
>>                    from arch/x86/include/asm/perf_event.h:5,
>>                    from include/linux/perf_event.h:25,
>>                    from drivers/gpu/drm/i915/i915_pmu.h:11,
>>                    from drivers/gpu/drm/i915/gt/intel_engine_types.h:21,
>>                    from drivers/gpu/drm/i915/gt/intel_context_types.h:18,
>>                    from drivers/gpu/drm/i915/gem/i915_gem_context_types.h:20,
>>                    from drivers/gpu/drm/i915/i915_request.h:34,
>>                    from drivers/gpu/drm/i915/i915_active.h:13,
>>                    from drivers/gpu/drm/i915/gt/intel_context.h:13,
>>                    from drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.c:8:
>>   drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.c: In function 'gsccs_send_message':
>>   include/drm/drm_print.h:456:39: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
>>     456 |         dev_##level##type((drm)->dev, "[drm] " fmt, ##__VA_ARGS__)
>>         |                                       ^~~~~~~~
>>   include/linux/dev_printk.h:110:30: note: in definition of macro 'dev_printk_index_wrap'
>>     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
>>         |                              ^~~
>>   include/linux/dev_printk.h:146:61: note: in expansion of macro 'dev_fmt'
>>     146 |         dev_printk_index_wrap(_dev_warn, KERN_WARNING, dev, dev_fmt(fmt), ##__VA_ARGS__)
>>         |                                                             ^~~~~~~
>>   include/drm/drm_print.h:456:9: note: in expansion of macro 'dev_warn'
>>     456 |         dev_##level##type((drm)->dev, "[drm] " fmt, ##__VA_ARGS__)
>>         |         ^~~~
>>   include/drm/drm_print.h:466:9: note: in expansion of macro '__drm_printk'
>>     466 |         __drm_printk((drm), warn,, fmt, ##__VA_ARGS__)
>>         |         ^~~~~~~~~~~~
>>   drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.c:146:17: note: in expansion of macro 'drm_warn'
>>     146 |                 drm_warn(&i915->drm, "caller with insufficient PXP reply size %u (%ld)\n",
>>         |                 ^~~~~~~~
>>   cc1: all warnings being treated as errors
>> 
>> Use the '%zu' format specifier, as the variable is a 'size_t'.
>> 
>> Fixes: dc9ac125d81f ("drm/i915/pxp: Add GSC-CS backend to send GSC fw messages")
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>
> yes, as specified in Documentation/core-api/printk-formats.rst.
>
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> 

Thanks for the patch and review, pushed to drm-intel-gt-next. The CI
failure was about hdac, hardly anything to do with this one.

BR,
Jani.


>
> Thanks,
> Andi

-- 
Jani Nikula, Intel Open Source Graphics Center
