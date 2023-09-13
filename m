Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4BE1DA3C
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 21:59:05 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-792717ef3c9so9965039f.3
        for <patches@lists.linux.dev>; Wed, 13 Sep 2023 14:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694642344; x=1695247144; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+zCQ2BjBgtFZ2NhlAiFIzP/Im5wW1vWUYChl7lp+s88=;
        b=XuBZpbq/n83tD8hcN7ox5iGF86sD+J+S8uVjJy+8eNnyKNhv8hjRu+pQcMqqu/JF3T
         fVwq+t4HLDrScLEhzbKR3zN++EG45JnoB4/10vQIz/sPbqx6QzqqpRZe6K0RfdyZD4FN
         v7KF+TvXVyThN3qn5vA+3unAdDenmfyfHGvPq6NqFVas5EYvVme8/eW7WgXbjgw3znrn
         X3AH5P16ufk2eDBuOG77n3T+0DhBnfhUmTgZlWL5iJDOfStjxLkJExZ8Dg/cQSPlexnb
         r4rp2bu/rUgxzEvZ1upqSppvTav6wsQstBYbDpnRkPnXUu9ZzF460YgMti+nPOmacNIP
         t0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694642344; x=1695247144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zCQ2BjBgtFZ2NhlAiFIzP/Im5wW1vWUYChl7lp+s88=;
        b=vrVgS2GAZbssG6iyv1+OAU53qLHqzyGDhTv8TxHg+cAMmLZhM9+5OjCETynj8Kc9tY
         XykfIhoDN7JWetP4MkJm4j7HybtH/VSpCul6xF6CoeSvyYJ1Al+mbpbGFKJCI3zoVXbn
         CXrhoopRpwrMtiJ995bnXipaLYow60ERBGwATfqiRHkQDPcdyf38XVs6of8df08RHeNP
         4TYSkaNPeeo0LDmCiWAVtQNgj2DwYpjpvaJOHEuN8c7p2cjb1ZtCWdvudH0UOXI6McRj
         B8EUOazhooZCKXuvMEjP0ezDot+en+F/yc1fla5yK4B6onnjOaxkqujds16JTNl2IHNy
         kBsA==
X-Gm-Message-State: AOJu0YzrwWUXLsEUwkZB+GpatoChb0gw1qGAVV2W82nOlQMY9w/cAX5z
	IiR69M3gs934Jk/csdAKd3o0+Q==
X-Google-Smtp-Source: AGHT+IHqayyFOTET4Oxr9mF0S5RGQHFaeK9o3on7YXY3s2SYxwil2JxnMX2Joby5fXJ//kuV/gya1Q==
X-Received: by 2002:a05:6e02:1d8b:b0:349:2d61:8631 with SMTP id h11-20020a056e021d8b00b003492d618631mr5002348ila.10.1694642344560;
        Wed, 13 Sep 2023 14:59:04 -0700 (PDT)
Received: from google.com (26.103.132.34.bc.googleusercontent.com. [34.132.103.26])
        by smtp.gmail.com with ESMTPSA id ee18-20020a056638293200b0042b57bbbaf2sm34665jab.26.2023.09.13.14.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:59:03 -0700 (PDT)
Date: Wed, 13 Sep 2023 21:59:01 +0000
From: Justin Stitt <justinstitt@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kent.overstreet@linux.dev, bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 6/7] bcachefs: Fix -Wcompare-distinct-pointer-types in
 do_encrypt()
Message-ID: <20230913215901.kffbnpkosg7pkxd6@google.com>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
 <20230912-bcachefs-warning-fixes-v1-6-a1cc83a38836@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-6-a1cc83a38836@kernel.org>

On Tue, Sep 12, 2023 at 12:15:43PM -0700, Nathan Chancellor wrote:
> When building bcachefs for 32-bit ARM, there is a warning when using
> min() to compare a variable of type 'size_t' with an expression of type
> 'unsigned long':
>
>   fs/bcachefs/checksum.c:142:22: error: comparison of distinct pointer types ('typeof (len) *' (aka 'unsigned int *') and 'typeof (((1UL) << 12) - offset) *' (aka 'unsigned long *')) [-Werror,-Wcompare-distinct-pointer-types]
>     142 |                         unsigned pg_len = min(len, PAGE_SIZE - offset);
>         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   include/linux/minmax.h:69:19: note: expanded from macro 'min'
>      69 | #define min(x, y)       __careful_cmp(x, y, <)
>         |                         ^~~~~~~~~~~~~~~~~~~~~~
>   include/linux/minmax.h:38:24: note: expanded from macro '__careful_cmp'
>      38 |         __builtin_choose_expr(__safe_cmp(x, y), \
>         |                               ^~~~~~~~~~~~~~~~
>   include/linux/minmax.h:28:4: note: expanded from macro '__safe_cmp'
>      28 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>         |                  ^~~~~~~~~~~~~~~~~
>   include/linux/minmax.h:22:28: note: expanded from macro '__typecheck'
>      22 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>         |                    ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
>   1 error generated.
>
> On 64-bit architectures, size_t is 'unsigned long', so there is no
> warning when comparing these two expressions. Use min_t(size_t, ...) for
> this situation, eliminating the warning.
>
> Fixes: 1fb50457684f ("bcachefs: Fix memory corruption in encryption path")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  fs/bcachefs/checksum.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
> index 36939020f67d..ff0c3cd39ee2 100644
> --- a/fs/bcachefs/checksum.c
> +++ b/fs/bcachefs/checksum.c
> @@ -139,7 +139,7 @@ static inline int do_encrypt(struct crypto_sync_skcipher *tfm,
>
>  		for (i = 0; i < pages; i++) {
>  			unsigned offset = offset_in_page(buf);
> -			unsigned pg_len = min(len, PAGE_SIZE - offset);
> +			unsigned pg_len = min_t(size_t, len, PAGE_SIZE - offset);
>
>  			sg_set_page(sg + i, vmalloc_to_page(buf), pg_len, offset);
>  			buf += pg_len;
>
> --
> 2.42.0
>
