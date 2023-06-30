Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579433207
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55162C433C0;
	Fri, 30 Jun 2023 06:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688106760;
	bh=BPDk7H+jhHuLFprW64J6/fgB0XfVTAIjuo57afaHL1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hqrl+j6yUVvzd5yy01tfh4aj1nl0Bfoeruq5nxt1TUOmR6KjdyGVsbrz4mvsF/J/p
	 /GBo7GBGnk3mYZrbBV5SvwxaDyfwzGDRuO7SfSxcnBSB/ztGG9udF3BrRfYpDmbYFG
	 Rt0UFPBwYbNntQ+XvvL0YbtE1roZlUGGyR/wTjW0=
Date: Fri, 30 Jun 2023 08:32:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 00/29] 6.4.1-rc2 review
Message-ID: <2023063030-overgrown-unfunded-7523@gregkh>
References: <20230630055626.202608973@linuxfoundation.org>
 <CAHk-=when9OgPprG57O+DtVFM7X9_wb6x2h4Veq4Gu6TUvxyiQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=when9OgPprG57O+DtVFM7X9_wb6x2h4Veq4Gu6TUvxyiQ@mail.gmail.com>

On Thu, Jun 29, 2023 at 11:20:45PM -0700, Linus Torvalds wrote:
> On Thu, 29 Jun 2023 at 22:59, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Linus Torvalds <torvalds@linux-foundation.org>
> >     gup: add warning if some caller would seem to want stack expansion
> 
> Did you decide to take that one after all?

For now, yes.

> It's not exactly wrong, and it might help find any odd cases, but I do
> suspect you can get syzbot etc to trigger the warning. It's designed
> to find crazy users, and syzbot is - pretty much by definition and by
> design - one of the craziest out there.

I think the "crazy users" reports might be triggered sooner with stable
updates than from your tree as well, so this might be a early-warning
type system.  I am pretty sure at least one "distro" has enabled it in
their kernel already as well.

But if this starts triggering a bunch of warnings, and they are causing
problems, I'll drop it (and recommend you revert it in your tree too.)

I wanted to be "warning compatible" here for now to ensure the backports
were working properly.

thanks,

greg k-h
