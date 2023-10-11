Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3BB6106
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 09:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYFI10E6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2947BC433C8;
	Wed, 11 Oct 2023 09:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697015097;
	bh=KdSwyFFB1qrpPOFhVid5Br7z5KX419xUQhDpNZ+9iGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DYFI10E6rTZHU1cRCUy+vOuDx+AO8H+pW0nifwCknpDkbnvmO+KwvRTdMVL24WgoM
	 tVHzWpegLxTNE3sgq4qppwp80X8u/PW+A3hRqAjeSQleVXSKz+BgvxE6644NKpx3IH
	 RxsBxS0ST1PO8VuGDPHXSSM3MAeZ3iY4tevYRlZc=
Date: Wed, 11 Oct 2023 11:04:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de,
	Mark Rutland <mark.rutland@arm.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4.19 00/29] 4.19.282-rc1 review
Message-ID: <2023101132-playable-flagstick-1abf@gregkh>
References: <20230424131121.155649464@linuxfoundation.org>
 <CA+G9fYstB_fROK9LHYuQ8dc2ArieGGAW_x69eEX-eAi5xMeE3Q@mail.gmail.com>
 <20230426170945.0ec0f1ef@gandalf.local.home>
 <20230426181415.17c893f5@gandalf.local.home>
 <CA+G9fYtd=dJEM=+xOHA9Egs88r+gEfrnW_gFnTFm4of5uTQ7mA@mail.gmail.com>
 <CA+G9fYt518bg10DVo=ag=iGB8dj_NQZEmEty1CdkU3Cj+gtW0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt518bg10DVo=ag=iGB8dj_NQZEmEty1CdkU3Cj+gtW0w@mail.gmail.com>

On Wed, Oct 11, 2023 at 06:59:46AM +0530, Naresh Kamboju wrote:
> Hi Steven and Greg,
> 
> On Thu, 27 Apr 2023 at 15:19, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > Hi Steven,
> >
> > On Wed, 26 Apr 2023 at 23:14, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Wed, 26 Apr 2023 17:09:45 -0400
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > > Now the question is, why is this triggering on 4.19 but not in latest
> > > > mainline?
> > >
> > > I found it, I backported this patch and the warning goes away (at least for
> > > me). Can you add this and see if it makes the warning go away for you too?
> >
> > I have applied this patch on stable-rc 4.19 branch and tested on
> > - arm64: Juno-r2
> >  - x86_64 device
> >
> > and the reported problem has been resolved.
> >
> > Thanks for finding a quick fix patch.
> >
> > >
> > > -- Steve
> > >
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > Date: Fri, 7 Aug 2020 20:50:19 +0200
> > > Subject: [PATCH] sched,idle,rcu: Push rcu_idle deeper into the idle path
> > >
> > > commit 1098582a0f6c4e8fd28da0a6305f9233d02c9c1d upstream.
> 
> Can we expect this patch to be merged into 4.19 ?
> The reason for the question is, the reported problem is still seen on
> stable-rc 4.19.

Ok, I'll queue it up now, I didn't realize it needed to be there, sorry.

greg k-h
