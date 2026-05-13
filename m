Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395753630A4;
	Wed, 13 May 2026 04:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778648400; cv=none; b=tYFjq1BPVJTG4OY96EgfT1D27MJ04oJKCvewAX7oDGAphAbudO2bMiMEHJMON+bFE+4Ror7dPBYfCke0ZMz0EnE5EJIKXdMStiSL7mvKvMJDlMwAQ3uiwHlT1wBtxMubG+RHDf3ESxL7KdH4V0o+nVsi20QOeUCaSMiaXTzprKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778648400; c=relaxed/simple;
	bh=OcJJur5kBVC2vJOyBNxR6/x/CsmZAaJam6oljgn6EmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RMJBw2jV6UKkq5w5A/tdFwu7zjuMhwqjfBk72aVOVRHu7ysUJSmFNepUmsZH1USKM1+k50xYwOOtxFvMMzOXzm+2Buy0JG0A/vHwKXhp7lfOPDD2Hju5K7cQmUs9MsAVptJNThUoSWsNPLiu8DvIub7y5Z9kEJTUFh31lbo8Fow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X04Su6Sg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X04Su6Sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CBDC2BCB7;
	Wed, 13 May 2026 04:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778648399;
	bh=OcJJur5kBVC2vJOyBNxR6/x/CsmZAaJam6oljgn6EmI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X04Su6Sgc1dbaeIKVYmHwgNYmIZEqHsSPsCyhWnXDOgVmZSEmCJFofKHfkXrQxA7U
	 ib34zXgWBvDhi2nVrK+YXGIBQ4b+iQ4scMqCA9W4R95iX16ZJMEIAEmoGtksqnmPFu
	 RFIsk+qnYvWAoT73D95GQ8MCwvUOnxVqPhR1ppAnEvoTwYNfVOyGZiPGdapwbxsVF5
	 ZU8qxn3FYsQNbYDatXV1aaylNPefLZ4JaSBGapHQGKjvaZsh8BkNCecWGPhkbiTdQG
	 LNjlXJQK+XILyuxydSe8GdyxjJARiBr98l2uQxplpFTHhI3RxvMTomjwPeXDoV/S+Y
	 SICHl7EKxOPEQ==
Message-ID: <2f509cbf-f14f-4dfc-8ba9-d53dc10e0aad@kernel.org>
Date: Wed, 13 May 2026 06:59:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 247/307] sched_ext: Skip tasks with stale task_rq in
 bypass_lb_cpu()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Chris Mason <clm@meta.com>,
 Tejun Heo <tj@kernel.org>, Andrea Righi <arighi@nvidia.com>
References: <20260512173940.117428952@linuxfoundation.org>
 <20260512173945.338221208@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20260512173945.338221208@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12. 05. 26, 19:40, Greg Kroah-Hartman wrote:
> 7.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tejun Heo <tj@kernel.org>
> 
> commit da2d81b4118a74e65d2335e221a38d665902a98c upstream.
> 
> bypass_lb_cpu() transfers tasks between per-CPU bypass DSQs without
> migrating them - task_cpu() only updates when the donee later consumes the
> task via move_remote_task_to_local_dsq(). If the LB timer fires again before
> consumption and the new DSQ becomes a donor, @p is still on the previous CPU
> and task_rq(@p) != donor_rq. @p can't be moved without its own rq locked.
> 
> Skip such tasks.
> 
> Fixes: 95d1df610cdc ("sched_ext: Implement load balancer for bypass mode")
> Cc: stable@vger.kernel.org # v6.19+
> Reported-by: Chris Mason <clm@meta.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Andrea Righi <arighi@nvidia.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   kernel/sched/ext.c |    9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> --- a/kernel/sched/ext.c
> +++ b/kernel/sched/ext.c
> @@ -4008,6 +4008,15 @@ resume:
>   		if (cpumask_empty(donee_mask))
>   			break;
>   
> +		/*
> +		 * If an earlier pass placed @p on @donor_dsq from a different
> +		 * CPU and the donee hasn't consumed it yet, @p is still on the
> +		 * previous CPU and task_rq(@p) != @donor_rq. @p can't be moved
> +		 * without its rq locked. Skip.
> +		 */
> +		if (task_rq(p) != donor_rq)
> +			continue;

As others pointed out already:
[   75s] In file included from ../kernel/sched/build_policy.c:62:
[   75s] ../kernel/sched/ext.c: In function ‘bypass_lb_cpu’:
[   75s] ../kernel/sched/ext.c:4019:35: error: ‘donor_rq’ undeclared 
(first use in this function); did you mean ‘donee_rq’?
[   75s]  4019 |                 if (task_rq(p) != donor_rq)
[   75s]       |                                   ^~~~~~~~
[   75s]       |                                   donee_rq

Donor and donor_rq were introduced in:
commit ff06f727a9412b3c9f2f13f1441a5a0d2a31366b
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Mar 6 07:58:03 2026 -1000

     sched_ext: Move bypass_dsq into scx_sched_pcpu

thanks,
-- 
js
suse labs

