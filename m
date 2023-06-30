Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44975538C
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF62C433C8;
	Fri, 30 Jun 2023 06:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688107893;
	bh=bXxMTjgW+hjAU8Zr3U8MPiozOA/sFSQmjIUUsOcJZy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r85eumcuBGOV7SWEaIzN+R9ajMjt88Jel7PpBLClkQhUBmQN9MiUlRbchryDv4Q0h
	 PxqSwxeHL2oblOGbDQGcsKRDYwoLf6qMmujNbqG1OJjYV4EtzJXECrAzMDaTbxbfnl
	 /bqKorB+Z2Bd5IABqjhQ0eRQ+v9vJb4DfWunDSWA=
Date: Fri, 30 Jun 2023 08:51:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
	Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	linux-parisc <linux-parisc@vger.kernel.org>,
	sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
	Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
Message-ID: <2023063023-bulge-dispute-bf78@gregkh>
References: <20230629184151.888604958@linuxfoundation.org>
 <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
 <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net>
 <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>

On Thu, Jun 29, 2023 at 11:33:45PM -0700, Linus Torvalds wrote:
> On Thu, 29 Jun 2023 at 23:29, Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > Did you see that one (in mainline) ?
> >
> > Building csky:defconfig ... failed
> 
> Nope. Thanks. Obvious fix: 'address' is called 'addr' here.
> 
> I knew we had all these tiny little mazes that looked the same but
> were just _subtly_ different, but I still ended up doing too much
> cut-and-paste.
> 
> And I only ended up cross-compiling the fairly small set that I had
> existing cross-build environments for. Which was less than half our
> ~24 different architectures.
> 
> Oh well.  We'll get them all. Eventually. Let me go fix up that csky case.

Thanks, I've picked that up now as well.

greg k-h
