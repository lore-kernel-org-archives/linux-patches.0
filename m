Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4525211C90
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693491681; x=1725027681;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8oKQD9M25fFEQrtVAj6n2ITPsYj6gJcwmARduDZtNcA=;
  b=UUevlDgmzCdMGz+I4TjZfXARpRx4ro3vZjnTDDOtf+fYJf60zDOb/8Bg
   9vWQJj5ui2/fdFG6Vt2qMnGYlj/YjXmgeBQXMrMJfuHJ04OLPmvpeQeQs
   0wj781NtMVjApwufe5LvDsYf0Br5H41oRGY5XyOSZE5gt6Xid/bJedVuo
   itxk/2BkDqCTvnwwnH7foB9HgsDj0U15Q3goH7k2u7xm74C+Cp4L/oXI5
   QsAVPHq2B+Pwhev6ZGOYrdaDrdMSOUmdfTu2qNfgSXUKtZOyE2Y2QhXpv
   lJy2CoPtTJAheSnS06JVlzt80I5y5OKSBpf6uIpDPw2c7OPyNMOtUHroP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="379730047"
X-IronPort-AV: E=Sophos;i="6.02,217,1688454000"; 
   d="scan'208";a="379730047"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 06:53:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="986238572"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="986238572"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 06:53:17 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qbi6k-005Oxh-2r;
	Thu, 31 Aug 2023 16:53:14 +0300
Date: Thu, 31 Aug 2023 16:53:14 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH 1/3] platform/x86: intel_scu_ipc: Check status after
 timeouts in busy_loop()
Message-ID: <ZPCbSse3J6ksZwJa@smile.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org>
 <20230831011405.3246849-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831011405.3246849-2-swboyd@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Aug 30, 2023 at 06:14:01PM -0700, Stephen Boyd wrote:
> It's possible for the polling loop in busy_loop() to get scheduled away
> for a long time.
> 
>   status = ipc_read_status(scu);
>   <long time scheduled away>
>   if (!(status & IPC_STATUS_BUSY))
> 
> If this happens, then the status bit could change and this function
> would never test it again after checking the jiffies against the timeout
> limit. Polling code should check the condition one more time after the
> timeout in case this happens.
> 
> The read_poll_timeout() helper implements this logic, and is shorter, so
> simply use that helper here.

I don't remember by heart, but on some older Intel hardware this might have
been called during early stages where ktime() is not functional yet.

Is this still a case here?

...

Codewise change looks good to me.

-- 
With Best Regards,
Andy Shevchenko


