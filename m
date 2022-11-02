Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308AA7460;
	Wed,  2 Nov 2022 16:15:32 +0000 (UTC)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-12c8312131fso20834087fac.4;
        Wed, 02 Nov 2022 09:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JgdHlgFUL52ZSlgJoR2BWxLy/c2ChtXsX4iM/BXcyqc=;
        b=ho8Lt6cCmihgvDFQsW1Yod9zxSYinMTGeBkJpi7Z9kRRm94PktrqsKojXGwz8PTa22
         ylgX6D5aVmt463Z5uEMjQ5mYf/FrjayBb94syCzgDLnttyg9Ph9Kzd6ZYgx9PNQ4B5+Z
         RKEflZvPevS8Y+vjindMbLmh3ku4RuY64NutN+HMb/lgzYK42JB9eRsb2SEilvLnPsmx
         sdBBL5lC/5ObFeW4jhfOQMtHraKfShq/EVfFhYdVFGx02ndLkGcbwxOtEsfttViwAh4g
         c5JHz3n4NrKqr5Vy+UmIcpuBZmX/zi8dcyXea4Jyn8WdzlRpzz7xFuFQzB+xOnp+wL3n
         2Drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JgdHlgFUL52ZSlgJoR2BWxLy/c2ChtXsX4iM/BXcyqc=;
        b=pYfVvE/1Adz9cfRXGyDI8Zk2MgO/oaKMKwHuTw0BPswK324CBK7gR0JLkZnIn6bms9
         2spalu4WPaUlj//A7cbAqXD6qV5lm/SAraHlOl3enm7fkKEh69XRv6LxHKl/yjrAi7jT
         cPkqcAjIHCTx9VI2F8UB/syxURxp3x6zPoFMkTvIjo1EIzxEMzQH3F7ejrBNIdMFpq97
         CG0ztfsy+lnPOqPcuFyyg+JKWwSwauvW/zYJBoMcjOsOt4vt1l9B21XJW/qNCBB3/xPQ
         +zFibJTifvmJijMXTkZoCLWUFbfH5LhW5fyg3O/whd+zKTcG6c4f55oPJEfKWkWQpP9g
         enww==
X-Gm-Message-State: ACrzQf23Kc7hbl/smLKT6MGGYAsOE9wHUBY4VnPBLWXSv+IcyrUG7ovx
	0RFVtx2P0o1+ygAId5/bj9Zk+gCamXxFGIkCfaU=
X-Google-Smtp-Source: AMsMyM4e5KRS5+wtnu+5IMwyVsDM0J1Z9m0fl9VvwJLdX+CyYgyy3luD7SpqwqGASkuDfYCIT1DxBn+1OauaueJkz1Y=
X-Received: by 2002:a05:6870:a7a4:b0:136:7c39:979e with SMTP id
 x36-20020a056870a7a400b001367c39979emr15352738oao.96.1667405731170; Wed, 02
 Nov 2022 09:15:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221102152540.2389891-1-nathan@kernel.org> <20221102152540.2389891-2-nathan@kernel.org>
 <202211020842.8B8E29F8@keescook>
In-Reply-To: <202211020842.8B8E29F8@keescook>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 2 Nov 2022 12:15:20 -0400
Message-ID: <CADnq5_NFtZHzOC2o1yq6VjqT8DYB+q200R_xjf+b1qZonRh4=Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/amdgpu: Fix type of second parameter in
 odn_edit_dpm_table() callback
To: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>, llvm@lists.linux.dev, Tom Rix <trix@redhat.com>, 
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	patches@lists.linux.dev, amd-gfx@lists.freedesktop.org, 
	Sami Tolvanen <samitolvanen@google.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied the series.  Thanks!

Alex

On Wed, Nov 2, 2022 at 11:43 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Nov 02, 2022 at 08:25:40AM -0700, Nathan Chancellor wrote:
> > With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> > indirect call targets are validated against the expected function
> > pointer prototype to make sure the call target is valid to help mitigat=
e
> > ROP attacks. If they are not identical, there is a failure at run time,
> > which manifests as either a kernel panic or thread getting killed. A
> > proposed warning in clang aims to catch these at compile time, which
> > reveals:
> >
> >   drivers/gpu/drm/amd/amdgpu/../pm/swsmu/amdgpu_smu.c:3008:29: error: i=
ncompatible function pointer types initializing 'int (*)(void *, uint32_t, =
long *, uint32_t)' (aka 'int (*)(void *, unsigned int, long *, unsigned int=
)') with an expression of type 'int (void *, enum PP_OD_DPM_TABLE_COMMAND, =
long *, uint32_t)' (aka 'int (void *, enum PP_OD_DPM_TABLE_COMMAND, long *,=
 unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
> >           .odn_edit_dpm_table      =3D smu_od_edit_dpm_table,
> >                                      ^~~~~~~~~~~~~~~~~~~~~
> >   1 error generated.
> >
> > There are only two implementations of ->odn_edit_dpm_table() in 'struct
> > amd_pm_funcs': smu_od_edit_dpm_table() and pp_odn_edit_dpm_table(). One
> > has a second parameter type of 'enum PP_OD_DPM_TABLE_COMMAND' and the
> > other uses 'u32'. Ultimately, smu_od_edit_dpm_table() calls
> > ->od_edit_dpm_table() from 'struct pptable_funcs' and
> > pp_odn_edit_dpm_table() calls ->odn_edit_dpm_table() from 'struct
> > pp_hwmgr_func', which both have a second parameter type of 'enum
> > PP_OD_DPM_TABLE_COMMAND'.
> >
> > Update the type parameter in both the prototype in 'struct amd_pm_funcs=
'
> > and pp_odn_edit_dpm_table() to 'enum PP_OD_DPM_TABLE_COMMAND', which
> > cleans up the warning.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> > Reported-by: Sami Tolvanen <samitolvanen@google.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> --
> Kees Cook
