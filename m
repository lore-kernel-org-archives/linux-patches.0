Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A9511CA4
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 16:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BC8C433C8;
	Wed,  5 Jul 2023 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688573165;
	bh=zcbwmkRhZSBxVlltXrtaXLWraw9XRA5aayEuGWq66Iw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FVRHslv3pvP8n8Aznz01EcHcmgl3dpj2UahkGRhqEpzoTrs6HEzdLQ/nxuuTBmqgm
	 mlMqna6fkPzh8UVJqh6yEDgXzY3GhkLkwSY327qBUdn9RDmFd4jz6eyzC3yVHQCv77
	 TMC7SrilUTHGtnJ/oNBDQW8QghvMIEfL8V9cfKe4=
Date: Wed, 5 Jul 2023 17:06:02 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/13] 6.1.38-rc2 review
Message-ID: <2023070529-barcode-unpleased-5705@gregkh>
References: <20230704084611.071971014@linuxfoundation.org>
 <824705ec-38ca-1587-573c-595b146ee2e1@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <824705ec-38ca-1587-573c-595b146ee2e1@roeck-us.net>

On Wed, Jul 05, 2023 at 07:23:30AM -0700, Guenter Roeck wrote:
> On 7/4/23 01:48, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.38 release.
> > There are 13 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.38-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >      Linux 6.1.38-rc2
> > 
> > Linus Torvalds <torvalds@linux-foundation.org>
> >      gup: avoid stack expansion warning for known-good case
> > 
> 
> I am a bit puzzled by this patch. It avoids a warning introduced with
> upstream commit a425ac5365f6 ("gup: add warning if some caller would
> seem to want stack expansion"), or at least it says so, but that patch
> is not in v6.1.y. Why is this patch needed here ?

It isn't, and was dropped for -rc2, right?

thanks,

greg k-h
