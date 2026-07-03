Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8F22857F0;
	Fri,  3 Jul 2026 05:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783057085; cv=none; b=Fq1Qk2830B13mgnfMUbuD+c1kCzCCBXalB6rHFAIGVdp/m7PZGy2hTwHjNYtmAdQjRPup4hhDDZkbhkk4rM2fWZm715M6faGacEiGrTehlYyH/dIsuAQdukrHNZUN5syThdiznU6WEhDm3rY8DH46eGb+bUmcrG0n5x551IXEbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783057085; c=relaxed/simple;
	bh=DCR6ZYxlzYYAtxzAfCQ0MViqSJzBGX/3lGgM73udkSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQ8JT7lIdXolKkWPhjr+xZP9aM7bYsw4rYh6GXJgjxBR3NYmSmDaqr5EHdJnLNh71Zl9ESlDbgV/uB5lhicYPJgxtZULSv2lj2cTnfBPdDHnpwU90pVZ7Xas0skgXDsxxF6Zc/ZjcWmMDgDW9ymoVmMAKL2/rmbgmSlIjnRZ5as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oR6gi2fk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oR6gi2fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E341F000E9;
	Fri,  3 Jul 2026 05:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783057084;
	bh=M7kJGpHUevpDgZJOPKLrEaRXTnWAx7jiwkscngfQ+l4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oR6gi2fkOycewFZxL1xcEmRMIgKbCV41FDqzR2zbnwtBHEP1N8LL7Q0wuayZ7lHmC
	 u9F7vHYUkueyr5kO1vTiPRc8VCIh+qBRpIdlJXxUqWiunyyxSoC7Bzencbttw3/pof
	 p40AY9zp7HdXt/q1vpk+Ddb3MxQsUlwT1ZNUnI+4=
Date: Fri, 3 Jul 2026 07:38:14 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
Message-ID: <2026070302-cramp-casually-fce6@gregkh>
References: <20260702155112.964534952@linuxfoundation.org>
 <20260703001546.13180-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703001546.13180-1-ojeda@kernel.org>

On Fri, Jul 03, 2026 at 02:15:46AM +0200, Miguel Ojeda wrote:
> On Thu, 02 Jul 2026 18:19:56 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 7.1.3 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> > Anything received after that time might be too late.
> 
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> for loongarch64 and arm32:
> 
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
> 
> It would be nice to get this one in for 6.18 and 7.1:
> 
>   3fff4271809b ("rust: str: clean unused import for Rust >= 1.98")

It will get there eventually, my backlog right now is huge...
