Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B5268B62;
	Tue,  5 Dec 2023 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNYuHoIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21742C433C8;
	Tue,  5 Dec 2023 18:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701800249;
	bh=9+ZWs5EHaDXM+kXbnYb4FMhkFDrqEduTIdllgO0DxZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WNYuHoIMrEtuBRdgl0VnUNHZvPO0vmND/WmjivuFLUdYLsvJGVKzR2bPz+CNv2nWj
	 da2YSmQ6IMdCmW7P19jnCpiERseCns2RfUf4CbadTabskql5464He+2StHC4cGl7Y7
	 +HE9m3Jru87/Q2yRlz2Zh4qQxsKqz2ZiHVHSybVk=
Date: Wed, 6 Dec 2023 03:17:27 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>, namhyung@kernel.org
Subject: Re: [PATCH 5.15 00/67] 5.15.142-rc1 review
Message-ID: <2023120618-around-duplicity-8f8f@gregkh>
References: <20231205031519.853779502@linuxfoundation.org>
 <c8ebf598-4d9a-4ce0-bccf-2109150919dc@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8ebf598-4d9a-4ce0-bccf-2109150919dc@oracle.com>

On Tue, Dec 05, 2023 at 12:46:43PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 05/12/23 8:46 am, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.142 release.
> > There are 67 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.142-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > Adrian Hunter <adrian.hunter@intel.com>
> >      perf inject: Fix GEN_ELF_TEXT_OFFSET for jit
> > 
> > 
> 
> ^^ This commit is causing the perf/ build failure:
> 
> In file included from util/jitdump.c:29:
> util/genelf.h:5:10: fatal error: linux/math.h: No such file or directory
>     5 | #include <linux/math.h>
>       |          ^~~~~~~~~~~~~~
> compilation terminated.
> 
> This was previously reported on 5.15.136-rc:
> 
> Vegard shared his analysis on ways to fix here:
> 
> https://lore.kernel.org/stable/fb1ce733-d612-4fa3-a1e4-716545625822@oracle.com/

Now dropped from here and 4.19.y

thanks,

greg k-h
