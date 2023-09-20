Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A324F9E1
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 08:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E813C433C7;
	Wed, 20 Sep 2023 08:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695197469;
	bh=7wf1p0Aec6gggxYmTBq1JQOuPInnKOwidNeGe4yZnm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nDoS+NdziuEqkwYc/f+wdv99E/h00icsJLiYbiWm9zSSrZv1gXZqURhp6bbbgSEVm
	 ZNgjEpHfIMpKZ3hfWEWOpFzKWhb58OMrbyp5Uw5CEyhfdaohhXbX+OHFy1Jk4CucWR
	 bIQwe/9FXrQ0C78yI9fGl88OMfCCU5rtVo+GbQYk=
Date: Wed, 20 Sep 2023 10:11:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>, Kyle Zeng <zengyhkyle@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/406] 5.10.195-rc1 review
Message-ID: <2023092009-angriness-sank-ae4f@gregkh>
References: <20230917191101.035638219@linuxfoundation.org>
 <07a04540-554c-4394-1e79-46ea665f8c03@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07a04540-554c-4394-1e79-46ea665f8c03@roeck-us.net>

On Tue, Sep 19, 2023 at 09:57:25PM -0700, Guenter Roeck wrote:
> On 9/17/23 12:07, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.195 release.
> > There are 406 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> > Anything received after that time might be too late.
> > 
> 
> chromeos-5.10 locks up in configfs_lookup() after the merge of v5.10.195.
> 
> I am a bit puzzled because I see
> 
> c709c7ca020a configfs: fix a race in configfs_lookup()
> 
> in v5.10.195 but not in the list of commits below. I guess I must be
> missing something.

It was part of the big patchset, it was posted here:
	https://lore.kernel.org/r/20230917191101.511939651@linuxfoundation.org

Not hidden at all :)

and was submitted here:
	https://lore.kernel.org/r/ZPOZFHHA0abVmGx+@westworld

> Either case, the code now looks as follows.
> 
> configfs_lookup()
> {
>     ...
>     spin_lock(&configfs_dirent_lock);
>     ...
>         err = configfs_attach_attr(sd, dentry);
>     ...
>     spin_unlock(&configfs_dirent_lock);
>     ...
> }
> 
> and
> 
> configfs_attach_attr(...)
> {
>     ...
>     spin_lock(&configfs_dirent_lock);
>     ...
> }
> 
> which unless it is way too late here and I really need to go to sleep
> just won't work.

Kyle, you did the backport, any comments?

thanks,

greg k-h
