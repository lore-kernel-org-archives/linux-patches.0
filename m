Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF87647
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 02:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="oY73XIav"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2b9d07a8d84so81060791fa.3
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 19:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1696992268; x=1697597068; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tfP08o9WTgZjhnwYY2YMLugpyMhSldsfMjRLs/4Yykg=;
        b=oY73XIav7RlynGpmZIZSvOqHoPScyf2uBBT89/Ar1a+jDnqYRtejtN9hapldty15VI
         SA0V57CQBY57hlRtD8P3/Qglwfli+F64ov40g1D/kpKN71yXn8R5+gPv4vBbZq6GqUBR
         Cgpy2++MjerBILNPcTXWdp3NDg+M9CnIeegrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696992268; x=1697597068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tfP08o9WTgZjhnwYY2YMLugpyMhSldsfMjRLs/4Yykg=;
        b=XzlJZvknlXnQFlL4rSszW8Zk/LDf9tx3JFaWB5PTpygJe/XLUd1QtAwwbdQoynT+pf
         ZCIiL1qhUE9axgIIJqJ3uVqj6F0i+wePjfY70pEU9w4pUPFe0WzVb61K/kvOvINufXIV
         dZFBgWPk17gd4xGKIpodpcLJhQy5DWZs2oiZCXbSn72Fclycd2NQfjc/xHmDc7ShT29c
         vca+5Q9tYF8prGDbS1sws8uY7cI0zrI/HYq3KWhqJXUBh/QlIV/M7rttgjREmdN2xxsw
         KsR4NkLEwdmdgxLD0uGlpoeDY/yCC4LHLxJhcBXMLYb1Ii9tiUIAVjTrc+SPy1t8LDxz
         Jmsw==
X-Gm-Message-State: AOJu0YwJFBoUnhacVfF6uFj8NB5TvOMBBdpULB5CMkMngE3hQymY9KZD
	75+2LKt6oYapNdhmR+zfbhphGgEHrHR3mcwwMRWBTw==
X-Google-Smtp-Source: AGHT+IEjH14ZTyGUyfXOqAvZB6QgDxtkcp+eg2meOjmZxrUxcG6Y3RJwEU1Sg/YDewrwZkZ+eJ1n9IM63GXFrkK3u1k=
X-Received: by 2002:a2e:a1c6:0:b0:2bd:1fee:aacf with SMTP id
 c6-20020a2ea1c6000000b002bd1feeaacfmr15567601ljm.24.1696992268077; Tue, 10
 Oct 2023 19:44:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175203.943277832@linuxfoundation.org> <CA+G9fYunnEUT2evdabX1KOTiryP1heNHWDH4LWZCt2SVRmnKOA@mail.gmail.com>
 <20231006162038.d3q7sl34b4ouvjxf@revolver> <57c1ff4d-f138-4f89-8add-c96fb3ba6701@paulmck-laptop>
 <20231006175714.begtgj6wrs46ukmo@revolver> <7652477c-a37c-4509-9dc9-7f9d1dc08291@paulmck-laptop>
 <CAEXW_YS16NxPxg52T=3FcyZ2qocj36zKyhPnEQL3nBTbD-qJ-A@mail.gmail.com> <9470dab6-dee5-4505-95a2-f6782b648726@paulmck-laptop>
In-Reply-To: <9470dab6-dee5-4505-95a2-f6782b648726@paulmck-laptop>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Tue, 10 Oct 2023 22:44:16 -0400
Message-ID: <CAEXW_YTYzoAfOcgYA-N7VJYJoZTVX2=GtDrZc19RXoAXidbvyA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/183] 5.15.134-rc1 review
To: paulmck@kernel.org
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Naresh Kamboju <naresh.kamboju@linaro.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, Chengming Zhou <zhouchengming@bytedance.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ovidiu Panait <ovidiu.panait@windriver.com>, 
	Ingo Molnar <mingo@kernel.org>, rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 8, 2023 at 9:20=E2=80=AFPM Paul E. McKenney <paulmck@kernel.org=
> wrote:
[...]
> > > > How frequent is this function called?  We could check something for
> > > > early boot... or track down where the cpu is put online and restore=
 idle
> > > > before that happens?
> > >
> > > Once per RCU Tasks Trace grace period per reader seen to be blocking
> > > that grace period.  Its performance is as issue, but not to anywhere
> > > near the same extent as (say) rcu_read_lock_trace().
> > >
> > > > > > It's also worth noting that the bug this fixes wasn't exposed u=
ntil the
> > > > > > maple tree (added in v6.1) was used for the IRQ descriptors (ad=
ded in
> > > > > > v6.5).
> > > > >
> > > > > Lots of latent bugs, to be sure, even with rcutorture.  :-/
> > > >
> > > > The Right Thing is to fix the bug all the way back to the introduct=
ion,
> > > > but what fallout makes the backport less desirable than living with=
 the
> > > > unexposed bug?
> > >
> > > You are quite right that it is possible for the risk of a backport to
> > > exceed the risk of the original bug.
> > >
> > > I defer to Joel (CCed) on how best to resolve this in -stable.
> >
> > Maybe I am missing something but this issue should also be happening
> > in mainline right?
> >
> > Even though mainline has 897ba84dc5aa ("rcu-tasks: Handle idle tasks
> > for recently offlined CPUs") , the warning should still be happening
> > due to Liam's "kernel/sched: Modify initial boot task idle setup"
> > because the warning is just rearranged a bit but essentially the same.
> >
> > IMHO, the right thing to do then is to drop Liam's patch from 5.15 and
> > fix it in mainline (using the ideas described in this thread), then
> > backport both that new fix and Liam's patch to 5.15.
> >
> > Or is there a reason this warning does not show up on the mainline?
> >
> > My impression is that dropping Liam's patch for the stable release and
> > revisiting it later is a better approach since tiny RCU is used way
> > less in the wild than tree/tasks RCU. Thoughts?
>
> I think that this one is strange enough that we need to write down the
> situation in detail, make sure we have all the corner cases covered in
> both mainline and -stable, and decide what to do from there.
>
> Yes, I know, this email thread contains much of this information, but
> a little organizing of it would be good.
>
> Would you like to put that together, or should I?  If me, I will get
> a draft out by the end of this coming Tuesday, Pacific Time.

I apologize, I haven't been able to do any real work as I was OOO for
the most part due to dental issues. I am about 25% back now. I will
review your other email writeup and thanks for putting it together!

 - Joel
