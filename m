Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BA23216
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 21:40:18 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id c2so494629pga.10
        for <patches@lists.linux.dev>; Tue, 05 Apr 2022 14:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=4qdFCpqXJlibMLMmOh+khRtYiv84b92yeP1UHSU4/XM=;
        b=qdb9FXkcJDsuO06gq+eT+kXK0a+6EAevKNYutHs1sHo02PgFcBzm4NidfGlv0TeZsk
         lAye9LJRnRUsM5PPn8JATtm9hvlOa0GVJ+6X0B3a4M1SQ+KhgtmV+NPD8o5BiU0Orf3j
         4x8lnnEDrhHCxeZLy8J8nnqdwGAZ1Gkpc0hmy4N0mYsU4HLnwMA1ZKyqDPJfYwIcElbM
         7jroAQC1AOR23AO9iP5KKLawgM9QJu+OXGHVrm9JPAawThONQEos0sZ/bSgJyD3kNm2+
         JAN8hpJfKhrgAT5E0JbW0/hLVcIaB2Mu3QKE/gd62QVsfLvdVtNS4rOMAv/4BGuwjsGH
         CiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=4qdFCpqXJlibMLMmOh+khRtYiv84b92yeP1UHSU4/XM=;
        b=YHtCFCbi12VUJIkMGSSYJlhdF6i0lRMlsZH2Zqaq4ol3X+YVFNsyjMQ04cgSmffzWH
         NfJcGGXXRfgTVGn6nVaCXyeEx9iEs4jeDKd4HQkisAiS8ZW3nIGUpSOi3Tuj+MyrkFHv
         //L8TqQsACme4XR39p1lW0Nv91BrHPcRk857S9VjlvXeTaYpIKYq0gaMpAAWc3fiQu2g
         /X19aai26NDdkHLZ4zErdj3y3BbjK/fb7SMpDfzeYGF+UccxGaMIAM2kt/Iglvxq6iXZ
         pcCBiSzwwHJQDA0W87cEST49JEtEdqc2Tp4ChG2fqAKRkDIbkDF9JuiNVV309e6k3xsI
         nukQ==
X-Gm-Message-State: AOAM531PbFsOOkLgW3yQymiCsxvDtyYOlnZtq6bLU2Hvv3lDy5nKX5Te
	qc4/yNLJBw/9iAT6W1gNnCki3g==
X-Google-Smtp-Source: ABdhPJwPwjfefI2JSh8SzZZVYV7Z0sOVeowJ14ZyTTisOzE7+UVYFaPwlmA1EkEbrCCUemK24q4jjg==
X-Received: by 2002:a05:6a00:810:b0:4fa:e71f:7e40 with SMTP id m16-20020a056a00081000b004fae71f7e40mr5528326pfk.15.1649194817775;
        Tue, 05 Apr 2022 14:40:17 -0700 (PDT)
Received: from [2620:15c:29:204:be3e:5e1c:99cc:513f] ([2620:15c:29:204:be3e:5e1c:99cc:513f])
        by smtp.gmail.com with ESMTPSA id m7-20020a625807000000b004fe0a89f24fsm8117856pfb.112.2022.04.05.14.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 14:40:17 -0700 (PDT)
Date: Tue, 5 Apr 2022 14:40:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Pekka Enberg <penberg@kernel.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
    patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Oliver Glitta <glittao@gmail.com>, Marco Elver <elver@google.com>, 
    Mike Rapoport <rppt@linux.ibm.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
    Imran Khan <imran.f.khan@oracle.com>
Subject: Re: [PATCH v3 4/6] mm/slub: distinguish and print stack traces in
 debugfs files
In-Reply-To: <20220404164112.18372-5-vbabka@suse.cz>
Message-ID: <a8801c0-45d6-7c90-35f9-c3221736ef13@google.com>
References: <20220404164112.18372-1-vbabka@suse.cz> <20220404164112.18372-5-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 4 Apr 2022, Vlastimil Babka wrote:

> From: Oliver Glitta <glittao@gmail.com>
> 
> Aggregate objects in slub cache by unique stack trace in addition to
> caller address when producing contents of debugfs files alloc_traces and
> free_traces in debugfs. Also add the stack traces to the debugfs output.
> This makes it much more useful to e.g. debug memory leaks.
> 
> Signed-off-by: Oliver Glitta <glittao@gmail.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-and-tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> ---
>  mm/slub.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 98c1450c23f0..f2e550e1adf0 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5064,6 +5064,7 @@ EXPORT_SYMBOL(validate_slab_cache);
>   */
>  
>  struct location {
> +	depot_stack_handle_t handle;
>  	unsigned long count;
>  	unsigned long addr;
>  	long long sum_time;
> @@ -5116,9 +5117,13 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
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
> @@ -5133,7 +5138,8 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
>  			break;
>  
>  		caddr = t->loc[pos].addr;
> -		if (track->addr == caddr) {
> +		chandle = t->loc[pos].handle;
> +		if ((track->addr == caddr) && (handle == chandle)) {
>  
>  			l = &t->loc[pos];
>  			l->count++;
> @@ -5158,6 +5164,8 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
>  
>  		if (track->addr < caddr)
>  			end = pos;
> +		else if (track->addr == caddr && handle < chandle)
> +			end = pos;
>  		else
>  			start = pos;
>  	}

Does this need to properly handle the case where handle == NULL?

> @@ -5180,6 +5188,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
>  	l->max_time = age;
>  	l->min_pid = track->pid;
>  	l->max_pid = track->pid;
> +	l->handle = handle;
>  	cpumask_clear(to_cpumask(l->cpus));
>  	cpumask_set_cpu(track->cpu, to_cpumask(l->cpus));
>  	nodes_clear(l->nodes);
> @@ -6089,6 +6098,21 @@ static int slab_debugfs_show(struct seq_file *seq, void *v)
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
> -- 
> 2.35.1
> 
> 
