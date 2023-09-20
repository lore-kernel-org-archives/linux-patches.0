Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAC829A1
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 15:32:54 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1c0e7e3d170so166635ad.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 08:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695223974; x=1695828774; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdCXdOQ9nj5NwvgTMa99A9hiNmoB51uuqq4nZAsFZLE=;
        b=d9oOA7TnoZtltNuyIhpF4wiEXZCxuNTC4xARsZaXYPOyfkkhoCrhGmmKAJKiGrtZSd
         JWgxCnNWgFjyCXwWfv6qu/WfpKtpkxGwRcKxWnMclh83cES3Wn0EYprCYbfQ9vFYsxQ+
         tKE2O2n8EwQq3+Wh5rI0+LORwPNI141nauAuwx8caEtlGSwxTGvxqzo6mjiEqSSOcrK3
         o9AR0kzi9b44LZJW9AC8PwMvd5pJYcRBlIX8AqQknpHL5EzhZkeFWlxvKewoI3Bi6LFC
         rcsJSApM2Byi2HUO5xFciXA0Tqjy4GgJG8PgaUrBh9bEYGmNnQx5WdRdea/PeYNg8cPe
         jL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695223974; x=1695828774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bdCXdOQ9nj5NwvgTMa99A9hiNmoB51uuqq4nZAsFZLE=;
        b=mA+zUeA1ZILANVZdBkS8YykQlltQv0gz/Xif9VJslz6x8XeGby8CJ+Ijv3lokVzadX
         6LfsdhqY7SexUp3Kmxm2qHkHoysnLYssIeZvMnxVdLCp4KDGaK4Q+Ln47iAutW3qxHiZ
         jVdtv3NC7m6YXfr80A65cxkGCtJd9Fa09m8WxyjSA6cU7gZ7ZO5mleEb5fT/GbghzBIt
         vFJQO59RYa2ne2zrSPv9I/xgSFKv4zy8IEZl8TbaF73nf8iJK4FH8nGLqDtnFmj3lb2W
         kEG3JT5fO5oMTcCTkPHO7i0Pzsh54fSWhsG/VimJKaHDfc8WFLX6BF3EcZ5qcIyw/oDp
         8S6A==
X-Gm-Message-State: AOJu0YzR5GY2VsD58YSLRKtZPOrlHrWmJBQULV4Wd7Gk0HSVBfb+/cyS
	mAn+pCIbMc6CaBeaJsnSqdqeIlfAdkaTJpx94g26Eg==
X-Google-Smtp-Source: AGHT+IG7jHv9mEJ9vDwu2rKaq8OA4qZgGZVHORBp0NC00eAtSWOs7zP67eILIjgFXrRNttx39BoMwKPfmWcjEmZ73Bs=
X-Received: by 2002:a17:903:41c7:b0:1c4:21fe:2823 with SMTP id
 u7-20020a17090341c700b001c421fe2823mr181043ple.13.1695223974038; Wed, 20 Sep
 2023 08:32:54 -0700 (PDT)
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
 <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz>
In-Reply-To: <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz>
From: Shakeel Butt <shakeelb@google.com>
Date: Wed, 20 Sep 2023 08:32:42 -0700
Message-ID: <CALvZod7E_Jm9y+40OKtLs5EFA0ptKGjoe2BU58SY29pUiPc93g@mail.gmail.com>
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

On Wed, Sep 20, 2023 at 6:47=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Wed 20-09-23 15:25:23, Jeremi Piotrowski wrote:
> > On 9/20/2023 1:07 PM, Michal Hocko wrote:
> [...]
> > > I mean, normally I would be just fine reverting this API change becau=
se
> > > it is disruptive but the only way to have the file available and not
> > > break somebody is to revert 58056f77502f ("memcg, kmem: further
> > > deprecate kmem.limit_in_bytes") as well. Or to ignore any value writt=
en
> > > there but that sounds rather dubious. Although one could argue this
> > > would mimic nokmem kernel option.
> > >
> >
> > I just want to make sure we don't introduce yet another new behavior in=
 this legacy
> > system. I have not seen breakage due to 58056f77502f. Mimicing nokmem s=
ounds good but
> > does this mean "don't enforce limits" (that should be fine) or "ignore =
writes to the limit"
> > (=3Ddon't event store the written limit). The latter might have uninten=
ded consequences.
>
> Yes it would mean that the limit is never enforced. Bad as it is the
> thing is that the hard limit on kernel memory is broken by design and
> unfixable.  This causes all sorts of unexpected kernel allocation
> failures that this is simply unsafe to use.
>
> All that being said I can see the following options
> 1) keep the current upstream status and not export the file
> 2) revert both 58056f77502f and 86327e8eb94 and make it clear
>    that kmem.limit_in_bytes is unsupported so failures or misbehavior
>    as a result of the limit being hit are likely not going to be
>    investigated or fixed.
> 3) reverting like in 2) but never inforce the limit (so basically nokmem
>    semantic)
>
> Shakeel, Johannes, Roman, Muchun Song what do you think?

I think the safe option would be to revert 86327e8eb94 for now and put
pr_warn_once even for the read of kmem.limit_in_bytes? We can retry
86327e8eb94 in a year or so.

However personally I would prefer option 1. Also I don't think
reverting  58056f77502f would give any benefit.
