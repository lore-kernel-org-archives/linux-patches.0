Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620B61380
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 07:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676965523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGa7NO6NvCuIiIGrSLg9tkK4hlPNsQh2fYB6P/foNGk=;
	b=D5qWLvN3j62Nkhu4GTCQDrsuxrhOxmIw5ME6oJZPEvf8xzimUy87DPojQDlrrxVWGz0+V2
	Ni75wDEjn3N+po1SUpBmrQWH1uKaPdkASrqzoVRr4d9r1YVAvfYe9XGAscf/3CF6+OEiaD
	BF2MhswOJEqrfFFLOV7FaFvrp1gfQ7E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-551-mDZJuOU9PoWwn2B0E4zPQQ-1; Tue, 21 Feb 2023 02:45:21 -0500
X-MC-Unique: mDZJuOU9PoWwn2B0E4zPQQ-1
Received: by mail-wm1-f69.google.com with SMTP id z6-20020a05600c220600b003e222c9c5f4so1791142wml.4
        for <patches@lists.linux.dev>; Mon, 20 Feb 2023 23:45:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676965520;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qGa7NO6NvCuIiIGrSLg9tkK4hlPNsQh2fYB6P/foNGk=;
        b=neumT/C3z4CU3AjLTS+BUXLWV4SLasYr6tC1w9/B1zcL0hW2BTlFXqjvz/oCD1vr8Z
         6G+tldQnf1VjEfkHTlipTeFZI6nFD2KsAFadFhb3PLiRtFTjS+tBqGbBzU55uN2CoJc3
         wW5e6VMMVHgNGDSuDStiJ2hlvY25aAO2ipgmdh88AFha9IA7bmwqG0QkPVMlPZxBUjOv
         0apBfxD65DwWoNiOJGYXegpRAcgInKS9FHBFYnialsoGNYBHyf2L7pTIOZQIVW12VQ5i
         +VHXwh/UA3s5cuIIVOemnkGGUKuxolvoM9comCcqzEc5faU+pgGQSqZCpIlxn5/h5m8U
         Lj6Q==
X-Gm-Message-State: AO0yUKWQA6fM0Lq7mu0XniM5NplsS+fV000ooxXeV8Aq3g6fQ5afsZVA
	RPucUBQrgJMtu4Lx0Hsz/i+OykXL1NffAtXphcIabXfJEYgS7xneoRPspUVopyuDVM/LDI2ppWB
	b88fBrS5CQ7SmsfBU2A==
X-Received: by 2002:a5d:69d2:0:b0:2c5:5b85:3b43 with SMTP id s18-20020a5d69d2000000b002c55b853b43mr2838627wrw.7.1676965520782;
        Mon, 20 Feb 2023 23:45:20 -0800 (PST)
X-Google-Smtp-Source: AK7set+3p67zuMhzq3/msWLJusMN23I+0bP9GeSqxEyyARwphKo3WV8/Daj/nMUn7ldKdhNz3uHMwQ==
X-Received: by 2002:a5d:69d2:0:b0:2c5:5b85:3b43 with SMTP id s18-20020a5d69d2000000b002c55b853b43mr2838612wrw.7.1676965520448;
        Mon, 20 Feb 2023 23:45:20 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id b17-20020a056000055100b002c592535838sm4639919wrf.2.2023.02.20.23.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 23:45:19 -0800 (PST)
Message-ID: <1bfe95ba03a58d773f50a628b9fb5e007dd124ad.camel@redhat.com>
Subject: Re: [PATCH 5.4 096/156] net: sched: sch: Bounds check priority
From: Paolo Abeni <pabeni@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Kees Cook
 <keescook@chromium.org>,  Simon Horman <simon.horman@corigine.com>, Cong
 Wang <cong.wang@bytedance.com>, Sasha Levin <sashal@kernel.org>
Date: Tue, 21 Feb 2023 08:45:18 +0100
In-Reply-To: <20230220133606.471631231@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
	 <20230220133606.471631231@linuxfoundation.org>
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

Hello,

On Mon, 2023-02-20 at 14:35 +0100, Greg Kroah-Hartman wrote:
> From: Kees Cook <keescook@chromium.org>
>=20
> [ Upstream commit de5ca4c3852f896cacac2bf259597aab5e17d9e3 ]
>=20
> Nothing was explicitly bounds checking the priority index used to access
> clpriop[]. WARN and bail out early if it's pathological. Seen with GCC 13=
:
>=20
> ../net/sched/sch_htb.c: In function 'htb_activate_prios':
> ../net/sched/sch_htb.c:437:44: warning: array subscript [0, 31] is outsid=
e array bounds of 'struct htb_prio[8]' [-Warray-bounds=3D]
>   437 |                         if (p->inner.clprio[prio].feed.rb_node)
>       |                             ~~~~~~~~~~~~~~~^~~~~~
> ../net/sched/sch_htb.c:131:41: note: while referencing 'clprio'
>   131 |                         struct htb_prio clprio[TC_HTB_NUMPRIO];
>       |                                         ^~~~~~
>=20
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Link: https://lore.kernel.org/r/20230127224036.never.561-kees@kernel.org
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This one has a follow-up which I don't see among the patches reaching
the netdev ML:

commit 9cec2aaffe969f2a3e18b5ec105fc20bb908e475
Author: Dan Carpenter <error27@gmail.com>
Date:   Mon Feb 6 16:18:32 2023 +0300

    net: sched: sch: Fix off by one in htb_activate_prios()

Cheers,

Paolo

