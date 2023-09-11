Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4187C53AC
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 21:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694467119; x=1726003119;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yGWD+0QAiO0KJK3ZJuw6WyxLl7KFH8YmNMNIBv7XPaU=;
  b=i9g+cEMPU8FlF8McDvDODijBDYbFdYh0wZmiiMn2CYlZjM4AmpXm3DkN
   e82FUU1heSEySeaRu5AredR6YZ0PCphYysaxSH9Lxi3/i+FGhsGNi7f2N
   hdWp4pX10nA5QrwlJiBy/EvxjV3P7vuQzKjpRk+yIlVL+FVnzzzc0kKPI
   CyEA/4nx+pk+9i8OK1X78FJp6cb5OF2FkXqpE34Yd99WSZU0Z57ymiZa5
   Rd20Iy919BQumV0fGmh3bE8LIKI37hDXwHGNsEN3fEh6/Kr0kjf70mqPk
   DSrd2Xmht65R3wjbwWPJkUpxPIHBFoBMrClQc83eUPyIqWlibPxjFWG0r
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="375544009"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="375544009"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 14:18:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="808961273"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="808961273"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 14:18:36 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qfoIj-008QUP-0D;
	Tue, 12 Sep 2023 00:18:33 +0300
Date: Tue, 12 Sep 2023 00:18:32 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v3 3/4] platform/x86: intel_scu_ipc: Don't override scu
 in intel_scu_ipc_dev_simple_command()
Message-ID: <ZP+EKLClR1ldvY4x@smile.fi.intel.com>
References: <20230911193937.302552-1-swboyd@chromium.org>
 <20230911193937.302552-4-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911193937.302552-4-swboyd@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Sep 11, 2023 at 12:39:35PM -0700, Stephen Boyd wrote:
> Andy discovered this bug during patch review. The 'scu' argument to this
> function shouldn't be overridden by the function itself. It doesn't make
> any sense. Looking at the commit history, we see that commit
> f57fa18583f5 ("platform/x86: intel_scu_ipc: Introduce new SCU IPC API")
> removed the setting of the scu to ipcdev in other functions, but not
> this one. That was an oversight. Remove this line so that we stop
> overriding the scu instance that is used by this function.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


