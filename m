Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD2A33C18A
	for <patches@lists.linux.dev>; Mon,  5 Jan 2026 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767623138; cv=none; b=Ark8/W8Pt3Lp5dewNXBDxsA55gRbkG+y3R4ltqQ72K106p9dWOb4BkR53inQ9D3IyT07jtQLJDPmqxCiFwsjGPuJ9W2cmOVDMYCM5cfUBiRe0dC+mCSpCpLtWneUdXV1w6UtzUeR0P3Tcem2QPSyVIvRLYBeMYACTcvzaia++GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767623138; c=relaxed/simple;
	bh=LcX/87BJpADy0gFkHTct9orjnSeGMIJK9wazMd+rynY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ioahgIlKpmopX7BcAajQrcwYWyGlg3qxBTII/CRifgJTKnaN12YGefGYHXt8Kx0V13uCvVjek0O1QS0vzVgeP8KvaB62gChM+0W6Yfsqnlh87xjqV2nXaGx4mZ7s8pGiRH4LVE3mEvmk4qE74rvoIHpOGZPCysIYBGHqwJp0xKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fYUiW5SN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fYUiW5SN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767623135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OzVxOaWerAMt2ZeWFto1pZrrjffzCV4VdvrI0NSN7iY=;
	b=fYUiW5SNthMS3mahqLUYsj4qKeLtWHQCt2SZ0YfFeZnEeBGlGIh3BVncjjnyxW8XGzF2cE
	Qf2mI7lX5RaQio07b9PE13TJMkZj1pJfZEvOD1KjwCkkC8Or8XrcMvLsLAumkj2nabom/5
	bBQnbl3wjJVdGl1oJPE/mKyC0sagOpw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-zpCP4ZvwPVKYtqsf1lsH-w-1; Mon, 05 Jan 2026 09:25:34 -0500
X-MC-Unique: zpCP4ZvwPVKYtqsf1lsH-w-1
X-Mimecast-MFC-AGG-ID: zpCP4ZvwPVKYtqsf1lsH-w_1767623134
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-78fc789257dso133222407b3.2
        for <patches@lists.linux.dev>; Mon, 05 Jan 2026 06:25:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767623134; x=1768227934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OzVxOaWerAMt2ZeWFto1pZrrjffzCV4VdvrI0NSN7iY=;
        b=hiCBBecBV6FfqrJ95up6ldRmADl0lC7IGK6mxdMy/wml0nexjV7545p1GYmygoA+DI
         mJ5TcTkhsLJeR1SYtcR5kvYQ5sHt711QrE7phrtgJExR31e7U8/0112Ds6jkysnVrI5Y
         m/VZOFgj6K0Ocm5FLZtEEu0vue00OW/+vpsFxU1KrsUrpb4xuPa9S9CQ5gHkR3vh/jjT
         mTsQ0zS5g5M7cTyGq7Vbg274ihw6qiop7PHOjzHXH/ST/1NVkgTvv4qzxsVteuOodL9A
         1xhl0dFf20dJsyZkJfWgkzMgttKpV7u1NizPV4NYcpZF8pZgXxQ786XiRW+f28/NMfnt
         UdYw==
X-Forwarded-Encrypted: i=1; AJvYcCXTky9vXk9X3F/YRI6G32QG86KoyF/pDhbrZht6GYHSX04FLOAnauGv9hysnYnB8UTlcZwxjhDY@lists.linux.dev
X-Gm-Message-State: AOJu0YzjHEaTF1cwlgJQmFFlrlJEyv5TQqmEm61M6+f82VjRY8No09h3
	a5fkJo3buMZcdD42sxL7AmUbGCXGtwrLaXUg7r4qinHlPN02yakP7hrEPWjqBsQEyhUpIjtdqlm
	o+h1eIKBUY0n8RPe6eNXpdUzAVwpx2ncGbVJJW5QU1YWymSnkf0D+GoS5vAEhksBFtEBo7/opEk
	GydnAPLxkKEaOgWVilTKaoFQcAhcP5jR4HGA==
X-Gm-Gg: AY/fxX6h/mei7+hEEzAcPaIoPJLNz7F2TVMEXnp1SmX8tms3wbFlthHzC/bO6nYDJwn
	ay7f+JWuj186j6zxKaS87rLbOBgELlwMPcgbgPL4+yxNj6SPbICVIWArbzJbZsKAs4aqhLMxaAF
	dtwFMUuH9qkO3G8s7fYHnNVJZmbfy9qEAb/OrGMH9CFr+9wgL/S7yEtDlMzcQPikUKxbkvS7NxB
	ahH+ONDzNDwifnkj1plVqpQ+tP1nftzDtmQ190CWQdkizSitk6IoA==
X-Received: by 2002:a05:690c:c83:b0:788:44d:2dca with SMTP id 00721157ae682-78fb4067597mr443587967b3.56.1767623133676;
        Mon, 05 Jan 2026 06:25:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIOVOrNuNjAvkUwjDlLDi75TU0GGLY+aJ4T9zAFjvNRQTkCDhYZhwEw4ZAwSW9cYvjcnM9GcL6E3ZcnakfJjI=
X-Received: by 2002:a05:690c:c83:b0:788:44d:2dca with SMTP id
 00721157ae682-78fb4067597mr443587717b3.56.1767623133283; Mon, 05 Jan 2026
 06:25:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251229160724.139406961@linuxfoundation.org> <20251229160726.283681845@linuxfoundation.org>
 <CANubcdVnWRkJ8x7zLGKih+uY0D0cE8jGmF_dx7+iDb5sgBWtQg@mail.gmail.com>
 <2026010240-certify-refined-7c02@gregkh> <CANubcdW2z9AEdML4sV9XEXFeDUUzbt20istLuZ9s=zUoPvjDLQ@mail.gmail.com>
 <2026010551-recite-vacant-01fd@gregkh>
In-Reply-To: <2026010551-recite-vacant-01fd@gregkh>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 5 Jan 2026 15:25:20 +0100
X-Gm-Features: AQt7F2rLkji_1foozKxSR-ZYEdQ2fVvt6ziR3E69e12e2NHbEwphnUFHIRmkqiQ
Message-ID: <CAHc6FU50YxerxNQEYkRz8a73A-Nv4f-p9cTTCTBDzkw=inr3Yw@mail.gmail.com>
Subject: Re: [PATCH 6.18 052/430] gfs2: Fix use of bio_chain
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Zhang <starzhangzsd@gmail.com>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Sasha Levin <sashal@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bri8IYJwDdERxKl2T6zQ04t63r7cjxkqc1_FoELc-vY_1767623134
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 2:55=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Jan 03, 2026 at 02:26:01PM +0800, Stephen Zhang wrote:
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2026=E5=B9=B41=
=E6=9C=882=E6=97=A5=E5=91=A8=E4=BA=94 14:49=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Wed, Dec 31, 2025 at 07:54:45PM +0800, Stephen Zhang wrote:
> > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2025=E5=B9=
=B412=E6=9C=8830=E6=97=A5=E5=91=A8=E4=BA=8C 00:16=E5=86=99=E9=81=93=EF=BC=
=9A
> > > > >
> > > > > 6.18-stable review patch.  If anyone has any objections, please l=
et me know.
> > > > >
> > > > > ------------------
> > > > >
> > > > > From: Andreas Gruenbacher <agruenba@redhat.com>
> > > > >
> > > > > [ Upstream commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941 ]
> > > > >
> > > > > In gfs2_chain_bio(), the call to bio_chain() has its arguments sw=
apped.
> > > > > The result is leaked bios and incorrect synchronization (only the=
 last
> > > > > bio will actually be waited for).  This code is only used during =
mount
> > > > > and filesystem thaw, so the bug normally won't be noticeable.
> > > > >
> > > > > Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
> > > > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > > >  fs/gfs2/lops.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> > > > > index 9c8c305a75c46..914d03f6c4e82 100644
> > > > > --- a/fs/gfs2/lops.c
> > > > > +++ b/fs/gfs2/lops.c
> > > > > @@ -487,7 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio =
*prev, unsigned int nr_iovecs)
> > > > >         new =3D bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf,=
 GFP_NOIO);
> > > > >         bio_clone_blkg_association(new, prev);
> > > > >         new->bi_iter.bi_sector =3D bio_end_sector(prev);
> > > > > -       bio_chain(new, prev);
> > > > > +       bio_chain(prev, new);
> > > > >         submit_bio(prev);
> > > > >         return new;
> > > > >  }
> > > > > --
> > > >
> > > > Hi Greg,
> > > >
> > > > I believe this patch should be excluded from the stable series. Ple=
ase
> > > > refer to the discussion in the linked thread, which clarifies the r=
easoning:
> > > >
> > > > https://lore.kernel.org/gfs2/tencent_B55495E8E88EEE66CC2C7A1E6FBC2F=
C16C0A@qq.com/T/#mad18b8492e01daa939c7d958200802c9603b6c73
> > >
> > > What exactly is the reasoning?  Why not just take these submitted
> > > patches when they hit Linus's tree as well?
> > >
> >
> > My understanding is that this patch didn't actually fix anything and
> > instead introduced a new bug by mistake. Since it was merged, a
> > second patch had to be submitted to revert/correct the original "fix."
> >
> > Therefore, for the stable series, the appropriate action is to simply
> > drop this incorrect fix.
>
> It's best to take the revert as well, to keep in sync, otherwise scripts
> will keep trying to apply the original.  What is the revert's git id?

At this point, there is no revert, and no additional fixes have been
sent to Linus. The code in question needs fixing and I'm working on a
solution, but the issue is obscure enough that regular users shouldn't
be affected, with or without this partial fix.

Thanks,
Andreas

