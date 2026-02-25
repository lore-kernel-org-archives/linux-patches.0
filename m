Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E861A01C6;
	Wed, 25 Feb 2026 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772030597; cv=none; b=lvgLE2qby/sbvDGDDKGBYA2nlFqmZf3DOYEMoXOIyWQsOw/6iD0Yj7fnRebexUPNramWPFtFJfR2h4g+TZ9vfECpeWvQRO+ACg+5d2+vKuW6Sk7YDuUQb9WOLGqQGh1GF4GwvsAi6QtlEqW0kSFPp2LssJcMMqwQkCvuguUOKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772030597; c=relaxed/simple;
	bh=zBQynLpMlV5CH7IkkbHeYFYRvBle93RX9g3w0zEWESw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJaur2AGbTghao/VZTTBwHYhzTl9N6I/DStaLcghUkJnjmAmDPY4ZYd9nvu9PSS2nQ7UDxVpHDrA4bgCVQUZFm8nLF2Y3vdjoYEHpBm7wsTZQnJm0A900ifYInyfhhQN7tylSjPWA9txuITGVIrEdv+w+d+yZEiu2pKsQpYPo0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUWEGlK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUWEGlK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA017C116D0;
	Wed, 25 Feb 2026 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772030597;
	bh=zBQynLpMlV5CH7IkkbHeYFYRvBle93RX9g3w0zEWESw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tUWEGlK6Rv+uAZaG/M6yhf+4Qy8piM1WsSaA47JZmtpU6Vi2nmbcaP49pql+6BmRs
	 ANwHEl0VAN64IjDJi4KfzbnsgtZYKf2cMTX43AHyMG4wkcQzuHoX3cBoWaXClGp9+V
	 YNGapJQd7rW5StN1g0A+acoS2WPVnr54uDSwcJxg=
Date: Wed, 25 Feb 2026 06:43:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Timur =?iso-8859-1?Q?Krist=F3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.19 202/781] drm/amdgpu: dont attach the tlb fence for SI
Message-ID: <2026022511-dynamite-dreamlike-2c9d@gregkh>
References: <20260225012359.695468795@linuxfoundation.org>
 <20260225012404.620340700@linuxfoundation.org>
 <96928eb5-bfa8-482b-9555-3662e25803cf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96928eb5-bfa8-482b-9555-3662e25803cf@kernel.org>

On Wed, Feb 25, 2026 at 07:46:31AM +0100, Jiri Slaby wrote:
> On 25. 02. 26, 2:15, Greg Kroah-Hartman wrote:
> > 6.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Alex Deucher <alexander.deucher@amd.com>
> > 
> > [ Upstream commit 820b3d376e8a102c6aeab737ec6edebbbb710e04 ]
> 
> Bah :/.
> 
> It was applied in 6.19 as:
> commit eb296c09805ee37dd4ea520a7fb3ec157c31090f
> Author: Alex Deucher <alexander.deucher@amd.com>
> Date:   Tue Dec 2 14:24:03 2025 -0500
> 
>     drm/amdgpu: don't attach the tlb fence for SI
> ...
>     (cherry picked from commit 820b3d376e8a102c6aeab737ec6edebbbb710e04)
> 
> 
> 
> 
> and reverted by:
> commit 808c2052f046d730a588f7b92b04a12f64970853
> Author: Prike Liang <Prike.Liang@amd.com>
> Date:   Fri Jan 9 16:15:11 2026 +0800
> 
>     Revert "drm/amdgpu: don't attach the tlb fence for SI"
> ...
>     (cherry picked from commit 9163fe4d790fb4e16d6b0e23f55b43cddd3d4a65)
> 
> still in 6.19 (the cherry picks suggest fixes takes to some 6.19-fixes
> tree).
> 
> 
> 
> 
> Then merged to 7.0 as:
> commit 820b3d376e8a102c6aeab737ec6edebbbb710e04
> Author: Alex Deucher <alexander.deucher@amd.com>
> Date:   Tue Dec 2 14:24:03 2025 -0500
> 
>     drm/amdgpu: don't attach the tlb fence for SI
> 
> 
> 
> and reverted by:
> commit 9163fe4d790fb4e16d6b0e23f55b43cddd3d4a65
> Author: Prike Liang <Prike.Liang@amd.com>
> Date:   Fri Jan 9 16:15:11 2026 +0800
> 
>     Revert "drm/amdgpu: don't attach the tlb fence for SI"
> 
> It should be dropped or the latter revert added too.

what a mess.  Again, I hate this "cherry-pick forward in time"
monster...

I've applied this now, thanks.

greg k-h
