Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA313376A3;
	Wed, 17 Dec 2025 15:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765985144; cv=none; b=LUS5vuB2m2ZzHnzBxwLF6NuPI9W57bTAqFpvd0UtyXukESHWIDv64oILnAltWDfuuN3er8VEzdJQEhnHEKMEINpSy4VbX6lRxJ3CmDmOvbjizPxqqXmitWsqsSTDy/448l2VLapEJ7pvMwtTSGR9IMJ68d9GCz/jaNOZSrII0Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765985144; c=relaxed/simple;
	bh=fSfF3hPb1vJBXlF4loldiSrHjhKAiqjAwSfM33spSbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J312XPPl49+rg/EGAtqijjNdQcesAx0AzADbNKMVzae8qPJtJNtatqLYLQMRO+MhKLuwxNgwKy2vz/I6UXDCyZZ3KlcbTyHbLmJprkFcBHH5VHQ365QVV0DLchfXWN3kpMeGnn8lX2bJOMpt1lVk5QEqlnMxghjUTMSy6HwGxLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3o2eRNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3o2eRNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A63C4CEF5;
	Wed, 17 Dec 2025 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765985143;
	bh=fSfF3hPb1vJBXlF4loldiSrHjhKAiqjAwSfM33spSbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=z3o2eRNcRPj6D3AVOyRvJo2Z3v5zCk5wLkAaPgnnoB4+Eociwv33XrPA9E3qgbLO5
	 3+HdhRQQZTA3Fv20SN20VIWeSXsJ8ha6oM7e43HJT8EUjXYQTTORhInRva104ksn98
	 Wg0+ebfNoIMQ2o0Z3YY+/niOCJKzr4eDR8fHPNiI=
Date: Wed, 17 Dec 2025 16:25:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ronald Warsow <rwarsow@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, conor@kernel.org, hargar@microsoft.com,
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
Message-ID: <2025121733-glaring-imperfect-3332@gregkh>
References: <20251216111401.280873349@linuxfoundation.org>
 <1056aea9-1977-440e-9ad3-8a0b8b746288@gmx.de>
 <2025121714-gory-cornhusk-eb87@gregkh>
 <b72d4821-d3e6-4b29-96c8-6acb1fc916a8@gmx.de>
 <2025121708-chunk-sasquatch-284c@gregkh>
 <797b868d-ffee-401d-afca-466394a03738@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <797b868d-ffee-401d-afca-466394a03738@gmx.de>

On Wed, Dec 17, 2025 at 01:45:33PM +0100, Ronald Warsow wrote:
> On 17.12.25 10:36, Greg Kroah-Hartman wrote:
> > On Wed, Dec 17, 2025 at 09:27:49AM +0100, Ronald Warsow wrote:
> > > On 17.12.25 06:47, Greg Kroah-Hartman wrote:
> > > > On Tue, Dec 16, 2025 at 05:06:56PM +0100, Ronald Warsow wrote:
> > > > > Hi
> ...
> > 
> > Odd, as you aren't even running the driver that this commit points to,
> > right?  You shouldn't be building it, so why does this show up as the
> > "bad" commit id?
> > 
> > totally confused,
> > 
> 
> well I realized I left out several steps to do bisect correct.
> 
> I hope this time it's correct:
> 
> d84236562448e634208746f0e04f725a509d4648 is the first bad commit
> commit d84236562448e634208746f0e04f725a509d4648
> Author: Matthew Brost <matthew.brost@intel.com>
> Date:   Fri Oct 31 16:40:45 2025 -0700
> 
>     drm/xe: Enforce correct user fence signaling order using
> 
>     [ Upstream commit adda4e855ab6409a3edaa585293f1f2069ab7299 ]
> 
>     Prevent application hangs caused by out-of-order fence signaling when
>     user fences are attached. Use drm_syncobj (via dma-fence-chain) to
>     guarantee that each user fence signals in order, regardless of the
>     signaling order of the attached fences. Ensure user fence writebacks to
>     user space occur in the correct sequence.
> 
>     v7:
>      - Skip drm_syncbj create of error (CI)
> 
>     Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel
> GPUs")
>     Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>     Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>     Link:
> https://patch.msgid.link/20251031234050.3043507-2-matthew.brost@intel.com
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
>  drivers/gpu/drm/xe/xe_exec_queue.c | 3 +++
>  1 file changed, 3 insertions(+)
> 

Thanks, will go drop this one now.

greg k-h
