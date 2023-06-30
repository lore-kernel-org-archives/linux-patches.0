Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDADAD27
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276E3C433C0;
	Fri, 30 Jun 2023 06:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688106561;
	bh=+deePIa1085/REYZ8uHg602pH8rUsFTFyjfVM/LP49o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2oVEnUEH43h5OVHMbw6dEkdbXZUDVR15a3xLxuhBa7N0p6REOuKib7BsJaFP/yWGK
	 +9gfSzla00j3Zdz5UiQcNNYF1nCCYQZXyp/w1AgbgFCg1GNe24nrljY4nnQtgnRnwG
	 9a4V9zNM2b8k9ayVjp1c64twR3snP5JTFvQ30e3M=
Date: Fri, 30 Jun 2023 08:29:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, linux-parisc <linux-parisc@vger.kernel.org>,
	sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
	Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
Message-ID: <2023063001-overlying-browse-de1a@gregkh>
References: <20230629184151.888604958@linuxfoundation.org>
 <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>

On Thu, Jun 29, 2023 at 11:16:21PM -0700, Linus Torvalds wrote:
> On Thu, 29 Jun 2023 at 22:31, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > arch/parisc/mm/fault.c: In function 'do_page_fault':
> > arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared (first use in this function)
> >   292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))
> 
> Bah. "prev" should be "prev_vma" here.
> 
> I've pushed out the fix. Greg, apologies. It's
> 
>    ea3f8272876f parisc: fix expand_stack() conversion
> 
> and Naresh already pointed to the similarly silly sparc32 fix.

Ah, I saw it hit your repo before your email here, sorry about that.
Now picked up.

greg k-h
