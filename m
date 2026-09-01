Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9DA35E931
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 11:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788261081; cv=none; b=n8ZrHF4B2Av4R1lwvVRWzqgYSnjnsh1mtVn9pYTyD2JEgDXbruQ5ZUpD4q8+LQd213yQYZXPWXjTAmE3DUIPdafZKcwIeN/qkMIPI6s+7nw8zuMefXjMruIdpNzx7J8aPWszq8Dj7a30Fl5FkmluGK/oKNt6QF4BWwFI5qlCSOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788261081; c=relaxed/simple;
	bh=3M/wtxlpOKgLrsAMEM44P3wgylXnfeeEVOBwPFxHqY4=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jHrnzF5LsiBwKZFn9/vRNLFMRXwDYQEvt/kFz4ox/XH+DTqPoB8vl4bWSHyt3t3H++9M5S7Yg9hdFRnd0QEpP55xb4XXQbmzoKY48ICKlNV7khfAgarOeXkUs4pW/AdP7l6/84QEbbYXd12acmOhfhC+ZW/XfQMFhgM4/J5vY4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B7G1lCp8; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B7G1lCp8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788261081; x=1819797081;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=3M/wtxlpOKgLrsAMEM44P3wgylXnfeeEVOBwPFxHqY4=;
  b=B7G1lCp8e5WeZ9HTQcz2Zs75XA7C82jgFL26VbYk0PUdnOQv7zMx/fmj
   JnUFs2UiaPZbr0j8xgvYS2sKEleH31qzpd3NWJdljowbazteBoUnPnYXz
   Yl+wkiVkd9fr1lm6uIIXRTyJjZkhj27iajtJM5oWKWe1VZQSwMonyBypG
   88XluVygoc4UnheLqKE7mrp0HUiHfzHrqjme0TS5Czmqb149KDyyPo/2b
   YcNZZzckkUfjBqpt+NSgqLODzt0lVKhupwevy9CztAF3l2WEmpuDwk/um
   GHdMrVN6yBvOIqpquKtEqsnhWS685BFjmWLYa28wXauvawFp2umt7Vjn4
   Q==;
X-CSE-ConnectionGUID: w7nKf02nRp60AXBPAVvBLA==
X-CSE-MsgGUID: gua8q/K4QpiW8WyHl/hwqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="99020583"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="99020583"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 04:11:20 -0700
X-CSE-ConnectionGUID: 9IzzO06xRoCz3LEOwlwXpA==
X-CSE-MsgGUID: qWJ+8BHdSJaDzF/AdoGaMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="293904569"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.37])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 04:11:14 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 1 Sep 2026 14:11:10 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: Fenghua Yu <fenghuay@nvidia.com>, 
    Reinette Chatre <reinette.chatre@intel.com>, 
    Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
    Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>, 
    Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
    Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, 
    David E Box <david.e.box@intel.com>, x86@kernel.org, 
    Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v11 16/23] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
In-Reply-To: <20260831174421.13921-17-tony.luck@intel.com>
Message-ID: <7ac854d2-69eb-6dbd-e9bc-ec51b0f3fe07@linux.intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com> <20260831174421.13921-17-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 31 Aug 2026, Tony Luck wrote:

> INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
> call PMT functions directly.
> 
> Use ".probe_type = PROBE_FORCE_SYNCHRONOUS" to ensure sequential, synchronous
> calls to per-device .probe() functions.  Register the telemetry enumeration
> function pointers at the end of pmt_telem_init() when all .probe() functions
> have run and enumeration is complete.
> 
> Unregister at the start of pmt_telem_exit() before teardown of the
> auxiliary drivers.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v11:
> 	Add TAB to line up '=' in .driver initialization
> 
>  drivers/platform/x86/intel/pmt/telemetry.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
> index 953f35b6daec..2d2282c636b2 100644
> --- a/drivers/platform/x86/intel/pmt/telemetry.c
> +++ b/drivers/platform/x86/intel/pmt/telemetry.c
> @@ -427,16 +427,28 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
>  	.id_table	= pmt_telem_id_table,
>  	.remove		= pmt_telem_remove,
>  	.probe		= pmt_telem_probe,
> +	.driver		= {
> +		.probe_type = PROBE_FORCE_SYNCHRONOUS,
> +	},
>  };
>  
>  static int __init pmt_telem_init(void)
>  {
> -	return auxiliary_driver_register(&pmt_telem_aux_driver);
> +	int ret;
> +
> +	ret = auxiliary_driver_register(&pmt_telem_aux_driver);
> +
> +	if (!ret)
> +		intel_aet_register_enumeration(THIS_MODULE, intel_pmt_get_regions_by_feature,
> +					       intel_pmt_put_feature_group);

Preferably reverse the logic and handle the error first.

> +
> +	return ret;
>  }
>  module_init(pmt_telem_init);
>  
>  static void __exit pmt_telem_exit(void)
>  {
> +	intel_aet_unregister_enumeration();
>  	auxiliary_driver_unregister(&pmt_telem_aux_driver);
>  	xa_destroy(&telem_array);
>  }
> 

-- 
 i.

