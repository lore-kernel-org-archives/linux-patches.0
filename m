Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282195B5AB;
	Fri,  6 Feb 2026 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770383888; cv=none; b=KGNjmHNT11DSXd3Q2fuwihlGe27wJxPJQMzkpVrNdOWh+fiLI7oDrDGKc4n7QU1rrEMotUfugVIeBOReoSO9dvD/Dc1WFQsF15uCveU3NSCGKdAMG85tXj315Wizh0bp/xqFd6OyF6yZxtTbJxQz/0ntDL1xpFBOh9mfzkwBhS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770383888; c=relaxed/simple;
	bh=f8yHgE4ymsyl9+mh++5Npa8yArm3D9qnM/5eaTm6niw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jk9OCfSeMW6JX/uSthY23GmcwCRifVAHHXsIcMcBwg8GHsesVApIWrJOxLnipNC7YcbxSH6mf+SO/8M38MSKWYBTS3b2mfD53OoNz6yzEysfHPOamvrhGk401thM4g+DtZv7y4mGB11W/clbQNcv+Rfg8VByi3JBPrDBI/Tnkhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJdHmsaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJdHmsaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A47AC116C6;
	Fri,  6 Feb 2026 13:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770383887;
	bh=f8yHgE4ymsyl9+mh++5Npa8yArm3D9qnM/5eaTm6niw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJdHmsaDNTLZ9MPn37WYYZnv8f9Q8KS3N5A1NIQmfBfJRCbrK71E4LnLkx+nxcLWz
	 36zIgleMyfyzXFco7TXr5mpJ7cjZ7z0EglVtnazXlP5dGvX0FM6oPpqYaqPGs/CDK1
	 3v7AaVVPIyV2dg8EPOmBfSb98IcF2rg1Nvpa3MGI=
Date: Fri, 6 Feb 2026 14:18:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/160] 5.10.249-rc2 review
Message-ID: <2026020646-lash-celestial-2c7a@gregkh>
References: <20260205143430.733102763@linuxfoundation.org>
 <CAG=yYwnDVbTB3Y+zX8yLATGRKeZzSXNu-eiU-ABReZhJ0vep3A@mail.gmail.com>
 <2026020619-eccentric-retaining-86ef@gregkh>
 <CAG=yYwkOvV_=hhzSkQ06UqUW2X_FOm6saGqBaz4hLxqAg_WcvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG=yYwkOvV_=hhzSkQ06UqUW2X_FOm6saGqBaz4hLxqAg_WcvQ@mail.gmail.com>

On Fri, Feb 06, 2026 at 06:29:08PM +0530, Jeffrin Thalakkottoor wrote:
> >
> > What config causes this?  What target are you building, libbpf?
> >
> 
> May be the attached config causes this. iam not building libbpf alone.

I tried your config, with gcc:
$ gcc --version
gcc (GCC) 15.2.1 20260103

And it built just fine.

I did have to do a 'make clean' first.  Did you try that out?

Have you ever built this kernel successfully?  If so, can you use 'git
bisect' to track down the offending commit for you?

thanks,

greg k-h
