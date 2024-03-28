Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F4F1E533
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 21:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711663170; cv=none; b=RYteyBiJBWnIjbdjodXwZEALHTcLb38Uybsie4J9JZEwF+PEApjqpXKrlizJYLfNrm1RqdJxhhM6Zd4U2Mq1P/lr3XWcFJonHd5KXulp1XBGaryOrEYCXtJoE1bfScAS4H/lMEcNoF45h7tSoiF2+wHTpGNsDVjAq7Y71Yxno+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711663170; c=relaxed/simple;
	bh=xmo39MCdNMPQmHxw1MUgA6OOoECS018DvUqLxEsi7YM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ee+KFSD04Asu8Oic76Hs/0Kp3XxfbvnmkMbm2gwBjLNLSc9ANBNb6bpmAOcDFxN48PeKMmrBqNjncpB5eTVnTlYY8JgasO0YSquH/+3CgRFl7Xc8muY0Agzx/Z3RECSHW08hYJLj8iThsPHZmgaaFLBorbANFQtIj9X3KMGBmaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vWDR4AOi; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vWDR4AOi"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56c08d1e900so1692061a12.3
        for <patches@lists.linux.dev>; Thu, 28 Mar 2024 14:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711663167; x=1712267967; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JkrR3TRsPYSXBmltvKoz6z3FLacSM3QfrKhBArRhwdM=;
        b=vWDR4AOikZrPkEoNr3Dbo7gARKJc4jWB8vP0gjn8rQeq/BafbmYzkyrV3O3zu1x+lp
         fK+ob+KXv4w5Ys+H4ROBUoFfWDQL2vVUzNmhaF0Sd2rVspgbGB7/xFVEs1j8mON+8+J2
         GEa/93ycYqMUmCrW9ehN9Zz/ur53xaNGNI6mD1NZfT40Rfkc+tIa4rBg2DTIMXPhFYpe
         HatRe8zKek37oKgBtbxW97TyatpPX0zO2LZgOz74GgVafv718bQpYYNTP74raigC45nH
         Rlk6++ot5DJH+9Zgul1FOP+PgLD1zZfu5/9Aj16FM2mcOG33DWYag/zUIpi3h5GZ0yNI
         OD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711663167; x=1712267967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JkrR3TRsPYSXBmltvKoz6z3FLacSM3QfrKhBArRhwdM=;
        b=vgpccGr6jhZJrw/z30sPKKZKSp4VXokM7/HFw+Bf7bjwp+l0ioLPtXKW3TFMIiucuv
         fhCIXdv2HkB2uafjh342TGT9i4SgoE49Or4E+LYBjd9iXrGMolcPr2bgkNmLJF0PlFyJ
         YRsNlAzg4VrHD/5SEY8IL3GWD1WxO/fJ+XJ8BUX+hu3rSKAdquHrvOhFQLI4ynD+ZDvB
         BXGn//iDq3Iisebj5cORshJ/lYpFz1vFmecoYMeNy9z3+JSwPRxao0Q9hJBftALnbIue
         ZLzSgVsMLxFjzGcqnkLZ51A7H3CGfHs+D3Pub33F2MsYkl6LV3UsCzJ6Id+ttDptzkb4
         2nbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsaE+6lpHeT+lVxWHIH0aOwfU2Fu9wBaWDj0MXTvBFdA7rcuYHu9w1fhpuxvcg/NoPxvVNHGBNFmW6EEg/G5tu9CT1Gat7EQ==
X-Gm-Message-State: AOJu0YydW9yUwho1Nyf2bQqDJORfsX7tcZiQBV+WCVXcXcHPJEAeYEmI
	NWg0ePYuMEKFvztHnSMWwRkqZlnjVS6gMfuxKPEVJ2yCCtN5hW6zpCETPP/59Si99GdeZ3sluai
	vC303pYUILLbmVxn6HX7O3glfENTMqfwAJLFC
X-Google-Smtp-Source: AGHT+IHxVJPGgWlPUtD38LmquZT+Kw2h6yv1jTsdsBsy+O/RrcoVPzZF9uidn02SdlhCE7x48PGrZPsbAniqVO9n/64=
X-Received: by 2002:a05:6402:3548:b0:56b:c210:870c with SMTP id
 f8-20020a056402354800b0056bc210870cmr331295edd.15.1711663167480; Thu, 28 Mar
 2024 14:59:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240328-panthor-drop-csg_mod_mask-v1-1-5a80be3df581@kernel.org>
In-Reply-To: <20240328-panthor-drop-csg_mod_mask-v1-1-5a80be3df581@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 28 Mar 2024 14:59:15 -0700
Message-ID: <CAFhGd8qJQw9TFPzM5VqwPAdvFCfYRW6TMFYZcOOPWW74qvNz6Q@mail.gmail.com>
Subject: Re: [PATCH] drm/panthor: Fix clang -Wunused-but-set-variable in tick_ctx_apply()
To: Nathan Chancellor <nathan@kernel.org>
Cc: boris.brezillon@collabora.com, steven.price@arm.com, liviu.dudau@arm.com, 
	maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de, 
	ndesaulniers@google.com, morbo@google.com, heiko@sntech.de, 
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 9:22=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns (or errors with CONFIG_WERROR):
>
>   drivers/gpu/drm/panthor/panthor_sched.c:2048:6: error: variable 'csg_mo=
d_mask' set but not used [-Werror,-Wunused-but-set-variable]
>    2048 |         u32 csg_mod_mask =3D 0, free_csg_slots =3D 0;
>         |             ^
>   1 error generated.
>
> The variable is an artifact left over from refactoring that occurred
> during the development of the initial series for this driver. Remove it
> to resolve the warning.

Yep, makes sense.

>
> Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  drivers/gpu/drm/panthor/panthor_sched.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/pa=
nthor/panthor_sched.c
> index 5f7803b6fc48..e5a710f190d2 100644
> --- a/drivers/gpu/drm/panthor/panthor_sched.c
> +++ b/drivers/gpu/drm/panthor/panthor_sched.c
> @@ -2045,7 +2045,7 @@ tick_ctx_apply(struct panthor_scheduler *sched, str=
uct panthor_sched_tick_ctx *c
>         struct panthor_device *ptdev =3D sched->ptdev;
>         struct panthor_csg_slot *csg_slot;
>         int prio, new_csg_prio =3D MAX_CSG_PRIO, i;
> -       u32 csg_mod_mask =3D 0, free_csg_slots =3D 0;
> +       u32 free_csg_slots =3D 0;
>         struct panthor_csg_slots_upd_ctx upd_ctx;
>         int ret;
>
> @@ -2139,7 +2139,6 @@ tick_ctx_apply(struct panthor_scheduler *sched, str=
uct panthor_sched_tick_ctx *c
>
>                         csg_iface =3D panthor_fw_get_csg_iface(ptdev, csg=
_id);
>                         csg_slot =3D &sched->csg_slots[csg_id];
> -                       csg_mod_mask |=3D BIT(csg_id);
>                         group_bind_locked(group, csg_id);
>                         csg_slot_prog_locked(ptdev, csg_id, new_csg_prio-=
-);
>                         csgs_upd_ctx_queue_reqs(ptdev, &upd_ctx, csg_id,
>
> ---
> base-commit: d180649238f04183950d9c8a7d8a2c2f1788a89c
> change-id: 20240328-panthor-drop-csg_mod_mask-b4bbe317d690
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
