Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7730C1DDD1
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 21:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707946345; cv=none; b=LDP8+qqdJ/1fXv8QeeIWb3n3/C+DjfZEkJkTMhmcFGNaajjcvm94l7pC6TpbNlYrvkFP9WlxU8nKMSkUee8eZDUCo+frM524JpydHz4MyMxxmYgHR1QZt3xlzF8XXs7Fq8IB1tEBAVx6PKmyff5J20oKzwjxsLhMIge70CnQslM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707946345; c=relaxed/simple;
	bh=mzDDSMUcdlm0Up4f4mJcp+HyVxmyqjTrTC7RCdD9z7Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cOVny51B9519rcPxxuoIlLYlwe2hTvz1NBej7USTTzv3y0vlYfpm1vZrebl4WYVEq73BkHQzAnmS/5JwY/5Nmq+KUO+lB3bz5vUX4N4yY7PWD2K5tw9bs00xqpYVsnldRiVzIbm8gJpd36aMI1Y9spKnOIcc/qrJgTYhJTzUYTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UwL42+YV; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UwL42+YV"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4120933b710so5465e9.0
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 13:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707946343; x=1708551143; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7jzhXS2LwlH6Na13t2uRB5AnuKFssoLivXgy4Bk1Ws=;
        b=UwL42+YVVhLh5Ai627JEnY6JOT7soNQsgqCipaPdq1iYgmwNRULc0bifvU0b/VRikG
         LTYsfLvZA4GGgoo74HPDkjamdqJV0J04TGKsLdxebr4R8dfBdNbn6QNyJeUIfhnYveNl
         U9qAmjhL1V8L0FV0FpvMLidBLiwCQUhL3klD/NvZP7tDvPVjgnVZlhpPJz6IMdPSvavh
         Rn6FxRETmLNf/rH59qEoDSB6iezEux+k+W8nbu9mvE1ea3JQqa7qDeqx7uzC/u9877Vq
         zNgLfXRtWXcYIl60MwIVvmbhQevNTlw/uRZP37mY7Apxgh8ulWQd0MVtz/9BVPG4O/5l
         E5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707946343; x=1708551143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7jzhXS2LwlH6Na13t2uRB5AnuKFssoLivXgy4Bk1Ws=;
        b=tRKvy+z5XAb5qMyx74hMaaJepyLXJJH92aqS/npI5lLrZ5EKdASPEiQQsx33+n9VWK
         mM0dlImQDTRih0qdG6K9dIknQu+hxDm3zTBk84hlaakHTpKuwY5c9C1D80yBe4sm/hbx
         PK+brcHvkpCMGxajUmrDVwgXuvCVw1qi6QearODRcDyM2yXst/EVD7Xvbl5VPNbdcE6T
         tE/Z12fUtEnXPglvLBfhej2BY/z0zUVW5S3npmfz5TNfRIyYIgz1nDYjUFgjaIQp/9BX
         MCV9LrhO73h2D4UviKK/rPjNEAiAG6w9BXBIgS4hNAlxNe6jTukC1mAOb7FXPNXy8h0o
         So7Q==
X-Forwarded-Encrypted: i=1; AJvYcCW3NPK77bta1rjqVunZlB84ZAyMOHOYsvYY0VXsKRqFY7jnC13lSsqaGk2n+M+0HXgHbuRDSO/g6M2/tW5IfjHS7kVEBauR2Q==
X-Gm-Message-State: AOJu0YxWd0s7+TMo9oJiqGX1b/7O8MOd58L1cb+qJPfYeEfOLncxFDCS
	4ClQXxARghF0+AyXi+sJXgoT9soFFpuyWt6SAjZD7qwic1J2XkvzsLMBONnvv5UPxTS7gmTpfsr
	yPlNK9MtH79b6AFp+l0j7UQS+o4G/w9FIrDH5
X-Google-Smtp-Source: AGHT+IE5ehL53MTjl/C7JyHdLt/tpxzFhvMTW9TYqxUkVLe03JhGEAREu202kUoVCBnpW7EKcv+ZGc8eHAGUZNCg7gE=
X-Received: by 2002:a05:600c:a01a:b0:411:e72d:e5c9 with SMTP id
 jg26-20020a05600ca01a00b00411e72de5c9mr223035wmb.5.1707946342669; Wed, 14 Feb
 2024 13:32:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240207-s390-lld-and-orphan-warn-v1-0-8a665b3346ab@kernel.org>
 <20240207-s390-lld-and-orphan-warn-v1-6-8a665b3346ab@kernel.org>
 <CAFP8O3+L6Jpgktk50UBKg_SodH-DTAW2syZueUqxdZsxrOT3bg@mail.gmail.com> <20240214121755.6438-C-hca@linux.ibm.com>
In-Reply-To: <20240214121755.6438-C-hca@linux.ibm.com>
From: Fangrui Song <maskray@google.com>
Date: Wed, 14 Feb 2024 13:32:09 -0800
Message-ID: <CAFP8O3+uLO9a2n3NuQd9bhzRtpG4GvzoJyMuasGZuCrkBRqq_A@mail.gmail.com>
Subject: Re: [PATCH 06/11] s390/boot: vmlinux.lds.S: Handle '.rela' sections
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, ndesaulniers@google.com, 
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 14, 2024 at 4:18=E2=80=AFAM Heiko Carstens <hca@linux.ibm.com> =
wrote:
>
> On Mon, Feb 12, 2024 at 09:18:34PM -0800, Fangrui Song wrote:
> > >         ASSERT(SIZEOF(.plt) =3D=3D 0, "Unexpected run-time procedure =
linkages detected!")
> > > +       .rela.dyn : {
> > > +               *(.rela.*) *(.rela_*)
> > > +       }
> > > +       ASSERT(SIZEOF(.rela.dyn) =3D=3D 0, "Unexpected run-time reloc=
ations (.rela) detected!")
> ...
> > Commit 5354e84598f264793265cc99b4be2a2295826c86 ("x86/build: Add
> > asserts for unwanted sections")
> > specifies `*(.rela.*) *(.rela_*)` but it's not clear why `.rela_*` is
> > included. We only need .rela.* (see also ld.bfd --verbose)
> >
> > This patch LGTM with this changed.
>
> I'll keep it as it is, just to be consistent with x86.

Sent https://lore.kernel.org/all/20240214212929.3753766-1-maskray@google.co=
m/
("[PATCH] x86/build: Simplify patterns for unwanted section")
to simplify the patterns in x86 vmlinux.lds.S:)


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
