Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB82211CA1
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 20:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694033193; x=1725569193;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d5zvRhW8pHPVPvumASeRUDz78JQVHT52yAzi/mOU2s4=;
  b=YFMbYB661rPjOxZBnB2/Y1n+3MDSXnXNGXoksL9FucNfAkDOA2WzUGNM
   cnOVqu54+fN9juxhgWdnMcGBUKdRdaDB4ZtrzwArV/s4klCH1+B30g1HO
   RcXPFmm8XpoIM88sKP+Ta3q3bj0lrqFfWb5NcLgEBmFposjj3q5ISQj8O
   zMKkNQMfHxTB/nj1gx4tGzaz5xNTXe4R0HX7YUt8ZkhC1aXeANUBFQbUi
   inN/xSdhzaMrSo3/Yn+0CguVQ0Pt4Y4i5VJOSpqs6u0Iz6NmHqLi2pvjB
   STsi4zmVtj1AqYrb5uPBpcRVLUf0AKQqJj1AXmj4BWnRnw6HJQI08MeiJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="377093189"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="377093189"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 13:46:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="776772647"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="776772647"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 13:46:29 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qdzPv-0079X0-0D;
	Wed, 06 Sep 2023 23:46:27 +0300
Date: Wed, 6 Sep 2023 23:46:26 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v2 3/3] platform/x86: intel_scu_ipc: Fail IPC send if
 still busy
Message-ID: <ZPjlIhDykHd44YTz@smile.fi.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org>
 <20230906180944.2197111-4-swboyd@chromium.org>
 <ZPjdZ3xNmBEBvNiS@smile.fi.intel.com>
 <CAE-0n53iGCL3q=CsDKZr28eMjx40miLNG6+-jf12JKMxuAKkKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n53iGCL3q=CsDKZr28eMjx40miLNG6+-jf12JKMxuAKkKg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Sep 06, 2023 at 03:22:43PM -0500, Stephen Boyd wrote:
> Quoting Andy Shevchenko (2023-09-06 13:13:27)
> > On Wed, Sep 06, 2023 at 11:09:43AM -0700, Stephen Boyd wrote:

...

> > > @@ -450,6 +468,12 @@ int intel_scu_ipc_dev_simple_command(struct intel_scu_ipc_dev *scu, int cmd,
> > >               return -ENODEV;
> > >       }
> >
> > >       scu = ipcdev;
> >
> > Side observation: Isn't this a bug? We should not override the supplied parameter.
> 
> If it is a bug that would be great to know. I wanted to make an API that
> got the scu if it wasn't busy but then I ran across this code that
> replaced the scu with ipcdev.

To me this seems like a bug, because in other similar code we don't do that.
And even reading this one, why do we have a parameter if it's always being
rewritten?

-- 
With Best Regards,
Andy Shevchenko


