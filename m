Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4068E85260;
	Fri, 31 Jan 2025 08:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738313883; cv=none; b=B1nIFpkDz/Wfzqvzq3VencY1cj3TOymhEMylXq4ROcW+5RbaUILXuls3EDjhgO7SYomLJCDTfDLILlZL0bVx79xkXWBhgsO5AbKdz8u1x5Wxq37FdFEA6I4klNc44A9gnHG5hmgVnlc6hGGInWtXJEWMvMiHtBO8piWYX6D2D84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738313883; c=relaxed/simple;
	bh=Ke0OtWaw3nBc5yKiSB9Rrj6dgZ0fJCmtQG3icWWYdjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isqK2M6jqrat4NLfzHhEoDN61LlKMcMs6zBZMoASuwDsPj0AoWVRXhFM9u2hWuQUCKHv8+8eFbMArOtbRXV0pOmHN4ngKffPwHOr6fyukHIubrYRcH1vFrfDpuXfvJvpc8HiICNelS09OXXIKNLP3GT/9mzdL4uOjArtIPWy4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lD420rQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lD420rQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30691C4CED1;
	Fri, 31 Jan 2025 08:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738313882;
	bh=Ke0OtWaw3nBc5yKiSB9Rrj6dgZ0fJCmtQG3icWWYdjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lD420rQQnwrQ/1ZsyGIUz299vGxdItX/pzbW8LZdGoGokJlnpRhJidQft92EL36U3
	 MKHGit6UUzxAVLVmBatZvZ10bN/MJyRNJuGXX0y1Dnxe1mh46ofamxX08kLBF9Hupy
	 05HYZGG1TJSDNLMoTXTEwhCAhaZaMMNM4dwzIMRU=
Date: Fri, 31 Jan 2025 09:58:00 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
Message-ID: <2025013151-embody-unmade-1791@gregkh>
References: <20250130133456.914329400@linuxfoundation.org>
 <0fe1555d-855d-4fab-970f-69bd7119946d@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fe1555d-855d-4fab-970f-69bd7119946d@gmail.com>

On Thu, Jan 30, 2025 at 02:06:17PM -0800, Florian Fainelli wrote:
> On 1/30/25 05:58, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.1 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> cpupower does not build on 6.13 because this fix made it too late:
> 
> 3075476a7af666de3ec10b4f35d8e62db8fd5b6d ("pm: cpupower: Makefile: Fix cross
> compilation")
> 
> Do you mind picking it up so 6.13.1 builds without any special configuration
> required on my side?

Sure, now picked up, thanks.

greg k-h
