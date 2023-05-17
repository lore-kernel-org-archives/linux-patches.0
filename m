Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DDDAD2E
	for <patches@lists.linux.dev>; Wed, 17 May 2023 08:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D46C4339C;
	Wed, 17 May 2023 08:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684312101;
	bh=Dk3FoDyyLxuyBINUs34Am5WqC6Ckf7i4P5ahfp4vBmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mXNT9PQdfqj5oEOTaB1+pMn1PrkbyvYRtTuhQc4us6r1FiPtpKQAhzFnzwN2JIfr5
	 r1K7CZJ3sofH0+G6vz8v83SO0SGrLr3SLuDunhNXwEeYfSat1G7d42U+553yZdlr3J
	 MElFjy+8mshbqgyIkAyHkaA7ZFBMVjHeMWaNZ2lE=
Date: Wed, 17 May 2023 10:28:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
Message-ID: <2023051756-shield-reenter-80fe@gregkh>
References: <20230515161736.775969473@linuxfoundation.org>
 <ZGNATKe3U0oXHICX@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZGNATKe3U0oXHICX@eldamar.lan>

On Tue, May 16, 2023 at 10:35:24AM +0200, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Mon, May 15, 2023 at 06:24:11PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.180 release.
> > There are 381 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> > Anything received after that time might be too late.
> 
> The build fails here with:
> 
> sound/soc/intel/boards/sof_sdw.c:187:6: error: ‘RT711_JD2_100K’ undeclared here (not in a function)
>   187 |      RT711_JD2_100K),
>       |      ^~~~~~~~~~~~~~
> make[7]: *** [scripts/Makefile.build:286: sound/soc/intel/boards/sof_sdw.o] Error 1
> make[6]: *** [scripts/Makefile.build:503: sound/soc/intel/boards] Error 2
> make[5]: *** [scripts/Makefile.build:503: sound/soc/intel] Error 2
> make[4]: *** [scripts/Makefile.build:503: sound/soc] Error 2
> make[3]: *** [Makefile:1828: sound] Error 2
> 
> I did mention it in
> https://lore.kernel.org/stable/ZFuHEML1r5Xd6S7g@eldamar.lan/ as well but I
> guess it felt trough the cracks back then.

Sorry I missed this back then, now dropped.  Interesting that almost no
other build testing caught this, it's a hard driver to enable...

thanks,

greg k-h
