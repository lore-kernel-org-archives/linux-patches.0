Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73693221710;
	Sat,  6 Dec 2025 21:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765057936; cv=none; b=VT2M0IsTRk7wmHHSLawkOdYGnkGYdvAfqjFTfw82TjkJsAS5TUCpFMXYtjFtHziEuPGDIxI15oYHm0z2w0FntbGlCJNfnlZLOlLvwv/TEg66zh9VnPIYnWAtEigjgvZMSFTnBG7G9etPMQ3MdEuoZQPeDdLlr9ohf2NAGOCKduE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765057936; c=relaxed/simple;
	bh=FILMRgQKN9fD9q+OVKg0dScHyxbVENaJTCPuXAeoctM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPkQrfJifVXTqzAkVOe353RwCFPLrTwEcOYc4QK+UzX384Dx3PdvQMYTkOvjXL4vbyEWATQLzfAJM3QeIp1X2hrwQQkrED32dsPKQaDQJNICTvaE2FP9C/onJCQ3m/UhRRqjW/XjspG3znelD4r+HYKcEDauAxIgteXl4pVDRIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bYLw4RK2; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bYLw4RK2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765057933; x=1796593933;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FILMRgQKN9fD9q+OVKg0dScHyxbVENaJTCPuXAeoctM=;
  b=bYLw4RK2YGXK8Zh1SNkSoEHAAFu3urvZ/C3xqrhNonzi8UYsW+O+6CoF
   dHI+wZrIdk9LxgsEb3cKGWTf6HF+7n/h6OrX3+QUzqGlafzr1TU//fGhH
   ZH6GMhsoef2+Q/NRm87vQ0MYds66rtPpOTTeImKTNOfjJcEx1jhg7Itby
   tE579X7YkVlXSkm9Rwd5M+LocSyeUKXQliAkp6yAGwQG+mAoYfOsCVl4d
   KyerWUQyALJA9mxEFtuIDGIQMNsRxFfOQvhuSQgS7N2gdH6xIyT6qxFDc
   V31bqgpkKQjw88evn9VIx5qmX1iLBpvDbNvZhkSniY77MWhB4Q5IgAFiC
   w==;
X-CSE-ConnectionGUID: lRzutmFVSWKVmFVsIpibtA==
X-CSE-MsgGUID: 47ENa01xT/qAknWxm9BF0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="77375331"
X-IronPort-AV: E=Sophos;i="6.20,255,1758610800"; 
   d="scan'208";a="77375331"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 13:52:08 -0800
X-CSE-ConnectionGUID: CdZEbJFZR/WfZlXpYuN/iw==
X-CSE-MsgGUID: YWVdeDCvRCigy88TWnw7AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,255,1758610800"; 
   d="scan'208";a="200513465"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.244.204])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 13:52:05 -0800
Date: Sat, 6 Dec 2025 23:52:02 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Askar Safin <safinaskar@gmail.com>
Cc: Mika Westerberg <westeri@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-gpio@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev, Dell.Client.Kernel@dell.com,
	Mario Limonciello <superm1@kernel.org>, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] gpiolib: acpi: Add quirk for Dell Precision 7780
Message-ID: <aTSlgoK0PcE937l1@smile.fi.intel.com>
References: <20251206180414.3183334-1-safinaskar@gmail.com>
 <20251206180414.3183334-2-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206180414.3183334-2-safinaskar@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Sat, Dec 06, 2025 at 06:04:13PM +0000, Askar Safin wrote:
> Dell Precision 7780 often wakes up on its own from suspend. Sometimes
> wake up happens immediately (i. e. within 7 seconds), sometimes it happens
> after, say, 30 minutes.

Bart, up to you, if you want to take this. But I can do with a usual route via
my tree.

-- 
With Best Regards,
Andy Shevchenko


