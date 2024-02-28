Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399716EF1C
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146668; cv=none; b=IsxQMsFWK/gKeqEAZ5x1py3WJQouok04cWSw2aADJvcfzs4Qtj/c6+YKHVsN9SWaobk+NoPQ+Y/HoO+jNP8gn2Qln6YMckhDLlXj1qagIrQkUQT+dI5TXz897O6lmpMlgNMAdT+yT0DpnYfkvFF3dLW+YrNiaS3SOOxtkKCAW00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146668; c=relaxed/simple;
	bh=gDw3jRm0AM60tHCxqaG2rfJ1npT2cZmBML0MaxvzlBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdPZxV5KZW1zOf+QNikWvWAGcKo2M6wR1E8D+/hCt/T41imBdqrp7fDquz3Ys6RmN+VampM0cJtrBLAZfljr6XcfKtT1DEjiWr4+oV/xvmZ2AAe3xTprNGrUi/Tz0e43Sgs5716WQ14iTR4VA8Mtsr9SXzB7Vc+Jij82UpKnJII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ge53Hj89; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ge53Hj89"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709146666; x=1740682666;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gDw3jRm0AM60tHCxqaG2rfJ1npT2cZmBML0MaxvzlBA=;
  b=Ge53Hj89Bz13xZN8xUwvtddTidhJIa9KLlg/TfFBwl6RuvxVl2GT0OpA
   qxgGG9/Az1kEYANDlenFYxRuWGrBOpj99Jw2f+xczaoPqxejLAq8igWj9
   UnvsGd6udK8RJE3FcK4tb7LOLNcwWpWxfgl56THWoGIp51jMVb9fQDpKW
   2+E52tTGw3/HPoVT3bwIobL/Mc1M3E5TSo7MzTOYMQ1ULe4HhWfFIGME7
   5KbfzJr4iy2QFxAsLvFea4HoAIE0SqWcNlbX3HU/UubyVUkqZSz4aIx7a
   6SsTzqwoWoPGUo5Fj4KV0jZ/+YEOwFFYpktL4k6HgYOjMz9xqIKJnwwKb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="21025986"
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="21025986"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 10:57:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="913958400"
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="913958400"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 10:57:43 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1rfP7c-00000008Izz-2Ern;
	Wed, 28 Feb 2024 20:57:40 +0200
Date: Wed, 28 Feb 2024 20:57:40 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, linux-gpio@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2] gpiolib: Pass consumer device through to core in
 devm_fwnode_gpiod_get_index()
Message-ID: <Zd-CJHkCHpuIEnWh@smile.fi.intel.com>
References: <20240223065254.3795204-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223065254.3795204-1-swboyd@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Feb 22, 2024 at 10:52:53PM -0800, Stephen Boyd wrote:
> This devm API takes a consumer device as an argument to setup the devm
> action, but throws it away when calling further into gpiolib. This leads
> to odd debug messages like this:
> 
>  (NULL device *): using DT '/gpio-keys/switch-pen-insert' for '(null)' GPIO lookup
> 
> Let's pass the consumer device down, by directly calling what
> fwnode_gpiod_get_index() calls but pass the device used for devm. This
> changes the message to look like this instead:
> 
>  gpio-keys gpio-keys: using DT '/gpio-keys/switch-pen-insert' for '(null)' GPIO lookup
> 
> Note that callers of fwnode_gpiod_get_index() will still see the NULL
> device pointer debug message, but there's not much we can do about that
> because the API doesn't take a struct device.

Have you seen this?
https://lore.kernel.org/r/20231019173457.2445119-1-andriy.shevchenko@linux.intel.com

-- 
With Best Regards,
Andy Shevchenko


