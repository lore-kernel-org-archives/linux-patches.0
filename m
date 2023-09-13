Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17CC33D4;
	Wed, 13 Sep 2023 19:54:32 +0000 (UTC)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-1d577c89a4fso123512fac.1;
        Wed, 13 Sep 2023 12:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694634872; x=1695239672; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osCTzI9cCYtzIuEZzi5z7ouWZ4LnqWzf0G6j+lNBEFY=;
        b=eyXjhvUzXi4AMIGBrzx7zOJJOMe+Z85P4cYxlhkrjhALjOxF3OTa8prrh+o5slGIa6
         v8HcTLgurrYbX4Gw8H2B/fcUyp+5ersMNxYAD1ZVjvQrsSJxgjqg0prUy991zXtexOd9
         7G3EupJTdUXZ2DFrQMwbQI3gZzBTiwNvq2e9zjDLGuTphDXyaTvY86/rAnLE0GvJ4mRm
         MARj2BOhVsPUpbtegFZwe7rPd/B+j17OBe3giBnh8lD856tLTz+m9b/YATitkD1OJdOU
         bUDpR82+Eo0FZ47QGWoy0vMdguSxXwVKS3mq8n4aadoQjymyxzTwFyz0aU8yV3pBdcJp
         PJig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694634872; x=1695239672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=osCTzI9cCYtzIuEZzi5z7ouWZ4LnqWzf0G6j+lNBEFY=;
        b=szm03R9TKPLtlDd9Yi0cvymwluC6A+Ss/SCnfsTYjHiK4tk7HLPRZAtF7XQCVb3/cc
         pgokVJ/ds1VK8GDasFbPc8V4oAqeRMH5cP1ay4njjRutSn4Brs41zGw0NKEIrfZL5nwY
         610SeO1vpuiH6YuRvZG/yah9S3n2ka70FNXvKsuvlPD36r4qFEefCeoN8j6od/2mIr+8
         PBuTRqwlQ4130N282nkO/RmSXCxGDAq2DmGwgR6Myi2AOX0GzFQJZKQGPUMnLFRoHI5J
         BAh7N3IDN7oC3QEUsvcF46dVlGMSQo6qidD2w1i8RyVSpM+HX1q7p9rQXQOarUvZ4j/2
         2lNg==
X-Gm-Message-State: AOJu0YyIwqEX0CTI/yeu7gGrlkvZRFXrQiwdUW5XgTagfxL4aDs50MWi
	vgAGQf5vrfF7STmJ1maIC73VAJ0dw8wwGIXilkQ=
X-Google-Smtp-Source: AGHT+IFFiUKtj1CKnJq+Xei7nO7sjezhHA1Rs/tOdwnA4vpSxnZp2+wnMMXaGbu10QoLVHeTKAyYF6kNYzEuEmIMAoU=
X-Received: by 2002:a05:6870:65a5:b0:1bf:4f42:de91 with SMTP id
 fp37-20020a05687065a500b001bf4f42de91mr3748284oab.33.1694634871879; Wed, 13
 Sep 2023 12:54:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230913-fix-wuninitialized-dm_helpers_dp_mst_send_payload_allocation-v1-1-2d1b0a3ef16c@kernel.org>
 <b11cce07-7e13-49b5-aed3-88517356281b@amd.com>
In-Reply-To: <b11cce07-7e13-49b5-aed3-88517356281b@amd.com>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 13 Sep 2023 15:54:20 -0400
Message-ID: <CADnq5_MsHwC94F_2SdyUM39FRoeVZMNa-8quxB4TVOVqM05=zQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Fix -Wuninitialized in dm_helpers_dp_mst_send_payload_allocation()
To: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Nathan Chancellor <nathan@kernel.org>, harry.wentland@amd.com, sunpeng.li@amd.com, 
	Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com, christian.koenig@amd.com, 
	Xinhui.Pan@amd.com, Wayne.Lin@amd.com, lyude@redhat.com, trix@redhat.com, 
	llvm@lists.linux.dev, ndesaulniers@google.com, patches@lists.linux.dev, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 13, 2023 at 12:17=E2=80=AFPM Hamza Mahfooz <hamza.mahfooz@amd.c=
om> wrote:
>
>
> On 9/13/23 12:10, Nathan Chancellor wrote:
> > When building with clang, there is a warning (or error when
> > CONFIG_WERROR is set):
> >
> >    drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_helpers.c:=
368:21: error: variable 'old_payload' is uninitialized when used here [-Wer=
ror,-Wuninitialized]
> >      368 |                                                  new_payload=
, old_payload);
> >          |                                                             =
  ^~~~~~~~~~~
> >    drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_helpers.c:=
344:61: note: initialize the variable 'old_payload' to silence this warning
> >      344 |         struct drm_dp_mst_atomic_payload *new_payload, *old_=
payload;
> >          |                                                             =
       ^
> >          |                                                             =
        =3D NULL
> >    1 error generated.
> >
> > This variable is not required outside of this function so allocate
> > old_payload on the stack and pass it by reference to
> > dm_helpers_construct_old_payload(), resolving the warning.
> >
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1931
> > Fixes: 5aa1dfcdf0a4 ("drm/mst: Refactor the flow for payload allocation=
/removement")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>
> Reviewed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
>
> Hm, seems like this was pushed through drm-misc-next and as such our CI
> didn't get a chance to test it.

Can you push this to drm-misc?  That is where Wayne's patches landed.
If not, I can push it.

Alex


>
>
> > ---
> >   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c =
b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > index 9ad509279b0a..c4c35f6844f4 100644
> > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > @@ -341,7 +341,7 @@ bool dm_helpers_dp_mst_send_payload_allocation(
> >       struct amdgpu_dm_connector *aconnector;
> >       struct drm_dp_mst_topology_state *mst_state;
> >       struct drm_dp_mst_topology_mgr *mst_mgr;
> > -     struct drm_dp_mst_atomic_payload *new_payload, *old_payload;
> > +     struct drm_dp_mst_atomic_payload *new_payload, old_payload;
> >       enum mst_progress_status set_flag =3D MST_ALLOCATE_NEW_PAYLOAD;
> >       enum mst_progress_status clr_flag =3D MST_CLEAR_ALLOCATED_PAYLOAD=
;
> >       int ret =3D 0;
> > @@ -365,8 +365,8 @@ bool dm_helpers_dp_mst_send_payload_allocation(
> >               ret =3D drm_dp_add_payload_part2(mst_mgr, mst_state->base=
.state, new_payload);
> >       } else {
> >               dm_helpers_construct_old_payload(stream->link, mst_state-=
>pbn_div,
> > -                                              new_payload, old_payload=
);
> > -             drm_dp_remove_payload_part2(mst_mgr, mst_state, old_paylo=
ad, new_payload);
> > +                                              new_payload, &old_payloa=
d);
> > +             drm_dp_remove_payload_part2(mst_mgr, mst_state, &old_payl=
oad, new_payload);
> >       }
> >
> >       if (ret) {
> >
> > ---
> > base-commit: 8569c31545385195bdb0c021124e68336e91c693
> > change-id: 20230913-fix-wuninitialized-dm_helpers_dp_mst_send_payload_a=
llocation-c37b33aaad18
> >
> > Best regards,
> --
> Hamza
>
