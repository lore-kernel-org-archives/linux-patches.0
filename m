Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83B818C36;
	Thu,  3 Oct 2024 06:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727938380; cv=none; b=hQLZr6tCOH28L7f+pPrYHPTJHLLuAtojgHsYd/x07/JcR3C220Lvlr346CJC/94b6XG4hfyP1LnxyHVPbfpTW8w58IAYBuchyf5qufOJoIWgBqlhU91xs3pAVnj4oxcr6agox+6lh/fzDD+5n4KzQRrbtWN8OvHd2W149K7tG6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727938380; c=relaxed/simple;
	bh=yS3mYykYk5EOg/v1Pdc01zIx5ixKFJ2r6zT862EhC4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBeO3lUJWyIagDiREtfLbIpg5xYmM8OskmiI7Q7H8wd2EyNCRFhA8APdxFmGaTo8d06H+S1bu+5+RLHMjnNcEIwN8lNXNLsGGp53Qr4vf9IPsxCW5cy6XGVzCIP/dCtf3fbndd0e7K6pxLlrgzJxQsNJ1JKnJgLQyQBLLRKKRh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTo8yz1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTo8yz1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D89FC4CEC7;
	Thu,  3 Oct 2024 06:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727938380;
	bh=yS3mYykYk5EOg/v1Pdc01zIx5ixKFJ2r6zT862EhC4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yTo8yz1OFuO/9reVFr9o5Ub6VfEmMwX0Nb3ML5ZL+zuuaD3jmm2PHKrxLVD4NTpQr
	 4YceDvACJHaBTKI8Lwl8VUNFrn5e0O4iEycHwSYxZLLwxBgAXMSYSvYiEa3TTaC0cY
	 RpRrXIDr5xjOiZXpxnSacbW/nY5Tp41k306r2efs=
Date: Thu, 3 Oct 2024 08:52:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/538] 6.6.54-rc1 review
Message-ID: <2024100341-astrology-remorse-7d3a@gregkh>
References: <20241002125751.964700919@linuxfoundation.org>
 <e500ad8b-07d6-413e-8fc6-2a9afd5593de@linuxfoundation.org>
 <a9f2e3c6-7e4e-4fbd-8a79-b3fc011412e2@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9f2e3c6-7e4e-4fbd-8a79-b3fc011412e2@linuxfoundation.org>

On Wed, Oct 02, 2024 at 06:07:20PM -0600, Shuah Khan wrote:
> On 10/2/24 17:57, Shuah Khan wrote:
> > On 10/2/24 06:53, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.6.54 release.
> > > There are 538 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > Compile failed on my system.
> > 
> > libbpf.c: In function ‘bpf_object__create_map’:
> > libbpf.c:5215:50: error: ‘BPF_F_VTYPE_BTF_OBJ_FD’ undeclared (first use in this function)
> >   5215 |                         create_attr.map_flags |= BPF_F_VTYPE_BTF_OBJ_FD;
> >        |                                                  ^~~~~~~~~~~~~~~~~~~~~~
> > libbpf.c:5215:50: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > I think this is the commit. I am going to drop this and see
> > if it compiles.
> > 
> > > Martin KaFai Lau <martin.lau@kernel.org>
> > >      libbpf: Ensure undefined bpf_attr field stays 0
> > > 
> > 
> 
> Sorry - not the above. Here is the one:
> 
> > Kui-Feng Lee <thinker.li@gmail.com>
> >      libbpf: Find correct module BTFs for struct_ops maps and progs.
> 
> Upstream commit:
> 9e926acda0c2e ("libbpf: Find correct module BTFs for struct_ops maps and
>  progs.)"

Thanks for finding this, will drop the offending commits and push out a
-rc2 soon.

greg k-h
