Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115E922A80D
	for <patches@lists.linux.dev>; Wed, 31 Dec 2025 11:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767182124; cv=none; b=sHb8n6jShmxNcNyEmPPXG3TR1lvCDBLBnhJaMF4vo5zMiccXa0/0lNaA38256Vq37CI7QCfnwu3yi56cHtsPTz/5Ci8u5fYRjhAAhjTLeWKKOam8rfLGRlBHtKS+iPBu0dBm4ENtQTHvB5Z70c8mnKkEPr6cpob9GD2TtKskcp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767182124; c=relaxed/simple;
	bh=N3R0iLPZCN8oy/x63B5VdEnB5ZvOWFcuCSuFzDxjd5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sQ2ibM7vpGmEMSq7K8Xe7VgeCUTNz7fzeTw6WJ+4uayb7O8l2X7lQnr5HwEqGqjt6rUOd00By/ophUysL9WWWpSqZ/yAgT3cHdzzvl89Tc4/+2XrM89ttad1jP5yQeus09gpxGb9HB1uJ0cqCXQAEaCiPYiSIRmWCBrAgKpIQ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SG/FsyFW; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SG/FsyFW"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4f1b212ba25so94404631cf.2
        for <patches@lists.linux.dev>; Wed, 31 Dec 2025 03:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767182122; x=1767786922; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swz2J2a/Uvz7GnbU1XB2xGVGkNfU6LCVp1sNpOikUcs=;
        b=SG/FsyFWHbML624Rzswe+vDMh98yfmAwevLgK0gmX7kPQgkJn+57vcnvLZlg7MMWrx
         33nyzyUfCwR7awkDd0uamaEsHBiDZpBgCHd14b4eTRAKicM02oFfIhBKAUmdT4YcB+bN
         SggYHswKmNGy5PI8PuN1y9djRO047TmogofCQWfcbAlvOwdFC2dePyec+4KSD/yKhfuh
         lXsHiVNtCkEIUjymAU4RKRtG8vzteuvkgjOJEeey+iVbIjhFLtkJoM4JY8LcnI42s9dw
         igtxTeBLUW6lJHe7VuFspxrwpDBYUcQHyrjqnxBR1pUvjCO7gtNr6QfyfCVkQPiFdGEM
         9h/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767182122; x=1767786922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=swz2J2a/Uvz7GnbU1XB2xGVGkNfU6LCVp1sNpOikUcs=;
        b=KLr+5hVjSvufdfIHNe3DF0gtFk1XSfsd7VkHLpk/7qUWsn+EOUb3DKVCiVoUHN0eeT
         anJUmhj1wYD6l9M5bnpFNc1FphgexKIdb04emYpxwiX6kKxDjOETLsRikugajah1ctei
         aQDE5XeUG0doCN52+sQaghoCaKCuzG1Hh8PTTbS4olm5jevaMhWwdgB+mIRp887cH3Lu
         NZ4IEvl+WnZ3HJ0SiOm5X0yMTxutZ6XwBrMJtn7uejJcXRywhPRevcxOE2WZlGSuI71Y
         RPt9M65ll7j7JQxcJRWWFUOEoitfCk4Q89iT3tbRhwc+8Pc0yad2o7dexvvofsNwfam1
         6p7A==
X-Forwarded-Encrypted: i=1; AJvYcCV7At1u1aJmjyE0YxiTKvbktKvfw31l71PvMHJWHRXpMnByiCtdYlqeEsP40WAm2QoQaBdhQ/LJ@lists.linux.dev
X-Gm-Message-State: AOJu0Yygua7Fz1fRzl2xv7kXcWOe/tLuSyVd8oJ3EnBe8OAVgjHltNoy
	ebi58ZSKt9aaJLfU2szM+UTgXJnBo2lXLz/ODX8qq+xvmQkIfA6ukeuhO5cwh/lpSs8YVUVpX6c
	7NPLLqG+yhuPtzGvQpMpCYeFL2FEuXVA=
X-Gm-Gg: AY/fxX6ogvkATxAmx8OskK6WvJV85B764iCpHPQ85/FfbPj/lptUZ4KBHkEKRN+Hw8T
	24w3NrSCBl5TAaDSBqz+6fo4plqggeUxzJrPACoX35KK6+j28jU2wlORKkoy6p4eVARuHJA6XnM
	2B3y6WKGZZungTX2O80tN0v13t1KJLmE6/vyk6EoM6BDQoilF3jddsDSCRwDYSY4F8a3J8mePSH
	tqozeCF/7oGKxb13xz10x+x9kDUp1SDdEw3mUneHGCLNfQh4twM9wfkcvOvtAORJ+dw9ow=
X-Google-Smtp-Source: AGHT+IFSuOTcv/Uh/apazb+bOJuHLdM9Q6TSJGWkd1oEWKleP+mW23X2bKU7OmiDGmvR/RzBi9zk+nAmClTjQmrHgOY=
X-Received: by 2002:a05:622a:4017:b0:4ec:f697:2c00 with SMTP id
 d75a77b69052e-4f4abd8cb3cmr518033781cf.42.1767182122009; Wed, 31 Dec 2025
 03:55:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251229160724.139406961@linuxfoundation.org> <20251229160726.283681845@linuxfoundation.org>
In-Reply-To: <20251229160726.283681845@linuxfoundation.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Wed, 31 Dec 2025 19:54:45 +0800
X-Gm-Features: AQt7F2q870pijWoytKiNxUv66GsO0vxRiMRdawQxP41fpdIBzi8BjzcfnQb7-Xc
Message-ID: <CANubcdVnWRkJ8x7zLGKih+uY0D0cE8jGmF_dx7+iDb5sgBWtQg@mail.gmail.com>
Subject: Re: [PATCH 6.18 052/430] gfs2: Fix use of bio_chain
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Andreas Gruenbacher <agruenba@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2025=E5=B9=B412=E6=
=9C=8830=E6=97=A5=E5=91=A8=E4=BA=8C 00:16=E5=86=99=E9=81=93=EF=BC=9A
>
> 6.18-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Andreas Gruenbacher <agruenba@redhat.com>
>
> [ Upstream commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941 ]
>
> In gfs2_chain_bio(), the call to bio_chain() has its arguments swapped.
> The result is leaked bios and incorrect synchronization (only the last
> bio will actually be waited for).  This code is only used during mount
> and filesystem thaw, so the bug normally won't be noticeable.
>
> Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/gfs2/lops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> index 9c8c305a75c46..914d03f6c4e82 100644
> --- a/fs/gfs2/lops.c
> +++ b/fs/gfs2/lops.c
> @@ -487,7 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, u=
nsigned int nr_iovecs)
>         new =3D bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOI=
O);
>         bio_clone_blkg_association(new, prev);
>         new->bi_iter.bi_sector =3D bio_end_sector(prev);
> -       bio_chain(new, prev);
> +       bio_chain(prev, new);
>         submit_bio(prev);
>         return new;
>  }
> --

Hi Greg,

I believe this patch should be excluded from the stable series. Please
refer to the discussion in the linked thread, which clarifies the reasoning=
:

https://lore.kernel.org/gfs2/tencent_B55495E8E88EEE66CC2C7A1E6FBC2FC16C0A@q=
q.com/T/#mad18b8492e01daa939c7d958200802c9603b6c73

Thanks,
Shida

> 2.51.0
>
>
>
