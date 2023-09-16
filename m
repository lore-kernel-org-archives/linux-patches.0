Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD99713AC6
	for <patches@lists.linux.dev>; Sat, 16 Sep 2023 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694862855; x=1726398855;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6LByGd6BJ/KoBVbB5quf9dys3O4g3Rte15yl6U221g8=;
  b=DGoC0FvImDErw6iSP6qAzFzZ2rJXU6aIZU+Qed3j7Uze5fGhnRMnSdDp
   jWy7lazfgqw/5xlCCA9X2r0g8pdxq4GRMBY8+FlyCuM+73U9ZKLUJINc1
   Wzl4qy/ourL6rODPBbZnl2o97zN3jeIKsGFd5Jwv4tkp+AbdPtKMvRb6a
   ThaYGLeXpJ5gGvnew1RleeOCyC/Wc+GtBBVLnVRBKPTdGztmSlIl+OFIF
   orA649vGOnkARTmg2Khf5F9yYktBzFxSHZjk3dbtsIUbK+SMzCiUpvJ0G
   Fqw8FsiqzQ6GpUKu8zBvT8bmeatuuYS7DshZd7ArivLstTUqgvUoUAOXx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="359655883"
X-IronPort-AV: E=Sophos;i="6.02,152,1688454000"; 
   d="scan'208";a="359655883"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2023 04:14:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="869045162"
X-IronPort-AV: E=Sophos;i="6.02,152,1688454000"; 
   d="scan'208";a="869045162"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2023 04:14:10 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97-RC0)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qhTFX-0000000Gg9M-2NuF;
	Sat, 16 Sep 2023 14:14:07 +0300
Date: Sat, 16 Sep 2023 14:14:07 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Stephen Boyd <swboyd@chromium.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v4 3/4] platform/x86: intel_scu_ipc: Don't override scu
 in intel_scu_ipc_dev_simple_command()
Message-ID: <ZQWN/xpN2801loCo@smile.fi.intel.com>
References: <20230913212723.3055315-1-swboyd@chromium.org>
 <20230913212723.3055315-4-swboyd@chromium.org>
 <58e817b0-1872-6ff1-58bb-1aeeb572361@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58e817b0-1872-6ff1-58bb-1aeeb572361@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, Sep 15, 2023 at 05:45:42PM +0300, Ilpo Järvinen wrote:
> On Wed, 13 Sep 2023, Stephen Boyd wrote:
> 
> > Andy discovered this bug during patch review. The 'scu' argument to this
> > function shouldn't be overridden by the function itself. It doesn't make
> > any sense. Looking at the commit history, we see that commit
> > f57fa18583f5 ("platform/x86: intel_scu_ipc: Introduce new SCU IPC API")
> > removed the setting of the scu to ipcdev in other functions, but not
> > this one. That was an oversight. Remove this line so that we stop
> > overriding the scu instance that is used by this function.
> > 
> > Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Closes: https://lore.kernel.org/r/ZPjdZ3xNmBEBvNiS@smile.fi.intel.com
> 
> This looks somewhat unusual way to tag it. I'd just drop the Closes tag 
> as the email list is not a bug tracter.

This is a new requirement enforced by checkpatch.pl. If commit message has
the Reported-by: tag it should have Closes: one as well.


-- 
With Best Regards,
Andy Shevchenko


