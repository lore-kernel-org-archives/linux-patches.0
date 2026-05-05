Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACFD48B398
	for <patches@lists.linux.dev>; Tue,  5 May 2026 16:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777997149; cv=pass; b=E0j4nl1d70P8GJKVEAi92kLfF6xji12m03ogQdw7jU6SJ4otjVl5k/4DAdIgVibvS8eg/g8orHxu1OjwjM4i8w9/EAqTmOTwUof0Yk8OXFpKBc9SoT+/MyNTZXN7riVpqGV3+hZcLKyAD+cE2XKRGv7JDXPkWsRGaqrSOotXy7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777997149; c=relaxed/simple;
	bh=J6ANT64o73Oy/MqjWeiTVaKBLJandxdhBxQ3kDb+K3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EI6Z5ntDCQOThUI9fRMfxPRTCGgsMCojJsBrAtHI0ZOQnwl7MV10bDYoqhTxyrL/ykyETzmO1WXxhuHSlniiBtnOFGCHdzqDUY+2BbxE362bKxD9cHvh+mYL+bSl+H1M3Fu8ZMm5iqibau9MZWlWrIul3FuEUFSGJM16JREh0GI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IilXMfbO; arc=pass smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IilXMfbO"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-130c653cce4so1537449c88.1
        for <patches@lists.linux.dev>; Tue, 05 May 2026 09:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777997147; cv=none;
        d=google.com; s=arc-20240605;
        b=RHwWzJ/AjjpP4x/zPixGcFCtWpl4V6waVyU1Aig69oejmPDt6WtgBCR+SwoCceRGSx
         WtxRKyRps7DhsTATh7TOgioXlUndefGJHXg4pG0yDiuFXwb4t1l0xafUGqImvsKFbhQ/
         AR0Rwe/4UvJCsL9Oy7e09J7NdQ9W6C0jY2+BUQ+4L0UG5roYqa3yNVz9DNgvesW0e4w5
         h5M0Ndlb6womwLlw77af4bFrxwkGyNaTrNkQ/BqX4ZzagLHR0UuKuoMvs4yvkR7RQo+S
         DzvBIjP7RIkn0VmcUyIwBWckGhcJqZ+mOHwzJWcBg2vc2FIe7VG6/zIjitmvKSxSgB4n
         OF+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jr+WQFKJTcHJZ0sRMLiTHOm1qsMvrLUcWME2L+LwpFY=;
        fh=Xv8I02YHEFOMMSjOmI6SdYEOEqqGWseNnpxY0FBsxJU=;
        b=dSjT8tQ49ifzie4grdI4pVDHDFC/swEr2ZW4OM3koxXafu/ntGd9Dml0XzHHMCdmf8
         z/qmm5OGmD1DlbDOsPbOwE/RDzjBtXPnPCBpoI3g5R6jwitRZHpMZ2ywL/VpXwpIvW92
         iYZxqGxwE0fkHVIizNtm7e8ecOtJemykeK3biWUOKUiMdg7b/VQSNtfgScHdWs4+iNXY
         nNHrc6Qq4SUo3UFU686A/1cHzlws+cTqEBFUB0YalUQS2wWWzReszqGkyp9YBfnJzObb
         nZj8vbaMtPenvN8ZCf6/zZK97VwRwIGqQRaNFJnkiE8E7NlGJ8hqSN6e8cqFhYYKkFku
         IZRA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777997147; x=1778601947; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jr+WQFKJTcHJZ0sRMLiTHOm1qsMvrLUcWME2L+LwpFY=;
        b=IilXMfbO+0oenYRa7esG2Ba/jPR1whord+iQ7rv4r+D9X0NR6SbJAfoba26LbElk5E
         OiO6PyWMgpAaQ16k0H7+9qSNrXIPezeejNT2guHELg22UnxykSyETxjVyMkc2e/qw8ws
         cvq1NOKLwRwwJ628PgiLwpYrGt2IS1s0jFiNRmURxTv6p+yJm8TdLGu9Dugynf7AmkmZ
         svKf8YqJ0tPtPRA0A0x4QtXZiWRo5h1gpgaGy+SBS65AVtjaGP6CSFwhxGJv9bj96KNH
         2awfEZSBZCY7PxGL8QIxJo+qCanCHHrsZwrKs09E35o+kCPLwM1c7nDOr8kdfuDN2Gig
         PMAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777997147; x=1778601947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jr+WQFKJTcHJZ0sRMLiTHOm1qsMvrLUcWME2L+LwpFY=;
        b=PaOyT6ebehbtuY2qGXu3D1acHq2F0VNUYFJm6+q36yE/VrijA+YwG0fpBxD1OjNDgy
         4v6s6pBBUiTszG1Z8UMUClN3/lh1zlUfoF8Z1HmVKDkWaYsrQr3y1zpysvd1/P+p/fMF
         KoCWyceuQhp6/dUUR7dhRA05G7U14mYBleQrNDSzXQysDUqQJjai2V1aky2zF/2V82f0
         2N6A1uj2JF8PPEmP7lN2NSd2B1qPCCCFgfT0wv5kKEcV/zsucexcDaCaRaDW7GDBwoGP
         KGOyZqmHeUU/YP3No5v/ZikMifO8gb3XKojExI8Wmtn8fvpUEY5qE1UGhg0or8cWKB72
         bsZA==
X-Forwarded-Encrypted: i=1; AFNElJ96yKGtDyWMrL8ZtM/MEcfBI2qi5uEeZ89ch/iWAhkFtFhkEpuYmkMz/ZS5ipCK9UE4mf0/f1C9@lists.linux.dev
X-Gm-Message-State: AOJu0YzjrZGjBnO8Y83XclVb0bgj+vfG7VhRD1mQrl+9PQ7aI3Ml+DyP
	L/BG5QUpAlHvBhM14YsSVyPwSNYtTXUF4KjHD/5bcOKkKfZAbKS3gFDzLlfW4u5cwmV6ij0Y5xX
	S0Qg0ZCt2N5npxqxfR+2ouZWyM/hzcjJYqHud5KOR
X-Gm-Gg: AeBDiev3Z8B+OVkZ9e7NtSn/hnKXIUOz4vtnFptuRSzjRWSolOq/Fvar3zfMrk5ZfEI
	0IieCQam6THPn7NE5x/+OGe8BUpSnHqm8wruCzhrPbxU1DQUwAvIYR0/pOMaQjeH/bSVpY8ecbw
	agui5a6NYid9a6dyaqhkXcOvXOow9PEeGkyJQAG8yQxjgImhGuwuR74IrF9yOFvbNNh0nIKiKqK
	Gutts82AmLTvUvV1ulInT0F+KlKApLhpSoVBicknmDsa4lI1sWj8DETksb51ozFjg2x8lHHMHQy
	rfwMxE1QmQx7zSIm4Vt1LGg5wQdfCmV5fSP4+9Ur
X-Received: by 2002:a05:7022:6628:b0:12d:b214:7dbc with SMTP id
 a92af1059eb24-12dfd7da15bmr7713863c88.7.1777997146733; Tue, 05 May 2026
 09:05:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com> <7-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
 <afkH3pMJKkIbElhI@google.com> <afoSQWreOWDIfVxZ@nvidia.com>
In-Reply-To: <afoSQWreOWDIfVxZ@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 5 May 2026 09:05:19 -0700
X-Gm-Features: AVHnY4I9kiI4Q1jkqtdnHvyGsFiT-Xosh4J8OR2OjxYfYINDrozPSiggYWTK0ps
Message-ID: <CALzav=c2r5cBSpgnG6-Njc3sGrrtt-weFXo1pRUL862SdK7w=A@mail.gmail.com>
Subject: Re: [PATCH 07/11] vfio: selftests: Allow drivers to specify required
 region size
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 5, 2026 at 8:52=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Mon, May 04, 2026 at 08:55:58PM +0000, David Matlack wrote:
> > On 2026-04-30 09:08 PM, Jason Gunthorpe wrote:
> > > Add a region_size field to struct vfio_pci_driver_ops so drivers can
> > > declare how much DMA-mapped region they need. The mlx5 driver will
> > > need ~18MB for firmware pages. Existing drivers leave region_size as
> > > 0 and get the current default of SZ_2M.
> >
> > I would like to get rid of the magic SZ_2M to make it easier for other
> > tests to use the driver framework. Can you make this commit update all
> > the drivers to set region_size? They can all use the same approach:
> >
> >   struct vfio_pci_driver_ops foo_driver =3D {
> >           ...
> >           .region_size =3D roundup_pow_of_two(sizeof(struct foo)),
> >           ...
> >   };
>
> Sure, lets put the roundup in the core code?

Sounds good.
