Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24E67B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 09:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976C1C433EF;
	Sat, 11 Mar 2023 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678526414;
	bh=BPD8iZ7NmgAO/P2+4l2QmGyukbYibkFfEbCkZWi187s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rn8/KpWPzfbmk/CVifvlyw0qIY1DNALK0sTxXLItfC5CMC+bnhkrteKdYqYWYHsbI
	 aovsq2RWBy6jK80H+FjFzbqarLdfsPybfv+Dja0ZmeQwzB0zGvxeOmuh9z/cT+554v
	 TJ/y63HuPu72ifvEsu/jJWzX+K3i0Ld7CbyuUllc=
Date: Sat, 11 Mar 2023 10:20:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/193] 4.14.308-rc1 review
Message-ID: <ZAxHywhmpQhbMzfX@kroah.com>
References: <20230310133710.926811681@linuxfoundation.org>
 <fa9bb069-e298-4984-931d-40e151fab15e@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa9bb069-e298-4984-931d-40e151fab15e@roeck-us.net>

On Fri, Mar 10, 2023 at 01:03:46PM -0800, Guenter Roeck wrote:
> On Fri, Mar 10, 2023 at 02:36:22PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.308 release.
> > There are 193 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> > Anything received after that time might be too late.
> > 
> 
> s390:
> 
> arch/s390/net/bpf_jit_comp.c: In function 'bpf_jit_insn':
> arch/s390/net/bpf_jit_comp.c:1122:7: error: implicit declaration of function 'nospec_uses_trampoline'
> 
> arch/s390/net/bpf_jit_comp.c:1127:4: error: implicit declaration of function 'EMIT6_PCREL_RILC'

Thanks, I'll go drop the offending patch.

greg k-h
