Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EB31D8DE2;
	Tue, 15 Oct 2024 11:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728990862; cv=none; b=ryrkKS10rrE6ol2akOI2kwVk/3MsDY4AOT37y9fzDprrmoXeUJGdsuElBhyiyzaa1PPJs2qygylQl8HAdLl0Z/DNUTfFUJWUZy9PJJLE4H0RbgA78BN8twyFUAnckiTPuOThcFzw6fYQWgAMhqiYbGClwAnXAlkWVIZgJL32xNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728990862; c=relaxed/simple;
	bh=Ww7I9qP9b+gQT6n8y5YBtyJZUxROCz7Fcg7oOE0SK0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OB22Oyg3r297yyXq2TQx0Tg3auEm8ZpBd7OK5Rr4ImVAaiZPiTN3qtWU5gn9ytNRNNA5tL5QFLuuaC/gxW8EjRKfzON5urfAKjDL/WNORTDXaUOa+Zh0fL+IufNpxvPBKzvdwKGmr1qzUZfsy/Uh+he0Y5ShSoTPxrnInsfrnUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SE1f2BDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SE1f2BDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D607C4CEC6;
	Tue, 15 Oct 2024 11:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728990861;
	bh=Ww7I9qP9b+gQT6n8y5YBtyJZUxROCz7Fcg7oOE0SK0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SE1f2BDD/RciteVCvrKm+seK1CXQDh5xrSyicPArx0Q/OJU22BkSaoTT/RRSTk8Zs
	 Fk8tlDglHip8qZt53zvfwzVHkirIiKYMsjHRxSM5N52jH1+mHvG1iEpsiqE22Dtj9X
	 zAW5rbWubeCnABr2rpT4q4BRjpXVzULc12CKuX2c=
Date: Tue, 15 Oct 2024 13:14:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	linux-s390@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
Message-ID: <2024101509-cesspool-sensation-f3f3@gregkh>
References: <20241014141217.941104064@linuxfoundation.org>
 <CA+G9fYuaZVQL_h1BYX4LajoMgUzZxJUH5ipdyO_4k36F62Z5DA@mail.gmail.com>
 <20241015095013.7641-H-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015095013.7641-H-hca@linux.ibm.com>

On Tue, Oct 15, 2024 at 11:50:13AM +0200, Heiko Carstens wrote:
> On Tue, Oct 15, 2024 at 02:23:32PM +0530, Naresh Kamboju wrote:
> > On Mon, 14 Oct 2024 at 20:20, Greg Kroah-Hartman
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > The bisection pointing to,
> >   73e9443b9ea8d5a1b9b87c4988acc3daae363832
> >   s390/traps: Handle early warnings gracefully
> >     [ Upstream commit 3c4d0ae0671827f4b536cc2d26f8b9c54584ccc5 ]
> > 
> > 
> > Build log:
> > -------
> > arch/s390/kernel/early.c: In function '__do_early_pgm_check':
> > arch/s390/kernel/early.c:154:30: error: implicit declaration of
> > function 'get_lowcore'; did you mean 'S390_lowcore'?
> > [-Werror=implicit-function-declaration]
> >   154 |         struct lowcore *lc = get_lowcore();
> >       |                              ^~~~~~~~~~~
> >       |                              S390_lowcore
> > arch/s390/kernel/early.c:154:30: warning: initialization of 'struct
> > lowcore *' from 'int' makes pointer from integer without a cast
> > [-Wint-conversion]
> > cc1: some warnings being treated as errors
> 
> Same here, please drop this patch.
>

Now dropped from 6.1.y and 6.6.y, thanks!

greg k-h
