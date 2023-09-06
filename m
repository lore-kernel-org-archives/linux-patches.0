Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A097C10954
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 20:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694030799; x=1725566799;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Yy84/Xk9VMmXeaZDz9etLBxRJHsaQPXyEOL3fPHQHKM=;
  b=WNV+hUF/7GnCcCzy0gKb4uiEwPOq1k0K3gRGhwpM55hYh+/iDzS2rFEj
   ogec0Do4ReYKT8FP5RCItK9//H9NRahBY698Hg+HX5qKsGKyVKSyu/gXu
   bBYfMZBJuiAb0xMxZLOS/3bhQCliJJUxDLwrN4D26+lXIkBv3N8zibHOZ
   u4pqxk/hp72vIF9LpkawPpKrJ6r4M6Pl4DxgrYA1KI//NYfZFlu3S+XOZ
   rSvtgeJzsvwtimZSiKG2iwMOmxBL4soHx8YzdIVz3i+35SXddmfpobHxZ
   Bd7TWOjAZ1Twk1D5qeNUvs8yoRcuk06LDMAr5M5Gk+wzlC5teMAsW0HB1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="443559592"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="443559592"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 13:06:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="811807912"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="811807912"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 13:06:36 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qdynJ-00796e-1l;
	Wed, 06 Sep 2023 23:06:33 +0300
Date: Wed, 6 Sep 2023 23:06:33 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v2 2/3] platform/x86: intel_scu_ipc: Check status upon
 timeout in ipc_wait_for_interrupt()
Message-ID: <ZPjbyckhj63Gw+SB@smile.fi.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org>
 <20230906180944.2197111-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230906180944.2197111-3-swboyd@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Sep 06, 2023 at 11:09:42AM -0700, Stephen Boyd wrote:
> It's possible for the completion in ipc_wait_for_interrupt() to timeout,
> simply because the interrupt was delayed in being processed. A timeout
> in itself is not an error. This driver should check the status register
> upon a timeout to ensure that scheduling or interrupt processing delays
> don't affect the outcome of the IPC return value.
> 
>  CPU0                                                   SCU
>  ----                                                   ---
>  ipc_wait_for_interrupt()
>   wait_for_completion_timeout(&scu->cmd_complete)
>   [TIMEOUT]                                             status[IPC_STATUS_BUSY]=0
> 
> Fix this problem by reading the status bit in all cases, regardless of
> the timeout. If the completion times out, we'll assume the problem was
> that the IPC_STATUS_BUSY bit was still set, but if the status bit is
> cleared in the meantime we know that we hit some scheduling delay and we
> should just check the error bit.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


