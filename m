Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE56521128F;
	Wed, 22 Jan 2025 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737542588; cv=none; b=ZKtPvy/qIkW+Qjh5zBgBFH+1WBcTgldXQiSfkfLVQmN9fNfXp8nrEl7wk9HBKcRTzDBIi/Hlps7FR+OUbQAsh+3R/32r+yw/W0sqirUc0U0iAPk40AcNy43vpe8F3Udy3L5iSF27PNWLPGU6c8VKppedPtTLfwJNwuNCyUimNIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737542588; c=relaxed/simple;
	bh=6RK2LSMv+0Q68//4QWU/qbuMfzriSHOefcNBL78JN3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTFoaI+HvfKpLuTqIRMc0ePj8wSd/S68C3DM48Tbmzjl6FWQW0w8Kk5mih+Oa+BgozsJvaQvIQoJg8q3eT1oLOodMy2kdhgcfebIKjF6Pey8CXBtAGyCIG8y7g+dAMw+Jq861Omv8RLPoELefmbbG16R9RyNK5reCVaPinq4++s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U7AXiQIx; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U7AXiQIx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=cFQniLK3zVbqj8SwwGlEr5FmYpVT2AWUKFfFET2fIVE=; b=U7AXiQIxK2UMiPMF+Da3N2fDiG
	/rF5KSjQfanzF6UuKrmKEkCshMMzeE0uK54Gr446/iKMgiObv08xdKILbdoeBhklei6gm2eCxFOln
	aBQzp3of7vUO+fWuxPjk8PDid45yJFc5TS1pf7nNk3Mun+btzlLw5m7CbmZ5ozpIUm5e8sHYsTNJa
	Uv3N1dnZSoDJLfTW3znpAr5SuFQDTZXG2olDT3/I3N1ouByIPQdcAnpQc4Nu+oNlVFkV9In0YMAw8
	12tg2sCNtblze4nPnLvdprj+c5EIwTPvjv9gLdi4ejYEhpwAw0wgJiyzSQerA8jq+BmE1cjbGuNTn
	vof9vCsQ==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1taYCJ-0000000DXr3-1Urp;
	Wed, 22 Jan 2025 10:42:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E6157300599; Wed, 22 Jan 2025 11:42:58 +0100 (CET)
Date: Wed, 22 Jan 2025 11:42:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
Message-ID: <20250122104258.GJ7145@noisy.programming.kicks-ass.net>
References: <20250121174532.991109301@linuxfoundation.org>
 <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>

On Wed, Jan 22, 2025 at 03:34:16PM +0530, Naresh Kamboju wrote:
> On Tue, 21 Jan 2025 at 23:28, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.11 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> Regressions on arm64, arm, x86_64, and i386.
> 
> The following build warn
> WARNING: CPU: 1 PID: 22 at kernel/sched/fair.c:5250 place_entity
> (kernel/sched/fair.c:5250 (discriminator 1))

Odd, are you seeing the same on .13 ?

