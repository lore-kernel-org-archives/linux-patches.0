Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E521A5BE
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 19:46:35 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1c0e7e3d170so37275ad.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695239195; x=1695843995; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r1gDFWdH+zhoVhcN/66huTv4AT/CGtvploIElj8nrZg=;
        b=IhpjKZ+/1tGVYn58eJb/3ov08xq3uwK2uxWpDTMYTUgbC5SfqKB/EF/IOKKaiUfKwZ
         xU2MfZpHRs8q7oTtE4K1/mDZIOfhqMXVFQBdwR3theOFZD851sX8Z9Y6tDDnMwtyCI80
         a/fcUvVZQfjXQ8F4eeDHqhVUjk9sN18lpGyMQgdBRFnLLYEyTT0qnUb3nM2obxH+6+UH
         lh0hE6inN70ZzM5QsolGNNj19W+Hup0ohw8CogfTZLnElS1jeuPz2dy7dRfbz82hvZH9
         2pmEP80hyexzVXLnW0aOXKBNNL34wx3VSqgm/gCrtbEbiJKuq7GbtG61o1NJblseEwU9
         WYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695239195; x=1695843995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r1gDFWdH+zhoVhcN/66huTv4AT/CGtvploIElj8nrZg=;
        b=uU+e01vF/sU8Y8sJ0klQeauODRj0xPqkUohZ3/DAhsDngDgrqnCZVPgKpDdoTc2Cq0
         zdlS3QDxI12vj0gfKrHzhwXTLpRJztBU2WY+xExuKD1n0TTRTwJc9OJ9p8p81ZwaqG3n
         7UPl6c18rc3DWEaRGKSp2a+OJveqTJMWl8hchn5kwgdGHYlmNv737nJluO6FUZvMcukq
         kxDIbkktPqdt37MAIq4W5DUPM6Ecw36dmOnArk/iK4DRovwvXrEkM/ydr5/mj4tIbxqw
         0vtzqj/koaHBwhex8lFdBp9gUHC+mhozhQuy4Q5Upb92kK9MlL4ryb3+9M/iyDg1ZfU8
         Fl4A==
X-Gm-Message-State: AOJu0YyWivGeWU/g6FI/5aIkRl1aW/Coqou461mfSSd+v6xwvbcSZxlD
	D7tvvom1cnqpfEHOhKNoPbQOXE2r54i3UCOmSnBhZQ==
X-Google-Smtp-Source: AGHT+IH4cJjqSUopETrHJarjPAVi2y0a8t1+QAfpfCzTd4d9SfisXhgNE8Kx5Nor7zgLorMhAVrPgqi+P8d4gPxTggg=
X-Received: by 2002:a17:902:f691:b0:1c1:f658:7d05 with SMTP id
 l17-20020a170902f69100b001c1f6587d05mr39680plg.18.1695239194530; Wed, 20 Sep
 2023 12:46:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191040.964416434@linuxfoundation.org> <20230917191042.204185566@linuxfoundation.org>
 <20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz> <101987a1-b1ab-429d-af03-b6bdf6216474@linux.microsoft.com>
 <ZQrSXh+riB7NnZuE@dhcp22.suse.cz> <4eb47d6a-b127-4aad-af30-896c3b9505b4@linux.microsoft.com>
 <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz> <CALvZod7E_Jm9y+40OKtLs5EFA0ptKGjoe2BU58SY29pUiPc93g@mail.gmail.com>
 <ZQskGGAwlsr1YxAp@dhcp22.suse.cz>
In-Reply-To: <ZQskGGAwlsr1YxAp@dhcp22.suse.cz>
From: Shakeel Butt <shakeelb@google.com>
Date: Wed, 20 Sep 2023 12:46:23 -0700
Message-ID: <CALvZod6b3=+=xXEUeWOQW3t_URJpeeVX46WjBHv5BS+436KoFA@mail.gmail.com>
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop kmem.limit_in_bytes
To: Michal Hocko <mhocko@suse.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Tejun Heo <tj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, mathieu.tortuyaux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 20, 2023 at 9:55=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Wed 20-09-23 08:32:42, Shakeel Butt wrote:
> > Also I don't think reverting 58056f77502f would give any benefit.
>
> Not reverting 58056f77502f would re-introduce the regression in some
> non-patched versions of Docker runtimes which cannot handle ENOTSUPP.
> So I think we need to revert both or none of them. I would prefer the
> later (option 1) as the fix is trivial but I do understand headache
> of chasing all those outdated deployments or vendor code forks.

I think that would be too much conservative an approach but I don't
have a strong opinion against it. Also just to be clear we are not
talking about full revert of 58056f77502f but just the returning of
EOPNOTSUPP, right?
