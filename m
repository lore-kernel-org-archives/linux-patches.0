Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A8A145A01;
	Thu, 30 May 2024 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717081092; cv=none; b=k5A8KDyQM0sR/831gRtsWNtAgQ4n98GjvWS4o1zHEI1QARMBd5157cOVe70R2Gq7Xh60cE+DfK6pGnbtZV4uDqOjGYab9x/+ZxbDkrcnT6On8LVeuYZyLfwmflCbsAKHRlYaHrDwKkhqMlLEmRY9VhKhu/gFABjyo7FKmC8KQZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717081092; c=relaxed/simple;
	bh=vHl/hFne/dN3VS62u9WcIyO8pcYKfCjKEu2He7GV1JM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qpBZQ6cM1VOdRo5Zu8HRh++qDVyB8Y+MbzomcBoW4Vn0qm4BehFpXZO0vsPU+qSsX4Z+/z/9mY2/P/1nF+YwyBB7npoBEW6S9ZZo/a/hZdt+9oM2R/eDT3sXdoxHB0jDBuNh/KyBWUxku6MqkFVLVqzODef2rks9m1nF/jfacvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VrYNBvc3; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrYNBvc3"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7024003a517so126152b3a.2;
        Thu, 30 May 2024 07:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717081090; x=1717685890; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pcneh6OdbXB2yw8eBub3uBTS5tn1ef9zWgBOmoSp/pE=;
        b=VrYNBvc3u8PZEs+SGpeDPIs/P0ONtFVgYjl46jzjmZTcTUcWIatXqSC+khdJ40GsD5
         cC2ZIx/JqOPtIOBcG3inW0gwJWstDN1DaaoKo1NPwrTJnFB1wpCKStqRXxXLmyhJgslR
         Uo/FDKuo767+6UiUpBYNrGV2R7URi9BBaRaI9FZI/BqYwns3F/GliwriiVZmNK4ar1fb
         gMo8TwPdND8xkuDFU9eHewqKIXKYbMcoSnErC4T8y2ACo7XYKkbcy/lbzmivfpbsl2lv
         cc1t8QZ3S7q8uhRHIgBg2FwvLFp9+ePbLd7b0UssGVsVEov5jD5g/sVlHKTZtlsWaJc8
         UwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717081090; x=1717685890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pcneh6OdbXB2yw8eBub3uBTS5tn1ef9zWgBOmoSp/pE=;
        b=AaveZ9KqokNEiVQrsvKu7XL6NTrWT6FcsJRfDNj5pARqNLZmxt5ijOiYZYqWUONX7D
         YSfCtmFAGipUSUSmLCQhkpbsgiSq4kfjZjfyZHZ/MyJ+kkvMfo4NTisI63sAkuGubcb/
         7t29U2EB1CKdWaZynWaLjf7P0h1BfcCp8lUVVEGDUHMz1lEnM79Ecd39aPexYEss/+Lo
         Ls4XVc1CxcZGXlBu4vPxEJlP/pVzEu6E499mjUZUrItuWi2ndUdeWSX0DZLc2kw2qWk0
         9hLZMIjJ9GQp2yA173EQuKHt9xcmHVgnUQ5KVJmTqk8og8fvwPnA+oX6QfWcIW2ZHF2K
         7rdg==
X-Forwarded-Encrypted: i=1; AJvYcCUbfYf7uLQonKNTq/lWREVBMcNrFVpDPfTV+YXcqNRYesSGq7iO3Fq7Rt9jFyT/aavhKmKj4jrI4PtWUEmXuRcesxxGwYvDwGJ0k3mTmGQXV/UMEtE0YWSw7ZDVynA=
X-Gm-Message-State: AOJu0YzDND6fhc7ME+QSM15+5aPqJ688Cc3+cFWkLWa/TVM0gthME+gT
	x9Z7ZaAhra3UMNJFUyG4+Dq4ZUyUg6pH2b8d8E1Kz1BhgvvXhOjAvUZZmahARij5m5dXyuLWjKl
	JhFOhsN/CCnFb0gbZkJd9mHcOl18Dkw==
X-Google-Smtp-Source: AGHT+IG/K9bjenhk0+Nldu2e8TDBOCESyblInvnkPhmih6+zxEhLkPmDFwz2LvGoFVaBBs/bIA3IpcKiiLGStFQRrDc=
X-Received: by 2002:a05:6a00:4214:b0:6ed:60a4:6d9c with SMTP id
 d2e1a72fcca58-702310e53cdmr2970675b3a.4.1717081090330; Thu, 30 May 2024
 07:58:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240529-drop-counted-by-radeon-states-state-array-v1-1-5cdc1fb29be7@kernel.org>
In-Reply-To: <20240529-drop-counted-by-radeon-states-state-array-v1-1-5cdc1fb29be7@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Thu, 30 May 2024 10:57:58 -0400
Message-ID: <CADnq5_P5Mz=Acm0HURUUHu03eBmemcu7jYe8nYJ5WtBjb93Qgg@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: Remove __counted_by from StateArray.states[]
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-hardening@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.  Thanks!

On Wed, May 29, 2024 at 5:54=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> From: Bill Wendling <morbo@google.com>
>
> Work for __counted_by on generic pointers in structures (not just
> flexible array members) has started landing in Clang 19 (current tip of
> tree). During the development of this feature, a restriction was added
> to __counted_by to prevent the flexible array member's element type from
> including a flexible array member itself such as:
>
>   struct foo {
>     int count;
>     char buf[];
>   };
>
>   struct bar {
>     int count;
>     struct foo data[] __counted_by(count);
>   };
>
> because the size of data cannot be calculated with the standard array
> size formula:
>
>   sizeof(struct foo) * count
>
> This restriction was downgraded to a warning but due to CONFIG_WERROR,
> it can still break the build. The application of __counted_by on the
> states member of 'struct _StateArray' triggers this restriction,
> resulting in:
>
>   drivers/gpu/drm/radeon/pptable.h:442:5: error: 'counted_by' should not =
be applied to an array with element of unknown size because 'ATOM_PPLIB_STA=
TE_V2' (aka 'struct _ATOM_PPLIB_STATE_V2') is a struct type with a flexible=
 array member. This will be an error in a future compiler version [-Werror,=
-Wbounds-safety-counted-by-elt-type-unknown-size]
>     442 |     ATOM_PPLIB_STATE_V2 states[] __counted_by(ucNumEntries);
>         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
>
> Remove this use of __counted_by to fix the warning/error. However,
> rather than remove it altogether, leave it commented, as it may be
> possible to support this in future compiler releases.
>
> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2028
> Fixes: efade6fe50e7 ("drm/radeon: silence UBSAN warning (v3)")
> Signed-off-by: Bill Wendling <morbo@google.com>
> Co-developed-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/radeon/pptable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/pptable.h b/drivers/gpu/drm/radeon/pp=
table.h
> index b7f22597ee95..969a8fb0ee9e 100644
> --- a/drivers/gpu/drm/radeon/pptable.h
> +++ b/drivers/gpu/drm/radeon/pptable.h
> @@ -439,7 +439,7 @@ typedef struct _StateArray{
>      //how many states we have
>      UCHAR ucNumEntries;
>
> -    ATOM_PPLIB_STATE_V2 states[] __counted_by(ucNumEntries);
> +    ATOM_PPLIB_STATE_V2 states[] /* __counted_by(ucNumEntries) */;
>  }StateArray;
>
>
>
> ---
> base-commit: e64e8f7c178e5228e0b2dbb504b9dc75953a319f
> change-id: 20240529-drop-counted-by-radeon-states-state-array-01936ded4c1=
8
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
