Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A7E1878
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 09:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676970744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAvHiPQ19TdYhLIdZGTOSEcgY7DzCG2H/QK92XwZ0l8=;
	b=WV2hyFug5ZcbUaYCoy19TiAt7BUf92YGFWTxjriXhGdPkbSu38suZbborDYPI3oiEDqnFV
	baBKkEUK2jcqEw6XIT4XEUKihQ7uXyQrxaqZC6jidefSrki67I+jibRltLZssDKujIlrGY
	3gj2nFD2bLNueAvJfbmvPRFJrxOEahM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-503-P87Glp0dPESw6Q-9hpNedQ-1; Tue, 21 Feb 2023 04:12:21 -0500
X-MC-Unique: P87Glp0dPESw6Q-9hpNedQ-1
Received: by mail-qk1-f198.google.com with SMTP id d72-20020ae9ef4b000000b0072db6346c39so1507499qkg.16
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 01:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZAvHiPQ19TdYhLIdZGTOSEcgY7DzCG2H/QK92XwZ0l8=;
        b=zC6Zyeod6ohnvXzbIOJIJbzTorlX10MsKRxPQ9M7E/aYTuIOVHdG5O3pVukBbA2tvb
         KZZHHrfEf1yLQzOKEODToFVLaBK/HmKP3vZWjlEfSbuO3VEVas8vaI8L+SLJfSGiAMvk
         8EJeUK7Tb5g2RwhF/fGiZPLxunkW6KbPyqvqv7XR2fkAmJwV2yK0Q8Iipo0FcZKRtSYp
         C04e9L2qsDy1PiPArIlGfsOAkesXHmX8PnvwfJIE+SRtX4ZrcTeK4IpjvJa9MnA04Hp5
         5uZw+MMnHWgKVE5wbbZvHTAGLMLAwbK6l5CAkuVrPfTueX8/TvsxC8s4XEDeeN61JCLd
         hReA==
X-Gm-Message-State: AO0yUKVGtJMxGlzPAytQM0txG9u/heTdrD9RGeiO2mnqwroUrA0cs0JU
	Ra8p+BJInSiMx0FzFNnfWtqbJerlmCYbZhKg2viFSTk00khPIqLlEULj9yCf5QWRuKl6J6mRaMh
	MgdhVutBFZW946fjjGg==
X-Received: by 2002:ac8:4e95:0:b0:3bd:142d:64dd with SMTP id 21-20020ac84e95000000b003bd142d64ddmr8526063qtp.3.1676970741037;
        Tue, 21 Feb 2023 01:12:21 -0800 (PST)
X-Google-Smtp-Source: AK7set83qv+2Mv0RH24mzPx8V9CvzDxA2eI0jnOhrHL7ToCbR/vkhX51kVrQ5bKHy82UfSXuqT0A8g==
X-Received: by 2002:ac8:4e95:0:b0:3bd:142d:64dd with SMTP id 21-20020ac84e95000000b003bd142d64ddmr8526022qtp.3.1676970740740;
        Tue, 21 Feb 2023 01:12:20 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id d4-20020ac81184000000b003b62bc6cd1csm10509603qtj.82.2023.02.21.01.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 01:12:20 -0800 (PST)
Message-ID: <00383a3d782a35173b0638ec1d4289a19cc326e7.camel@redhat.com>
Subject: Re: [PATCH 5.4 096/156] net: sched: sch: Bounds check priority
From: Paolo Abeni <pabeni@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Jamal Hadi Salim
 <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
 <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org,  Kees Cook <keescook@chromium.org>, Simon Horman
 <simon.horman@corigine.com>, Cong Wang <cong.wang@bytedance.com>, Sasha
 Levin <sashal@kernel.org>
Date: Tue, 21 Feb 2023 10:12:16 +0100
In-Reply-To: <Y/SDvySpXrsemVpH@kroah.com>
References: <20230220133602.515342638@linuxfoundation.org>
	 <20230220133606.471631231@linuxfoundation.org>
	 <1bfe95ba03a58d773f50a628b9fb5e007dd124ad.camel@redhat.com>
	 <Y/SDvySpXrsemVpH@kroah.com>
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-02-21 at 09:41 +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 21, 2023 at 08:45:18AM +0100, Paolo Abeni wrote:
> > Hello,
> >=20
> > On Mon, 2023-02-20 at 14:35 +0100, Greg Kroah-Hartman wrote:
> > > From: Kees Cook <keescook@chromium.org>
> > >=20
> > > [ Upstream commit de5ca4c3852f896cacac2bf259597aab5e17d9e3 ]
> > >=20
> > > Nothing was explicitly bounds checking the priority index used to acc=
ess
> > > clpriop[]. WARN and bail out early if it's pathological. Seen with GC=
C 13:
> > >=20
> > > ../net/sched/sch_htb.c: In function 'htb_activate_prios':
> > > ../net/sched/sch_htb.c:437:44: warning: array subscript [0, 31] is ou=
tside array bounds of 'struct htb_prio[8]' [-Warray-bounds=3D]
> > >   437 |                         if (p->inner.clprio[prio].feed.rb_nod=
e)
> > >       |                             ~~~~~~~~~~~~~~~^~~~~~
> > > ../net/sched/sch_htb.c:131:41: note: while referencing 'clprio'
> > >   131 |                         struct htb_prio clprio[TC_HTB_NUMPRIO=
];
> > >       |                                         ^~~~~~
> > >=20
> > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > Cc: Cong Wang <xiyou.wangcong@gmail.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > > Link: https://lore.kernel.org/r/20230127224036.never.561-kees@kernel.=
org
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> >=20
> > This one has a follow-up which I don't see among the patches reaching
> > the netdev ML:
> >=20
> > commit 9cec2aaffe969f2a3e18b5ec105fc20bb908e475
> > Author: Dan Carpenter <error27@gmail.com>
> > Date:   Mon Feb 6 16:18:32 2023 +0300
> >=20
> >     net: sched: sch: Fix off by one in htb_activate_prios()
>=20
> This too is in the queue for 5.4 and newer kernels, are you sure you
> didn't miss that in this series?

I missed it, sorry. I checked only my inbox and netdev, and it was not
there, but I see it in the stable queue.

Sorry for the noise,

Paolo

