Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F17A
	for <patches@lists.linux.dev>; Sun, 27 Feb 2022 00:23:00 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id iq13-20020a17090afb4d00b001bc4437df2cso8175005pjb.2
        for <patches@lists.linux.dev>; Sat, 26 Feb 2022 16:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dnqnUC19xO35MCy9LRDHO0Cui2vrFHNNs03zEs4NcDw=;
        b=PrZSLUN3MtjGPfHYaaY7BMwDWIbdVnmoXTS30IMzZlpZDFnUT5yitvdblFN1ZdNjLo
         owG3WClAMkuCWEUTCUO6HyB62hBXaW5jpm6MUrOX1a+DiKola00Kwq655ZKClUnSu4a+
         Mtlz1lkGuykQR2wkRStiRGhiOJDlwKhS0dWl4Vjh7a41NGSA/CGpdhMRUmjyXk3PNgEx
         WDhCaX7jC+Y8ha4vAREzLCH2xHTm2iRmx4E49+SJavbsKx+sReOgYy1acv1Sj4JsO2r1
         pba2QDiNlaY4rHX8tAmMerHss4bUctg9hIFPA0FBvWIThFFaJo2R3j3NccmQXeFwHcKV
         d4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dnqnUC19xO35MCy9LRDHO0Cui2vrFHNNs03zEs4NcDw=;
        b=YONfY5uZoWnRAv6APaDfBp6UTZEZ+2mNft36hxBhsZv3gS0REYObCTE4d6QXhSMucR
         cqyLf2LuW+KZ2EFIHtjyuTJv5nj6A5x3W9Abtw8hHPQFMf8tuPejsH6YfVrxQdPMMuH6
         mWzHLHXMo1iRJL0Jd1+Yty05d67z/95usFTnJdS4cl1mT5UAWKnUlwmorSzu9VnLntTb
         DZl6TbceYimkl6aHlaBqUfHVaeTDP2del0CtlyKXOVsJWHtIwqBpf26EQ8RbcWPK5FW2
         +R+GanCfk5aGbrrg5DwRfqP8RFdlT+JYZatFqAnSVaUe/7vCLmWUn/V9Qmc6MnI582cn
         9A6g==
X-Gm-Message-State: AOAM533Te9Y3dJ296A/A4x3lnQ5NDqSxUBnZG1Et8sCtflDzzdFtTz6u
	/4wMI/wjfgP0ju/RSuNlcPI=
X-Google-Smtp-Source: ABdhPJy1Fn+k0zmImu33O6WiH3LwjSnckxuFNoe7Wsf8iwvi/lRFbXV6YRdNIZGJHFxctNldLVmCyg==
X-Received: by 2002:a17:90a:db15:b0:1bd:71f:8123 with SMTP id g21-20020a17090adb1500b001bd071f8123mr7067540pjv.126.1645921380516;
        Sat, 26 Feb 2022 16:23:00 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id h3-20020a056a00170300b004f104c635e4sm8263288pfc.99.2022.02.26.16.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 16:23:00 -0800 (PST)
Date: Sun, 27 Feb 2022 00:22:55 +0000
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
Message-ID: <YhrEXwdK2/9x93Qp@ip-172-31-19-208.ap-northeast-1.compute.internal>
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

I think it will be better if subject was something like
"Differentiate by stack and print stack traces in debugfs"?

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
> -- 
> 2.35.1
> 

-- 
Thank you, You are awesome!
Hyeonggon :-)
