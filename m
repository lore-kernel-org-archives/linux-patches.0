Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5A3F4DD6
	for <patches@lists.linux.dev>; Wed, 20 May 2026 18:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300200; cv=pass; b=lto/6YtgFAqJ2x8iKVvJ67bj4JEzKpWE/ILHuDE4wEIlu5D96ba8duJT+cGPHpYxtwoGT3CzeiT/r/G9mBlgtq2xA2aTcTqpJVY/nDsCgb7+gixwwhlATFVCKfs1KiudQm4GRSbg2cWw31Jks4K8AXzUKK5arj8KZKvpWda0Ix0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300200; c=relaxed/simple;
	bh=R4vRu/jv4R4pEMk8oOa5/8LoVk1VuOpHapbhfUE09yQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pX8Qlc0N3a4DUkHkmWhKhZRovXgIl8sngk5TofHzc6YBWIE1BhVQAu4XJsT3Jhu4EnxJcNig/Vei7YL1zs+sc578jWggLpKPj4gW/+zw2W1cUY1Q+1wEJZU1tnPTxqoUcM4wWNF3crLxrFqQ0PiMBVgFwaOLyTAxEbXXgT9jg44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LO2aFwDY; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LO2aFwDY"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d7645adbdso3554289f8f.1
        for <patches@lists.linux.dev>; Wed, 20 May 2026 11:03:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779300198; cv=none;
        d=google.com; s=arc-20240605;
        b=FuNnKfeadWgyJ6Ot69qPaeJeyZZRl8TLT/S2i3WAU99l1Bf0D6/F0wuLv8AIHJdXx6
         Hx2h8xZOA6jI4qkCbqt5fhMsY9M/++SGeJq93EQ9v1QIza2l/clpbJLEOd3j1iVepB9x
         l3KKVowfr/uFlSmjShuiMBRJbXfwTEKJleVzy5D7dbirW/Gdw6PWjDdXL6CgPbEtfAkB
         nKYpeAmAOcRB6znnwCBds7LOGp6OSHx8/p/poIt6Lzkoic2rEGn9LB0SZan73vVoPSV7
         AxNe9v+8m5VlTZT63g1vkN5GMfLiUmaWQy49eYQRSj13RyvYpLuAtBNj9QqRsUzIiTLB
         3hwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nKzvQK6jVRc5SBSzyOa/yyss0dPKvwx3nFjmc+hSUAw=;
        fh=kL7vbw7vCnnw5hOgKJC5coX2M5/fxshJLOANTWHyjS4=;
        b=N69T9pnZ5BPD89mhjFfRYcSPARsuozoasrxcss8AQn7Ub3JhjyGxYnkqy5qk78Is8h
         9dQ0N+95YD9VGAEIB+vayeebO9dTjBYqh7acNFI+LqwuqiDxUBKsKF5ZCFzYDUVCdBBq
         e4guFpxGeuXO5qi5ZrHcCeQtDOxzEGmtCHJJfaxL3bSxXgVTRRCN2LayFCmzd0B1Appl
         ZI7WT1kpek/yOVkvnxMMOfYAqVtE0UVWDDEQZoHMlZ1YEGiRuGnw5MPdl8DZ+SVe827b
         Jr8GniAjwinWYKBL7Ok8zbGpKu0z5GLFLBt71YLCYyHfop+h7AjLD6/YHgSNT4cJ9yvC
         rTJw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779300198; x=1779904998; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKzvQK6jVRc5SBSzyOa/yyss0dPKvwx3nFjmc+hSUAw=;
        b=LO2aFwDYbOqWgKX7PkXlkmxvEwhjdDseLDBkGXVSjE48ePwslzfnqBU1/jKjm4AvJ2
         eXVNq3kND4lqxdf/oD5sqv8G4vYLjNNBjOL0SjLhYeR+e5c8e4obvMReMmmnd9zwQRBT
         t4yLmuBfmkTp7F5pnnajppBP+Gx9iPM3Jd5w6F0WJkkBCuUj8zd94P1CHqLS0pWYWemH
         2VWWzsqD5cOc1rM/cjt47v1gMHOmFvNE4rzoqlAn43JF2hIHz+kw/Z93nouvR1V1Ljm8
         CeCtbwEZRgNpbQ0caxdJ9tU9qTeTx3IO8esvlY7sGv5VJw/5wqpYnyJvHffaqaadgkxj
         tx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779300198; x=1779904998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nKzvQK6jVRc5SBSzyOa/yyss0dPKvwx3nFjmc+hSUAw=;
        b=TLwI85HGmEV/VA8l4jdRMjoRX6EzaxMCL0gbuTOCXfXIjoBDTjfCK+v8TTOT4eXBE7
         3qMv4B6hnxm2Hfq93uvnVBKxQiF+42YZ3I7/4+TUclNpWatjg2XrWLY/tVKtcC0o3jKQ
         aGfotQc5U0sTQBmKyCcVnJiyCz4Zy2BLsACjSWejK+iF3B10/o7/73EL8Uiz1/TtIrWZ
         p09WhQg5d5xi3u5OoT7Ux77lnBT9k4tWCVh+N5cnT9e4YI76ImSGubqmUjHpr1M9Iz/f
         gPk7OqOqpiO4e9ew55UubBq0X2p/UyIy6ykLEKDEgUQg90MXx1WVaCFHjdAZ0uHfkbDl
         eiQw==
X-Forwarded-Encrypted: i=1; AFNElJ+j34n4exDdqcdrT5lE4Myj+LstwB5Fo9/v1pt9Cjkgn+17XKPWHJDSZvyz6rT77GPM6IcYS7+j@lists.linux.dev
X-Gm-Message-State: AOJu0Yy60c5EMRKbX4xTsk3VFgK0pobryGL6CPHWL3KcijcQ3uK+DlqJ
	uKMZ4FP4I72Hy/MfBRmRUfQ0m/ISePmDQEBAXKXDBpyZqnlUy8Lwfyu4pLFewLyYod9BabEtRZt
	IL4DGUcghPbgWl9uK89a0QWk/Zif/QGk=
X-Gm-Gg: Acq92OFrjF4C2i84Et7hs1cJ5K574ruVw2fbkkna6PVGnPTsVxMuqbo3TLYQYRq73PB
	X2ItWM7TrFtp6vupvTYhLXQuZPdjeALgTiGNTVnYkMHVedUgPexmSOwwRdZCLNzf7h5+m+A8akt
	tDaT3TmN9XP+c5acAub8hevVL415X9gGypH4skPqKiBVKd13y5h/kcpT54Ii1q/ciD6OD8Rv2+W
	iJNpfO6/FlxWx2Pert0ysMvR9Gu/dRL4DBVTwBHJ0bZJRl7aX/8PJ5JpslPHMc7tSGM+ILI8t0w
	WSjC6w==
X-Received: by 2002:a5d:49d2:0:b0:45e:739b:3e3b with SMTP id
 ffacd0b85a97d-45e739b3ed0mr21571398f8f.0.1779300197474; Wed, 20 May 2026
 11:03:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162148.390695140@linuxfoundation.org> <20260520162158.293493405@linuxfoundation.org>
In-Reply-To: <20260520162158.293493405@linuxfoundation.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 20 May 2026 11:03:05 -0700
X-Gm-Features: AVHnY4I0oRD4H-nHPpGpN_31rOx9MKDL9wQCkgHb0aXOSidV1k_XTm-LjE_DV8A
Message-ID: <CAJnrk1bWJfT5hswsJ3X5HMZ=XLz5MO3pYXg6WkuYYvZ6ccS0Nw@mail.gmail.com>
Subject: Re: [PATCH 7.0 0446/1146] fuse: fix premature writetrhough request
 for large folio
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Horst Birthelmer <hbirthelmer@ddn.com>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 9:45=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 7.0-stable review patch.  If anyone has any objections, please let me kno=
w.

I don't think this is needed for 7.0-stable or 6.18-stable as the bug
isn't triggerable until large folios are enabled, which fuse doesn't
support yet [1].

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/52674b2d-627f-428a-89f7-36c39caa7=
6fe@linux.alibaba.com/#t

>
> ------------------
>
> From: Jingbo Xu <jefflexu@linux.alibaba.com>
>
> [ Upstream commit 5223e0470e7bb7910038fe3d31171490e00fbbb9 ]
>
> When large folio is enabled and the initial folio offset exceeds
> PAGE_SIZE, e.g. the position resides in the second page of a large
> folio, after the folio copying the offset (in the page) won't be updated
> to 0 even though the expected range is successfully copied until the end
> of the folio.  In this case fuse_fill_write_pages() exits prematurelly
> before the request has reached the max_write/max_pages limit.
>
> Fix this by eliminating page offset entirely and use folio offset
> instead.
>
> Fixes: d60a6015e1a2 ("fuse: support large folios for writethrough writes"=
)
> Reviewed-by: Horst Birthelmer <hbirthelmer@ddn.com>
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/fuse/file.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 676fd9856bfbf..3939f90d1b4d2 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1242,7 +1242,6 @@ static ssize_t fuse_fill_write_pages(struct fuse_io=
_args *ia,
>  {
>         struct fuse_args_pages *ap =3D &ia->ap;
>         struct fuse_conn *fc =3D get_fuse_conn(mapping->host);
> -       unsigned offset =3D pos & (PAGE_SIZE - 1);
>         size_t count =3D 0;
>         unsigned int num;
>         int err =3D 0;
> @@ -1269,7 +1268,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_io=
_args *ia,
>                 if (mapping_writably_mapped(mapping))
>                         flush_dcache_folio(folio);
>
> -               folio_offset =3D ((index - folio->index) << PAGE_SHIFT) +=
 offset;
> +               folio_offset =3D offset_in_folio(folio, pos);
>                 bytes =3D min(folio_size(folio) - folio_offset, num);
>
>                 tmp =3D copy_folio_from_iter_atomic(folio, folio_offset, =
bytes, ii);
> @@ -1299,9 +1298,6 @@ static ssize_t fuse_fill_write_pages(struct fuse_io=
_args *ia,
>                 count +=3D tmp;
>                 pos +=3D tmp;
>                 num -=3D tmp;
> -               offset +=3D tmp;
> -               if (offset =3D=3D folio_size(folio))
> -                       offset =3D 0;
>
>                 /* If we copied full folio, mark it uptodate */
>                 if (tmp =3D=3D folio_size(folio))
> @@ -1313,7 +1309,9 @@ static ssize_t fuse_fill_write_pages(struct fuse_io=
_args *ia,
>                         ia->write.folio_locked =3D true;
>                         break;
>                 }
> -               if (!fc->big_writes || offset !=3D 0)
> +               if (!fc->big_writes)
> +                       break;
> +               if (folio_offset + tmp !=3D folio_size(folio))
>                         break;
>         }
>
> --
> 2.53.0
>
>
>
