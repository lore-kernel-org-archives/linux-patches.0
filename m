Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8104C23A7
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:31:23 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id f28so13022262pfk.1
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/ZIBwdh7AZy1tlqpLcM+wJiYIr87DkwAsg5KZRoqj68=;
        b=Ruh/m0QpeWGCsAuDQ9vLgMeMnPwUDhrl9zrtFVQhUKHT651SheClw0ZDbbdAkAoW1i
         AWWwQTcmm7HgmZLKUbhe1zerjeL6tQndwX0YQvzXZaPS3qkGhMCJQ5MVId2fX3yigKC0
         EkEKImheXVwahv1KCIpsBcpCFuOAVPe3Csobg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/ZIBwdh7AZy1tlqpLcM+wJiYIr87DkwAsg5KZRoqj68=;
        b=nCYNxoyGXOHmsczh65uzet58Oke2XuB1NJlUbQTgLFnzcTCE2fzjKb3ZzWdYp/wlf9
         ig48ElelJ7C3ieeJSrQPI33o08qmaHU4wjDVc6jTNC7+Zd2NrlpsthbTz4vBxHu8PWKN
         S8qDjKnVU9n/YMbPF2vpvUsUHF468ycMnMHxBjngQFAoH8BHmtlakS+VgQYOW9FeqM4w
         si9RbmlMAgxcHGN8E0YitSMYlOFtD9HjMS3+Ybe7v7T+AZwXw7YytlJmIJEzUiFjUAjN
         3OmcxwWFxP0BgrN/cmFCU0DcJSrlO2diMGD3Zoae/ziIJ9UsmM1TnX127tYboDnfCtzS
         taGQ==
X-Gm-Message-State: ACgBeo2+vGksxgijXKhH7Ivz2CCPgYB5ad8jkhMDS5mLwKmb2j8hpPvY
	mjryqNpOJ/Vxq1MNQuZAwugkIQ==
X-Google-Smtp-Source: AA6agR65FRhlhXg+iyS9uiPMyxhif0H2qZvkrI2JMX3wGGKR0i72/DbE/1rC0DSvM0UBXh9VWHpySQ==
X-Received: by 2002:a63:4f24:0:b0:429:aee9:f59a with SMTP id d36-20020a634f24000000b00429aee9f59amr6255932pgb.180.1660768282990;
        Wed, 17 Aug 2022 13:31:22 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e6-20020a056a0000c600b00528c7f6f4dcsm10895421pfj.52.2022.08.17.13.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:31:22 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:31:21 -0700
From: Kees Cook <keescook@chromium.org>
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v9 03/27] kallsyms: add static relationship between
 `KSYM_NAME_LEN{,_BUFFER}`
Message-ID: <202208171330.BB5B081D1@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-4-ojeda@kernel.org>
 <202208171238.80053F8C@keescook>
 <Yv1GmvZlpMopwZTi@boqun-archlinux>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv1GmvZlpMopwZTi@boqun-archlinux>

On Wed, Aug 17, 2022 at 12:50:50PM -0700, Boqun Feng wrote:
> On Wed, Aug 17, 2022 at 12:39:48PM -0700, Kees Cook wrote:
> > On Fri, Aug 05, 2022 at 05:41:48PM +0200, Miguel Ojeda wrote:
> > > This adds a static assert to ensure `KSYM_NAME_LEN_BUFFER`
> > > gets updated when `KSYM_NAME_LEN` changes.
> > > 
> > > The relationship used is one that keeps the new size (512+1)
> > > close to the original buffer size (500).
> > > 
> > > Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> > > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > > ---
> > >  scripts/kallsyms.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> > > index f3c5a2623f71..f543b1c4f99f 100644
> > > --- a/scripts/kallsyms.c
> > > +++ b/scripts/kallsyms.c
> > > @@ -33,7 +33,11 @@
> > >  #define KSYM_NAME_LEN		128
> > >  
> > >  /* A substantially bigger size than the current maximum. */
> > > -#define KSYM_NAME_LEN_BUFFER	499
> > > +#define KSYM_NAME_LEN_BUFFER	512
> > > +_Static_assert(
> > > +	KSYM_NAME_LEN_BUFFER == KSYM_NAME_LEN * 4,
> > > +	"Please keep KSYM_NAME_LEN_BUFFER in sync with KSYM_NAME_LEN"
> > > +);
> > 
> > Why not just make this define:
> > 
> > #define KSYM_NAME_LEN_BUFFER (KSYM_NAME_LEN * 4)
> > 
> > ? If there's a good reason not it, please put it in the commit log.
> > 
> 
> Because KSYM_NAME_LEN_BUFFER is used as a string by stringify() in
> fscanf(), defining it as (KSYM_NAME_LEN * 4) will produce a string
> 
> 	"128 * 4"
> 
> after stringify() and that doesn't work with fscanf().

Ah yeah. Thanks!

> Miguel, maybe we can add something below in the commit log?
> 
> `KSYM_NAME_LEN_BUFFER` cannot be defined as an expression, because it
> gets stringified in the fscanf() format. Therefore a _Static_assert() is
> needed.

Yeah, please add a source comment for that. :)

-- 
Kees Cook
