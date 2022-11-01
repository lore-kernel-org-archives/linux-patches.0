Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDA32112
	for <patches@lists.linux.dev>; Tue,  1 Nov 2022 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667315066; x=1698851066;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hYrWyDx+OkwlhfrqmQICzcLjxPkbWXHK/iIT9BOIzhE=;
  b=CYdNiIY3kZuw/83pfoOoVubnkMIZq18yMNvZMh4nT6HnOWuVCNO6ZdUb
   Z4CilyyBCp9lFtanjJpCh+DlHxzl+Sms4jvu9S9iQ6v95R+mgnNd7BYk7
   uGBE3kmHdILqIvpz+j/x+Nn0WELJcrffKBCtYzX+BX6XT5tc08+rNQlSb
   JrYF/H7GIQVMKH/lvK8xgdIaoqYsPuX9w9e63tJVqso+lW2p7ZOp43fDQ
   /qeF1quC1eCI8W+6veQ9Xi9Hregi94IeRpb7RITDUvSDkR91MX0P9rfYu
   cGVoDjEKIlSXzSTL3RlOiXHg1DiAFqrPjW5hFMEfJT2IpE9fblLIs0ENA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="335824182"
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="335824182"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 08:02:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="879110355"
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="879110355"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 01 Nov 2022 08:02:47 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1opsmr-005dgq-28;
	Tue, 01 Nov 2022 17:02:45 +0200
Date: Tue, 1 Nov 2022 17:02:45 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-arm-msm@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH -next] pinctrl: qcom: Include bitfield.h in
 pinctrl-lpass-lpi.c
Message-ID: <Y2E1FbRvyN6myNR2@smile.fi.intel.com>
References: <20221027191625.1738204-1-nathan@kernel.org>
 <Y1rcUbCVJi7QhcFK@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1rcUbCVJi7QhcFK@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Oct 27, 2022 at 10:30:26PM +0300, Andy Shevchenko wrote:
> On Thu, Oct 27, 2022 at 12:16:25PM -0700, Nathan Chancellor wrote:
> > When building ARCH=arm allmodconfig, the following error occurs:

I have pushed my version to the tree, so it will appear in the next Linux Next.

-- 
With Best Regards,
Andy Shevchenko


