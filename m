Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04D527F1D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:36:29 +0000 (UTC)
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-765a1690003so202155885a.0
        for <patches@lists.linux.dev>; Fri, 21 Jul 2023 11:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689964588; x=1690569388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHZrBLyt0tLPGB2RONofsO5b0sKazW7IdioBPKpibr4=;
        b=ytwwLc0h9YOdggPJlKlzbjecI9Apaj257sz7uh6CdFxqjlBYy6kFl3hoL19aMz1ixE
         bjQCKRyBT4MK/9YEtKbbYUrYrvhupezSMAn0l1U3eRtox0mHBMH5FC8NqjeF+v2RvVIz
         XSCXQQ2nkYX/WQIclOKo4E3JtA1scC4P8b1Y3c9E2DvbQBuOj2caQPcSv8lBr+mgTPrm
         cqIRAzctEgT2qC3ljrYOWWTx6vjlJExJdmAEamcjfrA6+yHHgaZ9KyAmTu6SHAaPNHqo
         SDB00c+8qxHmt0qIx9ZozvrPG/G06aPFhe8GZIa8IJNEGYPj6rgTg8hbfFi6gyUxZHWo
         Nt1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689964588; x=1690569388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHZrBLyt0tLPGB2RONofsO5b0sKazW7IdioBPKpibr4=;
        b=M2M4ecSLCWh/+1tEsMLf39opNJAI/jq0MU7YTK3bBbFka8wxBqFijNrFwTxJQJB/El
         EhiWu0iyKYNL4pNp5KwTDoYKF3cwJ1VPKik2D8qVtllOj22bwOi2K2nPKzKe2cs0aWKC
         YPO1aC7YhAeCLQ9+KKlMOmMD57hd6HkChFWA8KugzZJ7GW2MFjvCPTgGh+PtStEbrrSe
         F5Ep7LEOQfp9WhyfCESHOGzioR9GPt5nbIcnRUJKl3sDXkus1+A3DzJEVZLuaRIuGGYu
         khARovV+cVqnajhqvZHrncebyp85PTcftM64ixkmhLKexFqRKpdSPQXuTLzUGnvjIfxZ
         LNCA==
X-Gm-Message-State: ABy/qLZkGeHbRbzc+yw2YivV0MWVdvENKCOw6iOJBxNli0SKe5Uhrs0X
	1shJ4g8mEUAC1SiR0Z2pZb3OT7fjpIzsTV5k7xn0fw==
X-Google-Smtp-Source: APBJJlGh9fwuP4Vof6eGVvzXhgYaNFm3V3zmaLa3+SuKLBH80ZShDvbTVFMZ3OBxViOUWTYv8r04Cf1dx8bNV5mmmaM=
X-Received: by 2002:ad4:404f:0:b0:636:b0b5:3198 with SMTP id
 r15-20020ad4404f000000b00636b0b53198mr797212qvp.50.1689964588331; Fri, 21 Jul
 2023 11:36:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718-nsecs_to_jiffies_timeout-constant-logical-operand-v1-0-36ed8fc8faea@kernel.org>
 <20230718-nsecs_to_jiffies_timeout-constant-logical-operand-v1-1-36ed8fc8faea@kernel.org>
In-Reply-To: <20230718-nsecs_to_jiffies_timeout-constant-logical-operand-v1-1-36ed8fc8faea@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 21 Jul 2023 11:36:17 -0700
Message-ID: <CAKwvOdkdjnNwBXKyp2ssq6iF9DMqJeWYyPOfTEFtLUoFhb79jg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/v3d: Avoid -Wconstant-logical-operand in nsecs_to_jiffies_timeout()
To: Nathan Chancellor <nathan@kernel.org>
Cc: jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, 
	rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com, emma@anholt.net, 
	mwen@igalia.com, justinstitt@google.com, trix@redhat.com, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 2:44=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> A proposed update to clang's -Wconstant-logical-operand to warn when the
> left hand side is a constant shows the following instance in
> nsecs_to_jiffies_timeout() when NSEC_PER_SEC is not a multiple of HZ,
> such as CONFIG_HZ=3D300:
>
>   In file included from drivers/gpu/drm/v3d/v3d_debugfs.c:12:
>   drivers/gpu/drm/v3d/v3d_drv.h:343:24: warning: use of logical '&&' with=
 constant operand [-Wconstant-logical-operand]
>     343 |         if (NSEC_PER_SEC % HZ &&
>         |             ~~~~~~~~~~~~~~~~~ ^
>   drivers/gpu/drm/v3d/v3d_drv.h:343:24: note: use '&' for a bitwise opera=
tion
>     343 |         if (NSEC_PER_SEC % HZ &&
>         |                               ^~
>         |                               &
>   drivers/gpu/drm/v3d/v3d_drv.h:343:24: note: remove constant to silence =
this warning
>   1 warning generated.
>
> Turn this into an explicit comparison against zero to make the
> expression a boolean to make it clear this should be a logical check,
> not a bitwise one.
>
> Link: https://reviews.llvm.org/D142609
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/gpu/drm/v3d/v3d_drv.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.=
h
> index b74b1351bfc8..7f664a4b2a75 100644
> --- a/drivers/gpu/drm/v3d/v3d_drv.h
> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
> @@ -340,7 +340,7 @@ struct v3d_submit_ext {
>  static inline unsigned long nsecs_to_jiffies_timeout(const u64 n)
>  {
>         /* nsecs_to_jiffies64() does not guard against overflow */
> -       if (NSEC_PER_SEC % HZ &&
> +       if ((NSEC_PER_SEC % HZ) !=3D 0 &&
>             div_u64(n, NSEC_PER_SEC) >=3D MAX_JIFFY_OFFSET / HZ)
>                 return MAX_JIFFY_OFFSET;
>
>
> --
> 2.41.0
>


--=20
Thanks,
~Nick Desaulniers
