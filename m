Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B88D6ADD
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 19:36:36 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id l64so12823910pge.0
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 12:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=DwQ4nsxbFKRBGX51s8IXcm7jc9sOynsnepHYnZvK+q8=;
        b=dDflZWLDwgLNEUqS2QSEf+EU9QySzBzklxHNtjMI6KEmn6Qm4yhXCaw+IjQWz0+EwN
         8dhgPlIueNI1tSl2rnGUbdr64cP3OayomPrD6oFw+uYC11PPeERBIAp8IzdvOOJ+cf6/
         /duC6UT3tzWyZkS281siFpZEZ4LqAen6po3cs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=DwQ4nsxbFKRBGX51s8IXcm7jc9sOynsnepHYnZvK+q8=;
        b=WXZYGPe8Y5/kaZY8ix3/THpvwlCT+/EDh3txaapHGQaO9XDnoewKIVmHAxWyXg7G6W
         YDslvBrYWuWg8LyOfzRntnV3NlwZN+rnsnBJxqpkMNgz9XlKzRBExUEvb09Ieou2eDWh
         524cRkr2jmXS49sHbN06O30RW9H+8zmwCkepONtLK6sbQu4T64GyA4xJ4Mq0aCTnS1vH
         1JR33bdcggxse9Zo635ojevmJ6DFsHFv9KvPyyntfNRe9KR4In9WeG/lVT9tNlwkYTlK
         E30Rc4hWKDnaueFVeW0b/GWolbAoCsMxmaSEGc9FyrX550/J2/ZiQ1qokXF8nhE0CbSO
         wn/Q==
X-Gm-Message-State: ACgBeo0f43w5ThL3Xcd4pVZJcJzHNqi6ES0cjOSN06RwMYlrrBAsZUwg
	sv08r9Wd4Qiszih8i8jgcLAwiSz3uoi4PA==
X-Google-Smtp-Source: AA6agR45Grj5WNJlJ+fDipgaBkC5y4R4JfAofjvtsISis6BMpiiepj37XY/6B9DM7K6AjAsyVP/0IA==
X-Received: by 2002:a63:8b44:0:b0:41c:df4c:7275 with SMTP id j65-20020a638b44000000b0041cdf4c7275mr23312562pge.434.1660764995806;
        Wed, 17 Aug 2022 12:36:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k8-20020a17090a658800b001f55dda84b3sm1917520pjj.22.2022.08.17.12.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:36:34 -0700 (PDT)
Date: Wed, 17 Aug 2022 12:36:33 -0700
From: Kees Cook <keescook@chromium.org>
To: Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc: ojeda@kernel.org, boqun.feng@gmail.com, gregkh@linuxfoundation.org,
	jarkko@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	rust-for-linux@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v9 01/27] kallsyms: use `sizeof` instead of hardcoded size
Message-ID: <202208171235.52D14C2A@keescook>
References: <20220805154231.31257-2-ojeda@kernel.org>
 <Yu2cYShT1h8gquW8@yadro.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yu2cYShT1h8gquW8@yadro.com>

On Sat, Aug 06, 2022 at 01:40:33AM +0300, Konstantin Shelekhin wrote:
> > diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> > index f18e6dfc68c5..52f5488c61bc 100644
> > --- a/scripts/kallsyms.c
> > +++ b/scripts/kallsyms.c
> > @@ -206,7 +206,7 @@ static struct sym_entry *read_symbol(FILE *in)
> >  
> >  	rc = fscanf(in, "%llx %c %499s\n", &addr, &type, name);
> >  	if (rc != 3) {
> > -		if (rc != EOF && fgets(name, 500, in) == NULL)
> > +		if (rc != EOF && fgets(name, sizeof(name), in) == NULL)
> >  			fprintf(stderr, "Read error or end of file.\n");
> >  		return NULL;
> >  	}
> 
> Might be another nit, but IMO it's better to use ARRAY_SIZE() here.

I'm not sure I see a benefit for char arrays. It'll produce the same
result, and the tradition for string functions is to use sizeof().
*shrug*

Either way:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
