Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598B67B
	for <patches@lists.linux.dev>; Fri,  6 Jan 2023 06:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B28AC433D2;
	Fri,  6 Jan 2023 06:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672988329;
	bh=el314kZ7VBsdxmxA7/FGLXa4ifdIwEn5Eeyvb0I5bRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hxAnJzheqjLmDSraLu9htVurlEHrLldoaSOOWWy4RR+Pve0W1+0F4ygFQKYI7wMnh
	 1Nuq6VlnvP/NaUZ88Ttl2drHewkKA9K7jz6CqYDRtI+Id3rU41qqYYMIpvvxm+g9hE
	 Fh1WE8i1zYoHDWa5WRuQi48UVEqddfsvNAERzXzU=
Date: Fri, 6 Jan 2023 07:58:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <Y7fGpYyaJWym1BxW@kroah.com>
References: <20230104160511.905925875@linuxfoundation.org>
 <Y7cmMKUr//oYKWXb@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7cmMKUr//oYKWXb@duo.ucw.cz>

On Thu, Jan 05, 2023 at 08:34:08PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.1.4 release.
> > There are 207 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Thank you.
> 
> Is it known at this point if 6.1 will became next longterm release? It
> is not listed as such on https://www.kernel.org/category/releases.html
> . We might want to do some extra testing if it is.

A kernel can not become "long term" until it would have normally dropped
off of support.  Right now there are known-regressions in 6.1 still that
are not resolved.

And "extra" testing is always good no matter what kernel branch it is
happening for, why not always do it?

thanks,

greg k-h
