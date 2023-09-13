Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590E122EFC
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 21:43:02 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-34f6c725d94so1055775ab.0
        for <patches@lists.linux.dev>; Wed, 13 Sep 2023 14:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694641381; x=1695246181; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WWw/GgRkO6GSoA0lYdFcK3fV5kiUwH+NqpK5ZJCXdHU=;
        b=XYUehcNz8tFY+T8k1c3AuqMIKDDVt0eM21BhBQjYqK2DFoZ2AAfMu51c6ReQztY4w/
         MDnLN4biAR1oH1YPyTWMjLVkQKzKmCA4fqKX5dNnvAld6OH/Gy1LIWG/IOhw4td7uyx8
         Y96nJn/yEjnjtWAGcX9n2sziQsovF2m+z65WLbktneRJf5N+qaWDvl8vLRQuY0HKMBK7
         QRbC6VMZytd7xNX1Iavtg7Q+Z2G04tDNIVgpRRqb9+92hFV/DncoX3/PHowbLSzTpVWq
         /qGpjf23QR0zosxvUWKjOsYlMJw01A5LPlxVpiqkQFMsAQwEmDwqEs4oRI3zu7AdjQS4
         7oHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694641381; x=1695246181;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWw/GgRkO6GSoA0lYdFcK3fV5kiUwH+NqpK5ZJCXdHU=;
        b=c0UtK+OSWb3w+IdV/xZeKGXl4Q+7Hsb1/U6sdt6WL2MDJ5g0sKNZvu6BGyTNDsANCu
         kPkGP+yM7DPnTW1nGNhcJ5SyxiqniWqN6Qwq2S+tNerbf9l96aFvAgpu4QN09kfArwbp
         yp790kDXYR7f8QgWpwehQobUxbtFiGC/Ciwi7XjHAq80Tmu5TKuyjJ69ZYGuk8iBTm6a
         dL3O+hVF8R7BBBu3oY0C+bg307XAHixM0lNayZtRxOukbLBtDM9XR0BSLIK3/+F+kBHm
         R/UX8dzMUmR7orwLjGllowhZ3DmnqZllGFCLamV+gbRmqXvAP9ZtnMPocY1xVROEBTb2
         vBbQ==
X-Gm-Message-State: AOJu0Yw9YvD0dInBa9PREb0znq/3CQkCIHb0ZvzWo6cVw8/Vp1g8VmFT
	0cUYEepsBHBvs9QKTKkl+28tWg==
X-Google-Smtp-Source: AGHT+IEW9tSNFuxjhVWsQo//UJue72qdTRJDT7UqhRqtQNQzNxPtNM01ZBxmyCinF0Ee+0CnJZ1m9Q==
X-Received: by 2002:a05:6e02:1d93:b0:34b:aa34:a5c4 with SMTP id h19-20020a056e021d9300b0034baa34a5c4mr4118911ila.30.1694641381373;
        Wed, 13 Sep 2023 14:43:01 -0700 (PDT)
Received: from google.com (26.103.132.34.bc.googleusercontent.com. [34.132.103.26])
        by smtp.gmail.com with ESMTPSA id b11-20020a02a58b000000b0042b09036e5fsm21283jam.175.2023.09.13.14.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:43:00 -0700 (PDT)
Date: Wed, 13 Sep 2023 21:42:57 +0000
From: Justin Stitt <justinstitt@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kent.overstreet@linux.dev, bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/7] bcachefs: Fix -Wformat in
 bch2_set_bucket_needs_journal_commit()
Message-ID: <20230913214257.vsjt5qrpa57sjcg7@google.com>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
 <20230912-bcachefs-warning-fixes-v1-1-a1cc83a38836@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-1-a1cc83a38836@kernel.org>

On Tue, Sep 12, 2023 at 12:15:38PM -0700, Nathan Chancellor wrote:
> When building bcachefs for 32-bit ARM, there is a compiler warning in
> bch2_set_bucket_needs_journal_commit() due to a debug print using the
> wrong specifier:
>
>   fs/bcachefs/buckets_waiting_for_journal.c:137:30: error: format specifies type 'size_t' (aka 'unsigned int') but the argument has type 'unsigned long' [-Werror,-Wformat]
>     136 |         pr_debug("took %zu rehashes, table at %zu/%zu elements",
>         |                                                   ~~~
>         |                                                   %lu
>     137 |                  nr_rehashes, nr_elements, 1UL << b->t->bits);
>         |                                            ^~~~~~~~~~~~~~~~~
>   include/linux/printk.h:579:26: note: expanded from macro 'pr_debug'
>     579 |         dynamic_pr_debug(fmt, ##__VA_ARGS__)
>         |                          ~~~    ^~~~~~~~~~~
>   include/linux/dynamic_debug.h:270:22: note: expanded from macro 'dynamic_pr_debug'
>     270 |                            pr_fmt(fmt), ##__VA_ARGS__)
>         |                                   ~~~     ^~~~~~~~~~~
>   include/linux/dynamic_debug.h:250:59: note: expanded from macro '_dynamic_func_call'
>     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
>         |                                                                  ^~~~~~~~~~~
>   include/linux/dynamic_debug.h:248:65: note: expanded from macro '_dynamic_func_call_cls'
>     248 |         __dynamic_func_call_cls(__UNIQUE_ID(ddebug), cls, fmt, func, ##__VA_ARGS__)
>         |                                                                        ^~~~~~~~~~~
>   include/linux/dynamic_debug.h:224:15: note: expanded from macro '__dynamic_func_call_cls'
>     224 |                 func(&id, ##__VA_ARGS__);                       \
>         |                             ^~~~~~~~~~~
>   1 error generated.
>
> On 64-bit architectures, size_t is 'unsigned long', so there is no
> warning when using %zu but on 32-bit architectures, size_t is
> 'unsigned int'. Use the correct specifier to resolve the warning.
>
> Fixes: 7a82e75ddaef ("bcachefs: New data structure for buckets waiting on journal commit")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  fs/bcachefs/buckets_waiting_for_journal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/buckets_waiting_for_journal.c b/fs/bcachefs/buckets_waiting_for_journal.c
> index 81ab685cdef9..ec1b636ef78d 100644
> --- a/fs/bcachefs/buckets_waiting_for_journal.c
> +++ b/fs/bcachefs/buckets_waiting_for_journal.c
> @@ -133,7 +133,7 @@ int bch2_set_bucket_needs_journal_commit(struct buckets_waiting_for_journal *b,
>  	b->t = n;
>  	kvfree(t);
>
> -	pr_debug("took %zu rehashes, table at %zu/%zu elements",
> +	pr_debug("took %zu rehashes, table at %zu/%lu elements",
>  		 nr_rehashes, nr_elements, 1UL << b->t->bits);
>  out:
>  	mutex_unlock(&b->lock);
>
> --
> 2.42.0
>
