Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC42022A1D5;
	Sun, 19 Oct 2025 11:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760875109; cv=none; b=eDr37Rf7ck9ZLTsGEa/e+LIw1WqpEATLJcnF4ye3BK0BTjRcUA03iJKwAUgZ4nsswBQ+1jyCSPnFGyLio1yL6tjoM8qa2DjnNXYhJ5UxBH1xeL000T+l4QgXBVe2pbCixImJrkl3DFrCUKvLAKZFqPueEZczmGtfdg36pw5uQ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760875109; c=relaxed/simple;
	bh=0tmg8uZi4aZuDPodcrxuOJU3I+GvuE1KL7HO4B2nsk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FE5rC41CJKE8m4IkijFi9hHRX24DvvHMVQ/8CtIcv1qeZKdA1a6aQHsGV+ftke87a7TRPDwH8gfiAsGSg+C6C+cXuXRkZQofa5hPOBNae6RKndc7k3QxkC5wleHptOIv1+q9Ca2woCaM0PD9p6BwiY2D+DRzaavdeIy6RkzjVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQsfyzlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQsfyzlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BDEC4CEE7;
	Sun, 19 Oct 2025 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760875108;
	bh=0tmg8uZi4aZuDPodcrxuOJU3I+GvuE1KL7HO4B2nsk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YQsfyzlBG+nqVKW+L0aVKbX41CErPbxLDcp1qu9kX9eIeIbGH7YuETkjXSDrOO4Jg
	 r3K/gGazP1N40mqyz4q0l1ddtdcwDaHdq2YhGQiKIc790aBYStKv+C6MOz5ri4a8CS
	 h3QKdmUdZS2BcdBLO5m2HJx4/49H31zSRkcMH2+Y=
Date: Sun, 19 Oct 2025 13:58:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: [PATCH 5.15 000/276] 5.15.195-rc1 review
Message-ID: <2025101906-spinner-neutron-0a9a@gregkh>
References: <20251017145142.382145055@linuxfoundation.org>
 <CA+G9fYvRHXOJUfKqxj9MNA1ax1i2xCrazh0x9b3QvrXLm+N+qQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvRHXOJUfKqxj9MNA1ax1i2xCrazh0x9b3QvrXLm+N+qQ@mail.gmail.com>

On Sat, Oct 18, 2025 at 02:38:46PM +0530, Naresh Kamboju wrote:
> On Fri, 17 Oct 2025 at 21:16, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.195 release.
> > There are 276 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.195-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The S390 build failed on stable-rc 5.15.195-rc1 with gcc-12, gcc-8
> and clang-21 due to following build warnings / errors.
> 
> ### Build error:
> drivers/s390/cio/device.c: In function 'purge_fn':
> drivers/s390/cio/device.c:1330:23: error: passing argument 1 of
> 'spin_lock_irq' from incompatible pointer type
> [-Werror=incompatible-pointer-types]
>  1330 |         spin_lock_irq(&sch->lock);
>       |                       ^~~~~~~~~~
>       |                       |
>       |                       spinlock_t ** {aka struct spinlock **}
> In file included from drivers/s390/cio/device.c:16:
> include/linux/spinlock.h:387:55: note: expected 'spinlock_t *' {aka
> 'struct spinlock *'} but argument is of type 'spinlock_t **' {aka
> 'struct spinlock **'}
>   387 | static __always_inline void spin_lock_irq(spinlock_t *lock)
>       |                                           ~~~~~~~~~~~~^~~~
> drivers/s390/cio/device.c:1353:25: error: passing argument 1 of
> 'spin_unlock_irq' from incompatible pointer type
> [-Werror=incompatible-pointer-types]
>  1353 |         spin_unlock_irq(&sch->lock);
>       |                         ^~~~~~~~~~
>       |                         |
>       |                         spinlock_t ** {aka struct spinlock **}
> include/linux/spinlock.h:412:57: note: expected 'spinlock_t *' {aka
> 'struct spinlock *'} but argument is of type 'spinlock_t **' {aka
> 'struct spinlock **'}
>   412 | static __always_inline void spin_unlock_irq(spinlock_t *lock)
>       |                                             ~~~~~~~~~~~~^~~~
> cc1: some warnings being treated as errors
> make[3]: *** [scripts/Makefile.build:289: drivers/s390/cio/device.o] Error 1
> 
> ### Suspecting patches
> Suspecting commit,
> 
>   s390/cio: Update purge function to unregister the unused subchannels
>   [ Upstream commit 9daa5a8795865f9a3c93d8d1066785b07ded6073 ]
> 
> 
> Build regressions: 5.15.195-rc1: S390: cio/device.c:1330:23: error:
> passing argument 1 of 'spin_lock_irq' from incompatible pointer type
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for the report, I'll go drop this from all 3 queues now.

greg k-h
