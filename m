Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCA86D19
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 19:51:13 +0000 (UTC)
Received: by mail-qk1-f176.google.com with SMTP id b9so5621306qka.2
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 12:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc;
        bh=v60uqYnukgjgZARXe5JJGms8uUUgUv8wpc53hUaJ67A=;
        b=JpefC9piThWn37ij83JUtU+fue08Tl6ykry7XnZ14DBKoDxePAQOK80AdrWAJ279px
         kcgkEXwRKcLiaoyNzJ+EI8n/tRYjvAaM9OA7ppJ7pFSusEicOlrDJYE3QaNMH8MqGMvR
         CWn5MzWzsDJ2Dxxk7lgkhTfQgInX9V3QLa6O79NTCAJjFXUFZQ0sMrsDc7E4fMJXjUDq
         WlAoyYbgC0IwfQBba7Lm7EukhyIjpr69eObpAhLbBvLWU1D5n6EBBus9KJmVX+aUmzFc
         +cP1U8QaRpaFqJEb4LRC7qIqK8SklFDGaEWG0AtZ2Jo3D7A18NK3Go4b1h7/xMs89cKr
         o/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc;
        bh=v60uqYnukgjgZARXe5JJGms8uUUgUv8wpc53hUaJ67A=;
        b=w0eKYt3unWDlcJo3x811dna4XoMCyJShJEm4PvY1WaL1p5v6zKxdPVlcDBtROICwED
         hTFUZh3MwmHF+JupQzkQIr1MaovwrWgKFTEf30576Mieq45CDeL0X9n/zhuGaO3GagVd
         ohIpomHpVFXjS11bz6+dNqqpRWzBjtXLMyu5zbslU1KLl6e1PulUp3lMKF6ZkxE//LYJ
         oiXrooV2bd2h2YRoX5uNDD7OItxERMX12kH5mM/1ZRzZhbrv4GrILw2NeBxTK4+U4mRN
         t2Lvo395JNpaYCegnRAhPr+2N86yq8sidqGmQK+2MeSOS8VYIyo1cCX8JaRvBKjaz46u
         4miA==
X-Gm-Message-State: ACgBeo0ZaofS62gfdZ5NlD161cavzWXkTmzhT34l5Hdf0UYH6yVcIzkl
	Pn2YkvE+0ex7DF9/Nev6mag=
X-Google-Smtp-Source: AA6agR4wb0hTyertW8x0U44XlUWC9UESZJzGxucrMzv60iW2eQI+SjAZa4eaPq87PCkVEUq6UypKmw==
X-Received: by 2002:a05:620a:1a9a:b0:69c:4a99:ea50 with SMTP id bl26-20020a05620a1a9a00b0069c4a99ea50mr20031342qkb.632.1660765871901;
        Wed, 17 Aug 2022 12:51:11 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id b8-20020ae9eb08000000b006b8f4ade2c9sm13759099qkg.19.2022.08.17.12.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:51:11 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailauth.nyi.internal (Postfix) with ESMTP id 9E9A927C0054;
	Wed, 17 Aug 2022 15:51:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 17 Aug 2022 15:51:10 -0400
X-ME-Sender: <xms:rUb9YsjrhBwDWi1UcrlAJOSkZoFWbWs6Wdyq53p-l3svLt4Dz3MJOg>
    <xme:rUb9YlAwxKSMQtAbCkoqL17OQVtDsxn4hUE3TCkIIXBk51zOdJqH6vyLX7CB_i9bj
    qs7DmA59stT6eK2IA>
X-ME-Received: <xmr:rUb9YkHKEExDeF-dyv87VUyFyglJNclBfoaZqBtFoE7LzDhOVbXTkXzS7qRGgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehiedgudegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveei
    udffiedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:rUb9YtTvq4_U7rRBDZGD4vov0GhVMjm2hdDkcfaE3JuV_ojE4i1hbw>
    <xmx:rUb9YpxZYdET6Anm_xf7p8yk0S_-KxS3CQS2Ouu871PFBPYVw-csxw>
    <xmx:rUb9Yr7rqwGEm3ttZTIYuBBl_eIwK6JjFF_lJ4X-FpeKbm1GWzwghw>
    <xmx:rkb9YgnF-q5Xcc8LmyDfUczZkU66iqh3omlThgZCPB8wDNsRqegbzA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Aug 2022 15:51:09 -0400 (EDT)
Date: Wed, 17 Aug 2022 12:50:50 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v9 03/27] kallsyms: add static relationship between
 `KSYM_NAME_LEN{,_BUFFER}`
Message-ID: <Yv1GmvZlpMopwZTi@boqun-archlinux>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-4-ojeda@kernel.org>
 <202208171238.80053F8C@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202208171238.80053F8C@keescook>

On Wed, Aug 17, 2022 at 12:39:48PM -0700, Kees Cook wrote:
> On Fri, Aug 05, 2022 at 05:41:48PM +0200, Miguel Ojeda wrote:
> > This adds a static assert to ensure `KSYM_NAME_LEN_BUFFER`
> > gets updated when `KSYM_NAME_LEN` changes.
> > 
> > The relationship used is one that keeps the new size (512+1)
> > close to the original buffer size (500).
> > 
> > Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> >  scripts/kallsyms.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> > index f3c5a2623f71..f543b1c4f99f 100644
> > --- a/scripts/kallsyms.c
> > +++ b/scripts/kallsyms.c
> > @@ -33,7 +33,11 @@
> >  #define KSYM_NAME_LEN		128
> >  
> >  /* A substantially bigger size than the current maximum. */
> > -#define KSYM_NAME_LEN_BUFFER	499
> > +#define KSYM_NAME_LEN_BUFFER	512
> > +_Static_assert(
> > +	KSYM_NAME_LEN_BUFFER == KSYM_NAME_LEN * 4,
> > +	"Please keep KSYM_NAME_LEN_BUFFER in sync with KSYM_NAME_LEN"
> > +);
> 
> Why not just make this define:
> 
> #define KSYM_NAME_LEN_BUFFER (KSYM_NAME_LEN * 4)
> 
> ? If there's a good reason not it, please put it in the commit log.
> 

Because KSYM_NAME_LEN_BUFFER is used as a string by stringify() in
fscanf(), defining it as (KSYM_NAME_LEN * 4) will produce a string

	"128 * 4"

after stringify() and that doesn't work with fscanf().

Miguel, maybe we can add something below in the commit log?

`KSYM_NAME_LEN_BUFFER` cannot be defined as an expression, because it
gets stringified in the fscanf() format. Therefore a _Static_assert() is
needed.

Thoughts?

Regards,
Boqun

> -Kees
> 
> -- 
> Kees Cook
