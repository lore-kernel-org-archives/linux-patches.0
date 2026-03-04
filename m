Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4EE372673;
	Wed,  4 Mar 2026 13:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631014; cv=none; b=e7LjQaw51Acts+muNQIaRIlNGmfz8jopthuA73lIDS0+rkKUC7Y1oBSw9QvNWryjZoDn+fTaTmv+fsCaPoBJb/WrvGquTgkxBYK9aH7ctgbkW3uOCMj1482GdvZywFf8FVpZRZ2raXXxQ1VZmrifZMmhy1G8ED2YDon+o0rNwHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631014; c=relaxed/simple;
	bh=OA7sY5Gukki1t+dkD73vfKDLROh7QEw2JN22fFOoXto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvmdBvRlgoy1YDELQLKiQvxGkmPn/kaf0r54DaBJbnGVQQWNK6ggt+FSdP9wZo0S0K+m0ASiYLLQTMpD41XaoG8ngQi/rN/LlyDSEv5NFjd1X3mxNu23QPLs7HI78H+moASeGpUxoOwAeSvOUjUZBTG/k8hEaHY0gm4gHFFPTHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Wed, 4 Mar 2026 14:29:56 +0100
From: Brett A C Sheffield <bacs@librecast.net>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
Message-ID: <aagz1A1WCj2qBb4x@karahi.librecast.net>
References: <20260302160934.2521545-1-sashal@kernel.org>
 <20260302193559.3432-1-bacs@librecast.net>
 <aafiF3Mtc17i7Y72@auntie>
 <aagiQjT1eBGEHV--@laps>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aagiQjT1eBGEHV--@laps>

On 2026-03-04 07:14, Sasha Levin wrote:
> On Wed, Mar 04, 2026 at 07:41:11AM +0000, Brett A C Sheffield wrote:
> >On 2026-03-02 19:35, Brett A C Sheffield wrote:
> >> # Librecast Test Results (FAIL)
> >>
> >> 020/020 [ OK ] liblcrq
> >> 010/010 [ OK ] libmld
> >> 120/120 [ OK ] liblibrecast
> >>
> >> CPU/kernel: Linux auntie 6.6.128-rc2-ge6906aa7f5ea #1 SMP PREEMPT_DYNAMIC Mon Mar  2 17:31:27 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux
> >>
> >> Builds, boots and passes network tests.  Fails to poweroff.
> >>
> >> Bisects to commit 3ba77c48498f0fa29456e2435d7d49eafc0a279c (upstream 4589712e0111352973131bad975023b25569287c) and affects 6.6.y and 6.12.y. Other kernels are unaffected, including mainline.
> >
> >Are we dropping the offending commit from 6.6.y and 6.12.y and retesting?
> 
> Yup, I'm going to drop it from both trees.

Thanks.

-- 
Brett Sheffield (he/him)
Librecast - Decentralising the Internet with Multicast
https://librecast.net/
https://blog.brettsheffield.com/
