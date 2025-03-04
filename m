Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1955917583
	for <patches@lists.linux.dev>; Tue,  4 Mar 2025 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741097394; cv=none; b=mskopGIxHF3J55zPTrH+imGddslL6ue/GQ3Yr6Y4/CqG95KEQMeW+5uTDzoloHh8smrrLfs+1uGMuJ043n/U13VMyouyOIQErBvY4ydnbwnaORiRbNoQ0nktum8B8U0MKSPNowAgaVTY46apPt+xz9u096m4s0uvRN8377OWzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741097394; c=relaxed/simple;
	bh=pzDdAjfIYZzOdK4dw8r3huxzvxorzalfIll9yJWmUiQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IT/Rs568S73i16BLhJFjwl+RuZ2K96tsrKC6hIxdAU9z6xZGkzyrHkI4EK9zELWGzbms0VcwISK2t1Jg2Ifo2feOXSR77As99oP0USsmv1tGpjfxLGwskbWofYytAU52Wt/hjxVRVQby5YDk8phV41cw1XpPZGPpbTaDXpH9CfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Po5U6bei; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Po5U6bei"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741097393; x=1772633393;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=pzDdAjfIYZzOdK4dw8r3huxzvxorzalfIll9yJWmUiQ=;
  b=Po5U6beiPv6OgdrzL9cFWZsWzPfNzFElTIhznwx1LSItwND2SuNd1MM0
   phNQikzgsDP24It0o7jq+ec4W1Q+zhvVMURLPqpwPe7LebTkrOCJNZGA3
   21Sf3mvADnWhbe8SDKpjacKc4Ux18CoFjcbazrl6Oltc+8i2yTWOojUiz
   9foO0Tt4oWH2VUGKYGEiYplknInKFjch+qiDzp3wmrZs518t6mKJU47Rj
   QxZzeBfPBXDWVMxxCVahe5tCv1zpFHLROAul5Lq5Nx9L0EF/iehLZMvh/
   wJkEm5ELfe1xq/HpGYmlLihVZf6JSrbVYZe+IdSJSUg+u2EnQ/6pHtlnq
   Q==;
X-CSE-ConnectionGUID: i80g+fPwRjO5sze8nfdJ9g==
X-CSE-MsgGUID: hl08YVU3T6KlWD83ZeqpBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42263278"
X-IronPort-AV: E=Sophos;i="6.14,220,1736841600"; 
   d="scan'208";a="42263278"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 06:09:52 -0800
X-CSE-ConnectionGUID: lUtOcMvlTsGUZX96/AjNfg==
X-CSE-MsgGUID: UChttDzwSpKePN1KQX3C/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,220,1736841600"; 
   d="scan'208";a="149169477"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.192])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 06:09:48 -0800
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Nathan Chancellor <nathan@kernel.org>, Aun-Ali Zaidi <admin@kodeit.net>,
 Aditya Garg <gargaditya08@live.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>
Cc: Atharva Tiwari <evepolonium@gmail.com>, Kerem Karabay
 <kekrby@gmail.com>, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, Nathan Chancellor
 <nathan@kernel.org>
Subject: Re: [PATCH] drm/appletbdrm: Fix format specifier for size_t variables
In-Reply-To: <20250304-appletbdrm-fix-size_t-specifier-v1-1-94fe1d2c91f8@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20250304-appletbdrm-fix-size_t-specifier-v1-1-94fe1d2c91f8@kernel.org>
Date: Tue, 04 Mar 2025 16:09:44 +0200
Message-ID: <87h648zy3b.fsf@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, 04 Mar 2025, Nathan Chancellor <nathan@kernel.org> wrote:
> When building for a 32-bit platform, there are some warnings (or errors
> with CONFIG_WERROR=y) due to an incorrect specifier for 'size_t'
> variables, which is typedef'd as 'unsigned int' for these architectures:
>
>   drivers/gpu/drm/tiny/appletbdrm.c:171:17: error: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
>     170 |                 drm_err(drm, "Actual size (%d) doesn't match expected size (%lu)\n",
>         |                                                                             ~~~
>         |                                                                             %zu
>     171 |                         actual_size, size);
>         |                                      ^~~~
>   ...
>   drivers/gpu/drm/tiny/appletbdrm.c:212:17: error: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
>     211 |                 drm_err(drm, "Actual size (%d) doesn't match expected size (%lu)\n",
>         |                                                                             ~~~
>         |                                                                             %zu
>     212 |                         actual_size, size);
>         |                                      ^~~~
>
> Use '%zu' as suggested, clearing up the warnings.
>
> Fixes: 0670c2f56e45 ("drm/tiny: add driver for Apple Touch Bars in x86 Macs")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Just sent an identical patch [1]. :)

You have a better commit message, let's go with this. With Aditya's ack
from the other thread,

Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: Aditya Garg <gargaditya08@live.com>

[1] https://lore.kernel.org/r/20250304135456.429407-1-jani.nikula@intel.com

> ---
>  drivers/gpu/drm/tiny/appletbdrm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/tiny/appletbdrm.c b/drivers/gpu/drm/tiny/appletbdrm.c
> index f5d177e234e4..394c8f9bd41a 100644
> --- a/drivers/gpu/drm/tiny/appletbdrm.c
> +++ b/drivers/gpu/drm/tiny/appletbdrm.c
> @@ -167,7 +167,7 @@ static int appletbdrm_send_request(struct appletbdrm_device *adev,
>  	}
>  
>  	if (actual_size != size) {
> -		drm_err(drm, "Actual size (%d) doesn't match expected size (%lu)\n",
> +		drm_err(drm, "Actual size (%d) doesn't match expected size (%zu)\n",
>  			actual_size, size);
>  		return -EIO;
>  	}
> @@ -208,7 +208,7 @@ static int appletbdrm_read_response(struct appletbdrm_device *adev,
>  	}
>  
>  	if (actual_size != size) {
> -		drm_err(drm, "Actual size (%d) doesn't match expected size (%lu)\n",
> +		drm_err(drm, "Actual size (%d) doesn't match expected size (%zu)\n",
>  			actual_size, size);
>  		return -EBADMSG;
>  	}
>
> ---
> base-commit: 95a5c9d197bb22a506913acb330a926d4e51aa95
> change-id: 20250304-appletbdrm-fix-size_t-specifier-d3c547522379
>
> Best regards,

-- 
Jani Nikula, Intel
