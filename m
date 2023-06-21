Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F387819BA1
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 16:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11BFC433C0
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 16:32:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R1/NDnhk"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 21 Jun 2023 17:32:35 +0100
Resent-Message-ID: <ZJMmI96r/clFxPR7@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 21 Jun 2023 17:22:35 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=pvUL=CJ=linux.intel.com=andriy.shevchenko@kernel.org>)
	id 1qC0bH-002onR-VT
	for broonie@sirena.co.uk; Wed, 21 Jun 2023 17:22:35 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id D39AD615BF
	for <broonie@sirena.co.uk>; Wed, 21 Jun 2023 16:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 547F2C433C0; Wed, 21 Jun 2023 16:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C7BFC433C8
	for <broonie@kernel.org>; Wed, 21 Jun 2023 16:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 0C7BFC433C8
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687364549; x=1718900549;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2Sfvey+VaZL5qO8LPRWUl+d2EqW5EEQfVUj1+wDOePo=;
  b=R1/NDnhkW0SJnlzMTJc9zIPmjT7DHzMxXp2sk81DRTtlNfIBLAUCVIJO
   kmUIv6Dz7Ri6SLohHZqXFaiU+YsyoZcTNyA1S9a4nDK0x+qgJBi5QAH4A
   m8QoZA4qJLR3HqA/quApLpfCRk77hQ3BdfX8eCSnc9QQQqrWgWoCdB2O0
   Tjf0fat5hntNn0t7Z9+zJHAkQv2e76ws8NoLhxXmNxPk6TE+yDGCJDpEl
   1p12HhCncKL7V8YyX+gVGmwxLrtZBTMhxQzZpbxGm9qvJ/lEKKqF3IMrX
   zl4FRzh1M9PRo12tpLRUNt9qDq1Zj4n8B3agzj7/sjFD2+trDkqBKgCCp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="446605683"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="446605683"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 09:22:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="714549365"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="714549365"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 21 Jun 2023 09:22:01 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qC0ah-005XlD-2m;
	Wed, 21 Jun 2023 19:21:55 +0300
Date: Wed, 21 Jun 2023 19:21:55 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Phil Elwell <phil@raspberrypi.com>
Cc: James Schulman <james.schulman@cirrus.com>,
	David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	patches@opensource.cirrus.com
Message-ID: <ZJMjo1KpHyzTKnEw@smile.fi.intel.com>
References: <20230621153229.1944132-1-phil@raspberrypi.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621153229.1944132-1-phil@raspberrypi.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=pvUL=CJ=linux.intel.com=andriy.shevchenko@kernel.org
Subject: Re: [PATCH] ASoC: cs43130: Fix numerator/denominator mixup
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: zZO5JS1q9Flh

On Wed, Jun 21, 2023 at 04:32:29PM +0100, Phil Elwell wrote:
> In converting to using the standard u16_fract type, commit [1] made the
> obvious mistake and failed to take account of the difference in
> numerator and denominator ordering, breaking all uses of the cs43130
> codec.

Indeed. Thank you for fixing this and sorry for misreading the order.

> Fix it.


> [1] commit e14bd35ef446 ("ASoC: cs43130: Re-use generic struct u16_fract")

This one is not needed as you have the same in Fixes tag.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: e14bd35ef446 ("ASoC: cs43130: Re-use generic struct u16_fract")
> Signed-off-by: Phil Elwell <phil@raspberrypi.com>

-- 
With Best Regards,
Andy Shevchenko


