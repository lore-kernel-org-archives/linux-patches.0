Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACF7274FDF
	for <patches@lists.linux.dev>; Sat,  3 Jan 2026 06:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767421600; cv=none; b=PXnC6Z0ACrg8gwVF7kc4qdK/2Lg9qriC9MVBpBeG2++bDV0sHU1f9uQpGBr9XfjQag/T9iANJDnrSgYi7qzIOLMre8Gs37Z9cWIciDlbbAc27NnKXFVJ13tCbWZjkwuew7KHBX0zIzunnx+VbG+vppW//6mvxFMsAfzhtu9sXt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767421600; c=relaxed/simple;
	bh=QD4XyFbtYqO8OoXqrboWLQysmvPoH2D2aMqalSm0Juk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cJNGuftn8y4mUtbKuCAd3uItASUusOn/NCnmszrJ+qLIGg0nhXbK9mKGaSNhMo7cCugHGW9Ikqef9lJl8ThEmSbiv1MEZTg96BRJP/AAQGRSji2ilxaNEkxlvtfvXXoZX4RFoFhIPECTylUo5ffMn/gDRx4MaCA5ZdRlKWmA0vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DaGVlbQG; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DaGVlbQG"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b1e54aefc5so1135618785a.1
        for <patches@lists.linux.dev>; Fri, 02 Jan 2026 22:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767421598; x=1768026398; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GzTUqaBjKErhA8u/T2FQL1WG9Tm1uXsr+21laEF71/k=;
        b=DaGVlbQGUsJ2kZqw4BsGo886B6lBh38oVousz+ZqUrufucofe8bzAUgc5o5lwDkDtn
         V7hHC13+zoTH8OncAvx2MPwt77dk/ufzI3G60T1L3hf53gvIlNqu3HWAGrtP7CxKcBNz
         4cfVAI4sKJYSNC8xDQtjXtLfnP8iEe4NGB7id2+eQn0BamE+PONHOnukPdisdJtoZOvu
         A2rtUQP1kHZPf2FPXPrt3kJ53aMnLUDJ0TxLNmdybTUANu+II1ldnoE4zzKkgOAiJwIK
         1XKsGSoB1OU0f17M9IKvkvnuXLG4pTdLhueNWoRva3bSE0IzzWuSOaTTSkXw1pRB7ODv
         kIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767421598; x=1768026398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GzTUqaBjKErhA8u/T2FQL1WG9Tm1uXsr+21laEF71/k=;
        b=c1uzaXrblD4HcFm2Sbgm7tWowcf55OfhTuw5hSK6WxzyQc0Nb/Spgi+bM5HYOp96cm
         kU/Azh2Duh5lBDKeLT+m/kyRpq98Ra6ktqVc62fJQA650WQvhOAK2kBlrlly1LCvSsY7
         7Jiz1ihq09TJczrRZKvb7jp57mOmlJDRRgPsg7bSrhuk4knuMPFT5mBjAlEaGRXxpeu0
         PTP5QisucWHGuuFaE7/ZP/O0YrhcJqk5plUUc03FatDbtbomUjyyh5hehOW6BH2kqGLH
         0jyB6gZcPyOJTwXcVxTkrdE93JaPpxXw24tRhNxfjxIfF1JihBMD1EiO8a2E6qdNBl+N
         1Ejg==
X-Forwarded-Encrypted: i=1; AJvYcCUkB8he3TBbgOLBnTeyfB1klQL0UbwexMpo0VC7YInzTR8XqoIKJBW2EBtSjyz6rdt0wPlmssXM@lists.linux.dev
X-Gm-Message-State: AOJu0YwIlQC+asmUDsMwhA4vjxEHy9IIazWiKd7I4bya4/tkrML6aFIb
	QfdzGN8N8j6oHAkhxLdCE1WzNuLqDh3iXDgLTvrOA2vUzlH+iky0aQ3qpXPWRYUvgPgZOpX6mGA
	EV3nb/VhLElGhylnSppJd456TYyo6vYk=
X-Gm-Gg: AY/fxX4iabd7/s0FdAM8Tsxw4vLhi7OGDzqS23/2XaxnzRwLfSkWqw+/G1xfZvLNscr
	cmi+23/JUwVpmX1RojRNkqRQ1Vv0g+x3Hq7TSZo9RM8BLtKj//5LI/qaPDEPa2ngfKuMSeQqmRU
	ME1nZN1evJZTgH0unfkRkReD7avYM6XLCgXgsWgNuChkTKG9o/6MmoWipsMZLR0u2n3SB3LVwdP
	QDr64oFlHpa37iSe/tZPfE6WCLt4Cyjhtdmp55RQJyRk4lV3hjb7BLHgmnmlKj+SwT0VBDVC/C4
	lx/gjA==
X-Google-Smtp-Source: AGHT+IFaFIehM2CiM0gmEG+Na4SL0ej+sq5nHRE9bjtces3Vvr/kIlKB517060xRFmaeovwiWR7P9Cdthu4SqyN5SNo=
X-Received: by 2002:ac8:6711:0:b0:4f1:b93d:fb5a with SMTP id
 d75a77b69052e-4f4b43de5dbmr429908471cf.7.1767421597647; Fri, 02 Jan 2026
 22:26:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251229160724.139406961@linuxfoundation.org> <20251229160726.283681845@linuxfoundation.org>
 <CANubcdVnWRkJ8x7zLGKih+uY0D0cE8jGmF_dx7+iDb5sgBWtQg@mail.gmail.com> <2026010240-certify-refined-7c02@gregkh>
In-Reply-To: <2026010240-certify-refined-7c02@gregkh>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 3 Jan 2026 14:26:01 +0800
X-Gm-Features: AQt7F2p8hjCipjPSAJOhW80ofQZTg3x6YsPGRswI1qiJ6xQA2TC8ouImzh3I8jY
Message-ID: <CANubcdW2z9AEdML4sV9XEXFeDUUzbt20istLuZ9s=zUoPvjDLQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 052/430] gfs2: Fix use of bio_chain
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Andreas Gruenbacher <agruenba@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2026=E5=B9=B41=E6=
=9C=882=E6=97=A5=E5=91=A8=E4=BA=94 14:49=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Dec 31, 2025 at 07:54:45PM +0800, Stephen Zhang wrote:
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2025=E5=B9=B41=
2=E6=9C=8830=E6=97=A5=E5=91=A8=E4=BA=8C 00:16=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > 6.18-stable review patch.  If anyone has any objections, please let m=
e know.
> > >
> > > ------------------
> > >
> > > From: Andreas Gruenbacher <agruenba@redhat.com>
> > >
> > > [ Upstream commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941 ]
> > >
> > > In gfs2_chain_bio(), the call to bio_chain() has its arguments swappe=
d.
> > > The result is leaked bios and incorrect synchronization (only the las=
t
> > > bio will actually be waited for).  This code is only used during moun=
t
> > > and filesystem thaw, so the bug normally won't be noticeable.
> > >
> > > Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
> > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  fs/gfs2/lops.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> > > index 9c8c305a75c46..914d03f6c4e82 100644
> > > --- a/fs/gfs2/lops.c
> > > +++ b/fs/gfs2/lops.c
> > > @@ -487,7 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *pre=
v, unsigned int nr_iovecs)
> > >         new =3D bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP=
_NOIO);
> > >         bio_clone_blkg_association(new, prev);
> > >         new->bi_iter.bi_sector =3D bio_end_sector(prev);
> > > -       bio_chain(new, prev);
> > > +       bio_chain(prev, new);
> > >         submit_bio(prev);
> > >         return new;
> > >  }
> > > --
> >
> > Hi Greg,
> >
> > I believe this patch should be excluded from the stable series. Please
> > refer to the discussion in the linked thread, which clarifies the reaso=
ning:
> >
> > https://lore.kernel.org/gfs2/tencent_B55495E8E88EEE66CC2C7A1E6FBC2FC16C=
0A@qq.com/T/#mad18b8492e01daa939c7d958200802c9603b6c73
>
> What exactly is the reasoning?  Why not just take these submitted
> patches when they hit Linus's tree as well?
>

My understanding is that this patch didn't actually fix anything and
instead introduced a new bug by mistake. Since it was merged, a
second patch had to be submitted to revert/correct the original "fix."

Therefore, for the stable series, the appropriate action is to simply
drop this incorrect fix.

Thanks,
Shida

> thanks,
>
> greg k-h
