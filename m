Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469AC4B8DF5;
	Fri, 21 Aug 2026 14:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787321200; cv=none; b=QubPb9hKvUmSZXMsATR/FvGajeTLyKqcISIglfOz0nVxkIGeZsG7Pbu8ikDkka4eHgCWquCw6h8JuuShXkGqvCROIIHt1SxLZWFR3j2A02ay7hrMmNh2OKx8XfFQjAi/s6617u5Ihq8wK+Lf5e5h9xXay9V2/yOx43TSbQjoDqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787321200; c=relaxed/simple;
	bh=GzYh1qryS990F2Bcgg6MgmGiTiS5O0rXxIcszFa3cuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OuWf7czqSbUzTEKAcWP917DlgH1LZWRWeK18fOW+8haos2N+nOL3QI21mStNE7mFL15SBJ+v/6XTWxQ77bhmkMD+3ZRJBa8ZQC74igaMtBI12NPbIYFbLapuzVry769/53JxEc92M5odsyJ+L7K+pvKcdV5/8avzkNWO8Tzg7FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYZDtpHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYZDtpHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D9A1F000E9;
	Fri, 21 Aug 2026 14:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787321198;
	bh=TNUdK7wI9DHRbsPWGDifbyxIBrXp5cUqef0jvkNIP5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HYZDtpHbsc7Ft6TiRcqBBjqhzDfTzQW92xI9rb1uUHdWy3zuKJxxyL/MOG9P7XoTg
	 UOrSN5YJSvER1yyL1L7U5IX6Z4S1PGvN+zLxSrmSRPEvSdHaulBsNMgBk+zAa+aFRi
	 dFBeLJ6TIE0q6kORX0YJj8EcXEZYEu7U/Ne3KIqw=
Date: Fri, 21 Aug 2026 16:06:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@nabladev.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/235] 5.10.266-rc1 review
Message-ID: <2026082114-corral-shredder-f410@gregkh>
References: <20260820145216.426568665@linuxfoundation.org>
 <aodG_dzanEjlYfue@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aodG_dzanEjlYfue@duo.ucw.cz>

On Thu, Aug 20, 2026 at 08:27:09PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.266 release.
> > There are 235 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Similar failure to 5.15:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2776649189

Note, I'm not going to click through and attempt to dig through that to
find the error message.  Please cut/paste them for us to read here.

thanks,

greg k-h
