Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09311B667
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 21:46:30 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-34ccedcc584so1057145ab.0
        for <patches@lists.linux.dev>; Wed, 13 Sep 2023 14:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694641590; x=1695246390; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QowXTRSSOC8IB4ueS9Xc0NCSyyqp5xMMkI7wePQSkak=;
        b=bzTovrwMEabQwphQwO/fLdVZUdU/Jh2FvmJddOuct+kI8ER0fz13M8AO5f5TGzpeji
         ePcvA/+yAjX9SW5r7G1pr8H0SddNJusMwEAgvLhJIiMIC39KSQW7G/PvTEkBjrSrikXa
         j+HKmrsMa8+M/zNEzWjAvCUfNuxqVFa1FGldG8qaHibrt0FbMk3+hWQ9MORfdBc0myzx
         VUoa7eRlItyyCWNNtehWMWq2h3opl7GHoB4gPUY91AbFWWG9HdMosFQAgabZJGhGyyAG
         7nKvdfLqkMYN44F2JSVqyRogabj2HAKzK4SlYEGoZ8FIxidOlKMpZcYbWGZX+cW8JVcn
         Vl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694641590; x=1695246390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QowXTRSSOC8IB4ueS9Xc0NCSyyqp5xMMkI7wePQSkak=;
        b=ZzEOBXbDtZPN3qdJWw6UcZ4zT7IsMxIMnVp+B6K+ACkAiXsmL0y5HiEu6oXeq5V6iv
         Dt3hnQqHBnF0CY8TCyOO5L38WEUma2u8+MlL3cTZxymhxOQVHWGXgnVFYlQF5tuenDyj
         MyuwrIfFtg1kadN6zlsnqwcZ8wamuzboMWnxHoTViDN6/YjWVgRSNE7Y5UFqxCTFtsQ5
         AWD5y4vcR0IFns37OwWLPpdVQjUcP6cbACxa6SpexAhyAHtUZt3cXXcoyErGGhZ+bWsf
         W28eIlqzkKEUSS6xfbHAdYXy+xmy0VZZIBJue4ygT72+8ykYBSewL55mH0nmWJ7bpra/
         djeA==
X-Gm-Message-State: AOJu0YxIWK3cGNPGQKJ8QE3f70BZePZFNOqnBlwH+wGz1V7LAoFOXDzO
	ZY3cVeaJBV1HCUOVLfw/qdv/hw==
X-Google-Smtp-Source: AGHT+IHU/gkz+MAiiC6NWDNP87Txd53/KstTmyp3J9ijsGKI32VL8YatV9xSuNpaaWqc2Xy5X4aa3w==
X-Received: by 2002:a05:6e02:1bee:b0:34f:1e9c:45d9 with SMTP id y14-20020a056e021bee00b0034f1e9c45d9mr4553258ilv.12.1694641590231;
        Wed, 13 Sep 2023 14:46:30 -0700 (PDT)
Received: from google.com (26.103.132.34.bc.googleusercontent.com. [34.132.103.26])
        by smtp.gmail.com with ESMTPSA id r5-20020a92c505000000b0034f37a27bb4sm44105ilg.72.2023.09.13.14.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:46:29 -0700 (PDT)
Date: Wed, 13 Sep 2023 21:46:27 +0000
From: Justin Stitt <justinstitt@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kent.overstreet@linux.dev, bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 4/7] bcachefs: Fix -Wformat in bch2_bucket_gens_invalid()
Message-ID: <20230913214627.ankymdgklzwob4ij@google.com>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
 <20230912-bcachefs-warning-fixes-v1-4-a1cc83a38836@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-4-a1cc83a38836@kernel.org>

On Tue, Sep 12, 2023 at 12:15:41PM -0700, Nathan Chancellor wrote:
> When building bcachefs for 32-bit ARM, there is a compiler warning in
> bch2_bucket_gens_invalid() due to use of an incorrect format specifier:
>
>   fs/bcachefs/alloc_background.c:530:10: error: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
>     529 |                 prt_printf(err, "bad val size (%lu != %zu)",
>         |                                                ~~~
>         |                                                %zu
>     530 |                        bkey_val_bytes(k.k), sizeof(struct bch_bucket_gens));
>         |                        ^~~~~~~~~~~~~~~~~~~
>   fs/bcachefs/util.h:223:54: note: expanded from macro 'prt_printf'
>     223 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
>         |                                                               ^~~~~~~~~~~
>
> On 64-bit architectures, size_t is 'unsigned long', so there is no
> warning when using %lu but on 32-bit architectures, size_t is 'unsigned
> int'. Use '%zu', the format specifier for 'size_t', to eliminate the
> warning.
>
> Fixes: 4be0d766a7e9 ("bcachefs: bucket_gens btree")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  fs/bcachefs/alloc_background.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
> index 67e73864823c..2b0d155d1ed5 100644
> --- a/fs/bcachefs/alloc_background.c
> +++ b/fs/bcachefs/alloc_background.c
> @@ -526,7 +526,7 @@ int bch2_bucket_gens_invalid(const struct bch_fs *c, struct bkey_s_c k,
>  			     struct printbuf *err)
>  {
>  	if (bkey_val_bytes(k.k) != sizeof(struct bch_bucket_gens)) {
> -		prt_printf(err, "bad val size (%lu != %zu)",
> +		prt_printf(err, "bad val size (%zu != %zu)",
>  		       bkey_val_bytes(k.k), sizeof(struct bch_bucket_gens));
>  		return -BCH_ERR_invalid_bkey;
>  	}
>
> --
> 2.42.0
>
