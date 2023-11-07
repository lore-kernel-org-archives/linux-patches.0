Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26EA38DD0
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 20:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNrpqd1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E5DC433C7;
	Tue,  7 Nov 2023 20:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699388496;
	bh=0ZrrlUoDaDnYyIbMCJ+OpPT6t/CuFoTIItvkmvLiM0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dNrpqd1p31hy95o3OLzLLZalzfvoirNfdbgMYo/3TCxQ6z2+IIx6YjixetYBq2eYT
	 KABA0Fe9sXU2J3xNWOC45HvNvzX1Px9ce8/y4yIip56e4BLY472avZ8qtsYrIrqloA
	 hIMSZK0ytpkh5HN9DcDLBW9u6w5GN7fJ/WCBD+oU=
Date: Tue, 7 Nov 2023 21:21:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
	mizhang@google.com, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 5.15 000/128] 5.15.138-rc1 review
Message-ID: <2023110717-saddlebag-reflected-ed93@gregkh>
References: <20231106130309.112650042@linuxfoundation.org>
 <2665d8bc-111c-45ca-a473-b1c892867e9c@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2665d8bc-111c-45ca-a473-b1c892867e9c@oracle.com>

On Mon, Nov 06, 2023 at 08:24:43PM +0530, Harshit Mogalapalli wrote:
> Hello Greg,
> 
> On 06/11/23 6:32 pm, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.138 release.
> > There are 128 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> > Anything received after that time might be too late.
> > 
> 
> I am seeing a build failure with perf:
> 
> tools/perf/util/evlist.c: In function evlist__add_aux_dummy:
> tools/perf/util/evlist.c:266:31: error: implicit declaration of function
> evlist__dummy_event; did you mean evlist__add_sb_eventâ€™?
> [-Werror=implicit-function-declaration]
>   266 |         struct evsel *evsel = evlist__dummy_event(evlist);
>       |                               ^~~~~~~~~~~~~~~~~~~
>       |                               evlist__add_sb_event
> 
> 
> I think we should drop these three commits:
> 
> 20a5799cae7dc perf evlist: Avoid frequency mode for the dummy event
> 7de783c81c7e7 perf tools: Get rid of evlist__add_on_all_cpus()
> 141ce9207068e perf evlist: Add evlist__add_dummy_on_all_cpus()

Thanks, I've dropped all of these from 5.15.y and 5.10.y now.

greg k-h
