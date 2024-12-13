Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94041DF263;
	Fri, 13 Dec 2024 12:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734093223; cv=none; b=EeHG/v33eBiPKPzNPYMng+RDXkiznEojqKJG3B8c4RBT/Rhc6S1cQ992h7wVq45uUL9mdGLZvm427X++Hk9H87q95p1Kb0NnkK2yofxwawRRsvQosa0oEGUdvMEiCjrhryCFobsy4GkGhEEOulO6JDd7u7omemKKgySNtbT/eYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734093223; c=relaxed/simple;
	bh=rAk3hly/a41J/LN5k9ck0LTmi7LASXJDC2AInbW23io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwdE/5IIzarBFoP6cY6DkjqPlq2+je0PfwfjIUNHaKbsvYdssC4nsGITClZ8SkPBEHC9+Re/0qlZ2Nq2jPDZb1a5W41UXwQ/pMo2fSnS1PkqvFmMOs0a9IXWqSpPohO1pj2NkfLwiDT5+KPSP+ZuDulwkokqLYxSPPeZnSLOqDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXczbFWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXczbFWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B46C4CED4;
	Fri, 13 Dec 2024 12:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734093221;
	bh=rAk3hly/a41J/LN5k9ck0LTmi7LASXJDC2AInbW23io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OXczbFWjD5QZpWETZv6EhqMmw+FBRwP6/UNlIDMnXl5QdpSRYs+1zQaGTEBK7unFA
	 GtGpQrIWnUNb8YmfWCFBfAE/JO1abNo2RN/6CtWmfFUg4+GZ1p3N30VQXabtAXnbUF
	 bpS/jfiDnRfJ2R7OS1LYEpKDDpIBYbydLlkyQwSU=
Date: Fri, 13 Dec 2024 13:33:38 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
Message-ID: <2024121342-fastball-batting-c80b@gregkh>
References: <20241212144349.797589255@linuxfoundation.org>
 <c356563b-4137-403f-9f0f-29e9b38512ce@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c356563b-4137-403f-9f0f-29e9b38512ce@gmail.com>

On Thu, Dec 12, 2024 at 01:38:31PM -0800, Florian Fainelli wrote:
> On 12/12/24 06:49, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.120 release.
> > There are 772 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
> BMIPS_GENERIC:
> 
> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> There is a new warning though:
> 
> scripts/mod/modpost.c:969:44: warning: excess elements in array initializer
>   969 |         .good_tosec = {ALL_TEXT_SECTIONS , NULL},
>       |                                            ^~~~
> scripts/mod/modpost.c:969:44: note: (near initialization for
> ‘sectioncheck[10].good_tosec’)
>   HOSTLD  scripts/mod/modpost

I thought I saw that but kind of ignored it, but in looking at it
further, it's not good at all.  Let me go fix this up, for some reason
we have "too many" entries in this list and so we could flow over the
end of the buffer here...

thanks,

greg k-h
