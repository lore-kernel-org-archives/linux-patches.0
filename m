Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C355D19259F;
	Sun,  9 Mar 2025 09:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741512207; cv=none; b=VMQu7zkP6YBn0/BjU4XVIKKj94pdaKWZUUDgSt7T3RifDVgUSjZHQRPxMwjapOTz1HCJpVW97daQxbGDS2sRkbNJd2cyfZ7qC5kxyQl+Fz46WY3esGsDL9Mk7SN+cAzBDhkCjAUGp9/O1gCznBu140do08HPeBo0OH6qREf4Rq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741512207; c=relaxed/simple;
	bh=THgUwDalBcg4erMWitkeLHzuSldpSihPUeUF48weiAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksuM7mnRN5iLx+cXhSHeCAcze4S4WQk9w4n/Fc0SIgHHx1XMVYZykbEuNJyr4tlGWuONTZx5QTEW7yCXLf4KapVe1HcG5blqgT0vhzqB1fy7FRz/nZIRl59weWnFE4kjJyDUP7MuDU2oM/5XbYAwVbcrTFZBiW9MWwgCJXHfm3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6zC3R3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6zC3R3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113A5C4CEED;
	Sun,  9 Mar 2025 09:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741512207;
	bh=THgUwDalBcg4erMWitkeLHzuSldpSihPUeUF48weiAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=w6zC3R3tXZy0yHQwQxUYIacl2K+sbrGGIalVm84cgx2UQtS7T19HTtIvG3qpXprbp
	 pNKXkfZEGtVcS0nlIkHR1EOewVTtruvbkDWbTYEsgqEfPaYBmZZb68xRr6EAfPvXja
	 1Af3xesPtbn/RSegBWX9uNKD99uMjKOEXrEMN+bY=
Date: Sun, 9 Mar 2025 10:22:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/148] 6.12.18-rc2 review
Message-ID: <2025030902-avert-scored-a9c6@gregkh>
References: <20250306151415.047855127@linuxfoundation.org>
 <1c813c9d-de04-487c-a350-13577dbdd881@roeck-us.net>
 <3d99c624-88a8-4a98-b614-7565aa5dc4ba@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d99c624-88a8-4a98-b614-7565aa5dc4ba@roeck-us.net>

On Sat, Mar 08, 2025 at 10:24:37AM -0800, Guenter Roeck wrote:
> On Sat, Mar 08, 2025 at 07:15:35AM -0800, Guenter Roeck wrote:
> > On Thu, Mar 06, 2025 at 04:20:53PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.12.18 release.
> > > There are 148 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> > > Anything received after that time might be too late.
> > > 
> > v6.12.18:
> > 
> > Building loongarch:defconfig ... failed
> > --------------
> > Error log:
> > In file included from include/linux/bug.h:5,
> >                  from include/linux/thread_info.h:13,
> >                  from include/asm-generic/current.h:6,
> >                  from ./arch/loongarch/include/generated/asm/current.h:1,
> >                  from include/linux/sched.h:12,
> >                  from arch/loongarch/kernel/asm-offsets.c:8:
> > include/linux/thread_info.h: In function 'check_copy_size':
> > arch/loongarch/include/asm/bug.h:47:9: error: implicit declaration of function 'annotate_reachable'
> > 
> > This is not surprising:
> > 
> > $ git grep annotate_reachable
> > arch/loongarch/include/asm/bug.h:       annotate_reachable();
> > 
> > Caused by 2cfd0e5084e3 ("objtool: Remove annotate_{,un}reachable()").
> > 
> 
> The same problem also affects v6.13.6.

Now fixed up in the queues, thanks.

greg k-h
