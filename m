Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43F528F2
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 09:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9D9C433A0;
	Wed, 19 Apr 2023 09:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681896417;
	bh=qxflMxePag1Pfp9FeskoGvnzx5TEu05J4qB66RIz4rc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wX8OfZTayjwW6YX7xOLU3POe0aPRl6JO4m/T5PLFXaqUZqdpxXFqQ/vxy7I0M/rxa
	 +yS8acIoPwUueFeHp/yuP0hFYjsCaxuYaQHzRR8o84phECE1X0LN3EjP7f83i/Yqy1
	 6YfVTF2fJBPdlEnn01u8jv8X+91DlXoaYnxPfgRI=
Date: Wed, 19 Apr 2023 11:26:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/88] 5.15.108-rc2 review
Message-ID: <2023041934-affection-whisking-db24@gregkh>
References: <20230419072156.965447596@linuxfoundation.org>
 <f10dd20e-6dce-490a-f3fb-fdf79e83bc1d@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f10dd20e-6dce-490a-f3fb-fdf79e83bc1d@roeck-us.net>

On Wed, Apr 19, 2023 at 01:11:32AM -0700, Guenter Roeck wrote:
> On 4/19/23 00:23, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.108 release.
> > There are 88 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 21 Apr 2023 07:21:37 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> ...
> > Alexandre Ghiti <alexghiti@rivosinc.com>
> >      riscv: Do not set initial_boot_params to the linear address of the dtb
> > 
> 
> As expected, a quick test shows that this patch still results in immediate
> riscv32/64 crashes.

Thanks for the report, let me go drop this and push out a -rc3...

greg k-h
