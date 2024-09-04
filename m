Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C9C145B35;
	Wed,  4 Sep 2024 09:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725443506; cv=none; b=tIbAb5Zh2w1OwThLVIcEcqo0MtxlEqr84DyXnQpwjpjKrDaR+pASKfKJnLfaQ/OuKQf2a4v0qB1jRWoPPIdKmShhaMG0seTUVY+Banq6l+l6HM5InmPmNSzW/nVXJdB0ottQxD4se3PX/Ul58bAxWWvmt86jqeJ3SETQdCgpBWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725443506; c=relaxed/simple;
	bh=9v8g1rIECH33scUifS0SJLjKLhwqrmPT+U7zRZHR7aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GC8zOvZa5Q1Vxwu2ldA3LtrJZzZTwO+I72IuJyHSwi+DGZw2hP/jtzt4YWPKBHAcQDewFWIyLB1IUnjQ3zYYrfYhEERxhpLAwVjMkS07lVITf+2ZBiFYRccwkykK2qlrfTss92y1lUUyRa7lJjBf6WHFcn7K7aJ6OunyT+n2UaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kt653IpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kt653IpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC1BC4CEC2;
	Wed,  4 Sep 2024 09:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725443505;
	bh=9v8g1rIECH33scUifS0SJLjKLhwqrmPT+U7zRZHR7aQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kt653IpMJgUa37vyxIoA3w6Y9fHCQ6jN3ejkCQo9mUejmBKRAkDi7UwqDMKGaqE7y
	 wQDEEEbl1XaPaE1tarYBe9V5MRRUrChv3OsCRA7IAcz66WMWCK+yiy0mtQibNA2sDX
	 bdzTPi9qUpXimz11f6JOLAF5vteJeIWxfzAveUUo=
Date: Wed, 4 Sep 2024 11:51:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 4.19 00/98] 4.19.321-rc1 review
Message-ID: <2024090459-glancing-vengeful-f3fb@gregkh>
References: <20240901160803.673617007@linuxfoundation.org>
 <98f6ad0c-65d0-4a39-8a11-a55b3dd83b7b@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98f6ad0c-65d0-4a39-8a11-a55b3dd83b7b@oracle.com>

On Mon, Sep 02, 2024 at 02:44:44PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 01/09/24 21:45, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.321 release.
> > There are 98 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> > Anything received after that time might be too late.
> 
> Build fails on our infrastructure.
> 
> 
> BUILDSTDERR: In file included from /builddir/build/BUILD/kernel-4.19.321/linux-4.19.321-master.20240901.el7.dev/tools/include/linux/bitmap.h:6,
> BUILDSTDERR:                  from /builddir/build/BUILD/kernel-4.19.321/linux-4.19.321-master.20240901.el7.dev/tools/perf/util/include/../../util/pmu.h:5,
> BUILDSTDERR:                  from arch/x86/util/pmu.c:9:
> BUILDSTDERR: /builddir/build/BUILD/kernel-4.19.321/linux-4.19.321-master.20240901.el7.dev/tools/include/linux/align.h:6:10:
> fatal error: uapi/linux/const.h: No such file or directory
> BUILDSTDERR:  #include <uapi/linux/const.h>
> BUILDSTDERR:           ^~~~~~~~~~~~~~~~~~~~
> BUILDSTDERR: compilation terminated.
> 
> 
> Looked at the commits:
> 
> This commit 993a20bf6225c: ("tools: move alignment-related macros to new
> <linux/align.h>") is causing that perf build to fail.
> 
> Solution is not to drop this patch as this is probably pulled in to support
> bitmap_size() macros in these commits(which are also part of this release):
> 
> 6fbe5a3920f48 fix bitmap corruption on close_range() with
> CLOSE_RANGE_UNSHARE
> ef9ebc42c10f8 bitmap: introduce generic optimized bitmap_size()
> 
> 
> 
> Applying the below diff, helps the perf build to pass: I think we should
> fold this into: commit 993a20bf6225c: ("tools: move alignment-related macros
> to new <linux/align.h>")
> 
> diff --git a/tools/include/linux/align.h b/tools/include/linux/align.h
> index 14e34ace80dda..a27bc1edf6e5c 100644
> --- a/tools/include/linux/align.h
> +++ b/tools/include/linux/align.h
> @@ -3,7 +3,7 @@
>  #ifndef _TOOLS_LINUX_ALIGN_H
>  #define _TOOLS_LINUX_ALIGN_H
> 
> -#include <uapi/linux/const.h>
> +#include <linux/const.h>
> 
>  #define ALIGN(x, a)            __ALIGN_KERNEL((x), (a))
>  #define ALIGN_DOWN(x, a)       __ALIGN_KERNEL((x) - ((a) - 1), (a))

Change now made, thanks.

> !! But this breaks the build for arm here.
> !! Not sure what is the best way to solve this problem.

Are people building perf for arm on 4.19.y?  If so, wow, this thing is
about to go end-of-life any week now, and I would be amazed if it built
at all anymore as I can't get perf to build on _ANY_ lts kernel these
days.

Anyway, I'll make this change and if any arm build fixes want to show
up, I'll be glad to take them.

thanks,

greg k-h
