Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933090;
	b=XO6zX1xnKMld/XvCK/RCmYLr0hZg5MpIYncQDVkm0ezVwUZPhiL2Aq264j8Alc72g0hA
	 mhmLpWUKHYc9zMzIzYnHlbR6l4A6lmHRV9yMPdlKwIyUN9wthftQZOYpfUGBJZ4BVURBR
	 +lLp0668deFzEUu0hlMuj1ZGVn34pkERGUWyUV5h5yy8KxWxVCRNfTO7XlcnNozChqgG+
	 oCFcOXjtjMVAPs1I2TcPGvVTRVGeo2YswJ1G7qALSkhueWGrdJ+lOI0B0pF0DZEVorwsg
	 WuZ99zcUke+gzq+Vq/rMtU1+qg7r7cYBa7Dul2Bgom52b6NxXoAWwE95M+NsAVh1Dgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933090;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=GLSIPHQWl9F3PRzOpIFGBe0319Lzoq++2NVfjsq1w0s=;
	b=SfPU2G0GY1u8F7GvfYRiRdEdlNbfhOQAuSFBfgb/J3Ng39R+y7lQIdTmcGRpZfDBhZaT
	 MRJvNpz6ENCbaxhciiEj2eKuwbZfTonoUz/XvnEgzIy715vvkEALngCd0xUbhn9vOiYoO
	 j87P18C4Y5IRkmVoOUZOOuruFvSJ1uoqHZywmz/Wrfqx7MVt1puj29DPrD0HAc2Ff+V+P
	 giBSJ9yJ+/YB1HP17A0rDee99f/AUy4HkXsV6/JbtSC9HVThReTPAqwgf8KiAB3mCKlZy
	 SEA8YMD4tqIZijGp8FCitQR2v0QjEuyd5z4PneDvG9iEMGKcsg1MpnUAd9v8qnDvbUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aJmsKukt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1377E606A31B;
	Sun, 25 Oct 2026 12:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aJmsKukt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D691F01825;
	Sun, 25 Oct 2026 12:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792933089;
	bh=GLSIPHQWl9F3PRzOpIFGBe0319Lzoq++2NVfjsq1w0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aJmsKuktCl8do4ZM+X0KEpZIWVXAZuTyBlX+kW2PYmlnHIfBfGQfS/bsZramkOUu8
	 KahUE9YvtPC6vNVYsawtj+e0RWQSQKVjqmWxY5srcARTremgbQu3TIy8PYz7nau91C
	 cCjRazyhAXdSNWeBoIW3rLSfB4yIdav8zzWzPung=
Date: Sun, 25 Oct 2026 13:58:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
Message-ID: <2026102555-exponent-monogamy-5bc5@gregkh>
References: <20261024064731.125251200@linuxfoundation.org>
 <a65e25c3-b1ea-4b8b-bf3b-c5de0d069b22@pobox.com>
 <c2227d20-c533-47ad-8446-aa0838f7c0be@pobox.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2227d20-c533-47ad-8446-aa0838f7c0be@pobox.com>

On Sat, Oct 24, 2026 at 11:08:02AM -0700, Barry K. Nathan wrote:
> On 10/24/26 7:32 AM, Barry K. Nathan wrote:
> > On 10/23/26 11:59 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 7.2.13 release.
> > > There are 243 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-rc2.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > With 7.2.13-rc2, each time I go through a suspend/wake cycle on my Lenovo
> > ThinkPad T14 Gen 1, the following line appears in dmesg:
> > 
> > (NULL device *): Direct firmware load for i915/kbl_dmc_ver1_04.bin failed with error -2
> > 
> > This is new and appears to be a regression, and it is 100% reproducible.
> > It does not occur with 7.3.0, 7.2.12, or 6.18.59-rc1. I will start
> > bisecting it shortly after I send this email.
> > 
> > In case it's relevant, my ThinkPad T14 Gen 1 has an Intel Core i5-10310U
> > CPU (Comet Lake-U), and it's running an up-to-date Debian trixie.
> 
> It bisected down to these two patches:
> 
> fs-add-umh-argument-to-struct-kernel_clone_args.patch
> fs-stop-sharing-fs_struct-between-init_task-and-pid-1.patch
> 
> That is, with all of the patches prior to fs-add-umh... the bug does not
> reproduce. With fs-add-umh... the 7.2.13-rc1 boot problem happens, and
> adding fs-stop-sharing... fixes the boot problem, but now I have the
> new message when suspending.
> 
> dmesg context before and after the new message (should've included this
> in my previous email, sorry):
> 
> [   55.793416] PM: suspend entry (deep)
> [   55.825734] Filesystems sync: 0.032 seconds
> [   55.825812] (NULL device *): Direct firmware load for i915/kbl_dmc_ver1_04.bin failed with error -2
> [   55.826364] Freezing user space processes
> [   55.827740] Freezing user space processes completed (elapsed 0.001 seconds)
> [   55.827744] OOM killer disabled.
> [   55.827745] Freezing remaining freezable tasks
> [   55.828885] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
> [   55.828941] printk: Suspending console(s) (use no_console_suspend to debug)
> 
> Except for the new "(NULL device [...] error -2" message, all of the
> others are the messages that normally appear when suspending.

Ok, let me go drop all of these patches and push out a -rc3, thanks for
testing and letting me know!

greg k-h
