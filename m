Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866911C30
	for <patches@lists.linux.dev>; Sun, 12 Mar 2023 09:59:21 +0000 (UTC)
Received: by mail-wr1-f49.google.com with SMTP id g3so8771026wri.6
        for <patches@lists.linux.dev>; Sun, 12 Mar 2023 01:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678615160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F/eUf+U6VJsU72zpkAHAR/G+9W+06JthKevGiP5LF44=;
        b=mQjD7qOx7ex1pHGWyQeUg0YqTmCHy1WTTDhdvfcblgD/O1BEmOllQOhb+WykNhIjZJ
         8fABaAKSlHCX8WjL7ecmWEiu0afJm49LiQgrU5P3uvtEvjGEpPvoO7j8dghtH9yB888L
         HCvBJoyz+jBZK/OH4h0rkBdLpQgxskFHjLxJKzZvU/LYcoYJYRGamZUo6R8rp+kaw/P5
         9Sr9zUgOhCFMx8UDPSwTM1pnHDgf60/Et0uMd8VCzatob3+VhJvJcfqal/9xtFZQM0C+
         ptVF/C9NDptX9W5XaKpi5Qjssag5XtJADn60tuPiS9xen4hjcQy9fJnpldX5GgdwflXP
         3vAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678615160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/eUf+U6VJsU72zpkAHAR/G+9W+06JthKevGiP5LF44=;
        b=JmJVPtuqPVprbVgKh0vAtD4tGe/tAwA4WqP4kFc2wauOGmc6gSLaC8qfGpNslVOxQ/
         FKcS9OZu36Zy4zPXBa9rLHnF+FP2lpki6xlTZgMnLQt3szw/12KGBxZ+SYq3/GuCt21w
         xQhH7MuTLTh/Z1xC5VycGv1W1rlZRfRYgdv1C9gWZ7ZrL5IWv0gCNOcDR+UFdxpXShve
         nm+T6xcmOGTtDrQcr018Z4kOTohJXRSrVZ6I19DyqxihZ46npXRF0zDL8D26BCfOLPzd
         zqid4m8P58wGWq3Jr5BsSHPjccdaE7/Eyxh9rrTiY7Z2Vx8EKhYPE5puvK2+6iVB1TZ4
         UumA==
X-Gm-Message-State: AO0yUKXup22Tl7TpQMxxyoCxf0/4PWzOS1Rp2fgYYkbyY5EWcZeJVWRH
	uc/lnnpRGPfayYezCgU0I0o=
X-Google-Smtp-Source: AK7set8l8/lXKE5CTcpAn0qTvK8Gp5PAdyHglSBceQJL8ZQLKfrUOQl3w3Kww9Ks9mqp+kEuNQe/1Q==
X-Received: by 2002:a05:6000:181:b0:2ce:aa2e:b864 with SMTP id p1-20020a056000018100b002ceaa2eb864mr1211615wrx.27.1678615159553;
        Sun, 12 Mar 2023 01:59:19 -0800 (PST)
Received: from kernel.org ([46.120.23.99])
        by smtp.gmail.com with ESMTPSA id z10-20020a5d654a000000b002ceaa0e6aa5sm1753461wrv.73.2023.03.12.01.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 01:59:19 -0800 (PST)
Date: Sun, 12 Mar 2023 11:59:15 +0200
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 7/7] mm/slab: document kfree() as allowed for
 kmem_cache_alloc() objects
Message-ID: <ZA2ic9JYXGVzps1+@kernel.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-8-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-8-vbabka@suse.cz>

On Fri, Mar 10, 2023 at 11:32:09AM +0100, Vlastimil Babka wrote:
> This will make it easier to free objects in situations when they can
> come from either kmalloc() or kmem_cache_alloc(), and also allow
> kfree_rcu() for freeing objects from kmem_cache_alloc().
> 
> For the SLAB and SLUB allocators this was always possible so with SLOB
> gone, we can document it as supported.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> ---
>  Documentation/core-api/memory-allocation.rst | 15 +++++++++++----
>  include/linux/rcupdate.h                     |  6 ++++--
>  mm/slab_common.c                             |  5 +----
>  3 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
> index 5954ddf6ee13..f9e8d352ed67 100644
> --- a/Documentation/core-api/memory-allocation.rst
> +++ b/Documentation/core-api/memory-allocation.rst
> @@ -170,7 +170,14 @@ should be used if a part of the cache might be copied to the userspace.
>  After the cache is created kmem_cache_alloc() and its convenience
>  wrappers can allocate memory from that cache.
>  
> -When the allocated memory is no longer needed it must be freed. You can
> -use kvfree() for the memory allocated with `kmalloc`, `vmalloc` and
> -`kvmalloc`. The slab caches should be freed with kmem_cache_free(). And
> -don't forget to destroy the cache with kmem_cache_destroy().
> +When the allocated memory is no longer needed it must be freed. Objects

I'd add a line break before Objects                               ^

> +allocated by `kmalloc` can be freed by `kfree` or `kvfree`.
> +Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`
> +or also by `kfree` or `kvfree`, which can be more convenient as it does

Maybe replace 'or also by' with a coma:

Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`,
`kfree` or `kvfree`, which can be more convenient as it does


> +not require the kmem_cache pointed.

                             ^ pointer.

> +The rules for _bulk and _rcu flavors of freeing functions are analogical.

Maybe 

The same rules apply to _bulk and _rcu flavors of freeing functions.

> +
> +Memory allocated by `vmalloc` can be freed with `vfree` or `kvfree`.
> +Memory allocated by `kvmalloc` can be freed with `kvfree`.
> +Caches created by `kmem_cache_create` should be freed with
> +`kmem_cache_destroy` only after freeing all the allocated objects first.
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 094321c17e48..dcd2cf1e8326 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -976,8 +976,10 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>   * either fall back to use of call_rcu() or rearrange the structure to
>   * position the rcu_head structure into the first 4096 bytes.
>   *
> - * Note that the allowable offset might decrease in the future, for example,
> - * to allow something like kmem_cache_free_rcu().
> + * The object to be freed can be allocated either by kmalloc() or
> + * kmem_cache_alloc().
> + *
> + * Note that the allowable offset might decrease in the future.
>   *
>   * The BUILD_BUG_ON check must not involve any function calls, hence the
>   * checks are done in macros here.
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 1522693295f5..607249785c07 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -989,12 +989,9 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller);
>  
>  /**
>   * kfree - free previously allocated memory
> - * @object: pointer returned by kmalloc.
> + * @object: pointer returned by kmalloc() or kmem_cache_alloc()
>   *
>   * If @object is NULL, no operation is performed.
> - *
> - * Don't free memory not originally allocated by kmalloc()
> - * or you will run into trouble.
>   */
>  void kfree(const void *object)
>  {
> -- 
> 2.39.2
> 

-- 
Sincerely yours,
Mike.
