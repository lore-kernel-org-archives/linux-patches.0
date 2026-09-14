Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CE441DDEA;
	Mon, 14 Sep 2026 09:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377550; cv=none; b=M+kyhbu4I9KCDIH0GhHtDlgfULd670iwIIcZhXK0re7vB+FzWUAmWMPyQPY9otR3Vl3Vq+6sQI+lm4E5RPXLxS7K20LxIfWtaAeZlDgNfUK/MztJcu7RrtOgOwSuVuepaRx0inOaMCmVVlbBL3yZpne/TSefHG6hq7OfoOjoX3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377550; c=relaxed/simple;
	bh=zgHNssUAU7P6eNdP3GzHYgOH+o0aGipgW2wMtrhfn4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ebaoc+5XXJMnBhRtw6dCp/grRQHvOEIuZFJ5EedyoSN2oJgFdZL8tBeUC+WvUuu9fjxCB3EMrCKf07gc+v8AqI+yPSYEmKqQmAMbXVyt6/3CUkDgmFASYPF6QnoJps0kfbHn/7X4m+hPvQTuDBAIQY8rZk0IXXrzO2h3KsHWSHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbY2Uou8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbY2Uou8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A771F000FF;
	Mon, 14 Sep 2026 09:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789377546;
	bh=yX8V2mP8O1NdNarEn3J4AGxExpZl1EtOkA4r2T5UKqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=vbY2Uou8n6fuwvRotBVqzMQvokDZhXQIutK6quBbvDFUWmUCgu/WmAuyzBOdBLVga
	 aArnxdmJWym2uICWFr63OqbVL/Bn4AVtOL6UJhUY4U4cpZLPaYVeWvbLzaNimMtzM+
	 3lY1Hq9a1YmPLs0R6dX8hh7htlcq02F9seLh5ODA=
Date: Mon, 14 Sep 2026 11:18:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Boortz <bennib@mailbox.org>
Cc: Thorsten Leemhuis <linux@leemhuis.info>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
Message-ID: <2026091443-silenced-maximum-c398@gregkh>
References: <20260912065648.999753832@linuxfoundation.org>
 <5babfab4-ebf7-42b8-88f2-ac2f5b6b2d7f@leemhuis.info>
 <aqabqJHW_tHhQn3v@bb-82jq>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqabqJHW_tHhQn3v@bb-82jq>

On Sun, Sep 13, 2026 at 02:54:39PM +0200, Benjamin Boortz wrote:
> On Sat, Sep 12, 2026 at 12:18:56PM +0200, Thorsten Leemhuis wrote:
> 
> > On 9/12/26 08:29, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 7.2.6 release.
> > > There are 1815 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > [...]
> > 
> > My builds failed while compiling perf:
> > 
> > > > ui/browsers/hists.c: In function ‘evsel__hists_browse’:
> > > > ui/browsers/hists.c:3191:41: error: ‘hotkey_act’ undeclared (first use in this function)
> > > >  3191 |                                 memset(&hotkey_act, 0, sizeof(hotkey_act));
> > > >       |                                         ^~~~~~~~~~
> > > > ui/browsers/hists.c:3191:41: note: each undeclared identifier is reported only once for each function it appears in
> > Reverting "perf ui hists: In report UI ensure thread is set with
> > reference counting" fixes this. Haven't tried, but maybe including
> > bd86119c3ee6ed ("perf ui hists: Fix dso_filter reference leak and exit
> > zoom cleanup") will fix this, too.
> > 
> > That got me a little further, but then I ran into this:
> > 
> > > > tools/perf/util/python.c: In function ‘pyrf_evsel__open’:
> > > > tools/perf/util/python.c:1104:9: error: implicit declaration of function ‘CHECK_INITIALIZED’ [-Wimplicit-function-declaration]
> > > >  1104 |         CHECK_INITIALIZED(evsel, "evsel");
> > > >       |         ^~~~~~~~~~~~~~~~~
> > > > tools/perf/util/python.c: In function ‘pyrf_evsel__set_tracking’:
> > > > tools/perf/util/python.c:1295:9: error: implicit declaration of function ‘CHECK_INITIALIZED_INT’ [-Wimplicit-function-declaration]
> > > >  1295 |         CHECK_INITIALIZED_INT(pevsel->evsel, "evsel");
> > > >       |         ^~~~~~~~~~~~~~~~~~~~~
> > 
> > Only looked briefly, but didn't spot a simple way to work around that
> > through a simple revert or two (but it's quite likely I missed something).
> > 
> > Ciao, Thorsten
> > 
> 
> 
> build-tested and reproduced the 2 issues on x86_64 with:
> 
>   make -j$(nproc) -C ./tools/perf O=/tmp/perf-build
> 
> observed errors:
> 
> 1) tools/perf/ui/browsers/hists.c:3191:41: error: 'hotkey_act' undeclared
> 
> 2ec3b9858725 — "perf hists browser: Increase MAX_OPTIONS to prevent stack buffer overflow"
>   prerequisite: bd86119c3ee6 expects MAX_OPTIONS=32; stable-rc still has 16
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2ec3b985872594031cc1000b830344de5c26633d
> bd86119c3ee6 — declares hotkey_act, fixes dso_filter reference leak
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bd86119c3ee6ed7b8fc9be8298fe49f1a5355a46
> 
> 
> 2) tools/perf/util/python.c:1104:9: error: implicit declaration of function 'CHECK_INITIALIZED'
> 
> 01fa2d416ace — defines CHECK_INITIALIZED
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=01fa2d416aceab51f97ec2769e8da9971a605eeb
> 
> 
> With the 3 patches applied, perf build successful.

Thanks for that, it fixes it for me too, I'll go queue these up now.

greg k-h
