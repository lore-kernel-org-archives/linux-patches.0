Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2381E0DD9;
	Fri, 13 Dec 2024 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734099580; cv=none; b=ZR+Ncn8YMCZxFbao9xybkwBM/e0t8m46grCzzw8lowjiHhO3Ve4RAGwS/CwXmGDHOGBjLNrgUqT4ReJWdveOBLhsmhgAiIhymukDXxiritXwHsp7bSyaysLt+askHLHNPNeD5jlmXCggfw8Ddf2SHLvyCJS65UnRm9Eto+UHXG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734099580; c=relaxed/simple;
	bh=2MYBXKPqb/rjvc4glonJkSpvG0UrE6rRYZcWkbyKr2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tidByasdFTIN1OXTEG/qpr0hz7UQFsBCg4Dv+SPlnNtQKkcyDcLnHPJ8SXpeaCUj1cFbW8eIyqdP/Wy6GcL6UYSZeBG6JBrPZxQ5d/c58F0DZ2KmaqPj2fIumOJ0WnPc2vkFq6Ye449w7veBQAliIUmUT5sspW8au7YRc689nMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYob9Eo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYob9Eo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818B3C4CED0;
	Fri, 13 Dec 2024 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734099580;
	bh=2MYBXKPqb/rjvc4glonJkSpvG0UrE6rRYZcWkbyKr2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tYob9Eo2VpLXeGQIMTZY27wzrLdzhdl+DDfazbhVaXm84Twp7S7ntzQ0QATvJshQy
	 Ovbz6j5Sp1m2HGD5vktrFfxOwtVg5aUp4HPRJga5spztaTi3730O8H0JbtG9mqYWhw
	 b7WjszQwiqvC2iClUmmz60A5wZ7+N8hgecjsqSEM=
Date: Fri, 13 Dec 2024 15:19:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.4 000/321] 5.4.287-rc1 review
Message-ID: <2024121312-retrieval-stencil-d02d@gregkh>
References: <20241212144229.291682835@linuxfoundation.org>
 <975004ea-7eb0-4412-a9af-d10486df4bb7@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <975004ea-7eb0-4412-a9af-d10486df4bb7@sirena.org.uk>

On Fri, Dec 13, 2024 at 01:23:23PM +0000, Mark Brown wrote:
> On Thu, Dec 12, 2024 at 03:58:38PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.287 release.
> > There are 321 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> arm64 defconfig is failing to build with GCC 13 for me:
> 
> /build/stage/linux/arch/arm64/include/asm/memory.h: In function ‘__tag_set’:
> /build/stage/linux/arch/arm64/include/asm/memory.h:238:22: warning: cast from po
> inter to integer of different size [-Wpointer-to-int-cast]
>   238 |         u64 __addr = (u64)addr & ~__tag_shifted(0xff);
>       |                      ^
> /tmp/ccGiqYDV.s: Assembler messages:
> /tmp/ccGiqYDV.s:129: Error: invalid barrier type -- `dmb ishld'
> /tmp/ccGiqYDV.s:234: Error: invalid barrier type -- `dmb ishld'
> /tmp/ccGiqYDV.s:510: Error: invalid barrier type -- `dmb ishld'
> /tmp/ccGiqYDV.s:537: Error: invalid barrier type -- `dmb ishld'
> /tmp/ccGiqYDV.s:1132: Error: invalid barrier type -- `dmb ishld'
> /tmp/ccGiqYDV.s:1216: Error: invalid barrier type -- `dmb ishld'
> make[2]: *** [/build/stage/linux/arch/arm64/kernel/vdso32/Makefile:166: arch/arm64/kernel/vdso32/vgettimeofday.o] Error 1
> 
> I'm also seeing the 32 bit arm build errors Naresh reported.

Odd, it seems to work on clang here.  Any chance you can bisect this
down to find the offending change?

thanks,

greg k-h
