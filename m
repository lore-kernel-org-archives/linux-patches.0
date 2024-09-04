Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD33B17C9AA;
	Wed,  4 Sep 2024 09:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725442197; cv=none; b=tULgi0N+WEff9PzB/3B0Cp9ectYFwYHF8aPayfns3y8LHKyI9/mlmWDIU3LH/O94/3wfn+7EHDDCRozLAnzdjPuURJqOzllQr4FZ0vnMOShHHi0sYuGtgSrxYNHU0L7M4o3leMWDmeAiHcj9GZRi8xsTvTsvx5+5hvMH5QqB5oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725442197; c=relaxed/simple;
	bh=pKDl6/1gDcvOpmIoAI6TJhRZ8eBUNhAAzJqvOCMWq7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xvg5G3KnllxLz0OpuXNShkdN14pMu3DuNY78DTjNOPujuO9RvXFXlR2hwCqiNEhSqJh3tm8OZrMQpHZLIRu5CRRQqWQV9wt+AFT9pCQeNb8gyzNdMS2+co4vDjhypwM5UzidplMuP7S36/qOq16yxM8ofeZEZhtt4+C9Q4q6C0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIcLExD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIcLExD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C32C4CEC2;
	Wed,  4 Sep 2024 09:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725442196;
	bh=pKDl6/1gDcvOpmIoAI6TJhRZ8eBUNhAAzJqvOCMWq7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qIcLExD6HZx+K5LQGPxU1AHhtBVLPJ7ow3O/a0sFAhWSuwA1cejGjiqTzRjAMkwqp
	 riyzMfw4ddbPDaT18TFcx/Hg8zdgASV7nCJUOgJIEYy6PbOdymfWMQD4Qrlz1IeP/L
	 zgmvW+3bY4JCzu2xHQEDIsHnSb4EA4mvtFAZHBhI=
Date: Wed, 4 Sep 2024 11:29:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	abdulrasaqolawani@gmail.com, Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 5.4 000/134] 5.4.283-rc1 review
Message-ID: <2024090444-bully-parcel-c981@gregkh>
References: <20240901160809.752718937@linuxfoundation.org>
 <CA+G9fYszuNTqPzsX7cw-2_7D0tFUMeroVKeza4gASmUEbcxcqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYszuNTqPzsX7cw-2_7D0tFUMeroVKeza4gASmUEbcxcqw@mail.gmail.com>

On Mon, Sep 02, 2024 at 02:06:42PM +0530, Naresh Kamboju wrote:
> On Sun, 1 Sept 2024 at 22:09, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.283 release.
> > There are 134 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.283-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The Powerpc defconfig builds failed on Linux stable-rc due to following
> build warnings / errors with clang-18 and gcc-12.
> 
> This is a same problem on current stable-rc review on
>    - 5.4.283-rc1 review
>    - 5.10.225-rc1 review
>    - 5.15.166-rc1 review
> 
> In the case of stable-rc linux-5.4.y
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Anders bisected this to first bad commit id as,
>   fbdev: offb: replace of_node_put with __free(device_node)
>   [ Upstream commit ce4a7ae84a58b9f33aae8d6c769b3c94f3d5ce76 ]

Now dropped, thanks.

greg k-h
