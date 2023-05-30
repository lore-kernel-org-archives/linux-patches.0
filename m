Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3093B200AD
	for <patches@lists.linux.dev>; Tue, 30 May 2023 19:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685475548; x=1717011548;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=psbn6f6bXpts+8PR4gY1beEOF9Q0dLa1RISxJe9QLwo=;
  b=MosME9D67lvCw9+TlZb0qcK9p7CFoER8FhZjQ8B3UosDwYnA/go9kK1i
   8eblhYZHG52cMSXaSvfu+edIi1ZA1p/WzEfmirUwXC5bDGgDN1n6wmFuk
   0HUQVBG4ZNGXMaedX58ttSRhdqSu/rrMBpFOokUTtE5ghF2NXKyXcKkgU
   OOs+TkyvuSBmQmkPNA6Kzoq4k8IAVpLcZCnQqIeJJq4jB8riy6U5JwvYx
   m3nPEyurFwNDRp3fgX1rkDCDi+cnn88VNEak84I1iOAGZvXjYBQI5K69N
   QDirAw6N3XoDOUghVIskNIaaCjosiWs8L+AKZqANZoMPHr+f4ubS638Do
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="420791176"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="420791176"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 12:39:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="953313591"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="953313591"
Received: from amyachev-mobl3.ccr.corp.intel.com (HELO intel.com) ([10.252.53.184])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 12:39:04 -0700
Date: Tue, 30 May 2023 21:39:02 +0200
From: Andi Shyti <andi.shyti@linux.intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
	rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
	alan.previn.teres.alexis@intel.com, intel-gfx@lists.freedesktop.org,
	patches@lists.linux.dev, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/pxp: Fix size_t format specifier in
 gsccs_send_message()
Message-ID: <ZHZQ1gAWjdDql4Oi@ashyti-mobl2.lan>
References: <20230530-i915-pxp-size_t-wformat-v1-1-9631081e2e5b@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530-i915-pxp-size_t-wformat-v1-1-9631081e2e5b@kernel.org>

Hi Nathan,

On Tue, May 30, 2023 at 11:37:56AM -0700, Nathan Chancellor wrote:
> When building ARCH=i386 allmodconfig, the following warning occurs:
> 
>   In file included from include/linux/device.h:15,
>                    from include/linux/node.h:18,
>                    from include/linux/cpu.h:17,
>                    from include/linux/static_call.h:135,
>                    from arch/x86/include/asm/perf_event.h:5,
>                    from include/linux/perf_event.h:25,
>                    from drivers/gpu/drm/i915/i915_pmu.h:11,
>                    from drivers/gpu/drm/i915/gt/intel_engine_types.h:21,
>                    from drivers/gpu/drm/i915/gt/intel_context_types.h:18,
>                    from drivers/gpu/drm/i915/gem/i915_gem_context_types.h:20,
>                    from drivers/gpu/drm/i915/i915_request.h:34,
>                    from drivers/gpu/drm/i915/i915_active.h:13,
>                    from drivers/gpu/drm/i915/gt/intel_context.h:13,
>                    from drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.c:8:
>   drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.c: In function 'gsccs_send_message':
>   include/drm/drm_print.h:456:39: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
>     456 |         dev_##level##type((drm)->dev, "[drm] " fmt, ##__VA_ARGS__)
>         |                                       ^~~~~~~~
>   include/linux/dev_printk.h:110:30: note: in definition of macro 'dev_printk_index_wrap'
>     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
>         |                              ^~~
>   include/linux/dev_printk.h:146:61: note: in expansion of macro 'dev_fmt'
>     146 |         dev_printk_index_wrap(_dev_warn, KERN_WARNING, dev, dev_fmt(fmt), ##__VA_ARGS__)
>         |                                                             ^~~~~~~
>   include/drm/drm_print.h:456:9: note: in expansion of macro 'dev_warn'
>     456 |         dev_##level##type((drm)->dev, "[drm] " fmt, ##__VA_ARGS__)
>         |         ^~~~
>   include/drm/drm_print.h:466:9: note: in expansion of macro '__drm_printk'
>     466 |         __drm_printk((drm), warn,, fmt, ##__VA_ARGS__)
>         |         ^~~~~~~~~~~~
>   drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.c:146:17: note: in expansion of macro 'drm_warn'
>     146 |                 drm_warn(&i915->drm, "caller with insufficient PXP reply size %u (%ld)\n",
>         |                 ^~~~~~~~
>   cc1: all warnings being treated as errors
> 
> Use the '%zu' format specifier, as the variable is a 'size_t'.
> 
> Fixes: dc9ac125d81f ("drm/i915/pxp: Add GSC-CS backend to send GSC fw messages")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

yes, as specified in Documentation/core-api/printk-formats.rst.

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> 

Thanks,
Andi
