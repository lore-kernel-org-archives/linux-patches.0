Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0198953AC
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 21:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694467177; x=1726003177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KyY0bt2hfAVv84BS0o9R1NkNlZaPTKwHSs6qfsZUiAk=;
  b=gKKHSdu80Dotqxg+O3onod7fI44zdum0Fa84694PqIcw3xE/9HzXBuNq
   P1fhEEbJOE642hvUWHUKb6K/JXEdxO3LkyZxdhmDa+mUm237Az9R86iFQ
   bwSrVI4PLmSbvPMpgjWMGSVfa25bc0xtGI8XJP5+zWAfdstOvRhYp/0fm
   b5UvM371R6zRuB4PCIsOdtWWfLjmwPCQo8VXlSnBKDVtPR1ZvLe3oijeP
   dgtZQoe99aC36+Wqkaa5VUUhwb4rpgLv5AoKwuy2vQ6RrLK1yO1zZtF1Y
   VHEscds0d22RBhy93Kqf+2q7el1dX82koXuQgXs4dBsuA99lNU04jKJdY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="380907812"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="380907812"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 14:19:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="813545721"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="813545721"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 14:19:31 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qfoJc-008QUx-1r;
	Tue, 12 Sep 2023 00:19:28 +0300
Date: Tue, 12 Sep 2023 00:19:28 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v3 1/4] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
Message-ID: <ZP+EYOkT2kVX2UCi@smile.fi.intel.com>
References: <20230911193937.302552-1-swboyd@chromium.org>
 <20230911193937.302552-2-swboyd@chromium.org>
 <ZP+D4hlUXhAboFBJ@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZP+D4hlUXhAboFBJ@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Tue, Sep 12, 2023 at 12:17:22AM +0300, Andy Shevchenko wrote:
> On Mon, Sep 11, 2023 at 12:39:33PM -0700, Stephen Boyd wrote:

...

> > +	err = read_poll_timeout(ipc_read_status, status, !(status & IPC_STATUS_BUSY),
> > +				100, jiffies_to_usecs(IPC_TIMEOUT), false, scu);
> 
> Since "false" you probably can utilize readx_poll_timeout().

...and because only a single parameter taken.

> > +	if (err)
> > +		return err;

With that,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


