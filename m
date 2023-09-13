Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DD822F15
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 21:57:56 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6c09f1f4610so190728a34.0
        for <patches@lists.linux.dev>; Wed, 13 Sep 2023 14:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694642275; x=1695247075; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o3ASYzXFzhwX08HgFkmYe9aO+tH16Bmrn4RY01FcRdU=;
        b=4yUrgS1b5j6jTsMNSUe3qBI+AfUe3I/B1WAVkGyYLicf+gR6W3QfjHl9tou9ElMauV
         xf7J2QHIxaMSVUdi//WEYr5yPq2YausBqjRM2u9gWhpuoQ0bayk7xly7mUDvnZZyjFd8
         hzB12TUmjEXE42/JgUD5wn4nteX4ury3vFeOH6eyfWHh6mA6kIJigbfxNX11pk6+E+uO
         asKjyiQkvIFRPhxF+0bTWfGtb0+dYDCIiQTOV+wT1v44PqKCAjvkdPKXE7Ov3kiLML6o
         Xr1N6PV7bQHH7obTFAyzuySrM4p3IJeAayqsfQvzetrzhByWELSA5yWNyFur+ociSc03
         fPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694642275; x=1695247075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o3ASYzXFzhwX08HgFkmYe9aO+tH16Bmrn4RY01FcRdU=;
        b=taUZhA1WdiRZeSMjK2Z4F/jK44q9xInJA57Vnf/VA4UJDxFaU08hnUUUP19fYjHpOh
         RTzRD4X4Pv7LFPEy34IGud/l9sMyAxYD3QDRYO8Py5r8MmXG+aHgCO4GefTZCV5+yZuu
         qNPR2k7k5ANDI/pxt8gmmB76+DmbSPfTA05OPcZAS0dSkwI4vvqjpctu4Mxi64OzuQ+z
         Q4wDkUUFb3qLlAHX64PtZEpDmRnwt4FkvdXEKWxx+4RKDvUjIaVsV0UhfhzAZUq4JYxv
         xWWepGr5lJo8YLOvmbhVcM8n5WVzWDpdlurLh7ETAO0Q3YNJ4sJtG9WQciebiN4aVSKV
         ghNg==
X-Gm-Message-State: AOJu0YzFKk8pHydGmBFgymCdqprd+wD4FbYo023UFjr8PFrzKCEUNVlZ
	xZe4eBZKLhkNEEKPIRLjHUc9zg==
X-Google-Smtp-Source: AGHT+IHSgCOvwluF/xKeIomnnDgcULBJ6bjIyFPVhZkxnbRbDu+KsW2ZutX6SMqzLsPLczfpYNswXQ==
X-Received: by 2002:a9d:7d8a:0:b0:6be:fd51:cb6d with SMTP id j10-20020a9d7d8a000000b006befd51cb6dmr4346463otn.31.1694642275587;
        Wed, 13 Sep 2023 14:57:55 -0700 (PDT)
Received: from google.com (26.103.132.34.bc.googleusercontent.com. [34.132.103.26])
        by smtp.gmail.com with ESMTPSA id t24-20020a02ab98000000b004312e5c9b0dsm26436jan.139.2023.09.13.14.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:57:54 -0700 (PDT)
Date: Wed, 13 Sep 2023 21:57:52 +0000
From: Justin Stitt <justinstitt@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kent.overstreet@linux.dev, bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 5/7] bcachefs: Fix
 -Wincompatible-function-pointer-types-strict from key_invalid callbacks
Message-ID: <20230913215752.dj3jbeth3j6f7udc@google.com>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
 <20230912-bcachefs-warning-fixes-v1-5-a1cc83a38836@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-5-a1cc83a38836@kernel.org>

On Tue, Sep 12, 2023 at 12:15:42PM -0700, Nathan Chancellor wrote:
> When building bcachefs with -Wincompatible-function-pointer-types-strict,
> a clang warning designed to catch issues with mismatched function
> pointer types, which will be fatal at runtime due to kernel Control Flow
> Integrity (kCFI), there are several instances along the lines of:
>
>   fs/bcachefs/bkey_methods.c:118:2: error: incompatible function pointer types initializing 'int (*)(const struct bch_fs *, struct bkey_s_c, enum bkey_invalid_flags, struct printbuf *)' with an expression of type 'int (const struct bch_fs *, struct bkey_s_c, unsigned int, struct printbuf *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>     118 |         BCH_BKEY_TYPES()
>         |         ^~~~~~~~~~~~~~~~
>   fs/bcachefs/bcachefs_format.h:342:2: note: expanded from macro 'BCH_BKEY_TYPES'
>     342 |         x(deleted,              0)                      \
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
>   fs/bcachefs/bkey_methods.c:117:41: note: expanded from macro 'x'
>     117 | #define x(name, nr) [KEY_TYPE_##name]   = bch2_bkey_ops_##name,
>         |                                           ^~~~~~~~~~~~~~~~~~~~
>   <scratch space>:206:1: note: expanded from here
>     206 | bch2_bkey_ops_deleted
>         | ^~~~~~~~~~~~~~~~~~~~~
>   fs/bcachefs/bkey_methods.c:34:17: note: expanded from macro 'bch2_bkey_ops_deleted'
>      34 |         .key_invalid = deleted_key_invalid,             \
>         |                        ^~~~~~~~~~~~~~~~~~~
>
> The flags parameter should be of type 'enum bkey_invalid_flags', not
> 'unsigned int'. Adjust the type everywhere so that there is no more
> warning.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>
> ---
>  fs/bcachefs/bkey_methods.c | 10 +++++-----
>  fs/bcachefs/subvolume.c    |  2 +-
>  fs/bcachefs/subvolume.h    |  2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/bcachefs/bkey_methods.c b/fs/bcachefs/bkey_methods.c
> index 6547142db428..2a284c954c7a 100644
> --- a/fs/bcachefs/bkey_methods.c
> +++ b/fs/bcachefs/bkey_methods.c
> @@ -25,7 +25,7 @@ const char * const bch2_bkey_types[] = {
>  };
>
>  static int deleted_key_invalid(const struct bch_fs *c, struct bkey_s_c k,
> -			       unsigned flags, struct printbuf *err)
> +			       enum bkey_invalid_flags flags, struct printbuf *err)
>  {
>  	return 0;
>  }
> @@ -39,7 +39,7 @@ static int deleted_key_invalid(const struct bch_fs *c, struct bkey_s_c k,
>  })
>
>  static int empty_val_key_invalid(const struct bch_fs *c, struct bkey_s_c k,
> -				 unsigned flags, struct printbuf *err)
> +				 enum bkey_invalid_flags flags, struct printbuf *err)
>  {
>  	if (bkey_val_bytes(k.k)) {
>  		prt_printf(err, "incorrect value size (%zu != 0)",
> @@ -55,7 +55,7 @@ static int empty_val_key_invalid(const struct bch_fs *c, struct bkey_s_c k,
>  })
>
>  static int key_type_cookie_invalid(const struct bch_fs *c, struct bkey_s_c k,
> -				   unsigned flags, struct printbuf *err)
> +				   enum bkey_invalid_flags flags, struct printbuf *err)
>  {
>  	return 0;
>  }
> @@ -70,7 +70,7 @@ static int key_type_cookie_invalid(const struct bch_fs *c, struct bkey_s_c k,
>  })
>
>  static int key_type_inline_data_invalid(const struct bch_fs *c, struct bkey_s_c k,
> -					unsigned flags, struct printbuf *err)
> +					enum bkey_invalid_flags flags, struct printbuf *err)
>  {
>  	return 0;
>  }
> @@ -91,7 +91,7 @@ static void key_type_inline_data_to_text(struct printbuf *out, struct bch_fs *c,
>  })
>
>  static int key_type_set_invalid(const struct bch_fs *c, struct bkey_s_c k,
> -				unsigned flags, struct printbuf *err)
> +				enum bkey_invalid_flags flags, struct printbuf *err)
>  {
>  	if (bkey_val_bytes(k.k)) {
>  		prt_printf(err, "incorrect value size (%zu != %zu)",
> diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
> index 0214a98deb4f..b371a5c4e06e 100644
> --- a/fs/bcachefs/subvolume.c
> +++ b/fs/bcachefs/subvolume.c
> @@ -99,7 +99,7 @@ int bch2_check_subvols(struct bch_fs *c)
>  /* Subvolumes: */
>
>  int bch2_subvolume_invalid(const struct bch_fs *c, struct bkey_s_c k,
> -			   unsigned flags, struct printbuf *err)
> +			   enum bkey_invalid_flags flags, struct printbuf *err)
>  {
>  	if (bkey_lt(k.k->p, SUBVOL_POS_MIN) ||
>  	    bkey_gt(k.k->p, SUBVOL_POS_MAX)) {
> diff --git a/fs/bcachefs/subvolume.h b/fs/bcachefs/subvolume.h
> index 8d4c50f4cd05..bb14f92e8687 100644
> --- a/fs/bcachefs/subvolume.h
> +++ b/fs/bcachefs/subvolume.h
> @@ -10,7 +10,7 @@ enum bkey_invalid_flags;
>  int bch2_check_subvols(struct bch_fs *);
>
>  int bch2_subvolume_invalid(const struct bch_fs *, struct bkey_s_c,
> -			   unsigned, struct printbuf *);
> +			   enum bkey_invalid_flags, struct printbuf *);
>  void bch2_subvolume_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
>
>  #define bch2_bkey_ops_subvolume ((struct bkey_ops) {		\
>
> --
> 2.42.0
>
