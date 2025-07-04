Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0471A2D;
	Fri,  4 Jul 2025 09:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751622010; cv=none; b=jH8wigmOgYGiQtJKNg9P6ldguZbbCrgFQSpWvW0db63gf+LTCWoshyhOOcyG7wCxFkZTkoB6MM9oqcRW+AIejTRcQ4GsrxBiqnBdM8EQtTXXIjV3Jw80qGBWU74YZ4v8E6hXUr6xhsanUDuAyZzmtN7LJOHkZGoyNQbigpOVSlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751622010; c=relaxed/simple;
	bh=eTd+17f8nMKVCHy8M/z5RgqKTnnvWw1nEwLMxvq6gGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGR8jSEl/awxv1b+IBe6bAFDzUVjTBFrtmiSrpR06DMnfxMpa9SXCn7DGf4HMi2KZY/fRIQgNJxGg7jLwnzUwQgtpbXQNdod5ZpZjnsJZCmyJaybmUK4IJmspOkyc4LqVvc4LCjqQEHbnrjB9xipOwNVpsdyCA1akTQjLH1wBUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8oJm9gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8oJm9gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA59C4CEE3;
	Fri,  4 Jul 2025 09:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751622010;
	bh=eTd+17f8nMKVCHy8M/z5RgqKTnnvWw1nEwLMxvq6gGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=z8oJm9gg8uHu9gxPA6m2P5PBtIh6UAI7zTG+sr5wyc3C4JcwJJHRkOvc5D3pN9Jbu
	 K5jrO2W7cmclZ7IZ10CjA0G/IYRW3zZlDqHXwzqHgEcRceKHOZknOq+ztSsUGTeb5p
	 KQ5pcQU/t78GlD7kmt02K+67qWiHyHGk4VRQrIJ8=
Date: Fri, 4 Jul 2025 11:40:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Imre Deak <imre.deak@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: Re: [PATCH 6.1 075/132] drm/dp: Change AUX DPCD probe address from
 DPCD_REV to LANE0_1_STATUS
Message-ID: <2025070455-daily-province-6815@gregkh>
References: <20250703143939.370927276@linuxfoundation.org>
 <20250703143942.360601573@linuxfoundation.org>
 <aGaiASySvb3BVXlM@ideak-desk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGaiASySvb3BVXlM@ideak-desk>

On Thu, Jul 03, 2025 at 06:30:09PM +0300, Imre Deak wrote:
> Hi Greg and stable team,
> 
> please drop this patch from all stable trees, since it results in screen
> flicker for one user at least, see:
> https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14558
> 
> The original issue the patch fixed needs a different solution, taking
> into account the panel in issues/14558 as well, I'll follow up with any
> such fix instead of this one later.
> 
> So far I got a notification that the patch got queued for the 6.1, 6.6,
> 6.12, 6.15 stable trees, it should be removed from all.
> 
> Sorry for the trouble this caused.

No problem, now dropped from all queues, thanks for letting me know.

greg k-h
