Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B3D7A
	for <patches@lists.linux.dev>; Sun, 27 Feb 2022 00:18:37 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d17so7908645pfl.0
        for <patches@lists.linux.dev>; Sat, 26 Feb 2022 16:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n1TJ0Y2cV3ooViKl4YV0Gg01JoStoDXO+vd94Rnxvno=;
        b=FsPjxCbTXnQGUqDn4BqP5TqcxkgUQF/5Lnfz86M++Dz1AC/lqN/7gyMRQ8bxGAC24l
         l1xfrXzBc8wBuEbD05QWy+oKejfRJ+BR+K6ZyTnaz8bTZOfNYrY8uov8qmzR39OGwcpC
         UFYKfK2g3pTDpLWAi3FX1ThIfbLtzLIpwfIcys7xrRaDeqW7D4GPbKhAuUO6zrhk2O5p
         VjmtSd0k+lB7cZ9TInEDJ6NJlPY8BWMbHp2qOvLHXvGpKaN+tBMeF8WHA5yGvI0b3U2h
         d3+exONWiqXdaNw7qlel7MdPW+2FmKVWF9cGME+ygP69N75RJlr42RMStGVzc8bVJkma
         aH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n1TJ0Y2cV3ooViKl4YV0Gg01JoStoDXO+vd94Rnxvno=;
        b=QlBCdwJRbdOmyQduM8hQzciYnARvNj2W0xKPXAQ2O58CvGRhtMYzeECultcCEvQ+PX
         RYKSYszJoNlIUTVMOKeZ/xCFLTO1ulsPclF5kpbwSsvY1KKq71I487yKb1zAQBMTd2++
         bZgFLpyjGo8ZAWRk17YiQHDiacZcdkikDLQhcvtb75zlDeW6WwOqPCoNWZiwKwGA+COC
         39rRDW5LZhgnAdpGXoon0whWf8ZP+UFPKqD4HKnOYhPotgT3OEWXRXJ4bYhPgZRB5K2N
         ++8hFehgC5Jwam2OGW8QvwzO7kK47wVUBOc13M09z4Od/WJaa/aUbHNC/ndHnLJbvXb0
         +DBQ==
X-Gm-Message-State: AOAM533HgXR6QwWtq4MB//guxR3fe+digip9E3U85HmBRslDSYqlGfRg
	WpqdXQvHGvmFc5q600wF268=
X-Google-Smtp-Source: ABdhPJzaYbE9wt0hN6MMtWdOuTFNdyKrRrDJ7UMIDxzQDw8mKBv5MAvizizTGG+QwUbzX63Q1vVT3Q==
X-Received: by 2002:a05:6a00:1691:b0:4e1:935f:94dd with SMTP id k17-20020a056a00169100b004e1935f94ddmr14605506pfc.83.1645921117113;
        Sat, 26 Feb 2022 16:18:37 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id 124-20020a620582000000b004dee0e77128sm7412648pff.166.2022.02.26.16.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 16:18:36 -0800 (PST)
Date: Sun, 27 Feb 2022 00:18:32 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Oliver Glitta <glittao@gmail.com>,
	Faiyaz Mohammed <faiyazm@codeaurora.org>
Subject: Re: [PATCH 3/5] mm/slub: aggregate and print stack traces in debugfs
 files
Message-ID: <YhrDWK+TfC3uyjyX@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220225180318.20594-1-vbabka@suse.cz>
 <20220225180318.20594-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225180318.20594-4-vbabka@suse.cz>

On Fri, Feb 25, 2022 at 07:03:16PM +0100, Vlastimil Babka wrote:
> From: Oliver Glitta <glittao@gmail.com>
> 
> Aggregate objects in slub cache by stack trace in addition to caller
> address when producing contents of debugfs files alloc_traces and
> free_traces in debugfs. Also add the stack traces to the debugfs
> output. This makes it much more useful to e.g. debug memory leaks.
> 
> Signed-off-by: Oliver Glitta <glittao@gmail.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 3140f763e819..06599db4faa3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5075,6 +5075,7 @@ EXPORT_SYMBOL(validate_slab_cache);
>   */
>  
>  struct location {
> +	depot_stack_handle_t handle;
>  	unsigned long count;
>  	unsigned long addr;
>  	long long sum_time;
> @@ -5127,9 +5128,13 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
>  {
>  	long start, end, pos;
>  	struct location *l;
> -	unsigned long caddr;
> +	unsigned long caddr, chandle;
>  	unsigned long age = jiffies - track->when;
> +	depot_stack_handle_t handle = 0;
>  
> +#ifdef CONFIG_STACKDEPOT
> +	handle = READ_ONCE(track->handle);
> +#endif
>  	start = -1;
>  	end = t->count;
>  
> @@ -5144,7 +5149,8 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
>  			break;
>  
>  		caddr = t->loc[pos].addr;
> -		if (track->addr == caddr) {
> +		chandle = t->loc[pos].handle;
> +		if ((track->addr == caddr) && (handle == chandle)) {
>
>  			l = &t->loc[pos];
>  			l->count++;
> @@ -5169,6 +5175,8 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
>  
>  		if (track->addr < caddr)
>  			end = pos;
> +		else if (track->addr == caddr && handle < chandle)
> +			end = pos;
>  		else
>  			start = pos;
>  	}
> @@ -5191,6 +5199,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
>  	l->max_time = age;
>  	l->min_pid = track->pid;
>  	l->max_pid = track->pid;
> +	l->handle = handle;
>  	cpumask_clear(to_cpumask(l->cpus));
>  	cpumask_set_cpu(track->cpu, to_cpumask(l->cpus));
>  	nodes_clear(l->nodes);
> @@ -6102,6 +6111,21 @@ static int slab_debugfs_show(struct seq_file *seq, void *v)
>  			seq_printf(seq, " nodes=%*pbl",
>  				 nodemask_pr_args(&l->nodes));
>  
> +#ifdef CONFIG_STACKDEPOT
> +		{
> +			depot_stack_handle_t handle;
> +			unsigned long *entries;
> +			unsigned int nr_entries, j;
> +
> +			handle = READ_ONCE(l->handle);
> +			if (handle) {
> +				nr_entries = stack_depot_fetch(handle, &entries);
> +				seq_puts(seq, "\n");
> +				for (j = 0; j < nr_entries; j++)
> +					seq_printf(seq, "        %pS\n", (void *)entries[j]);
> +			}
> +		}
> +#endif
>  		seq_puts(seq, "\n");
>  	}
>

Yeah this is necessary as we collect not only caller address, but also
stacks. stacks can be different even if caller address is same. 
So we need to aggregate by both caller address and handle.

This patch looks good.

Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

And it works nicely. After this patch I see now it can differentiate
by stack too.

Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

I like this so much. This makes {free,alloc}_traces much more useful.

before patch:
# cat alloc_traces 
   2924 __d_alloc+0x30/0x3ac age=1/13709/14330 pid=0-184 cpus=0-3

after patch:
# cat alloc_traces 
    757 __d_alloc+0x30/0x3b0 age=2041/7771/7874 pid=1-179 cpus=0-3
        __slab_alloc.constprop.0+0x30/0x74
        kmem_cache_alloc+0x2c0/0x300
        __d_alloc+0x30/0x3b0
        d_alloc_parallel+0xd8/0x824
        path_openat+0xadc/0x16bc
        do_filp_open+0xf8/0x1f4
        do_sys_openat2+0x120/0x26c
        __arm64_sys_openat+0xf0/0x160
        invoke_syscall+0x60/0x190
        el0_svc_common.constprop.0+0x7c/0x160
        do_el0_svc+0x88/0xa4
        el0_svc+0x3c/0x80
        el0t_64_sync_handler+0xa8/0x130
        el0t_64_sync+0x1a0/0x1a4

    301 __d_alloc+0x30/0x3b0 age=8217/8237/8309 pid=51 cpus=1-2
        __slab_alloc.constprop.0+0x30/0x74
        kmem_cache_alloc+0x2c0/0x300
        __d_alloc+0x30/0x3b0
        d_alloc+0x30/0xd0
        __lookup_hash+0x70/0xf0
        filename_create+0xf4/0x220

	[...]

> -- 
> 2.35.1
> 

-- 
Thank you, You are awesome!
Hyeonggon :-)
