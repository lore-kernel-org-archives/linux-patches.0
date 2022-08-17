Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE986D19
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 19:39:50 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so2892931pjf.2
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 12:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=r68vuNb5uh5ONaquxzxTqZ7ONll565ksnKh3ylI2Qso=;
        b=fMHE08mTNGtgJz5Oy07EEtIpqqdqolGc17nEd8gVvKUw5CdSjv/rRzxqaLb78IHB67
         dldRsPtd4wwFvOhdDwQV4bqau/Eu1sfiQ9hhO6/lGkKw/IpZWigxnU2oPUBD+pZqQKEO
         7bul/7sfTougSEqU7vjXZAS4IeQZPRusWPFiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=r68vuNb5uh5ONaquxzxTqZ7ONll565ksnKh3ylI2Qso=;
        b=yJnhDcdGgwP4wMV8iyHHwN2fYiZ7L85ZbAio3T0Zz6wNZW2BIxThPXm3Bz8tWzmRKB
         bCI1O67ecvHxqw0XBKYj0DYxft+9oWzNqU/mbd+qTxY1fsDGzV39xBjrkudzmmf1W02q
         ixwk14SxWt2nVx/NmYBbVn8Gm8YX61LzpmLMamam1VVw1W2xIJjrJtIYB03J5PdaCp2S
         bvDHZ4KV6lcqNPoHBeNUkbejGXsLz8f1QIga0U3WrumGDn/T72DHdXJojx6MVprzzImp
         JJYKiGicWHqSm2X9jMfS4nj7wK3UFd2hw5sIhDpHksJiNySXB40LUg0jPAYvbuVUf3Cl
         9FXQ==
X-Gm-Message-State: ACgBeo0abc1LCQI3bZx/AfVO9IacxD8XIdsClP7VNkTbaiQXixij/yct
	g3yjT+bc0VWIkimNnoZcUNuuHw==
X-Google-Smtp-Source: AA6agR4QLUE1Ptr9L6/5prtoBq9XWGwAqLKFX6+0rTRLhg6Qq0It1iuQEECu3eQaVfLVc7g9ixBe/A==
X-Received: by 2002:a17:902:ccd1:b0:172:5c49:34be with SMTP id z17-20020a170902ccd100b001725c4934bemr21344292ple.23.1660765189710;
        Wed, 17 Aug 2022 12:39:49 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q7-20020aa79607000000b0052d0a93f6d5sm10845922pfg.116.2022.08.17.12.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:39:49 -0700 (PDT)
Date: Wed, 17 Aug 2022 12:39:48 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH v9 03/27] kallsyms: add static relationship between
 `KSYM_NAME_LEN{,_BUFFER}`
Message-ID: <202208171238.80053F8C@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-4-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-4-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:41:48PM +0200, Miguel Ojeda wrote:
> This adds a static assert to ensure `KSYM_NAME_LEN_BUFFER`
> gets updated when `KSYM_NAME_LEN` changes.
> 
> The relationship used is one that keeps the new size (512+1)
> close to the original buffer size (500).
> 
> Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  scripts/kallsyms.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index f3c5a2623f71..f543b1c4f99f 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -33,7 +33,11 @@
>  #define KSYM_NAME_LEN		128
>  
>  /* A substantially bigger size than the current maximum. */
> -#define KSYM_NAME_LEN_BUFFER	499
> +#define KSYM_NAME_LEN_BUFFER	512
> +_Static_assert(
> +	KSYM_NAME_LEN_BUFFER == KSYM_NAME_LEN * 4,
> +	"Please keep KSYM_NAME_LEN_BUFFER in sync with KSYM_NAME_LEN"
> +);

Why not just make this define:

#define KSYM_NAME_LEN_BUFFER (KSYM_NAME_LEN * 4)

? If there's a good reason not it, please put it in the commit log.

-Kees

-- 
Kees Cook
