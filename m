Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A6B283FF4;
	Tue, 24 Jun 2025 10:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760914; cv=none; b=M/cKgFHG+C3IzF+/NEbDtdDmCbYTzgHXJIDglgyx7p7L0BWnwIdzRBuRcO9y8pYyLgZ0yXT++SEZsaY8IbeVcW6iTrR4XfxkxBGOjqEOqQBV5kr03MovOhk4Kz/Ii+jHXfy9AkNGXj9qGXNFsrJb3oO9sxzAEFMRE8AfwhAhMtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760914; c=relaxed/simple;
	bh=ZBzUsG/qQKog5oKKSVcBj/BlCEZeFpe0571S/xO//4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7Lip8x//wC32yz40lAbIQfDuP8RVv/+iengg3Enz24D5erCYhuCPkLqHdbrQjG4+RdnSK0e5xKXwkXiHMuCEPh5dR1DMKIuayDEmjHlYzlU7AeC+6l/t+QZCa6ggMEMJ1qC10CyoGOG6IeiAMLI4PJel7oUKi+cfmGBewGtwCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpatTivv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpatTivv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9BBC4CEE3;
	Tue, 24 Jun 2025 10:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750760913;
	bh=ZBzUsG/qQKog5oKKSVcBj/BlCEZeFpe0571S/xO//4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jpatTivvdiD8Wd550/1mDK2wTqexts+q09dEtJPv5JQwpCCM2ZsvvnqsO9INk+UN5
	 3zAXon2Exv1oqtlfC0fmnYupf5oWj9/c1Qlqjfv8kiEUTbHNNDHshluY+nLnxcJtmO
	 e28lLKszKAk+x8lDv6Sfc2BOIdr81Ea1jPRCApA0=
Date: Tue, 24 Jun 2025 11:28:30 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Darren Kenny <darren.kenny@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.6 000/290] 6.6.95-rc1 review
Message-ID: <2025062407-species-whole-8103@gregkh>
References: <20250623130626.910356556@linuxfoundation.org>
 <807b87ea-a46c-4513-9787-56b2dfb4ae32@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <807b87ea-a46c-4513-9787-56b2dfb4ae32@oracle.com>

On Mon, Jun 23, 2025 at 09:29:59PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 23/06/25 18:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.95 release.
> > There are 290 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build issue:
> 
> In file included from main.h:14,
>                  from cgroup.c:20:
> cgroup.c: In function 'do_show':
> cgroup.c:339:36: error: 'cgroup_attach_types' undeclared (first use in this
> function); did you mean 'parse_attach_type'?
>   339 |         for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++) {
>       |                                    ^~~~~~~~~~~~~~~~~~~
> 
> 
> 
> BPF tool build is failing:
> 
> 
> Culprit looks like:
> 
> commit: 27db5e6b493b ("bpftool: Fix cgroup command to only show cgroup bpf
> programs")
> 

Odd that 6.1.y isn't failing as well.  I'll go drop this from all
branches older than 6.15.y for now.

thanks,

greg k-h
