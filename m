Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43ED29992B;
	Fri, 13 Feb 2026 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771000862; cv=none; b=saNWFas3qGtaHZdX0ZHjEbUrc/FksYVxGVTFuqCgbrJ2xVzhxkXCfUaspQKZBVQoV9Ee/N/VmAZvdtt2KMW3TUbsVkC5htadgIbNlHVOoPZssygU/wNiBQuvr1Rqcuxial73G68h+5Fhldd0ujgiCNCfLzfdIDZmLnZR4QoqikE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771000862; c=relaxed/simple;
	bh=xeR/60LbN62nVDCHbRH4pbO7J93R/K+jzqaV8eTbPqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJcBKpBbtR3xbHu0Q3Ao5RBj5H36Coo67mxbBB1jjGhqzEbUOEMwHzrkT2FwDyeB1FqV7ZrkXVPHgSOAB5qIGsmV6THm6mdcHRrqnbKjCWlTTkeHi9KRNAsf85h9q5RoVu6xkJm+47bguWAxAt+O8hJDKb18fuD8F3giovvZyh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhIKwz6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhIKwz6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E36C116C6;
	Fri, 13 Feb 2026 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771000861;
	bh=xeR/60LbN62nVDCHbRH4pbO7J93R/K+jzqaV8eTbPqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dhIKwz6NX2hZqJ3hDLRkvCpemiIYDlAjV7+zten8JJ/qVW+MLtDAL2mLEZFygJPm8
	 GeXhyDFj63f3Icyi1VE3j9CpB3E+mjBMu12zNlrBa4raNkEy7XGFLOqYuomJXSIRLb
	 RcBge4p5kbMHCoC6iBcSOsuchF85o34ZUqNmHQM8=
Date: Fri, 13 Feb 2026 11:41:00 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Achill Gilgenast <achill@achill.org>, helpdesk@kernel.org, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
Message-ID: <20260213-manipulative-proficient-robin-fc9c06@lemur>
References: <20260213134708.713126210@linuxfoundation.org>
 <DGDX0HGRJJ3N.1F1EWJEDMYZND@achill.org>
 <2026021312-magma-dormitory-53af@gregkh>
 <2026021325-repacking-crumpet-5861@gregkh>
 <2026021353-perfume-drum-3776@gregkh>
 <a856f911-c493-4c48-ade8-467d9da1f628@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a856f911-c493-4c48-ade8-467d9da1f628@googlemail.com>

On Fri, Feb 13, 2026 at 05:26:51PM +0100, Peter Schneider wrote:
> > > Ok, pushed again from my side, let's see if it propagates properly
> > > now...
> > > 
> > 
> > It's a kernel.org mirror issue, it's being worked on right now...
> 
> It seems only the tarballs are affected?! I could git pull this RC just fine
> some 10 minutes ago and build it. Adding Helpdesk and Konstantin in...

It's back in the world of living after a 2-disk RAID6 failure, an LVM cache
removal gone wrong, lots of futzing with /etc/lvm/archive contents, lots of
very heavy swearing in all languages known to me, and lots of nailbiting
as the RAID array rebuilt over 18 hours.

> The 404 is funny though, kudos to whoever made this :-))

Oh, yeah, I totally forgot about that one.

-K
