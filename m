Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDC4801;
	Mon,  2 Jun 2025 00:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748823832; cv=none; b=dtrK8KaoRG3HwQp0do7qZNkafIvIWycuYLltvMMdadbRT/AUKJ7d1wtiTDs3799nq4ZgIYFv6AOpgyHGyPjgjZQi084WM1AK19iYP7dRphmDwFBMGO0Rq4SgLcgWCrv3+KO4k25bmdgVQDeVl5HbW5r/a0nasw09kaP1Vt2fpOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748823832; c=relaxed/simple;
	bh=mPT034hNVZ/977d10Yr+1gK7OY83Sfsc+vYjI2DF18M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/objP5M+Gsmce7qSkd/pm2qUC651+Z1BxkVzq6sf2394QQCluZJm4Kc+IEFnllbkONOdrdh2VMHYutfmyaB7hqX4AgIbwQTf5+EdNH1OW4phsWIckkrbxrkQrlDttlrnbAIa0K0eDpxk8BiD4F/CapB9NL1kAvuEf7h2u89KMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=N6VRS2YS; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="N6VRS2YS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=FYIuU5adQcAYGloGoUqfC/nnupMXlhYz03OeWU8d5SU=; b=N6VRS2YSAFXF86qS
	DuTC0pRgN9Gmce800c4ExShbL1zoIOeDRHO309B1UY93x5BUAx4RvY03m7643W5EY1wGj3hqG0UsG
	HZQLV8Y2aUo8JA5OmDZvXzxkK4Lh7S6qo9ZMBa25jowDs1GTHiBvoi7/ZTU5Xf/wBva1yMe0EYwkg
	ja8fPWiwVRfNHvP753rmcqI3CVAVbe6n53tT9x+GmccLjHEim+lCZT3jbfeJyy39peje37jkR3n9d
	Z73cHw/QUtqmPTajQQA8uyeYBTtaQINDDsQHh1q3oQhtbHKs2XNmmrFdFFyTIwbP0r71gO9J+Uqmg
	WrmjVV5gKDzNJIxx3g==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1uLsSE-0074vX-2C;
	Sun, 01 Jun 2025 23:51:02 +0000
Date: Sun, 1 Jun 2025 23:51:02 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>, perex@perex.cz, tiwai@suse.com,
	yuehaibing@huawei.com, linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.15 101/110] ALSA: seq: Remove unused
 snd_seq_queue_client_leave_cells
Message-ID: <aDznZgej_QbaalP0@gallifrey>
References: <20250601232435.3507697-1-sashal@kernel.org>
 <20250601232435.3507697-101-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20250601232435.3507697-101-sashal@kernel.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-34-amd64 (x86_64)
X-Uptime: 23:48:36 up 35 days,  8:02,  1 user,  load average: 0.10, 0.06, 0.01
User-Agent: Mutt/2.2.12 (2023-09-09)

* Sasha Levin (sashal@kernel.org) wrote:

Hi Sasha,

> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> [ Upstream commit 81ea9e92941091bb3178d49e63b13bf4df2ee46b ]
> 
> The last use of snd_seq_queue_client_leave_cells() was removed in 2018
> by
> commit 85d59b57be59 ("ALSA: seq: Remove superfluous
> snd_seq_queue_client_leave_cells() call")
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Link: https://patch.msgid.link/20250502235219.1000429-4-linux@treblig.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> NO This commit should not be backported to stable kernel trees for
> several reasons: 

I'd agree with that big fat NO - unless it makes your life easier backporting
a big pile of other stuff.
I'm a bit curious about:
  a) How it got picked up by autosel - I'm quite careful not to include
     'fixes' tags to avoid them getting picked up.
  b) Given it's got a big fat no, why is it posted here?

Dave


**1. This is a code cleanup, not a bug fix** The commit
> removes dead code (`snd_seq_queue_client_leave_cells()`) that hasn't
> been used since 2018. The commit message explicitly states this function
> was already removed from use by commit 85d59b57be59 in 2018, and this
> commit is simply cleaning up the unused function definition. This is
> purely a maintenance/cleanup change with no functional impact. **2. No
> user-visible impact or bug being fixed** The removed function
> `snd_seq_queue_client_leave_cells()` was already unused, so removing it
> doesn't fix any existing bugs, security issues, or user-reported
> problems. The code changes show: - Removal of the function
> implementation from `sound/core/seq/seq_queue.c` (lines that iterate
> through queues and call `snd_seq_prioq_leave()`) - Removal of the
> function declaration from `sound/core/seq/seq_queue.h` **3. Follows
> pattern of similar non-backported commits** Looking at the similar
> commits provided: - **Similar Commit #1**: Removed superfluous function
> call - Status: NO - **Similar Commit #2**: Removed useless function -
> Status: NO - **Similar Commit #4**: Removed unused declarations -
> Status: NO - **Similar Commit #5**: Code refactoring with no functional
> changes - Status: NO Only **Similar Commit #3** was backported (Status:
> YES), and that was because it fixed an actual race condition bug that
> could cause long stalls, not because it was removing unused code. **4.
> Stable tree criteria not met** Stable kernel backports should focus on:
> - Important bug fixes that affect users - Security fixes - Critical
> functionality issues This commit doesn't meet any of these criteria.
> It's purely cosmetic code cleanup that removes dead code without
> changing any runtime behavior. **5. Risk vs. benefit analysis** While
> the risk of regression is minimal since the function was unused, there's
> no benefit to users of stable kernels from this change. Stable trees
> should minimize churn and only include changes that provide tangible
> benefits to users. The commit represents good housekeeping for the
> mainline kernel but doesn't provide the type of user-impacting fix that
> justifies inclusion in stable kernel trees.
> 
>  sound/core/seq/seq_queue.c | 16 ----------------
>  sound/core/seq/seq_queue.h |  1 -
>  2 files changed, 17 deletions(-)
> 
> diff --git a/sound/core/seq/seq_queue.c b/sound/core/seq/seq_queue.c
> index 5df26788dda41..10add922323da 100644
> --- a/sound/core/seq/seq_queue.c
> +++ b/sound/core/seq/seq_queue.c
> @@ -564,22 +564,6 @@ void snd_seq_queue_client_leave(int client)
>  
>  /*----------------------------------------------------------------*/
>  
> -/* remove cells from all queues */
> -void snd_seq_queue_client_leave_cells(int client)
> -{
> -	int i;
> -	struct snd_seq_queue *q;
> -
> -	for (i = 0; i < SNDRV_SEQ_MAX_QUEUES; i++) {
> -		q = queueptr(i);
> -		if (!q)
> -			continue;
> -		snd_seq_prioq_leave(q->tickq, client, 0);
> -		snd_seq_prioq_leave(q->timeq, client, 0);
> -		queuefree(q);
> -	}
> -}
> -
>  /* remove cells based on flush criteria */
>  void snd_seq_queue_remove_cells(int client, struct snd_seq_remove_events *info)
>  {
> diff --git a/sound/core/seq/seq_queue.h b/sound/core/seq/seq_queue.h
> index 74cc31aacdac1..b81379c9af43e 100644
> --- a/sound/core/seq/seq_queue.h
> +++ b/sound/core/seq/seq_queue.h
> @@ -66,7 +66,6 @@ void snd_seq_queue_client_leave(int client);
>  int snd_seq_enqueue_event(struct snd_seq_event_cell *cell, int atomic, int hop);
>  
>  /* Remove events */
> -void snd_seq_queue_client_leave_cells(int client);
>  void snd_seq_queue_remove_cells(int client, struct snd_seq_remove_events *info);
>  
>  /* return pointer to queue structure for specified id */
> -- 
> 2.39.5
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
