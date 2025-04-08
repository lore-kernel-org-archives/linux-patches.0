Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B2C1ADC8D;
	Tue,  8 Apr 2025 15:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125540; cv=none; b=PQ4mJRuZaVAqO9Uqv/li2rH0h4ClM03J7h82nJuBJ1KUzAPYbfh5D9ERCR1JrdpPOl2eHY+mr10D/xnk5Fh4jrQXEU3/XnZ9yzBOH+SoNnXlTQdB7EAqG2ACr5SZjjd2XfKou3IIwcI73DrRDE5btSL1q8RG2MJN67eob4LDGRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125540; c=relaxed/simple;
	bh=5UoJUCBT3LAaHEfHe9iTZOH67O24WbB9WsSvXP1s2hA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b71Gw2h+vF7MjnUz0SDzbBRzyQ/UKkvqop66dy6RTyNPjLtozURFZTB8JBgvKTZ3IZcZ4yoSPcwAlrC0VAIEprydfwXDJzxsWoSFM2o7FyZdmmxl09bAh8q3U4MmjezEfPlbikEdsY5xzCsKl2SEDIBCn6ep5j58Jd/1IvhkFXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr4PbX8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr4PbX8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C62DC4CEE5;
	Tue,  8 Apr 2025 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744125540;
	bh=5UoJUCBT3LAaHEfHe9iTZOH67O24WbB9WsSvXP1s2hA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fr4PbX8HNhnunVIWXCWIz4V6g1mV9B0LLvyZ+/RYDaHReGUVB5dEfDb9gsAWyVOG+
	 TZ05f5iSPywTAG/U5ex7OOG+B3xdVJ6pu+896gN/UY8a1Sx7M9aEagkfg85jFDmmcK
	 ISYlZuxvNSN5w11FR2z0ONClaTack/zG0f7BIaug=
Date: Tue, 8 Apr 2025 17:17:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ian Rogers <irogers@google.com>
Cc: Thorsten Leemhuis <linux@leemhuis.info>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Justin Forbes <jforbes@fedoraproject.org>,
	Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 6.13 000/499] 6.13.11-rc1 review
Message-ID: <2025040818-iodine-theater-7e1f@gregkh>
References: <20250408104851.256868745@linuxfoundation.org>
 <7d11f01f-9adc-467c-95bc-c9ff4bbf6a0f@leemhuis.info>
 <CAP-5=fVCADCyXeeLZT4EpU1OtOxMKB8omf5FFpDHmKgOWetW2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP-5=fVCADCyXeeLZT4EpU1OtOxMKB8omf5FFpDHmKgOWetW2A@mail.gmail.com>

On Tue, Apr 08, 2025 at 08:07:09AM -0700, Ian Rogers wrote:
> On Tue, Apr 8, 2025 at 6:09 AM Thorsten Leemhuis <linux@leemhuis.info> wrote:
> >
> > On 08.04.25 12:43, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.13.11 release.
> > > There are 499 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> >
> > Compiling for Fedora failed:
> >
> > util/stat.c: In function ‘evsel__is_alias’:
> > util/stat.c:565:16: error: implicit declaration of function ‘perf_pmu__name_no_suffix_match’ [-Wimplicit-function-declaration]
> >   565 |         return perf_pmu__name_no_suffix_match(evsel_a->pmu, evsel_b->pmu->name);
> >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > From a *very very* quick look I wonder if it might be due to this change,
> > as it seems to depend on 63e287131cf0c5 ("perf pmu: Rename name matching
> > for no suffix or wildcard variants") [v6.15-rc1]:
> >
> > > Ian Rogers <irogers@google.com>
> > >     perf stat: Don't merge counters purely on name
> >
> > But as I said, it was just a very very quick look, so I might be totally
> > off track there.
> 
> Thanks Thorsten, I repeated the failure and reverting that patch fixes
> the build. Alternatively, cherry-picking:
> 
> ```
> commit 63e287131cf0c59b026053d6d63fe271604ffa7e
> Author: Ian Rogers <irogers@google.com>
> Date:   Fri Jan 31 23:43:18 2025 -0800
> 
>    perf pmu: Rename name matching for no suffix or wildcard variants
> 
>    Wildcard PMU naming will match a name like pmu_1 to a PMU name like
>    pmu_10 but not to a PMU name like pmu_2 as the suffix forms part of
>    the match. No suffix matching will match pmu_10 to either pmu_1 or
>    pmu_2. Add or rename matching functions on PMU to make it clearer what
>    kind of matching is being performed.
> 
>    Signed-off-by: Ian Rogers <irogers@google.com>
>    Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
>    Link: https://lore.kernel.org/r/20250201074320.746259-4-irogers@google.com
>    Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ```
> 
> Also fixes the build.

Now added to both queues, thanks.

greg k-h
