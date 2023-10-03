Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9B83AC3F
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696353630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cPe6lTvqkDh3i4lqKXrA/YhSR1u22OINilkFmxSJKUU=;
	b=OxkpLsYNvPMK1LddKPanVVuWSfRHRvkVcVyhYMu6FWrUYFOc0jcKclUaPMduRQKoYLT0sQ
	Nc6l6N+863IxVzGAB62C8DZ8nrNq2n8YYHQkYzcyf/i4ozmpaASWmL2tN9aWN5V73I76U3
	JpG+/i36XF5abd41zzrfFj7Bj69Y4V0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-WuHGLgRcPvOkH58OGVY39Q-1; Tue, 03 Oct 2023 13:20:23 -0400
X-MC-Unique: WuHGLgRcPvOkH58OGVY39Q-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-352a199dd1eso3627135ab.1
        for <patches@lists.linux.dev>; Tue, 03 Oct 2023 10:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696353622; x=1696958422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ycuqtVjHcrXCLUdvSjDVUvWSxdxF9Ow7PHSrjQNyBrk=;
        b=RJQuTPTx5P/NFP6rJrkBnG3rMqTnkNH3mD7OCjBgvg96em4qoJDm1sstWfzSdVuEsX
         tZm/vJeYqFcTrj9kjIpq4qNOKQaF+zaeyi5Q3ArdOf4svVqwdmznRXc+Kv63VCZ3Dm8D
         7KyJHtXTygSOU7TxhaIBR9BVxFHDqs0lkpUFa44K3/XSNyGfak9bv7LWwbfk7ilHGD+9
         EWghc+0HuohJasl5C0FzSEp9naQ6qwqBWv6o/tXG+yMYNiU4a5UJeIiHh/0toad0Qizb
         8PzjeLGZFcpGej2BQ2QwEwfpkFP3RR9y7neP7vP4+nq/jEV/RGV8t0HHwLIxMgPyrOYT
         9+Nw==
X-Gm-Message-State: AOJu0YyoHOwX9NDmq5tNQtllbK/1dfkl4cVQc2xuIu0+1SEPIco/0Br5
	fsKnGAN+OWZvg6ll+Q8J87oYDV1lNjXkZuIaDJrgZj1xIDXGR06C0RHBekmT54B+rzYlK6LsrKx
	H/0JJZS6FanKwdJgXfA==
X-Received: by 2002:a92:c56e:0:b0:351:50f1:1f98 with SMTP id b14-20020a92c56e000000b0035150f11f98mr79558ilj.32.1696353622427;
        Tue, 03 Oct 2023 10:20:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnynlWHi7INx/zf65C77atiF7MZN2t7nxq6zwo60jAkNHoSX51/McrQhTu1+eBifVYHNmEgQ==
X-Received: by 2002:a92:c56e:0:b0:351:50f1:1f98 with SMTP id b14-20020a92c56e000000b0035150f11f98mr79539ilj.32.1696353622136;
        Tue, 03 Oct 2023 10:20:22 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id z2-20020a92d182000000b0034e1092bccfsm472062ilz.80.2023.10.03.10.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 10:20:21 -0700 (PDT)
Date: Tue, 3 Oct 2023 11:20:19 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
 nipun.gupta@amd.com, nikhil.agarwal@amd.com, ndesaulniers@google.com,
 trix@redhat.com, shubham.rohila@amd.com, kvm@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND
 expression and logical NOT
Message-ID: <20231003112019.4b067e45.alex.williamson@redhat.com>
In-Reply-To: <20231003152739.GB63187@dev-arch.thelio-3990X>
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
	<1fbe8877-aaa5-1b6f-e18c-1d231a31d2e7@linaro.org>
	<20231003152739.GB63187@dev-arch.thelio-3990X>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Oct 2023 08:27:39 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> On Tue, Oct 03, 2023 at 09:40:02AM +0200, Philippe Mathieu-Daud=C3=A9 wro=
te:
> > Hi Nathan,
> >=20
> > On 2/10/23 19:53, Nathan Chancellor wrote: =20
> > > When building with clang, there is a warning (or error with
> > > CONFIG_WERROR=3Dy) due to a bitwise AND and logical NOT in
> > > vfio_cdx_bm_ctrl():
> > >=20
> > >    drivers/vfio/cdx/main.c:77:6: error: logical not is only applied t=
o the left hand side of this bitwise operator [-Werror,-Wlogical-not-parent=
heses]
> > >       77 |         if (!vdev->flags & BME_SUPPORT)
> > >          |             ^            ~
> > >    drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' =
to evaluate the bitwise operator first
> > >       77 |         if (!vdev->flags & BME_SUPPORT)
> > >          |             ^
> > >          |              (                        )
> > >    drivers/vfio/cdx/main.c:77:6: note: add parentheses around left ha=
nd side expression to silence this warning
> > >       77 |         if (!vdev->flags & BME_SUPPORT)
> > >          |             ^
> > >          |             (           )
> > >    1 error generated.
> > >=20
> > > Add the parentheses as suggested in the first note, which is clearly
> > > what was intended here.
> > >=20
> > > Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
> > > Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature supp=
ort") =20
> >=20
> > My current /master points to commit ce36c8b14987 which doesn't include
> > 8a97ab9b8b31, so maybe this can be squashed / reordered in the VFIO tre=
e
> > (where I assume this commit is). That said, the fix is correct, so: =20
>=20
> Yes, this is a -next only issue at the moment and I don't mind this
> change being squashed into the original if Alex rebases his tree (some
> maintainers don't).

Right, where practical we try not to change commit hashes once
something has been included into linux-next, preferring to layer fixes
or even reverts, but occasionally something will come up where it makes
sense to rebase.  This is not such a case :)  Thanks,

Alex

> > Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> =20
>=20
> Thanks a lot for taking a look!
>=20
> Cheers,
> Nathan
>=20
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >   drivers/vfio/cdx/main.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> > > index a437630be354..a63744302b5e 100644
> > > --- a/drivers/vfio/cdx/main.c
> > > +++ b/drivers/vfio/cdx/main.c
> > > @@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *cor=
e_vdev, u32 flags,
> > >   =09struct vfio_device_feature_bus_master ops;
> > >   =09int ret;
> > > -=09if (!vdev->flags & BME_SUPPORT)
> > > +=09if (!(vdev->flags & BME_SUPPORT))
> > >   =09=09return -ENOTTY;
> > >   =09ret =3D vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET=
,
> > >=20
> > > ---
> > > base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
> > > change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278
> > >=20
> > > Best regards, =20
> >  =20
>=20

