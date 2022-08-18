Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8680F4434
	for <patches@lists.linux.dev>; Thu, 18 Aug 2022 16:03:23 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id bh13so1632149pgb.4
        for <patches@lists.linux.dev>; Thu, 18 Aug 2022 09:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tv5ULlLKxM0cuyQ6J1iQhNfNqwRvi2Mu8C1ughJ0TDs=;
        b=E8jwzzSWkQZjYK0CTe9AbY7M6bB8NxxJIz7ILJ36UNVCbM0Ka4LYZT8J1DGl3bqPX0
         QYiBjYNWgQVin49A+zu6WhOjtftpm78q+i3lZxR2f8g79FNVN782BBPffwkFDM5Qhce6
         Rg/+3iDQr9tXHcDn/L45hCa9B+zu+rRP+330c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tv5ULlLKxM0cuyQ6J1iQhNfNqwRvi2Mu8C1ughJ0TDs=;
        b=yuxeatpdooW1uwWWEWB/9h7OGVkO8lEoZ+0yCqqWFj+ciHI9pUzkvw6iwlJuZecB7Q
         NG6niH3imZz0M6fntpWAG4YPDN5wyTcb/tOBkCaiueNeWDd+v0nEWkOC8dBPBuSdQTza
         NdKuOmYaKQwXsQu374XuroybMMyHL/V1PDDgRZK0eMTZvgUyjboBjddx0JHkMzPE6luZ
         gyIOhC/xWYkiCqjUde5MTjGBrn/gtNbjvyV7mhFr4vzwd9HLgEC7I9K6nnfF2iKnFOwY
         3voQ3Q+Sy/K9L21kuG67N8dUTmU7RrcB3TYCJe2jwVzPSgywAA6AXQ2BlLce4hR9ebkp
         /HYA==
X-Gm-Message-State: ACgBeo3ZEjONdGYMnxBAwxDUrhG3dwgEWOCyQdbhw+hjCh4oInB6LPuS
	PKICQxgFpWWZdLY8KfUWxEsCUw==
X-Google-Smtp-Source: AA6agR6I5By68BlJBuyT8Qm/ntSjcqHInGgvxgMFjK+rM4WhYuZnlmgsqf6IjXF03Hs9zZoNkbKTWw==
X-Received: by 2002:a63:231a:0:b0:429:fb01:3c5d with SMTP id j26-20020a63231a000000b00429fb013c5dmr2790011pgj.583.1660838602898;
        Thu, 18 Aug 2022 09:03:22 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l21-20020a17090ac59500b001f1ea1152aasm1630436pjt.57.2022.08.18.09.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:03:22 -0700 (PDT)
Date: Thu, 18 Aug 2022 09:03:21 -0700
From: Kees Cook <keescook@chromium.org>
To: Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc: ojeda@kernel.org, boqun.feng@gmail.com, gregkh@linuxfoundation.org,
	jarkko@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	rust-for-linux@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v9 01/27] kallsyms: use `sizeof` instead of hardcoded size
Message-ID: <202208180902.48391E94@keescook>
References: <20220805154231.31257-2-ojeda@kernel.org>
 <Yu2cYShT1h8gquW8@yadro.com>
 <202208171235.52D14C2A@keescook>
 <Yv4AaeUToxSJZK/v@yadro.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv4AaeUToxSJZK/v@yadro.com>

On Thu, Aug 18, 2022 at 12:03:37PM +0300, Konstantin Shelekhin wrote:
> On Wed, Aug 17, 2022 at 12:36:33PM -0700, Kees Cook wrote:
> > On Sat, Aug 06, 2022 at 01:40:33AM +0300, Konstantin Shelekhin wrote:
> > > > diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> > > > index f18e6dfc68c5..52f5488c61bc 100644
> > > > --- a/scripts/kallsyms.c
> > > > +++ b/scripts/kallsyms.c
> > > > @@ -206,7 +206,7 @@ static struct sym_entry *read_symbol(FILE *in)
> > > >
> > > >     rc = fscanf(in, "%llx %c %499s\n", &addr, &type, name);
> > > >     if (rc != 3) {
> > > > -           if (rc != EOF && fgets(name, 500, in) == NULL)
> > > > +           if (rc != EOF && fgets(name, sizeof(name), in) == NULL)
> > > >                     fprintf(stderr, "Read error or end of file.\n");
> > > >             return NULL;
> > > >     }
> > >
> > > Might be another nit, but IMO it's better to use ARRAY_SIZE() here.
> > 
> > I'm not sure I see a benefit for char arrays. It'll produce the same
> > result, and the tradition for string functions is to use sizeof().
> > *shrug*
> 
> ARRAY_SIZE() (though not this one) can catch this:
> 
>   - char array[16];
>   + char *array;
> 
> Saves me some.

Oh, that's an excellent point; I forgot it'll actually compile-time
error if the var is a pointer. +1

-- 
Kees Cook
