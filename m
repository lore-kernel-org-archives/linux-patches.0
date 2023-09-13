Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FEF22EE8
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 21:46:04 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-34f6fd04fbeso1121475ab.1
        for <patches@lists.linux.dev>; Wed, 13 Sep 2023 14:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694641564; x=1695246364; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hS6LHZP97enWTuQrtj4p55fJQ0mnk4aMtCPKI4xtC9M=;
        b=h5da2UNlOzORLnoS25AxASD0nsY9Cvtzi7NhCXRvk+sqUc++etzZQcfXtX6mUURDzj
         xn+z+CMrnTgZUWfHKXI9Dcq20EuN8BhS6sI9fj68/WmASf6UpoYnD74yQv3kCCr1SSsq
         GiGAfwz499ygOFQi6vpXSL16rE9cRkx9uBQLUyj3ovJDUlXvrEu9rUt0gOgYqtbTKeL/
         cDeVli1ZPqINs72G45MuYnSyUTdoL/hkBDN7+PmjKstICvWbTngIA/un3z6u/PPpWojk
         pRNIv3NBT5i2Wb9PwCCzA64IK2xINpTALYCmPM4oX0/odA5OEwiL98ZByA9D++E8OvGM
         QvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694641564; x=1695246364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hS6LHZP97enWTuQrtj4p55fJQ0mnk4aMtCPKI4xtC9M=;
        b=MTBmsCIKZxPzWDPu6BUbIrxundWQi98h+OC2SpBk/sGnER8QjqLXZDN1puQjYhD5FK
         Xl6P9yBJFYJe6WHeB5atowgokjX3FmtObmsaCEr/QbhxCyZI+mYZKDeHKew5eVIcUghC
         LLlbVXJtigAbN2I7dN++pRf36AlXKv+fQNx+/9Oos0pq/Gy0kqnvSWz8HAMa2ISJDAO5
         kZJ1u69KeKLHABa2NMti4wqgJ3iLOY6bER2la6TDrLhOtm+eKcBpvFOhmjfrBLFJV1lV
         xWthGVO+H/urVnjSl2Q7hnbHGzf0CvOk/WvMtDFI/rw9OCnOUiRfLdkCdiHpRZKxsKZp
         nfUA==
X-Gm-Message-State: AOJu0YyyT7k30c/6LCukW+/CDJO46LJbNRx4fY+7+wCMG6sDGFYk/l/W
	n4oYB6q22/p3BnVJjX14r5B6iboUYTp2WIAmV2KTbQ==
X-Google-Smtp-Source: AGHT+IEB+MklxqwnlrjkpN5LSD98xUtIFfRsg2kZyYkJD4SxmRxnVtsxRjGe7HwbeANhxquKJjnX0g==
X-Received: by 2002:a05:6e02:214d:b0:349:9af9:d412 with SMTP id d13-20020a056e02214d00b003499af9d412mr4794802ilv.0.1694641564057;
        Wed, 13 Sep 2023 14:46:04 -0700 (PDT)
Received: from google.com (26.103.132.34.bc.googleusercontent.com. [34.132.103.26])
        by smtp.gmail.com with ESMTPSA id f15-20020a056638118f00b004316bbe1d4csm24843jas.78.2023.09.13.14.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:46:03 -0700 (PDT)
Date: Wed, 13 Sep 2023 21:46:00 +0000
From: Justin Stitt <justinstitt@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kent.overstreet@linux.dev, bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 3/7] bcachefs: Fix -Wformat in bch2_alloc_v4_invalid()
Message-ID: <20230913214600.y3eo3emayljnxfuy@google.com>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
 <20230912-bcachefs-warning-fixes-v1-3-a1cc83a38836@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-3-a1cc83a38836@kernel.org>

On Tue, Sep 12, 2023 at 12:15:40PM -0700, Nathan Chancellor wrote:
> When building bcachefs for 32-bit ARM, there is a compiler warning in
> bch2_alloc_v4_invalid() due to use of an incorrect format specifier:
>
>   fs/bcachefs/alloc_background.c:246:30: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
>     245 |                 prt_printf(err, "bad val size (%u > %lu)",
>         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                                     %u
>     246 |                        alloc_v4_u64s(a.v), bkey_val_u64s(k.k));
>         |                        ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
>   fs/bcachefs/bkey.h:58:27: note: expanded from macro 'bkey_val_u64s'
>      58 | #define bkey_val_u64s(_k)       ((_k)->u64s - BKEY_U64s)
>         |                                 ^
>   fs/bcachefs/util.h:223:54: note: expanded from macro 'prt_printf'
>     223 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
>         |                                                               ^~~~~~~~~~~
>
> This expression is of type 'size_t'. On 64-bit architectures, size_t is
> 'unsigned long', so there is no warning when using %lu but on 32-bit
> architectures, size_t is 'unsigned int'. Use '%zu', the format specifier
> for 'size_t' to eliminate the warning.
>
> Fixes: 11be8e8db283 ("bcachefs: New on disk format: Backpointers")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  fs/bcachefs/alloc_background.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
> index 540d94c0cceb..67e73864823c 100644
> --- a/fs/bcachefs/alloc_background.c
> +++ b/fs/bcachefs/alloc_background.c
> @@ -242,7 +242,7 @@ int bch2_alloc_v4_invalid(const struct bch_fs *c, struct bkey_s_c k,
>  	struct bkey_s_c_alloc_v4 a = bkey_s_c_to_alloc_v4(k);
>
>  	if (alloc_v4_u64s(a.v) > bkey_val_u64s(k.k)) {
> -		prt_printf(err, "bad val size (%u > %lu)",
> +		prt_printf(err, "bad val size (%u > %zu)",
>  		       alloc_v4_u64s(a.v), bkey_val_u64s(k.k));
>  		return -BCH_ERR_invalid_bkey;
>  	}
>
> --
> 2.42.0
>
