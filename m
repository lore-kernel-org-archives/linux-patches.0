Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54036222580;
	Fri, 22 Aug 2025 08:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755850589; cv=none; b=RPT2qhwupzqlM+jRggCH+A4pxW7Ao1PiCzRL1jsDgAcgIXLbt+pJi8R6IA/4wSu0cgrWitm9ITxbMNxiUPqlvDj3lvjFS0h7ko/OgQfyK0T/LfRMTPWIvuA2hQOzMrqDDnunLf4bNXPYXo7w3TAdhai/qFgRfmB+2PxV3NxwDOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755850589; c=relaxed/simple;
	bh=b/vxIm0ScLDuYxESXResXplPHsWNapbvSWd5rO+Uj0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D8jON9x1qYQG5TCseDvgnFFHxknawmrwnlce7ItB8FVXb8oHle+Cd0VOFMaUofdim9B0tuoAZlsOuS0deMI22WW5MlBp1uadYBmVhdXvlNl65L7Pr5VY3BjfFy1jG8bYYrB1O73TDy76LMHlOtGfZWE70kD366azkwBSFCgGJRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKuLov9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKuLov9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179E2C4CEF1;
	Fri, 22 Aug 2025 08:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755850588;
	bh=b/vxIm0ScLDuYxESXResXplPHsWNapbvSWd5rO+Uj0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uKuLov9A4TJTzyPfgyNZXJPyjt/6rGkPbh33t2XGjzKv0hEsMCF9e9x1+NFe0Y/H5
	 MF4j/OShmDyJkaZA4p7PHWHcCE5tOGFuAJNhGvf2Mu7CJmx8tRFq1o2B9RASXyOhMX
	 kUqgozc4Kc9jd/uwfnc9mIxXaUVQAB5fgImH3Rjg=
Date: Fri, 22 Aug 2025 10:16:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.12 000/438] 6.12.43-rc2 review
Message-ID: <2025082231-upstairs-blinks-1f4e@gregkh>
References: <20250819122820.553053307@linuxfoundation.org>
 <63e25fdb-095a-40eb-b341-75781e71ea95@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63e25fdb-095a-40eb-b341-75781e71ea95@roeck-us.net>

On Thu, Aug 21, 2025 at 08:12:27AM -0700, Guenter Roeck wrote:
> On Tue, Aug 19, 2025 at 02:31:21PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.43 release.
> > There are 438 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 21 Aug 2025 12:27:16 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build reference: v6.12.43
> Compiler version: arm-linux-gnueabi-gcc (GCC) 14.3.0
> Assembler version: GNU assembler (GNU Binutils) 2.44
> 
> Configuration file workarounds:
>     "s/CONFIG_FRAME_WARN=.*/CONFIG_FRAME_WARN=0/"
> 
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> drivers/net/can/ti_hecc.c: In function 'ti_hecc_start':
> drivers/net/can/ti_hecc.c:386:21: error: implicit declaration of function 'BIT_U32'; did you mean 'BIT_ULL'? [-Wimplicit-function-declaration]
>   386 |         mbx_mask = ~BIT_U32(HECC_RX_LAST_MBOX);
>       |                     ^~~~~~~
>       |                     BIT_ULL
> 
> There is no BIT_U32 in v6.12.y. The same build error is seen in v6.15.11,
> which is also missing the definition of BIT_U32. Odd that no one seems
> to have noticed this. Am I missing something ?

I'm now seeing this as well.  I'm guessing no one else does arm32 full
builds anymore?  I guess no one cares about that platform anymore :(

I'll go revert the offending commit, thanks for letting me know.

greg k-h
