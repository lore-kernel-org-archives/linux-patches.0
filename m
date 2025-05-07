Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BAB28C5D2
	for <patches@lists.linux.dev>; Wed,  7 May 2025 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746639790; cv=none; b=Z7I2J3RY4OmnQdhX6NQUMTMaog43Nq9jz7vZaT4YZ4E2Bb32xZklGuZ9tpxulcXCtsC83V/SJYwZCOMOxRKl1Xabw6/RiJyYBqaIbUcMaYjyu12TsYN4VMHht/YZo4WdE6A6N9IC8KK7u0BYtiHjv0IR7SUKrT1ik338l6LY1VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746639790; c=relaxed/simple;
	bh=DOQ3fPkTGtVwPh7S8hPxEgsaEuP90mc8DIEtOpcrtOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7gQCQ+M6qVyBkaiQf46aGuHEySGe0QPvNeD7QIrkHX6I23Sk3i3D/3ks9b38Xk0jYb+NyzOr+MUGD0P2CuIEnxgd8AwiJYQk1Xutr72AConFQOSY4ERYKKKEm5zf+jze5vJ0VmY5H3xdPmlJFTm+qIhvNwFtjUJrwIMYLYY2ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b=0ylsmPe1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b="0ylsmPe1"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22e696bbc85so259115ad.2
        for <patches@lists.linux.dev>; Wed, 07 May 2025 10:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1746639788; x=1747244588; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rl0H2iR/SnugHTVu/jGXkIv241LQtPIB5UJqW+ObFoA=;
        b=0ylsmPe1vtb/yGQKL6dmcmNK/HOdgBYdRGbzr7ks8Y3VPtsT/LBfQ2iDYHjNIdi0bo
         n9qaimfueO1hYyqH5omgThjeYzPJFPyLnVsVt/kKtI/OgNWnI8fnj9rfW4D0hyuuV/Bt
         JAsPaa+LtDy0osqGfDiN/kxdvtjVgdoyicXGizbRiTfWN+o7bvG4kj5oBS+24BIFfaWJ
         IX+KuVcmTakLLj1S8pOYtBFkuNx1cYevuzSvEns797n8ToufkIwPdQNo+koWfWe0Se3R
         K2EMaXO2M4uElxcAbbAr45kjAXWT2JajYw94aHUR2MnGF5Cr1NKy6eOH4nK+kWRyecGy
         gsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746639788; x=1747244588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rl0H2iR/SnugHTVu/jGXkIv241LQtPIB5UJqW+ObFoA=;
        b=IdMC1eZN/SxpP2O62cTQ2dSn2XaRS+uM1LbPSJBfRTui9iexybThJRNSsudL2lFPgi
         qIfAml7ccmANPnTZtxMP4HiQt5UPCcdkOKnjH2KRf9RVm4P4gyPaz9oL6p3guL5ehdQF
         NOIVvkzfjqdVMg1qxvlW2VrMhB2lKQohNFGt9lOx5M3ysswRsUbGZkSed2suG+iqyigb
         OJSe1u5zG3jei3N1C1tE+gM+dM/Qe4S7XfYjpSoT4jOq76seS2pUo2nVx67Xj4IZE0iF
         EPRB9AHxShwBf6/5nUk1Ez491lUJ6vbkMPFl571rcFfY7OzrujSDUxLOwqq3rmYrIjto
         OQoA==
X-Forwarded-Encrypted: i=1; AJvYcCUqjtkQxC4c+P5qz0bk4q0SKKbsgIqcMVu+wsJJf+qaopz/XAbOKxyL8TQ09tI3SIa1HR0Bv0Et@lists.linux.dev
X-Gm-Message-State: AOJu0YzqZZcVjAmh4WONmCONxn5qqn6smWh52H3OfITJWyx5zDBdcQOy
	2IDOyt0G5LNiwOGPOo7V4qQNgZ+wdrgFgrt8U93OtwC8pdSvT7aLb7toLGYrW0E=
X-Gm-Gg: ASbGncu6sq+4KMBj47ZWUdoRpx05rTosBPpN3WO5GgMmRINqVaNOw/z2Dltlnirw73N
	u1ijgFXGKmHPU6y7ZBuHoY/UMSeDcgse3Ecu+gtCumQjGTcSfDtmbwuX9Bl6hGSjcgGrP2/ysw/
	cyvFZvFvmtPr0TgRt8KZEQ49/79F5vZA3O7/1sn7S6A44MLzYhD1mUcQXUPLpNQC+DdSSVjh4+3
	0JfkXhTnJVX+xZGdL3CzNDZ8z20flCsT307+cBcG9Zr6DtwGcEl9uYCRM4eiL0eCiZJFjewf0er
	9VT2oCw8F3BCub5qcuPlC60=
X-Google-Smtp-Source: AGHT+IG6AxXo+9sgAJAUeVFr6UfrJVjrGlAFg7c/bKd9M9Iu1T876QFThEe/3tYLHzn264Vso+4UNw==
X-Received: by 2002:a17:903:28f:b0:224:1005:7281 with SMTP id d9443c01a7336-22e5ea7b7d6mr20810065ad.7.1746639787581;
        Wed, 07 May 2025 10:43:07 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:400::5:2b0b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e5b7e2238sm23520375ad.48.2025.05.07.10.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 10:43:07 -0700 (PDT)
Date: Wed, 7 May 2025 10:43:05 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 102/311] sched/eevdf: Fix se->slice being set to
 U64_MAX and resulting crash
Message-ID: <aBubqcsiWmEK0NRg@telecaster>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161125.215831187@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429161125.215831187@linuxfoundation.org>

On Tue, Apr 29, 2025 at 06:38:59PM +0200, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Omar Sandoval <osandov@fb.com>
> 
> [ Upstream commit bbce3de72be56e4b5f68924b7da9630cc89aa1a8 ]
> 
> There is a code path in dequeue_entities() that can set the slice of a
> sched_entity to U64_MAX, which sometimes results in a crash.
> 
> The offending case is when dequeue_entities() is called to dequeue a
> delayed group entity, and then the entity's parent's dequeue is delayed.
> In that case:
> 
> 1. In the if (entity_is_task(se)) else block at the beginning of
>    dequeue_entities(), slice is set to
>    cfs_rq_min_slice(group_cfs_rq(se)). If the entity was delayed, then
>    it has no queued tasks, so cfs_rq_min_slice() returns U64_MAX.
> 2. The first for_each_sched_entity() loop dequeues the entity.
> 3. If the entity was its parent's only child, then the next iteration
>    tries to dequeue the parent.
> 4. If the parent's dequeue needs to be delayed, then it breaks from the
>    first for_each_sched_entity() loop _without updating slice_.
> 5. The second for_each_sched_entity() loop sets the parent's ->slice to
>    the saved slice, which is still U64_MAX.
> 
> This throws off subsequent calculations with potentially catastrophic
> results. A manifestation we saw in production was:
> 
> 6. In update_entity_lag(), se->slice is used to calculate limit, which
>    ends up as a huge negative number.
> 7. limit is used in se->vlag = clamp(vlag, -limit, limit). Because limit
>    is negative, vlag > limit, so se->vlag is set to the same huge
>    negative number.
> 8. In place_entity(), se->vlag is scaled, which overflows and results in
>    another huge (positive or negative) number.
> 9. The adjusted lag is subtracted from se->vruntime, which increases or
>    decreases se->vruntime by a huge number.
> 10. pick_eevdf() calls entity_eligible()/vruntime_eligible(), which
>     incorrectly returns false because the vruntime is so far from the
>     other vruntimes on the queue, causing the
>     (vruntime - cfs_rq->min_vruntime) * load calulation to overflow.
> 11. Nothing appears to be eligible, so pick_eevdf() returns NULL.
> 12. pick_next_entity() tries to dereference the return value of
>     pick_eevdf() and crashes.
> 
> Dumping the cfs_rq states from the core dumps with drgn showed tell-tale
> huge vruntime ranges and bogus vlag values, and I also traced se->slice
> being set to U64_MAX on live systems (which was usually "benign" since
> the rest of the runqueue needed to be in a particular state to crash).
> 
> Fix it in dequeue_entities() by always setting slice from the first
> non-empty cfs_rq.
> 
> Fixes: aef6987d8954 ("sched/eevdf: Propagate min_slice up the cgroup hierarchy")
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Link: https://lkml.kernel.org/r/f0c2d1072be229e1bdddc73c0703919a8b00c652.1745570998.git.osandov@fb.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/sched/fair.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Hi,

I believe this fix should go in 6.12, too.

Thanks,
Omar
