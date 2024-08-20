Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9F118B461;
	Tue, 20 Aug 2024 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148583; cv=none; b=SMJy8SgJQr7gvtGuJpQKwpXpDtJ6kd+AcZ2vTm9rO2XXfSZ804uiQYdWcYPpONwrluJpljGf/4qumhMNPUSUA43Cu/5XtqP1UcM8GZrB0BIn/X4qjp91sNTVhDmcDcpF9U/Ggw9vV2xNRXB2tLGfYrWPK+QPsstEIC+6cX3cmNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148583; c=relaxed/simple;
	bh=3tVTMBl8GkEdITq3AfFty1yHWAX+Rf+21JgHphAFdlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZmWwr+uovsbixoCNCADTAjVo8Xq2MnBQ1Gglr3inoIUmFsmOc59vSAYKBMptC6ld/JqVriFOvqSudnRW6ivu8WkmwCXJQjJPK5iWuwNn28syQRQtJK3Ub/pNmUoetqM/JaZ0wOwIptEVt9490+il5Na206n+XJfVMj2ZHM1e6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=grkfMJ+n; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="grkfMJ+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724148581; x=1755684581;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3tVTMBl8GkEdITq3AfFty1yHWAX+Rf+21JgHphAFdlY=;
  b=grkfMJ+n6kEMEHJVyEhqiFYtMqXkMM9G+o/Nq+F7IOu/LILISKevyz4j
   NuEaS9Bo9IzfJroHXr2EDymnZeNHyD3hSjdCWDBaPMv/GYOPxFaenYBRc
   RvAjNdybh4/r4kYgZLUTTpYWDKVDF7rtnvCUwZzoe0ihwWB4eF6yqPkcI
   oFwNvdVYC+d4kbWu/XccT9/9kttSI9/Y/qlA47zlHYV5F+LpE1F7i0SKw
   97gr++Qjzz7da1bYNeT28hNw4pNW1mRMiBJr3SGNNXKXuKZvMFeIAE+ZV
   aOJ35Sb1DQB9seU1q4N2Fr5ltQpSHE4whvE2qnoTSW9yotpiQPbXmUnBa
   A==;
X-CSE-ConnectionGUID: bDVsbNU9RwSldciH4ihyOw==
X-CSE-MsgGUID: /kbpQYQGSL2N7dZwUQ/COQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11169"; a="39942825"
X-IronPort-AV: E=Sophos;i="6.10,161,1719903600"; 
   d="scan'208";a="39942825"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 03:09:40 -0700
X-CSE-ConnectionGUID: CmRgePgTRQ+WeEPu8CBnhw==
X-CSE-MsgGUID: vcfqOtI4S6mOAnzISwJg/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,161,1719903600"; 
   d="scan'208";a="83887188"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 03:09:33 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1sgLnt-0000000HG4x-1BmJ;
	Tue, 20 Aug 2024 13:09:29 +0300
Date: Tue, 20 Aug 2024 13:09:29 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, devicetree@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Benson Leung <bleung@chromium.org>,
	Conor Dooley <conor+dt@kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
	David Airlie <airlied@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Guenter Roeck <groeck@chromium.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Lee Jones <lee@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Prashant Malani <pmalani@chromium.org>,
	Robert Foss <rfoss@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Daniel Scally <djrscally@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Ivan Orlov <ivan.orlov0322@gmail.com>, linux-acpi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH v3 02/17] drm/bridge: Verify lane assignment is going to
 work during atomic_check
Message-ID: <ZsRrWfoPPVGC4Dqy@smile.fi.intel.com>
References: <20240819223834.2049862-1-swboyd@chromium.org>
 <20240819223834.2049862-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819223834.2049862-3-swboyd@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Aug 19, 2024 at 03:38:16PM -0700, Stephen Boyd wrote:
> Verify during drm_atomic_bridge_check() that the lane assignment set in
> a bridge's atomic_check() callback is going to be satisfied by the
> previous bridge. If the next bridge is requiring something besides the
> default 1:1 lane assignment on its input then there must be an output
> lane assignment on the previous bridge's output. Otherwise the next
> bridge won't get the lanes assigned that it needs.

> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: Robert Foss <rfoss@kernel.org>
> Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
> Cc: Jonas Karlman <jonas@kwiboo.se>
> Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: <dri-devel@lists.freedesktop.org>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Yeah, I really think that the appearance of this thousandth time in the Git
history has almost no value and just pollutes the commit message makes it not
very well readable. The only outcome is exercising the compression algo used
by Git.

...

> +	int i;

unsigned?

...

> +	/*
> +	 * Ensure this bridge is aware that the next bridge wants to
> +	 * reassign lanes.
> +	 */
> +	for (i = 0; i < num_input_lanes; i++)
> +		if (i != input_lanes[i].logical && !num_output_lanes)
> +			return -ENOTSUPP;

Besides missing {} this code is internal to the Linux kernel. Is it okay?

-- 
With Best Regards,
Andy Shevchenko


