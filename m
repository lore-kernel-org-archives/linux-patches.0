Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CD43B295;
	Tue,  2 Apr 2024 07:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712043440; cv=none; b=oJgtJ+jK1SwomffybNqGEJxGTgEhfwKn8jflUEI5KCm7e7VbxxeSul54uwK+UWEiGCpcUCWfaYR/3wgdoSQaHqSTI2n6fn7Vw+JFFJkW8DyE6X4xXHivJBLUQPS3pkerX48t80BzjreWOYGecMTmsKdAQPXEnmkXv+3kp26BCCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712043440; c=relaxed/simple;
	bh=DsIySMDvEsnmgwhe9U5+RGVKXgRQnbg+r6m0SbCq970=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kVo2pbcRWEvp1kx27Th7Kz9lRF603bgke41LNGeLOJ5mynKk4ijilhhLSPIdo8SXQFPQ7tdOj9WH8bi0aKC0GOYhQhPBAENb3lnRZ5EgGdmgczP6G7LkwDwporunlDcGdYuKY2cWd4Ks8c64vmtF7ZL/mTW59/iXjKm9TuXDJQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=Jb0P9P9p; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="Jb0P9P9p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1712043436;
	bh=DsIySMDvEsnmgwhe9U5+RGVKXgRQnbg+r6m0SbCq970=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Jb0P9P9pUf7J+27Fgsrpgq/psWpmzDvQKWKgd6TEF67/hoMAiXcr/sqpgOJI3Ow09
	 QNLoGhN4KqHIwTJtJCaTFA5IE1OCL+6n48Zn8nJ7tvEBS3KGC8XwerkiRCqTC5/OjW
	 HWU+13fQFnGdL64jzHvZnLx2y7Y0Yni8yQ9uz6T0dsyBOAvwIwR4o/AnbIgWZJvv9T
	 I6aURhal8gudv0H5Q382pr6wPqZn192L2fUl+GEXngZeNzj5sI8EkKh8ioLxvNMHq5
	 r2tKpb5h0v1kVx9XblVy2jMkjg6pxKJkvc3B6Qq3CcnKCR5SOrkZV2jIMqkS3UfTt2
	 CcRM9fJn7rOAA==
Received: from localhost (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id CF209378045F;
	Tue,  2 Apr 2024 07:37:15 +0000 (UTC)
Date: Tue, 2 Apr 2024 09:37:14 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: steven.price@arm.com, liviu.dudau@arm.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 ndesaulniers@google.com, morbo@google.com, justinstitt@google.com,
 heiko@sntech.de, dri-devel@lists.freedesktop.org, llvm@lists.linux.dev,
 patches@lists.linux.dev
Subject: Re: [PATCH] drm/panthor: Fix clang -Wunused-but-set-variable in
 tick_ctx_apply()
Message-ID: <20240402093714.16ee9a4c@collabora.com>
In-Reply-To: <20240328-panthor-drop-csg_mod_mask-v1-1-5a80be3df581@kernel.org>
References: <20240328-panthor-drop-csg_mod_mask-v1-1-5a80be3df581@kernel.org>
Organization: Collabora
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 Mar 2024 09:22:07 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> Clang warns (or errors with CONFIG_WERROR):
> 
>   drivers/gpu/drm/panthor/panthor_sched.c:2048:6: error: variable 'csg_mod_mask' set but not used [-Werror,-Wunused-but-set-variable]
>    2048 |         u32 csg_mod_mask = 0, free_csg_slots = 0;
>         |             ^
>   1 error generated.
> 
> The variable is an artifact left over from refactoring that occurred
> during the development of the initial series for this driver. Remove it
> to resolve the warning.
> 
> Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Queued to drm-misc-next.

Thanks,

Boris

> ---
>  drivers/gpu/drm/panthor/panthor_sched.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
> index 5f7803b6fc48..e5a710f190d2 100644
> --- a/drivers/gpu/drm/panthor/panthor_sched.c
> +++ b/drivers/gpu/drm/panthor/panthor_sched.c
> @@ -2045,7 +2045,7 @@ tick_ctx_apply(struct panthor_scheduler *sched, struct panthor_sched_tick_ctx *c
>  	struct panthor_device *ptdev = sched->ptdev;
>  	struct panthor_csg_slot *csg_slot;
>  	int prio, new_csg_prio = MAX_CSG_PRIO, i;
> -	u32 csg_mod_mask = 0, free_csg_slots = 0;
> +	u32 free_csg_slots = 0;
>  	struct panthor_csg_slots_upd_ctx upd_ctx;
>  	int ret;
>  
> @@ -2139,7 +2139,6 @@ tick_ctx_apply(struct panthor_scheduler *sched, struct panthor_sched_tick_ctx *c
>  
>  			csg_iface = panthor_fw_get_csg_iface(ptdev, csg_id);
>  			csg_slot = &sched->csg_slots[csg_id];
> -			csg_mod_mask |= BIT(csg_id);
>  			group_bind_locked(group, csg_id);
>  			csg_slot_prog_locked(ptdev, csg_id, new_csg_prio--);
>  			csgs_upd_ctx_queue_reqs(ptdev, &upd_ctx, csg_id,
> 
> ---
> base-commit: d180649238f04183950d9c8a7d8a2c2f1788a89c
> change-id: 20240328-panthor-drop-csg_mod_mask-b4bbe317d690
> 
> Best regards,

