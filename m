Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC1E78F29
	for <patches@lists.linux.dev>; Sun,  2 Nov 2025 11:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762081678; cv=none; b=eZd1d/wXe5JIf+coRA7CHvvx1niAkBfeingakrwspjEbe11KhaYN45dpJnfy150W63vwd1UOumMFFzrmV9dkg5Y88UUfYDo8R28C41eJ5K33/64XdBPexviOhRJDmHufs2KZdpqAOog3+y5oaBJm2hJlU6PMHgGYJly0tbQt4m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762081678; c=relaxed/simple;
	bh=Iwlb2KzOAUsWp1/2ne5jaA2bB1mN4zDZo4gjPoS+WdU=;
	h=Mime-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J5hnCLnTiHbvTJV6M4+CqFHZEQOSHdtS/vPM/gyTbH2asQYfwQmthCzRDe36eLNYMrlGK80wChWr4Ecn78wUCIiOuKdlbRSCOT/nm3G5Mzf13liSOx5UQXZcmrNUv+RlJgMpTqU7WTAAYD+7YQyRthjfDJnEKVj+j9SmaLPMOwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=iFO58j79; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="iFO58j79"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so875519a12.3
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 03:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1762081675; x=1762686475; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ciJ8ltYj16L6OcCIFxyx+RKgKBiqDR+LhiwFD9VIxUo=;
        b=iFO58j793OSgaTBXS2QO7JBKDpt5okU/XVZbemOFp8TBM03VbN3+/cfnPyobkXfZK8
         C4zjGZahc+FIzNvk2JmFSmG/NjTCE3ljfoPXzV05hj7adx8iHE4V+83qJdTwqkqFWRUG
         1WCMfo4ctj5sjcmBVDrE1XO3DLvtJh+L1LgzafkCKoKMU1/a6YB4jiexRcEhoL71XrP8
         s2gluWAeQKzR856Z0/pFGzSmgvSZv+Lx1IG64DHI3qZqUESQ/b2NmnyRYWN+quq8vGPt
         /+Tk9lKXRtGRZwJr6p3eVF+ut+ESFTp3xeWrxZx3IzOXgiOTHwn2kHUsnW4IszmRxQIe
         etrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762081675; x=1762686475;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ciJ8ltYj16L6OcCIFxyx+RKgKBiqDR+LhiwFD9VIxUo=;
        b=uUNXgRV49VZcddKZc7PZHWO80RmSIZkLB3gPcvkri4mnA2xJJ+srtEVWy+kyr3Xjjw
         TwgL4t2x4C44ZKDmJcaRQwKVFbGvUWZZ8nIEjnBHQxFk72sEoTI7jfsjP9ll4Z/lx183
         W5hvqfNyKbF1xWnRT2Icv25GuGEucfzf4nP6aUbUWkMJyMjS6f0Ok26buU2WM0mTC4n5
         wrj9ELjynQ6j4/dGvq1rxE7wZUXVi71sPI7VszC6FhlCqPX+oriMKb18e9ssgmOKXn0Y
         mv5EJLiPVfceTQv3glKqGXSXuO7KM0APwttyARhLpf4Kb/WNsCrUL1/u2X9uw+YIAhud
         aweA==
X-Forwarded-Encrypted: i=1; AJvYcCWs7IoP5VtFt56u3qWI1antbCClewSR0Hcxh2qRPc/x5Eqr+dwZ0CyI89ksvzwxm3qeLWE/X/dq@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7J+t3bzCWjwYHAcoomRVsfen3Kh3o/DRV8Id3DqB2hvS7RlsQ
	WhQmRYHZoglEpFL+RT6H0yJ6/jgXjXlBO8XeV6sK0LzOwcjoFZ6DIfaagnKWYyMdoSRFTma1pEW
	jE2V53I3w8GCdpmH8oXLPYTMaA1u+lXrlCok/0IAu
X-Gm-Gg: ASbGnctJ8TrYaU6Xn/iXK1Pu2oDC5F1ztClSE4SKt4Gf9DCRHV7yBfZnIT+LNC2nB9X
	RSll9OubObbzUXo5bsOwJQiY1oWN5G9mB2zHuFcH7nrQ65vklPpGPREjjdBSFSLHOt3c5MeYopG
	77tHcYX0H6Lb/q1ORUug4iqczeRiDfjJGYRMJif4iDt9KpZhhTUOGODfLB9PbEekIxiPSIYW7mB
	t3mbVkfWgNySXWXvdcWYNAmWUbl2v6Pwc5LgtgLl1f0lUhEcvTNCqThU1E7wQ==
X-Google-Smtp-Source: AGHT+IFtId39lDxEOoZUFlcoBwYD/1NQBZJtxCUsz0p5OSu83tgG4zgZDqWR9Kh3U9gJQEv5pIe1R+zpdQC9Cg/PGuA=
X-Received: by 2002:a05:6402:254e:b0:640:b321:9e9a with SMTP id
 4fb4d7f45d1cf-640b321a1bemr1546121a12.35.1762081674759; Sun, 02 Nov 2025
 03:07:54 -0800 (PST)
Received: from 44278815321 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 2 Nov 2025 12:07:54 +0100
Received: from 44278815321 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 2 Nov 2025 12:07:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
From: Aaron Lu <ziqianlu@bytedance.com>
In-Reply-To: <20251031140044.050079148@linuxfoundation.org>
X-Original-From: Aaron Lu <ziqianlu@bytedance.com>
References: <20251031140043.564670400@linuxfoundation.org> <20251031140044.050079148@linuxfoundation.org>
Date: Sun, 2 Nov 2025 12:07:54 +0100
X-Gm-Features: AWmQ_bloO0U9cVt1zx0nmqO8TIGQqJbFrRtmNfCpVvcLCQATHFfRii55pBTKiVc
Message-ID: <CANCG0GdKaxR4_0=O_nRUBj1LA2i=91bNj7M7N_k5P0F=ChGa3Q@mail.gmail.com>
Subject: Re: [PATCH 6.17 20/35] sched/fair: update_cfs_group() for throttled cfs_rqs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hello,

On Fri, Oct 31, 2025 at 03:01:28PM +0100, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Aaron Lu <ziqianlu@bytedance.com>
>
> [ Upstream commit fcd394866e3db344cbe0bb485d7e3f741ac07245 ]
>
> With task based throttle model, tasks in a throttled hierarchy are
> allowed to continue to run if they are running in kernel mode. For this
> reason, PELT clock is not stopped for these cfs_rqs in throttled
> hierarchy when they still have tasks running or queued.

This commit is needed only when the "task based throttle model" is used
and that "task based throttle model" feature is merged in v6.18 kernel,
so I don't think we need this commit for 6.17 based kernels.

Thanks,
Aaron

> Since PELT clock is not stopped, whether to allow update_cfs_group()
> doing its job for cfs_rqs which are in throttled hierarchy but still
> have tasks running/queued is a question.
>
> The good side is, continue to run update_cfs_group() can get these
> cfs_rq entities with an up2date weight and that up2date weight can be
> useful to derive an accurate load for the CPU as well as ensure fairness
> if multiple tasks of different cgroups are running on the same CPU.
> OTOH, as Benjamin Segall pointed: when unthrottle comes around the most
> likely correct distribution is the distribution we had at the time of
> throttle.
>
> In reality, either way may not matter that much if tasks in throttled
> hierarchy don't run in kernel mode for too long. But in case that
> happens, let these cfs_rq entities have an up2date weight seems a good
> thing to do.
>
> Signed-off-by: Aaron Lu <ziqianlu@bytedance.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/sched/fair.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4770d25ae2406..3e0d999e5ee2c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3957,9 +3957,6 @@ static void update_cfs_group(struct sched_entity *se)
>  	if (!gcfs_rq || !gcfs_rq->load.weight)
>  		return;
>
> -	if (throttled_hierarchy(gcfs_rq))
> -		return;
> -
>  	shares = calc_group_shares(gcfs_rq);
>  	if (unlikely(se->load.weight != shares))
>  		reweight_entity(cfs_rq_of(se), se, shares);
> --
> 2.51.0
>
>
