Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8A25CB5
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 07:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="iI5rjNh1"
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1451240341
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 07:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1698909776;
	bh=Pd7/lFtP4BYuqq3e5ONr1i/noTjwBlQpKuQjz8D374U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=iI5rjNh1h2zjAPg49hoOwC1Y8D+nFkvtjrLnVKi00lSQdcEHsHQVFXkWSnbYGvsYr
	 mjGAyizOJ0GTITLHAEKsoZ1UlNPtGmuuL5hSN/PuIyAs0h40GCkOExTk4m+8iHuYyH
	 syja5rRrs3LdBHinlRBVioIHSa54lASDkwO7Mf6eDNoJKr0U/qJP9MsbalzAt+sGdN
	 g8sHQ6d53IcXA9XFmWgYo7z5Nx71i8dWlkC6aJS5+VvOCE5KPflRKXeh+7gvZUonjY
	 RTTDh4GxBNNOB9SZifeHtI0mvVQ9/rorpqnWQkr+5aetsJfG5ABAaV2HazRw6a6Ikg
	 UqDpPsB0/31hg==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9d4b8735f48so39793366b.1
        for <patches@lists.linux.dev>; Thu, 02 Nov 2023 00:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698909775; x=1699514575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pd7/lFtP4BYuqq3e5ONr1i/noTjwBlQpKuQjz8D374U=;
        b=FnKehe8u8+ZlCvMDMUgzlPYUlznSF0GDY4aszr5Xxi8+bOp+iQIbs51wHpNZCEMAzQ
         /jFMuFBHZSIpaNavdFi9q0oElFPqTRRX/ODwno6/GUFpfzx6OOln2R5JdJZUsxRPywIs
         JGT87vhuZSuv3eTyr8i5XkGycI4bC6cOQPmgeh+hI9IcjO1txRgUrJd+uO4j/5jQxpBc
         eUrmg0RPt3O+Aiz3tlyrwIEYlpuMZKltbqxeaBDyc7pO2Anvbeoe5SLzfWZI6TrZzLBD
         VOWMg7h+M0sEE8Y5DPbOTS9XJ1Fyl77PNOSYHB9ktp+9rkEHgGYB2ghJp5bZLzbdUckJ
         B6cA==
X-Gm-Message-State: AOJu0YxKJjUKWrYFJNHXVfwvq3cb2snio9rF4GfZEpTeMfGVo7EjOyu1
	C4HRknfgDkfDTcGijuiXPBpV08vsL3fr3WspKTsfRasSvlkBdSLB2Z+Y3t0vbymlSHp7zON9ObE
	tSruIzYYtS/8M8cdCkdrDq5Kdf9Jhrh5VdiQ=
X-Received: by 2002:a17:907:2ce4:b0:9d3:ccf0:761e with SMTP id hz4-20020a1709072ce400b009d3ccf0761emr3442232ejc.49.1698909775539;
        Thu, 02 Nov 2023 00:22:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrcaepUPUtioNdapJVIzKQ0rujHR+g4fkf/lk1zTtPY1f2mSTPZz6aIQYCyYYCxcwy7R2PJg==
X-Received: by 2002:a17:907:2ce4:b0:9d3:ccf0:761e with SMTP id hz4-20020a1709072ce400b009d3ccf0761emr3442218ejc.49.1698909775093;
        Thu, 02 Nov 2023 00:22:55 -0700 (PDT)
Received: from localhost (host-79-33-130-95.retail.telecomitalia.it. [79.33.130.95])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090606c900b009b27d4153cfsm781396ejb.176.2023.11.02.00.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 00:22:54 -0700 (PDT)
Date: Thu, 2 Nov 2023 08:22:53 +0100
From: Andrea Righi <andrea.righi@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-modules@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	keescook@chromium.org, zhumao001@208suo.com, yangtiezhu@loongson.cn,
	ojeda@kernel.org
Subject: Re: [GIT PULL] Modules changes for v6.7-rc1
Message-ID: <ZUNOTRWCWNJkn66n@gpd>
References: <ZUKxT1CL9/0Dn6NE@bombadil.infradead.org>
 <CAHk-=whFXNYXG2ES8HdoaMC=O4bakMXGZezmoqA3SXwn4xJUPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whFXNYXG2ES8HdoaMC=O4bakMXGZezmoqA3SXwn4xJUPQ@mail.gmail.com>

On Wed, Nov 01, 2023 at 09:02:51PM -1000, Linus Torvalds wrote:
> On Wed, 1 Nov 2023 at 10:13, Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > The only thing worth highligthing is that gzip moves to use vmalloc() instead of
> > kmalloc just as we had a fix for this for zstd on v6.6-rc1.
> 
> Actually, that's almost certainly entirely the wrong thing to do.
> 
> Unless you *know* that the allocation is large, you shouldn't use
> vmalloc(). And since kmalloc() has worked fine, you most definitely
> don't know that.
> 
> So we have 'kvmalloc()' *exactly* for this reason, which is a "use
> kmalloc, unless that is too small, then use vmalloc".
> 
> kmalloc() isn't just about "use physically contiguous allocations".
> It's also more memory-efficient, and a *lot* faster than vmalloc(),
> which has to play VM tricks.
> 
> So this "just switch to vmalloc()" is entirely wrong.
> 
>               Linus

I proposed that change mostlfy for consistency with the zstd case, but I
haven't experience any issue with gzip compressed modules (that seem to
require less memory, even with larger modules).

So, yes, it probably makes sense to drop this change for now and I can
send another patch to switch to kvmalloc() for all the decompress cases.

Thanks,
-Andrea
