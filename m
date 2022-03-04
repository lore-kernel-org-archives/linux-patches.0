Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691767A
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 12:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646397595; x=1677933595;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lu2A8nr4iljZZ3A9dmddmJKaKz+e0D2A7UK6WgZvM78=;
  b=WbDclmm1S8vvP5aC8Y971GebGjLRuMryBrNJ+o+2oUblWutZ4fpfBM4x
   udQS2l9PqWGiLbnyUwKZO0r7SlkRfaqX0TJ1D0gI66qo7OkjL4fImmypR
   /0/6gaQ8gPxcJA8aTlANG44RhC/Ugok47CR4jCVycYMihuvti6qDeam5j
   8csRCFxGm1HtNSZT9s6HhJwFp4sUa65VVlxZD6t8j7xxK/TIX33hSbbt2
   U4lTY2DUBVsUgemvZfII/RO2SepEKH9+PWef4RRHe4yd+a4QDUdJ30p2R
   HSUPDzs6qJMsKwFX3wR/kvpmRQx34InuPlUfhpeJbG3Or4QcpLv2YMYYN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="253899042"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="253899042"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 04:39:55 -0800
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="508971098"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 04:39:52 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1nQ7D8-00BDd6-E7;
	Fri, 04 Mar 2022 14:39:06 +0200
Date: Fri, 4 Mar 2022 14:39:06 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jan Dabros <jsd@semihalf.com>, Hans de Goede <hdegoede@redhat.com>,
	linux-i2c@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH -next] i2c: designware: Mark
 dw_i2c_plat_{suspend,resume}() as __maybe_unused
Message-ID: <YiIIanhJXnoDWJkq@smile.fi.intel.com>
References: <20220303191713.2402461-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303191713.2402461-1-nathan@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Mar 03, 2022 at 12:17:13PM -0700, Nathan Chancellor wrote:
> When CONFIG_PM is set but CONFIG_PM_SLEEP is not, two compiler warnings
> appear:
> 
>   drivers/i2c/busses/i2c-designware-platdrv.c:444:12: error: unused function 'dw_i2c_plat_suspend' [-Werror,-Wunused-function]
>   static int dw_i2c_plat_suspend(struct device *dev)
>              ^
>   drivers/i2c/busses/i2c-designware-platdrv.c:465:12: error: unused function 'dw_i2c_plat_resume' [-Werror,-Wunused-function]
>   static int dw_i2c_plat_resume(struct device *dev)
>              ^
>   2 errors generated.
> 
> These functions are only used in SET_LATE_SYSTEM_SLEEP_PM_OPS(), which
> is defined as empty when CONFIG_PM_SLEEP is not defined. Mark the
> functions as __maybe_unused to make it clear that these functions might
> be unused in this configuration.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Thanks!


> Fixes: c57813b8b288 ("i2c: designware: Lock the adapter while setting the suspended flag")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/i2c/busses/i2c-designware-platdrv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index 116a297d1f6b..70ade5306e45 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -441,7 +441,7 @@ static int dw_i2c_plat_runtime_suspend(struct device *dev)
>  	return 0;
>  }
>  
> -static int dw_i2c_plat_suspend(struct device *dev)
> +static int __maybe_unused dw_i2c_plat_suspend(struct device *dev)
>  {
>  	struct dw_i2c_dev *i_dev = dev_get_drvdata(dev);
>  
> @@ -462,7 +462,7 @@ static int dw_i2c_plat_runtime_resume(struct device *dev)
>  	return 0;
>  }
>  
> -static int dw_i2c_plat_resume(struct device *dev)
> +static int __maybe_unused dw_i2c_plat_resume(struct device *dev)
>  {
>  	struct dw_i2c_dev *i_dev = dev_get_drvdata(dev);
>  
> 
> base-commit: 1d366c2f9df8279df2adbb60471f86fc40a1c39e
> -- 
> 2.35.1
> 

-- 
With Best Regards,
Andy Shevchenko


