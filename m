Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18213BCD0B;
	Tue, 15 Sep 2026 15:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486557; cv=none; b=Ibwb/hll7tokSlZecJeNADkMEBE9EBGpLk4PQaZu+aTww4IVwwE34ixkzplEU8G9qAXTh4WYYLpLLr7arquW3gGXhMREAJHusg1F7zStzthysMCM3CgvlUvVnfmtrC64ZRB0njf+qOoTacahrsn3VcWVvKInyBUrmDlNhq3f1cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486557; c=relaxed/simple;
	bh=619GG4pSIYQXqyXSDpjaSeEbJx7eg4HrrgiyWyiBUFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kMjurQm3+4ubko1tc9J9aCpPK01hTxx82gwG/tD1HLma5zgmiNRGdGk4mfYtFRisk5bVI9h5zjCepvS5CVfs208n9hkxh0bx2drT8y3VYSGCzVY8+XWiwlQEuYl7dzEuzCLRcRGp8UWBU8L2yBdhxXNCslZPKrmq5wULU/Lokz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lyaCPt7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lyaCPt7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824701F000FF;
	Tue, 15 Sep 2026 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789486555;
	bh=eIE5Vq0CFBUSKsZPUEoumfbD3kBp123cMRHTTVMd3H4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lyaCPt7uJYk7aQeXKJJunQOhN1oPhfnH1MQcZABpnm8N8BvkYMdFxkvwSRwAa3i4R
	 FWuaACGOC7uOJ6kR7xBeIAD5xXitVzAzPh/ZIcSoDHb0hMpnlkbpkUHxl/KUpK/KN9
	 4UKCc79gLBXrdwdqBC0PgMYLt3OZd02b4I82+Rh7ziMXKZNaMXxs7Zf6hzTbB1TUUR
	 SsQjFc8mzP4vcyQnUa8toMwtovn0jpumDpgHWFp3VC2/gOzcybpc9mHCj6Cuw6Z6oN
	 soLeETzD+/RihQ2HU9bPat2OweUy2Aa4Vvc+5tCpNd7MH/FG30XIu1LoqIB+oMu+Jm
	 MuLPDe607YiWQ==
Message-ID: <599fd878-e670-4ee7-8ded-4299c19c085c@kernel.org>
Date: Tue, 15 Sep 2026 17:35:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH AUTOSEL 6.18-6.1] sched/fair: Reject misfit pulls onto
 busy SMT siblings on asym-capacity
Content-Language: fr
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Andrea Righi <arighi@nvidia.com>, Felix Abecassis
 <fabecassis@nvidia.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Vincent Guittot <vincent.guittot@linaro.org>, mingo@redhat.com,
 juri.lelli@redhat.com, linux-kernel@vger.kernel.org
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-171-sashal@kernel.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20260831133314.4125787-171-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Sasha,

On 31/08/2026 15:23, Sasha Levin wrote:
> From: Andrea Righi <arighi@nvidia.com>
> 
> [ Upstream commit bf6aa722198d3c06e4236e8c5a480f30a64e1513 ]
> 
> When SD_ASYM_CPUCAPACITY load balancing considers pulling a misfit task,
> capacity_of(dst_cpu) can overstate available compute if the SMT sibling is
> busy: the core does not deliver its full nominal capacity.
> 
> If SMT is active and dst_cpu is not on a fully idle core, skip this
> destination so we do not migrate a misfit expecting a capacity upgrade we
> cannot actually provide.
> 
> Reported-by: Felix Abecassis <fabecassis@nvidia.com>
> Signed-off-by: Andrea Righi <arighi@nvidia.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
> Link: https://patch.msgid.link/20260509180955.1840064-5-arighi@nvidia.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
> (attempt 1)...
> Retry attempt 1...
> The background `git log --grep` search finished without finding this
> commit in the 6.18.43 tree — which matches what we saw in code
> (`dst_core_idle` is absent from `kernel/sched/fair.c`).

Mmh, you might need to check this. Is it why it didn't detect issues on v6.1,
see below.

> **Verdict for 6.18.y: YES.** It's a small, maintainer-reviewed
> scheduling correctness fix for misfit task migration on asymmetric-
> capacity + SMT systems. The buggy logic is present in this tree and the
> patch should apply cleanly.
> 
>  kernel/sched/fair.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ac5f08cd01a83..fee58d01ae0f9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -9395,6 +9395,7 @@ struct lb_env {
>  
>  	int			dst_cpu;
>  	struct rq		*dst_rq;
> +	bool			dst_core_idle;
>  
>  	struct cpumask		*dst_grpmask;
>  	int			new_dst_cpu;
> @@ -10636,10 +10637,16 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>  	 * We can use max_capacity here as reduction in capacity on some
>  	 * CPUs in the group should either be possible to resolve
>  	 * internally or be covered by avg_load imbalance (eventually).
> +	 *
> +	 * When SMT is active, only pull a misfit to dst_cpu if it is on a
> +	 * fully idle core; otherwise the effective capacity of the core is
> +	 * reduced and we may not actually provide more capacity than the
> +	 * source.
>  	 */
>  	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) &&
>  	    (sgs->group_type == group_misfit_task) &&
> -	    (!capacity_greater(capacity_of(env->dst_cpu), sg->sgc->max_capacity) ||
> +	    (!env->dst_core_idle ||
> +	     !capacity_greater(capacity_of(env->dst_cpu), sg->sgc->max_capacity) ||
>  	     sds->local_stat.group_type != group_has_spare))
>  		return false;
>  
> @@ -11206,6 +11213,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>  	unsigned long sum_util = 0;
>  	bool sg_overloaded = 0, sg_overutilized = 0;
>  
> +	env->dst_core_idle = !sched_smt_active() || is_core_idle(env->dst_cpu);

On v6.1, I got this:

kernel/sched/fair.c: In function 'update_sd_lb_stats':
kernel/sched/fair.c:9912:53: error: implicit declaration of function 'is_core_idle' [-Wimplicit-function-declaration]
   9912 |         env->dst_core_idle = !sched_smt_active() || is_core_idle(env->dst_cpu);
        |                                                     ^~~~~~~~~~~~

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

