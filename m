Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE26383C8E;
	Wed, 18 Mar 2026 11:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773834850; cv=none; b=NggIRQ6ySzYHIE4TBi6HzYocnA03JeC6eTYQBtq7R3PEdGpjkig21uWbYpAcETx7T2dkgCv2BFNAEbdPBnv9qRAtSu1kgMAbFWVlr/36HjPloXws5g1pGR9yUAYvC7thFAJQE40aON1lqIMXJF6OXhs6DMk9N95BHiQzBTA/SfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773834850; c=relaxed/simple;
	bh=xna2Qv5/4+vYiNyKiIvdpy6Tz/hk4ZsegI8AL++TUYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFqCGPEda1Cfyo7XS2y9eHbYpxDza0Xvny6/wJlsIt2X4vkIOO9Zx+FU+HlkiSBbNlUi1W0piDxUPF+7vYP9HdhjZE/O1FBRE5xGlh6xEfFvi3/A1+9clpGSB65Mwa3M8fmRUgqwZhwSa4NrXQppRDmuiWTRwsm4q/oS0ZyOPew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugjzPJgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugjzPJgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF4BC19421;
	Wed, 18 Mar 2026 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773834849;
	bh=xna2Qv5/4+vYiNyKiIvdpy6Tz/hk4ZsegI8AL++TUYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ugjzPJgQ7DRRP69RVdAJY8t3Uv9V1CwLtCVR84vqoLFGvTEVGID+/auVpthB2WT//
	 4Hb1EPt7hvDSeO/SU4dm/KzNOYS6fxqBY7knlmTrEijR1Pr6UCBbPXuqWhFFIWeVZv
	 Iy1lR4e46ibvP6zprKdttsvdozU5zTGbxyW30tYM=
Date: Wed, 18 Mar 2026 12:54:06 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ronald Warsow <rwarsow@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, conor@kernel.org, hargar@microsoft.com,
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/378] 6.19.9-rc1 review
Message-ID: <2026031858-ungodly-corrosive-37eb@gregkh>
References: <20260317163006.959177102@linuxfoundation.org>
 <10df8843-67e6-4830-955c-befc783f25df@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10df8843-67e6-4830-955c-befc783f25df@gmx.de>

On Tue, Mar 17, 2026 at 06:47:30PM +0100, Ronald Warsow wrote:
> Hi
> 
> compile runs in an error:
> 
>   LD      vmlinux.unstripped
>   BTFIDS  vmlinux.unstripped
> WARN: resolve_btfids: unresolved symbol kthread_exit
> make[2]: *** [scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 255
> make[2]: *** Deleting file 'vmlinux.unstripped'
> make[1]: *** [/home/DATA/DEVEL/linux/Makefile:1277: vmlinux] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
> 
> 
> if I do:
> 
> git revert f5ee297b23d843d4ae690595aa29e8f5baeaecf9 --no-edit
> 
> see:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-6.19.y&id=f5ee297b23d843d4ae690595aa29e8f5baeaecf9
> 
> 
> 
> all is fine here on x86_64 (Intel 11th Gen. CPU)
> 
> Thanks
> 
> Tested-by: Ronald Warsow <rwarsow@gmx.de>
> 

I've fixed this now, thanks!

greg k-h
