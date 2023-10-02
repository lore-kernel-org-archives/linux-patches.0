Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6E71E536
	for <patches@lists.linux.dev>; Mon,  2 Oct 2023 17:58:13 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4054f790190so406295e9.2
        for <patches@lists.linux.dev>; Mon, 02 Oct 2023 10:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696269492; x=1696874292; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VsBpR+o2VwUZxmif29P7D+FDUn0WQ42c0teYZCGcpHk=;
        b=2hMMos8vpSVyVFB+yKXKuMRLAtToBAXS9XoivEoim2Ud432miYpMAFwtx13ZIOeZu2
         P0qxv07j5zq3/xiqon2VMOKta0RCG4eF7S+5Ne5MFAyG4bZRFBfG1/uPxP4O18QLEMim
         KKetRy3C4dAEm+z2wbtt3OMBPkF+ChJ10iE8jqhs915R+fJlTer/P5eokzRn4r10NUpu
         Gl7nMMkMmUynEuF+ks5d44sHyAQE+00/B21TrBHoEZav2PaHxBBOkZGIeTc2BK3hxHPP
         4D59quJoIUBofmDJIu+IN78WPYd6mwHKRwRyQPBlSxSBcCCFyZ+qbccPs0ukO1CkIUkf
         nuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696269492; x=1696874292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsBpR+o2VwUZxmif29P7D+FDUn0WQ42c0teYZCGcpHk=;
        b=vMoXf1IEdfFZr5zylOv58WxzIld0IhA0JkHgzy1LbysJlKncrEzC9AC6FV9NFA9Lnr
         nKhX2TtlwrQjq/sMeuKR1VoS48lFQxcIntrfErADKPo/Z/YX1CrWphoyiuW2h7cw3QR8
         DausNukn/yD9Zx3mMgjLFLG6o90YTk1983DBKNLkarAn4207VNp9MCcRYGFCAABHf/vc
         iQW51ijjEEf046FJ1wAyqvSpKlRNt/CzE4qq3yexhdT/vKfQnnge8qciO9QtTTa2k4EZ
         EAgXPXYPwQ9aJV4lo7cikk2uy2v8UF7dsCBZ53uRQBWK6FENJbhOjLCBzTCNTSHTXf3u
         ejCA==
X-Gm-Message-State: AOJu0YwMVNZy+ZfvVFzZGNKAon3t5FhHDT+2sODXlMLKSR69Qxl65im0
	mFqHXWA4SJj0mamgX9SUpKg7FHdERB4XpeHMN7VFpw==
X-Google-Smtp-Source: AGHT+IEIl2jwbvsKAVgfWByX2B6a1DMXQKna6Ty6GhZkAl/pYppvt1et6/EXVwdZiiblx9aKr8y9mVuVofDpXf6T/0Q=
X-Received: by 2002:a5d:500b:0:b0:321:5d87:5f7c with SMTP id
 e11-20020a5d500b000000b003215d875f7cmr10813550wrt.30.1696269491834; Mon, 02
 Oct 2023 10:58:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
In-Reply-To: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 2 Oct 2023 10:57:57 -0700
Message-ID: <CAKwvOd=dK-OmLPOA3b0Bv-csNjSkGjnXybwT08BuXC72Wf35mA@mail.gmail.com>
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
To: Nathan Chancellor <nathan@kernel.org>
Cc: nipun.gupta@amd.com, nikhil.agarwal@amd.com, alex.williamson@redhat.com, 
	trix@redhat.com, shubham.rohila@amd.com, kvm@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 2, 2023 at 10:53=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> When building with clang, there is a warning (or error with
> CONFIG_WERROR=3Dy) due to a bitwise AND and logical NOT in
> vfio_cdx_bm_ctrl():
>
>   drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the=
 left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses=
]
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^            ~
>   drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to ev=
aluate the bitwise operator first
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^
>         |              (                        )
>   drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand si=
de expression to silence this warning
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^
>         |             (           )
>   1 error generated.
>
> Add the parentheses as suggested in the first note, which is clearly
> what was intended here.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
> Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support"=
)
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/vfio/cdx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> index a437630be354..a63744302b5e 100644
> --- a/drivers/vfio/cdx/main.c
> +++ b/drivers/vfio/cdx/main.c
> @@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *core_vd=
ev, u32 flags,
>         struct vfio_device_feature_bus_master ops;
>         int ret;
>
> -       if (!vdev->flags & BME_SUPPORT)
> +       if (!(vdev->flags & BME_SUPPORT))
>                 return -ENOTTY;
>
>         ret =3D vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
>
> ---
> base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
> change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>


--=20
Thanks,
~Nick Desaulniers
