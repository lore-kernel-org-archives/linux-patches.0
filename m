Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB6F1C330C
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729530747; cv=none; b=Oop2qoR/bJyHoFd9VqPMQ+LtEmcJl4JpoWl8OPFUDkvIWvk2wYfOpm7ZPziqW6vchuY0Okw5gK8BI7hozn1TAMtoV5O4p6LgcHSE02hP995S6mRC5ySHu7ZzeOTDhL/kkAEdbA5EKf6OEkkX54ZGMBo0Pb/wYWPqo4VK6o/mS5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729530747; c=relaxed/simple;
	bh=SCTFdrbfUBXrIcqhRwUXd+X5Tdul2fIzg9oC8CWTHCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KQe6jUGadP8O/5vLsT+JZz582T+05EQOVaiM1qGwVPvMLWx9qCRljmChcBmueekq6PPhTQG0XGacr3I7LcI2frXv0vUgrq7VIo3tH5fKPHQANSnpO5AFP4+4ygWAWkOtp3aISE/VZpVDTyvAnlFADjfclX5f61thww4aE+niW+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eMchxw35; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eMchxw35"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4608dddaa35so18661cf.0
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 10:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729530744; x=1730135544; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gwNJFQj9wVXQQyM3LpHrEo68BHNeskwH6JzAGyjqzms=;
        b=eMchxw35he1vWfBfk5+8NA7jkNPIOgBuEq1kAiumzVeL+SbIohD0WaSTS9zAgcJM2y
         oRAfaDtLGjA0PaqJCdVaRG3UNvc0Mxa+KZKFZe4/Jru6xtgIXyubslwqawywfdhb+gTa
         oyxPDULAz48XKt4aRXDfqC0LmH9T5Uobv6jq413I8MJWr/nCdAquuqP+joDQ6vIM5MBr
         iIkmKMnHbQYqJzhrdj1dxUm9qtcFGwag7eP24nCQnUG1Y8Y2mIIdSmp+/bqPxSSOJyxZ
         LlGgxx5TWPi+YAx6LePgv3GsX5wBYx8J0T0dTjmuzncoJJo/dmq9Iqr2SzoWmAJeEGkx
         469A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729530744; x=1730135544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gwNJFQj9wVXQQyM3LpHrEo68BHNeskwH6JzAGyjqzms=;
        b=lFI/n0qrDP/jky0Evm1I2WWGzDx+CSSvNqr//W7hXRXdciJCosppdzxTcKJYck0ymI
         ccm0wCD4h5a0I371hF2PTuSqM39FqykNoRCTuyOrBaoVTwPfazAg8CgIxyey+QqqwVD8
         fe8CaeIOG9jDGyTFCIQ/MeNv4xQzFxQrXZFo0evSFr3wKywwmgUDOOoRnoJzx/5V9KxQ
         9wed7wiaQ3CRuw5NpQajm8GgE2/8x3CnbK5kKGbOXyeGdpM9S7OSC90xV6JXI/EtQxox
         dBy+IvSibt4fjrnM63bJCTCnIF+sRh+vlg86DrZSxJaHbg9VekGx6B6MNJe6ytN0XN6w
         uf0g==
X-Forwarded-Encrypted: i=1; AJvYcCXBypICykq5LKLCykgYxA3X7nprZC8rSuZ7SyKvVieBZcH1QysiB4h5IQVBoLsj38IXI8uHW14/@lists.linux.dev
X-Gm-Message-State: AOJu0YzmH5HoJSRPhynleTc+81zMBxcWZ+Xw0OMrJR0yBTAzgUdgVN64
	IV3qBtSPArLoKeXsl4Fpw9+tSnO0d5CvMcsS09nqmaEfy8WWRzFVN3tZOwa8gE9AtM8ekrWHgNK
	RvoS7ePJv0yV0cNfBeJRyr3aSJCv/ENayTYJ/
X-Google-Smtp-Source: AGHT+IEX1w5oqvDfujpUByKRchWeThxcAKNpbwDI3AtAJ2PzyzefCjV0Et+8rfWN9SPjgyE6zHw/nVLVcU2oYC5446c=
X-Received: by 2002:a05:622a:5b97:b0:460:371b:bfd9 with SMTP id
 d75a77b69052e-460be4194femr5020471cf.5.1729530744180; Mon, 21 Oct 2024
 10:12:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021102259.324175287@linuxfoundation.org> <20241021102300.282974151@linuxfoundation.org>
 <a4163f51-cc1a-0848-d0fd-e9b94dafc306@candelatech.com> <ZxZ_uX0e1iEKZMk5@pc636>
 <2024102130-tweet-wheat-0e55@gregkh> <fb0cd50e-5525-4521-aa1d-f919ae19f77d@suse.cz>
 <CAJuCfpFU1tLc_wvAGu1T3WximLFRARVxBtJTm0bOfgqt_MnYyA@mail.gmail.com>
In-Reply-To: <CAJuCfpFU1tLc_wvAGu1T3WximLFRARVxBtJTm0bOfgqt_MnYyA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 21 Oct 2024 10:12:13 -0700
Message-ID: <CAJuCfpFzgYvCTOWNDq55tG+xPVdJ5Rc2DjH6Ltzrc7--U4Kv5Q@mail.gmail.com>
Subject: Re: [PATCH 6.11 024/135] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Ben Greear <greearb@candelatech.com>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Florian Westphal <fw@strlen.de>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 10:06=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Mon, Oct 21, 2024 at 10:04=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz>=
 wrote:
> >
> > On 10/21/24 18:57, Greg Kroah-Hartman wrote:
> > > On Mon, Oct 21, 2024 at 06:22:17PM +0200, Uladzislau Rezki wrote:
> > >> On Mon, Oct 21, 2024 at 09:16:43AM -0700, Ben Greear wrote:
> > >> > On 10/21/24 03:23, Greg Kroah-Hartman wrote:
> > >> > > 6.11-stable review patch.  If anyone has any objections, please =
let me know.
> > >> >
> > >> > This won't compile in my 6.11 tree (as of last week), I think it n=
eeds more
> > >> > upstream patches and/or a different work-around.
> > >> >
> > >> > Possibly that has already been backported into 6.11 stable and I j=
ust haven't
> > >> > seen it yet.
> > >> >
> > >> Right. The kvfree_rcu_barrier() will appear starting from 6.12 kerne=
l.
> > >
> > > Ick, how is it building on all of my tests?  What config option am I
> > > missing?
> >
> > Most likely CONFIG_MEM_ALLOC_PROFILING
> > Depends on: PROC_FS [=3Dy] && !DEBUG_FORCE_WEAK_PER_CPU [=3Dn]
>
> Yes, it's disabled by default.

6.11 backports including prerequisite patch are posted at
https://lore.kernel.org/all/20241021171003.2907935-1-surenb@google.com/

>
> >
