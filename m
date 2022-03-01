Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6CB181
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 06:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646116079; x=1677652079;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+coUtu0N9qJ7rXPZFDWZMiy7198iNtKXun0/rsR8NGA=;
  b=efaQtuLWrCEHFCBER5t91ekP3wRPFoxPkP2GBYoIhOZbviEFTD49tbhD
   IAE3o5C2SAcO9udR1P0HrD1sB9yunbhFlgWzg1SBOuR9Zgl8McILzoTGY
   TOA6iz6+re36AESncp0FnzL/ft3Z/NHY/mKC92QnA+MaXcsBNRUEz0N06
   GTVXHVJNx+lF4xCO8zMrbbAd4WFz93pX4lLXUKjULJ1EuZffBckYMv55L
   hzh007Kg2IsXEOpghPuqeD2F5zJkYNmB5bUhiy+OWLFXf5IeU8q3sOzku
   d6mxYB9bS8sQ6esUT7K3CXpuoZYezvcpNiZSWzVNjr+8cYYyvUsRX/D6C
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="313789543"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="313789543"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 22:27:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="641150697"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by orsmga004.jf.intel.com with ESMTP; 28 Feb 2022 22:27:57 -0800
Date: Tue, 1 Mar 2022 14:27:56 +0800
From: Feng Tang <feng.tang@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Igor Zhbanov <i.zhbanov@omprussia.ru>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] driver core: dd: fix return value of __setup handler
Message-ID: <20220301062756.GJ4548@shbuild999.sh.intel.com>
References: <20220301041829.15137-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301041829.15137-1-rdunlap@infradead.org>

Hi Randy,

On Mon, Feb 28, 2022 at 08:18:29PM -0800, Randy Dunlap wrote:
> When "driver_async_probe=nulltty" is used on the kernel boot command line,
> it causes an Unknown parameter message and the string is added to init's
> environment strings, polluting them.
> 
>   Unknown kernel command line parameters "BOOT_IMAGE=/boot/bzImage-517rc6
>   driver_async_probe=nulltty", will be passed to user space.
> 
>  Run /sbin/init as init process
>    with arguments:
>      /sbin/init
>    with environment:
>      HOME=/
>      TERM=linux
>      BOOT_IMAGE=/boot/bzImage-517rc6
>      driver_async_probe=nulltty
> 
> Change the return value of the __setup function to 1 to indicate
> that the __setup option has been handled.

Thanks for the fix!

Reviewed-by: Feng Tang <feng.tang@intel.com>


> Fixes: 1ea61b68d0f8 ("async: Add cmdline option to specify drivers to be async probed")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> ---
>  drivers/base/dd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20220228.orig/drivers/base/dd.c
> +++ linux-next-20220228/drivers/base/dd.c
> @@ -810,7 +810,7 @@ static int __init save_async_options(cha
>  		pr_warn("Too long list of driver names for 'driver_async_probe'!\n");
>  
>  	strlcpy(async_probe_drv_names, buf, ASYNC_DRV_NAMES_MAX_LEN);
> -	return 0;
> +	return 1;
>  }
>  __setup("driver_async_probe=", save_async_options);
>  
