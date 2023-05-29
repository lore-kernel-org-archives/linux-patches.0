Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD48B79F0
	for <patches@lists.linux.dev>; Mon, 29 May 2023 17:48:08 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-973f78329e3so284364766b.3
        for <patches@lists.linux.dev>; Mon, 29 May 2023 10:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685382487; x=1687974487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HMdOshEWsCUccpZDIFZZY9qEaKeS/wKY+PKyVf4UtLw=;
        b=ebxoUHMAoHjBwRTQQFj5NAVEDHva9Q+73M4/Q/jpzXMPHcw9bjP39wSyvA7bdgirQc
         hDUdZY8YVnGr12KA2uzMWc133w/odbrTDg9Nbdl8mv3qwoqkKKvfDmu9tG58tYTnLjTP
         yg1PQODaY05oxTogUAi/p3cS8p+y2FjkdNlYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685382487; x=1687974487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HMdOshEWsCUccpZDIFZZY9qEaKeS/wKY+PKyVf4UtLw=;
        b=BmIrAgawWRFw9SrjQ54qWtnejrH7qMuqckg6k7TScvqt9Mv9jZr64UmQbzP4Sc0JGN
         38KwHbNQ+cWP6bzhe4Dv0ZqTSJoRlZbEdpKWGtmVwcQQG/HpsOhWxcA6o/ZKjlxIflfl
         4iqKwXr1QJ4P+cmi+mLzYl2E00mD9nUjlkWHB5U3yeZ4mVXrI848XgELK9WgajXhBjxh
         YQUUpGWQpoysldKHnZqJMujsnFwsKxDnp9SB1n0DFXUkRsa3PZ5Cxwa8HTPcNyj9Ftoz
         JiOPDEc7IL6kroNyEDqfs1guCftDVT41eclQWRrC9F9vK1A/RQqwOTKk00pzZOridKGL
         AIZA==
X-Gm-Message-State: AC+VfDxpFQnr5eKrk30ig0Hxxd9XTIH4VOeem5rHNYRBKX+C63C2YZ2x
	SR+LVVzVbFqb7TGPP3VIvaNRABPnwETqWrjNw82Qq+Y4
X-Google-Smtp-Source: ACHHUZ6NJoxOgX64iqs2Cll2J3UZIwERjCG5Xfn34rC7XxGdnigwYYbqjcASCxsasOoBSV0i92oo8g==
X-Received: by 2002:a17:906:eec5:b0:95e:ce3b:a471 with SMTP id wu5-20020a170906eec500b0095ece3ba471mr12168133ejb.55.1685382486798;
        Mon, 29 May 2023 10:48:06 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id b7-20020a1709062b4700b0096f6a131b9fsm6111264ejg.23.2023.05.29.10.48.06
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 10:48:06 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-51475e981f0so6018642a12.1
        for <patches@lists.linux.dev>; Mon, 29 May 2023 10:48:06 -0700 (PDT)
X-Received: by 2002:a17:907:36cd:b0:96f:7d09:7deb with SMTP id
 bj13-20020a17090736cd00b0096f7d097debmr13772127ejc.69.1685382465126; Mon, 29
 May 2023 10:47:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524213620.3509138-1-mcgrof@kernel.org> <20230524213620.3509138-3-mcgrof@kernel.org>
 <8fc5b26b-d2f6-0c8f-34a1-af085dbef155@suse.com> <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
 <6gwjomw6sxxmlglxfoilelswv4hgygqelomevb4k4wrlrk3gtm@wrakbmwztgeu>
 <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org> <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com> <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
 <ZHSeOUpKtyc8VKx5@hovoldconsulting.com>
In-Reply-To: <ZHSeOUpKtyc8VKx5@hovoldconsulting.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 May 2023 13:47:28 -0400
X-Gmail-Original-Message-ID: <CAHk-=whHRAntqwt_iGAdezj4i33GTmN+Oa8z3CNz4LO0Puo85g@mail.gmail.com>
Message-ID: <CAHk-=whHRAntqwt_iGAdezj4i33GTmN+Oa8z3CNz4LO0Puo85g@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
To: Johan Hovold <johan@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Lucas De Marchi <lucas.demarchi@intel.com>, 
	Petr Pavlu <petr.pavlu@suse.com>, gregkh@linuxfoundation.org, rafael@kernel.org, 
	song@kernel.org, lucas.de.marchi@gmail.com, christophe.leroy@csgroup.eu, 
	peterz@infradead.org, rppt@kernel.org, dave@stgolabs.net, willy@infradead.org, 
	vbabka@suse.cz, mhocko@suse.com, dave.hansen@linux.intel.com, 
	colin.i.king@gmail.com, jim.cromie@gmail.com, catalin.marinas@arm.com, 
	jbaron@akamai.com, rick.p.edgecombe@intel.com, yujie.liu@intel.com, 
	david@redhat.com, tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com, 
	lennart@poettering.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2023 at 8:44=E2=80=AFAM Johan Hovold <johan@kernel.org> wro=
te:
>
> Yes, those two changes are enough to make the problem go away.

Ok, good. Expected, but just verifying that it wasn't some silly
incidental thinko.

> > I do wonder what it is that is different in your setup, and maybe you
> > could also enable the
> >
> >         pr_debug("finit_module: fd=3D%d, uargs=3D%p, flags=3D%i\n", fd,=
 uargs, flags);
>
> Below is the corresponding output with a working kernel: 174 requests
> for the 131 modules that end up being loaded (without the revert there
> is only around 110 modules loaded).

Ok, your setup doesn't sound *too* different from mine. I have 176
kernel modules on my laptop right now, and that exclusive open
obviously worked fine for me.

But it could easily be some random small difference just from
different hardware, so...

And yeah, that dmesg output is useless, I didn't think of the fact
that it only prints out the file descriptor, not the actual path to
the file. In fact, without that change in place, the module code never
actually looks at the file and leaves it all to
kernel_read_file_from_fd().

With my change, it woul dhave been trivial to use "%pD" and point it
at the file pointer instead, and get the dentry name that way, but
never mind.  I think you're entirely right that it's probably due to a
shared dependency module, and I just didn't happen to trigger that
case.

Sadly, the whole idea was to figure out the exclusion so early that we
don't have the module data structures lookup up yet, so there's no
really obvious thing to serialize the load on.

I'll have to think about this more. Serializing on a per-inode lock
would seem to be the simplest thing, but they are all for IO, and we
can't just take them over the read.

                     Linus
