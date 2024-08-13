Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316E5433C0;
	Tue, 13 Aug 2024 06:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723529945; cv=none; b=Yc9R6GBW502gADYwfg+45KjhzUGbUXn4iWHwF5p7Ty1zNScRbInGf7sGTpsW/ZEUbdJ0i7e6x3NlNn7o+B09TO6YALmJ1wWUFtzAB8oFkg03vXMReEiaHkt4ZGsmzhVng95DaaNH4PTzj2aozWvLWmsSV6fS7nFoucJ837zeCeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723529945; c=relaxed/simple;
	bh=WCl+wZrzT0x1i51/8Vy2Qn3S0hUdMU1X8mN8JKqg/rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTt0Tf+NEuvxeVbfY9Iti5tMXRj9CfMWemjGt4hQuJ+KZVCRS7q2nmtAxcdgGpIaLl5XI0KmxcLPlh9KHm2lXuz2+Kzu4pKLKJpI4HmwHRu0RefnLWSAcqzoGqj0UTCzPgLnR/ue5hbnHDx1VQoidurSSP3lsIqVDvuBymOhpWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tkphu/HT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tkphu/HT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F87C4AF11;
	Tue, 13 Aug 2024 06:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723529944;
	bh=WCl+wZrzT0x1i51/8Vy2Qn3S0hUdMU1X8mN8JKqg/rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tkphu/HTnTorP81r90waqwL4nRNolOVkD12/CjEHMxkOw8CFIzIDyoD6HCmchP0zE
	 1lPjZrrJninBx6JyxMwLWbj2vOQvFRYqn0qlTm0umXgF1YYDHz10AIPfCHBJk4g2XK
	 DsAlzLccnDBRgf/QM93SlrZNuJcwNBcPXDODfFJ8=
Date: Tue, 13 Aug 2024 08:19:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/150] 6.1.105-rc1 review
Message-ID: <2024081352-harsh-prior-004e@gregkh>
References: <20240812160125.139701076@linuxfoundation.org>
 <f514502a-0e89-4fcb-95c4-986a3cba2342@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f514502a-0e89-4fcb-95c4-986a3cba2342@roeck-us.net>

On Mon, Aug 12, 2024 at 02:42:58PM -0700, Guenter Roeck wrote:
> On 8/12/24 09:01, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.105 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building parisc64:C3700:smp:net=pcnet:initrd ... failed
> ------------
> Error log:
> In file included from /home/groeck/src/linux-stable/include/linux/fs.h:45,
>                  from /home/groeck/src/linux-stable/include/linux/huge_mm.h:8,
>                  from /home/groeck/src/linux-stable/include/linux/mm.h:745,
>                  from /home/groeck/src/linux-stable/include/linux/pid_namespace.h:7,
>                  from /home/groeck/src/linux-stable/include/linux/ptrace.h:10,
>                  from /home/groeck/src/linux-stable/arch/parisc/kernel/asm-offsets.c:20:
> /home/groeck/src/linux-stable/include/linux/slab.h:228: warning: "ARCH_KMALLOC_MINALIGN" redefined
>   228 | #define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
> 
> In file included from /home/groeck/src/linux-stable/arch/parisc/include/asm/atomic.h:23,
>                  from /home/groeck/src/linux-stable/include/linux/atomic.h:7,
>                  from /home/groeck/src/linux-stable/include/linux/rcupdate.h:25,
>                  from /home/groeck/src/linux-stable/include/linux/rculist.h:11,
>                  from /home/groeck/src/linux-stable/include/linux/pid.h:5,
>                  from /home/groeck/src/linux-stable/include/linux/sched.h:14,
>                  from /home/groeck/src/linux-stable/arch/parisc/kernel/asm-offsets.c:18:
> /home/groeck/src/linux-stable/arch/parisc/include/asm/cache.h:28: note: this is the location of the previous definition
>    28 | #define ARCH_KMALLOC_MINALIGN   16      /* ldcw requires 16-byte alignment */
> 

Thanks, I'll go drop the offending commit now.

greg k-h
