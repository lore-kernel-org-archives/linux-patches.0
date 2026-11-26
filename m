Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795674184;
	b=d6E9Ikh00WMX5YMey4Yt2Tdd3vZCRfB6/4vBsUQ6PZPsTvSkLNvlLbdYg28B0w0yHbYe
	 nYL0A7EHncsf+HTH3le1nDaq1kw3d5CrAvF3Gp72vRy1t3IxC+dj5syY8ng4mPo/n8jBd
	 vnUzylz9c8z56PMQqjoEusFerQ2tKb3XGTlcBzKfVKuV0PrxVK8opFjNQMDZ+RKV+zl0k
	 tfK/CCtHD3cea+S6Xu10uhohHuEnG6z1Z2UjsWj/DQUSP68ZYdCHVf+vCqAsYLXq/16Aj
	 eo8deGTHuECfKBLbAJbhTJSxJDjg6vpI/i0ZJvpds9e0GPOPc2Ul0CvzPFUMCXWAyuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795674184;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=i/PfyZgiIqxuCgtYIpFB5PotbGJbDdTpV+ed0bHaEPg=;
	b=gc9EYVN5jLtAim38rmE92MkCgVSertRoykU/auT96jW2Ih5HATGKldSB2lHWT4dNzPrr
	 ryp+BXP4suxifNGG0DoUzCWzc/jSTtevh2rF7CnxcTrNwUmBrbf5B6g/w1KZ/vdAp7hPJ
	 CONroQWeQAznVBTL+hHUd5Lx3Uq2HHlW0F/t4iGtBofqG+RKZw088tM6nwG6BjMo4vKf5
	 dLcaPJqU6wMR4/6HKC3t8fg1fxkpzgzU4QXbBI799b+5t/LSxX5zdaYw1+OmWElurGDEF
	 DA1kUL7W/xu3MBcat8WXP3gUrsMTz9LqVT3WFmjXXAoOmcJmH8sVoaXYeTNAIMbDsdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ote95j5p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08FB606A31C;
	Thu, 26 Nov 2026 06:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ote95j5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47AF1F000C4;
	Thu, 26 Nov 2026 06:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795674184;
	bh=i/PfyZgiIqxuCgtYIpFB5PotbGJbDdTpV+ed0bHaEPg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ote95j5pr3JMR0akV5+X2v4K8EFClOHD4MNcnS6qrEdyp+/8SlJLShY0nMyPRNq7C
	 Uj/qh37DCL+WJXSUS1VWv/LgG11uSl7Cn+qqzjDEJ+PRcuFNp98nepIweKsP8xD4Be
	 I37cf+c0lJ/gnyJU36C65oKacsbOLakjk3ev83H8JYGKix1+Y6VGr7yQ1rbb7bNcB5
	 WYEUw/QljjFBGYiWbGCI5aU0qaCMpSS7m7g+2iN94zXkbW0wM6nEGpBCFF1ixv4969
	 yke/woS5/AbV+LCeiTkZXg7ysZejiUnAf1Xi25rXdgIQt3UqByHNrvkbrv3tL0ECie
	 3mI7m/Tvw60gQ==
Message-ID: <6e2e92cb-6663-457b-8225-0809917f4332@kernel.org>
Date: Thu, 26 Nov 2026 07:23:01 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0478/1005] sched_ext: Add scx_bpf_dsq_reenq_task() to
 re-enqueue single tasks from a DSQ iteration
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Tejun Heo <tj@kernel.org>,
 Andrea Righi <arighi@nvidia.com>, Sasha Levin <sashal@kernel.org>
References: <20261125143821.729802100@linuxfoundation.org>
 <20261125143832.945376806@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261125143832.945376806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25. 11. 26, 15:30, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tejun Heo <tj@kernel.org>
> 
> [ Upstream commit b3768d058c98d4e8114a246d3267d7dae1c123fb ]
...
> --- a/kernel/sched/ext/ext.c
> +++ b/kernel/sched/ext/ext.c
...
> @@ -10340,6 +10358,64 @@ __bpf_kfunc void scx_bpf_dsq_reenq(u64 dsq_id, u64 reenq_flags,
>   	schedule_dsq_reenq(sch, dsq, reenq_flags, locked_rq);
>   }
>   
> +/**
> + * scx_bpf_dsq_reenq_task - Re-enqueue a task from a DSQ iteration
> + * @it__iter: DSQ iterator in progress
> + * @p: task to re-enqueue
> + *
> + * Mark @p, which is on the DSQ iterated by @it__iter and was queued before the
> + * iteration started, for re-enqueue. When the iteration ends, the DSQ's marked
> + * tasks go through ops.enqueue() with %SCX_ENQ_REENQ in DSQ order and the other
> + * tasks on the DSQ keep their positions. A marked task that leaves the DSQ in
> + * the meantime is not re-enqueued. The mark belongs to @p, so a re-enqueue
> + * scheduled by another iteration of the DSQ may re-enqueue @p before this
> + * iteration ends. @p must be on the DSQ's scheduler.
> + *
> + * Re-enqueues are performed asynchronously. Can be called from ops.dispatch()
> + * or any BPF context which doesn't hold a rq lock (e.g. BPF timers or SYSCALL
> + * programs).
> + *
> + * Return %true if @p was marked, %false if @p left the DSQ or was queued after
> + * the iteration started, @p is on another scheduler, or the iterator holds no
> + * DSQ.
> + */
> +__bpf_kfunc bool scx_bpf_dsq_reenq_task(struct bpf_iter_scx_dsq *it__iter,
> +					struct task_struct *p)
> +{
> +	struct bpf_iter_scx_dsq_kern *kit = (void *)it__iter;
> +	struct scx_dispatch_q *dsq = kit->dsq;
> +	struct rq *src_rq, *entry_rq;
> +	unsigned long flags;
> +	bool marked = false;
> +
> +	/* NULL after a failed bpf_iter_scx_dsq_new(), see scx_dsq_move() */
> +	if (unlikely(!dsq))
> +		return false;
> +
> +	/* the cursor check needs @p's rq locked */
> +	src_rq = task_rq(p);
> +	entry_rq = kf_switch_rq_lock(src_rq, &flags);

This also fails to build:
error: implicit declaration of function ‘kf_switch_rq_lock’

> +
> +	scoped_guard (raw_spinlock, &dsq->lock) {
> +		if (nldsq_cursor_lost_task(&kit->cursor, src_rq, dsq, p))
> +			break;
> +
> +		if (unlikely(!scx_task_on_sched(dsq->sched, p))) {
> +			scx_error(dsq->sched, "scx_bpf_dsq_reenq_task() on %s[%d] but the task belongs to a different scheduler",
> +				  p->comm, p->pid);
> +			break;
> +		}
> +
> +		p->scx.dsq_flags |= SCX_TASK_DSQ_REENQ;
> +		/* the walk is scheduled once, by bpf_iter_scx_dsq_destroy() */
> +		kit->cursor.flags |= __SCX_DSQ_ITER_HAS_REENQ;
> +		marked = true;
> +	}
> +
> +	kf_restore_rq_lock(src_rq, entry_rq, flags);

And here:
error: implicit declaration of function ‘kf_restore_rq_lock’

> +	return marked;
> +}
> +
>   /**
>    * scx_bpf_reenqueue_local___v2 - Re-enqueue tasks on a local DSQ
>    * @aux: implicit BPF argument to access bpf_prog_aux hidden from BPF progs


-- 
js
suse labs

