Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178BB3054F7
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 08:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761121074; cv=none; b=oEB6IFMn19nxWseo7ldfXEVnc6qDY45fDDG0NrstRkmWM9Urzqo0J6hkoZqqi2JQvCDDwh/06GjwYGvqQUu19s38VVDc1nn2PU31FkTi3YkL8NvkzLtGSy6bYSa/MVTrzUb7fRb9x5I/hWh5Ek9uScOc5AwCLocDwSvLQxKoxmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761121074; c=relaxed/simple;
	bh=ti7G/84E0YzBXTvtASt3fHYjXTFmenpC52OVjFot3ZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hWeQEsrtscpVmdImJHZ/CHgJ5jtMgmidcFJcFNbDSbOT7D6pXE1Cylctd63wgk5K+ZcfDdlp/l7NAKSL548T9rMWEmYWDZYa1snH9In1wY0PXsCPddj2gTaimqjy5vZpcr0Eevdtz9BoCSVIfnOp28egEO9rPh7c7pE99ssbr+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=IWQvMPk6; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="IWQvMPk6"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61a54560c1fso1339107a12.0
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 01:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1761121068; x=1761725868; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4AnPmF7GikSpuBYeb5D1xWnDEMKbEHnX3EodtVzhcqs=;
        b=IWQvMPk6C+caNiNItxMs5Y8Am234ZXX9GjmLVIns4RXtNmZ2NDwiU1tSNH33JFxQvh
         Xp9QGv/5t7Sn2aZSNzsisBovr95P+HJbgZj8pC+0azBZVgvJzfNH0OJ9uzcJQ2WiQ06s
         vzQRHNOVzpWoOKZTZOesB2KEAmP7HQfBRvkKcVdLEdAF+YUY0FYE4P9TmhBc5gsEfuik
         yakCs4t3jVMaYQCqq1NW3LiE3P2qggrMRylP0OufQhpbVDd8rSslw41EKhrZpE9+Z0yp
         wQpan8o2coVfq3nXbSlthpec5hCpnEK9UBoOUzy2O3H6S209SwiHxSJ+rXx2djxGdZ97
         8D6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761121068; x=1761725868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4AnPmF7GikSpuBYeb5D1xWnDEMKbEHnX3EodtVzhcqs=;
        b=lEz+gWTE9KpyZCFNxvLEd/ZEDchUJGCQVNl7YegO3UkwWCp/bkiQer+NMzmLH5fMrz
         M1JQUyQzdU6Sobyz7Yl2UJ0mzOelnCO2ycorbjtCA13wYzEP1yG1J3tg0VypPzMfwZZR
         ijZenIGILybZqvfnJzbDhNVLnr3l0ZO6gLkNreXKhwtBEi0k+2SeQ6qI9GoQQxDx1SzD
         kyGQR+fDXHe+n0ZnP7Sf5/t0Smc89EbtKMouw8dAG8v3v9pnJ5r7A2j88sijjY/w61Rp
         OZL9uGin1W6EGFGkEsMXL9w6LyV7Rjn51IBRC90J6H7o9G2nXKmuXR+mYs6bn8NS02v6
         LheQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtdUbgOtxTzJ3i7Di3P7LXG2+s8SEzsrGpAmNg0GQDRxTy9lsLzBlQEq4/KNL24xa0n8+4d134@lists.linux.dev
X-Gm-Message-State: AOJu0YwhYcTZ2MSNeaz9fU/NEE5V5A1nC4RVau9GOZuKLd9HJtCLDi3i
	0pPOHOAfqHq8reqObHZC2g2sfaOdFJ0RaYFRHd7UbakZfEe0x+DDT3llRumLhATIcMGK96cEytc
	FBRReDzvHg5VySKiah8whufqDVgeo+15DyAwKMUUdww==
X-Gm-Gg: ASbGnctK4LT5SC+iuzGG8YxElNsRaDrje5Xdd27j2uHRXqoHAJwAWp5RBcYUu8ihzMY
	lX1RaHy5ZeMWQ1DEpnvpH8wSn4QPmfKUcIw10jy+sm1oSHHKIXGEiLHjmVkKzuqJyOG0JgGNVVn
	gdDbSNaB2Bd00lignuqt/ND3XZPuG7MzCKUBJIWbI48S1K+qiDp3UR4BmLgcWPBHbtl2wIm5Yxl
	1dhXZI78D+9vAYMxocQbpk0gs1m83UPul/XefeIyZ+JbC6SAUCMvv2MtpCm8krdtubwL5k0vo99
	sMcMVZJnj0/KtZLSdakIL+Jb3yot
X-Google-Smtp-Source: AGHT+IELYwuQuJq02S8YTBuoFu4VR+wgRs0gisHIbN1jW8etU1gm3iQvaw9IgNxYvPNwMTgRRsiqOxaHnS4XTtzawKE=
X-Received: by 2002:a05:6402:254c:b0:63b:f26d:2eab with SMTP id
 4fb4d7f45d1cf-63d16aece4emr3714487a12.2.1761121067970; Wed, 22 Oct 2025
 01:17:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251021195035.953989698@linuxfoundation.org> <20251021195038.635577649@linuxfoundation.org>
 <2025102240-zesty-unveiling-4f99@gregkh>
In-Reply-To: <2025102240-zesty-unveiling-4f99@gregkh>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 22 Oct 2025 10:17:36 +0200
X-Gm-Features: AS18NWDyzS1lKVizdJ-gUUOkZIsvOsfTH9zxZQijuuIDX1kTKUO4DW_6RhEvqk8
Message-ID: <CAMGffEnD5QePj+5sooX8RyZshO0fngLBv6xaBEWG6o4veJPxkg@mail.gmail.com>
Subject: Re: [PATCH 6.12 111/136] md/raid0: Handle bio_split() errors
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, axboe@kernel.dk, hare@suse.de, 
	john.g.garry@oracle.com, patches@lists.linux.dev, sashal@kernel.org, 
	yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 10:07=E2=80=AFAM Greg KH <gregkh@linuxfoundation.or=
g> wrote:
>
> On Wed, Oct 22, 2025 at 09:53:07AM +0200, Jack Wang wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > 6.12-stable review patch.  If anyone has any objections, please let me =
know.
> >
> > ------------------
> >
> > From: John Garry <john.g.garry@oracle.com>
> >
> > [ Upstream commit 74538fdac3e85aae55eb4ed786478ed2384cb85d ]
> >
> > Add proper bio_split() error handling. For any error, set bi_status, en=
d
> > the bio, and return.
> >
> > Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > Link: https://lore.kernel.org/r/20241111112150.3756529-5-john.g.garry@o=
racle.com
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Stable-dep-of: 22f166218f73 ("md: fix mssing blktrace bio split events"=
)
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -464,6 +464,12 @@ static void raid0_handle_discard(struct
> >               struct bio *split =3D bio_split(bio,
> >                       zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO=
,
> >                       &mddev->bio_set);
> > +
> > +             if (IS_ERR(split)) {
> > +                     bio->bi_status =3D errno_to_blk_status(PTR_ERR(sp=
lit));
> > +                     bio_endio(bio);
> > +                     return;
> > +             }
> >
> > The version of bio_split return NULL or valid pointer, so we need adapt=
 the
> > check to if (IS_ERR_OR_NULL(split)) for all the 3 commits about Handle
> > bio_split() errors for md/raidx.
> >
>
> Sorry, I do not understand the request here, is this not ok as-is?
godd question, if keep as-is, it doesn't improve anything, the check
doesn't catch the error condition, only add extra code.
it doesn't make the situation worse.
