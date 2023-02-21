Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BACD1390
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 08:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4DFC433D2;
	Tue, 21 Feb 2023 08:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676968897;
	bh=57nqzfGVuxrkqL24yI5SeHglbUx3waJxyAiXPHGLbdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lHzC4OLEFGIys80zD/pQCH2fuDiUdlnvsl3GLh0UfFR/Pdv61iMbueMHz5AsKJFr3
	 famEkZo1wBPAq7Bl84fd18R5R/MxRCZpaFBB+xyBKza9LcoPcVzKkXzMDzll/89kqb
	 GXuDmcoFEZBUHfjsSN8oCzD00nZF2GYYleBUfehw=
Date: Tue, 21 Feb 2023 09:41:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Simon Horman <simon.horman@corigine.com>,
	Cong Wang <cong.wang@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 096/156] net: sched: sch: Bounds check priority
Message-ID: <Y/SDvySpXrsemVpH@kroah.com>
References: <20230220133602.515342638@linuxfoundation.org>
 <20230220133606.471631231@linuxfoundation.org>
 <1bfe95ba03a58d773f50a628b9fb5e007dd124ad.camel@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bfe95ba03a58d773f50a628b9fb5e007dd124ad.camel@redhat.com>

On Tue, Feb 21, 2023 at 08:45:18AM +0100, Paolo Abeni wrote:
> Hello,
> 
> On Mon, 2023-02-20 at 14:35 +0100, Greg Kroah-Hartman wrote:
> > From: Kees Cook <keescook@chromium.org>
> > 
> > [ Upstream commit de5ca4c3852f896cacac2bf259597aab5e17d9e3 ]
> > 
> > Nothing was explicitly bounds checking the priority index used to access
> > clpriop[]. WARN and bail out early if it's pathological. Seen with GCC 13:
> > 
> > ../net/sched/sch_htb.c: In function 'htb_activate_prios':
> > ../net/sched/sch_htb.c:437:44: warning: array subscript [0, 31] is outside array bounds of 'struct htb_prio[8]' [-Warray-bounds=]
> >   437 |                         if (p->inner.clprio[prio].feed.rb_node)
> >       |                             ~~~~~~~~~~~~~~~^~~~~~
> > ../net/sched/sch_htb.c:131:41: note: while referencing 'clprio'
> >   131 |                         struct htb_prio clprio[TC_HTB_NUMPRIO];
> >       |                                         ^~~~~~
> > 
> > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > Cc: Cong Wang <xiyou.wangcong@gmail.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > Link: https://lore.kernel.org/r/20230127224036.never.561-kees@kernel.org
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This one has a follow-up which I don't see among the patches reaching
> the netdev ML:
> 
> commit 9cec2aaffe969f2a3e18b5ec105fc20bb908e475
> Author: Dan Carpenter <error27@gmail.com>
> Date:   Mon Feb 6 16:18:32 2023 +0300
> 
>     net: sched: sch: Fix off by one in htb_activate_prios()

This too is in the queue for 5.4 and newer kernels, are you sure you
didn't miss that in this series?

thanks,

greg k-h
