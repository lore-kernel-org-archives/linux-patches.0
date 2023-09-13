Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16E233D4;
	Wed, 13 Sep 2023 20:04:07 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-573675e6b43so168667eaf.0;
        Wed, 13 Sep 2023 13:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694635446; x=1695240246; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrYBdeOdlbO3LjTxL/wkAMApQxH+mOlX+GhFVIJ5rpM=;
        b=NYJPxCXC48FgM67kHudmCmUMAbabWMbhRD6ND5RZVXmkVBUQhJmDeRMWED5Y75Pvkb
         ue0v7nCj3aUZj6MySLDzyMMNs4F35ENrlOvdZpFb3JD2U/k/0vX5/vul0n8KjS8vB6sU
         Mjugsu72ohJ3HdJfoVOypqzJroDqfLQ0/5b3RaavTd36DfK4kk76869YIEgpMfHYV2MO
         PiXE01YEz+V4aUGvJMiXoATa6V6FJobrLQB0UnSLmVLD2Owyv3WO+EhJv6SeOwc3MrhC
         9G5lSn8Jt1QSqDXTEfetbdjHWefK5o7R75T2rjnhE4cwOw3moRTe/rLi0KgYmhwxgf5n
         9hYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694635446; x=1695240246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LrYBdeOdlbO3LjTxL/wkAMApQxH+mOlX+GhFVIJ5rpM=;
        b=pAYxNA01RC7QKIy7R3nptTrZ/v4WO1pMN9GX3ZSakiyQMz1YlOy6PYiVUiWKbEScmB
         1d6QeaBH6rUjodYw6LOekswe3r1/JJMmm7BVFv4i+Q0ahHrHZigW/NJbrRXW5gm0KjM2
         RUEWZmgxV4pAQ9k5X+bDuzHEn1F38mVUEiIAmNZ6oNXAXIrk1peiMyg+9UrCO4IyQ2mq
         40uM8m5Ek1q5tvke56uTV9+2MKFDvLBfJZdNCixhy5N2IXI5NmHEHivMS3ixQqTbp+L1
         YPCwu1hGeiA8iheGn7orgFcjDF16f3Foq4TGJsidM66qygxtHGlQL9dGJo+CdI/jZvoR
         0GwA==
X-Gm-Message-State: AOJu0YwNbz48MhftTs1G4g88yppPfmJHaIyHhRr7LLDXbp2jHCVRHIh0
	64w4c7nh+KjSiMMU2VktH6zATZptp5ApkHkLQ28zBjMx
X-Google-Smtp-Source: AGHT+IExe2crzJqQpUifFCUSPWho0xRRO7I3DVovg+yV6TJbukcMTWUToagMohWrdywQ44rLSI4EtCZqL+tZb5VB1TA=
X-Received: by 2002:a05:6870:a54a:b0:1b0:5bf7:3bb6 with SMTP id
 p10-20020a056870a54a00b001b05bf73bb6mr3629074oal.28.1694635446612; Wed, 13
 Sep 2023 13:04:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230913-fix-wuninitialized-dm_helpers_dp_mst_send_payload_allocation-v1-1-2d1b0a3ef16c@kernel.org>
 <b11cce07-7e13-49b5-aed3-88517356281b@amd.com> <CADnq5_MsHwC94F_2SdyUM39FRoeVZMNa-8quxB4TVOVqM05=zQ@mail.gmail.com>
 <b1396feb-9bd5-4aa4-97b1-9d743fffe5ef@amd.com>
In-Reply-To: <b1396feb-9bd5-4aa4-97b1-9d743fffe5ef@amd.com>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 13 Sep 2023 16:03:55 -0400
Message-ID: <CADnq5_NZ6Bv5zyNxJc13Bb4bPmHTTDPEWqtV_VFt5y1gzsgGzQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Fix -Wuninitialized in dm_helpers_dp_mst_send_payload_allocation()
To: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Nathan Chancellor <nathan@kernel.org>, harry.wentland@amd.com, sunpeng.li@amd.com, 
	Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com, christian.koenig@amd.com, 
	Xinhui.Pan@amd.com, Wayne.Lin@amd.com, lyude@redhat.com, trix@redhat.com, 
	llvm@lists.linux.dev, ndesaulniers@google.com, patches@lists.linux.dev, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 13, 2023 at 3:57=E2=80=AFPM Hamza Mahfooz <hamza.mahfooz@amd.co=
m> wrote:
>
>
> On 9/13/23 15:54, Alex Deucher wrote:
> > On Wed, Sep 13, 2023 at 12:17=E2=80=AFPM Hamza Mahfooz <hamza.mahfooz@a=
md.com> wrote:
> >>
> >>
> >> On 9/13/23 12:10, Nathan Chancellor wrote:
> >>> When building with clang, there is a warning (or error when
> >>> CONFIG_WERROR is set):
> >>>
> >>>     drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_helpers=
.c:368:21: error: variable 'old_payload' is uninitialized when used here [-=
Werror,-Wuninitialized]
> >>>       368 |                                                  new_payl=
oad, old_payload);
> >>>           |                                                          =
     ^~~~~~~~~~~
> >>>     drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_helpers=
.c:344:61: note: initialize the variable 'old_payload' to silence this warn=
ing
> >>>       344 |         struct drm_dp_mst_atomic_payload *new_payload, *o=
ld_payload;
> >>>           |                                                          =
          ^
> >>>           |                                                          =
           =3D NULL
> >>>     1 error generated.
> >>>
> >>> This variable is not required outside of this function so allocate
> >>> old_payload on the stack and pass it by reference to
> >>> dm_helpers_construct_old_payload(), resolving the warning.
> >>>
> >>> Closes: https://github.com/ClangBuiltLinux/linux/issues/1931
> >>> Fixes: 5aa1dfcdf0a4 ("drm/mst: Refactor the flow for payload allocati=
on/removement")
> >>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> >>
> >> Reviewed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
> >>
> >> Hm, seems like this was pushed through drm-misc-next and as such our C=
I
> >> didn't get a chance to test it.
> >
> > Can you push this to drm-misc?  That is where Wayne's patches landed.
> > If not, I can push it.
>
> No need, I cherry-picked Wayne's patches to amd-staging-drm-next and
> applied Nathan's fix.

Yes, but we can only have patches go upstream via one tree.  Wayne's
patches are in drm-misc, so that is where the fix should be.  It's
fine to have them in amd-staging-drm-next for testing purposes, but I
won't be upstreaming them via the amdgpu -next tree since they are
already in drm-misc.

Alex

>
> >
> > Alex
> >
> >
> >>
> >>
> >>> ---
> >>>    drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 6 +++-=
--
> >>>    1 file changed, 3 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.=
c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> >>> index 9ad509279b0a..c4c35f6844f4 100644
> >>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> >>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> >>> @@ -341,7 +341,7 @@ bool dm_helpers_dp_mst_send_payload_allocation(
> >>>        struct amdgpu_dm_connector *aconnector;
> >>>        struct drm_dp_mst_topology_state *mst_state;
> >>>        struct drm_dp_mst_topology_mgr *mst_mgr;
> >>> -     struct drm_dp_mst_atomic_payload *new_payload, *old_payload;
> >>> +     struct drm_dp_mst_atomic_payload *new_payload, old_payload;
> >>>        enum mst_progress_status set_flag =3D MST_ALLOCATE_NEW_PAYLOAD=
;
> >>>        enum mst_progress_status clr_flag =3D MST_CLEAR_ALLOCATED_PAYL=
OAD;
> >>>        int ret =3D 0;
> >>> @@ -365,8 +365,8 @@ bool dm_helpers_dp_mst_send_payload_allocation(
> >>>                ret =3D drm_dp_add_payload_part2(mst_mgr, mst_state->b=
ase.state, new_payload);
> >>>        } else {
> >>>                dm_helpers_construct_old_payload(stream->link, mst_sta=
te->pbn_div,
> >>> -                                              new_payload, old_paylo=
ad);
> >>> -             drm_dp_remove_payload_part2(mst_mgr, mst_state, old_pay=
load, new_payload);
> >>> +                                              new_payload, &old_payl=
oad);
> >>> +             drm_dp_remove_payload_part2(mst_mgr, mst_state, &old_pa=
yload, new_payload);
> >>>        }
> >>>
> >>>        if (ret) {
> >>>
> >>> ---
> >>> base-commit: 8569c31545385195bdb0c021124e68336e91c693
> >>> change-id: 20230913-fix-wuninitialized-dm_helpers_dp_mst_send_payload=
_allocation-c37b33aaad18
> >>>
> >>> Best regards,
> >> --
> >> Hamza
> >>
> --
> Hamza
>
