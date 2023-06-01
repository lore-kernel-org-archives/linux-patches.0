Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7570F4823D
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 18:10:27 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-96f818c48fbso166619566b.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 11:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685643025; x=1688235025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fN4dOkqKjC6yYa0WCy0PPXkew6vDz5s8phQTNj9Uuro=;
        b=LMamD9ZGqhsd796VPhVqGOUsh95L92VoivoPgRU5UCTYTQFubX9A+mz4OvotmLxtp5
         UP7BcmGvfxEEmXDFfkfYvpewgcnSFAhne6LHWjRUcMPkk68fb+yrkTlMOpX+31hwPIi9
         DPdSsC0DMD8A9Xa4ujsuEECTBLUi8zMGCrpSkdqjt3AWwQn8K7KuYZ2KobXr9sGbAaXX
         eIuEmthfQKrdS07eUYRYVkQx45iLu1tNIUSsos8pJ7yi8IlD5SGmmm5i7+chGKRztc5o
         UuO+b8qsb6vi7FwIEczQpLjmUk012qzSET9RVVVVQIxNDz/pb3kfKKQfXGXl1cg/LNpu
         WWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685643025; x=1688235025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fN4dOkqKjC6yYa0WCy0PPXkew6vDz5s8phQTNj9Uuro=;
        b=NqdbYNymf9yig5UA67LDcKYFwPlj6c7SsysSVj6Z/nlgTCE9fpAJqAV3iy1V+J4AWE
         7FzPUI0Wki2cxD5BCuaHOoubrisArXvHRDQyI9NY+FWWrFbg4CU21BCHNQp3scbEe2CY
         Ev4vsavwtIl8IXUX1NtPbCkm/ybQcNu3bqZ+gcIEVuhnU0eaLUU4BBAbZ4xil6eD+B6S
         Cx6G1DBT1t95qgIb6yHVPNfQ+5W9RDLKLR0mWieGzQHOTO3sJ7yMpl5fuuxbFPOeEohR
         6wBrr2W4PRCX80NjVvh8pTRHITEzJfJ2DJiYeNhcaw6LWbRaVJ5c8pMwaC6TlY3+R0y5
         GizQ==
X-Gm-Message-State: AC+VfDxpbqYu6NQLZvr6L6snRWdGq5UBBnM3nP6Ctf2wMX0qFEW4nZc6
	rsdOkxdE7nf0qox34PC6j1CzJjyNfEi9FmVcPm37Jw==
X-Google-Smtp-Source: ACHHUZ7igvhtiibQfA61bCZ+csGUB2mQgm5JSsigI+IF4r18gJt2/M9hdQNEH7zPfMRhvLmhwccp2hTEPWr+q9TRMIo=
X-Received: by 2002:a17:907:7293:b0:966:1984:9d21 with SMTP id
 dt19-20020a170907729300b0096619849d21mr8288661ejc.9.1685643025187; Thu, 01
 Jun 2023 11:10:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601-zswap-cgroup-wsometimes-uninitialized-v1-1-35debdd19293@kernel.org>
In-Reply-To: <20230601-zswap-cgroup-wsometimes-uninitialized-v1-1-35debdd19293@kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 1 Jun 2023 11:09:48 -0700
Message-ID: <CAJD7tkYZxbEyP6-yjcobws_6Cvjib9c9YnBQRBjhwrK3KaHs7A@mail.gmail.com>
Subject: Re: [PATCH] zswap: Avoid uninitialized use of ret in zswap_frontswap_store()
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, 
	vitaly.wool@konsulko.com, ndesaulniers@google.com, trix@redhat.com, 
	nphamcs@gmail.com, linux-mm@kvack.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 1, 2023 at 8:26=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> Clang warns:
>
>   mm/zswap.c:1183:6: error: variable 'ret' is used uninitialized whenever=
 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   mm/zswap.c:1327:9: note: uninitialized use occurs here
>    1327 |         return ret;
>         |                ^~~
>   mm/zswap.c:1183:2: note: remove the 'if' if its condition is always fal=
se
>    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    1184 |                 goto reject;
>         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   mm/zswap.c:1158:9: note: initialize the variable 'ret' to silence this =
warning
>    1158 |         int ret;
>         |                ^
>         |                 =3D 0
>   1 error generated.
>
> Set ret to -EINVAL, which seems to best match the situation the comment
> mentions and matches an earlier bailout due to an unsupported type or
> situation.

Shouldn't this be -ENOMEM? I think this was the error code returned in
this situation before 6804144bf1cf.

>
> Fixes: 6804144bf1cf ("zswap: do not shrink if cgroup may not zswap")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/202306011435.2BxsHFUE-lkp@intel.com/
> Closes: https://lore.kernel.org/202306012152.o4FL7Y6J-lkp@intel.com/
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1861
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  mm/zswap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index cff93643a6ab..e8313e2f5807 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigned type, pg=
off_t offset,
>          * local cgroup limits.
>          */
>         objcg =3D get_obj_cgroup_from_page(page);
> -       if (objcg && !obj_cgroup_may_zswap(objcg))
> +       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> +               ret =3D -EINVAL;
>                 goto reject;
> +       }
>
>         /* reclaim space if needed */
>         if (zswap_is_full()) {
>
> ---
> base-commit: b2424568bd9b947b2698b693ff24fec63bb4b36a
> change-id: 20230601-zswap-cgroup-wsometimes-uninitialized-b549ff4247ed
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>
