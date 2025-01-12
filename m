Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A473D1CD1F1
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736701820; cv=none; b=ALFVx3Lv3CeQtR9A5dLTjh56JQeBZY/dirt1dGOADqLKsUQlo+QJusVPXBMtldfchg0YPeVgUneC6PTVrkI6q7Q1EG82Nh8IShYT8roIzaVovr/IbJNtR9jeYdsIY3ldHyyxQeBOjgkfy4gGS/68j0CEk36jQE56z/LP2DTjhg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736701820; c=relaxed/simple;
	bh=gJ+RuvagMf8tl1xcnIOZN+Mj3mQMfvDjzmgmDAhHNVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pyhbwvbvbTRL+BTDoi1BZITUInMR3E7ogwU5kRwYmwvGPDAaz96X4h66qYuq4Wb48QRwZkBkdpv3pEhB9N+jqBoyFLOb92mPx5MAnaFthqZfNQYNdgLSakKkzsqw+u8Tz1VbsE5G6LdpheIOqYfF2+fnGReapj3SUk7v+spRJIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=clizyaI5; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="clizyaI5"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ee534d6800so833899a91.2
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 09:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736701816; x=1737306616; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJ+RuvagMf8tl1xcnIOZN+Mj3mQMfvDjzmgmDAhHNVY=;
        b=clizyaI5EKQGlogq6x0XEbFZ3rGFG27Nyos86jzowv1Ar4rd78GCKSc/7uk9aIesFl
         T+QwJbHBkNzbqo7o3K1QAMMByBCKsir4Gsfqno8gULPUlvHw8rvm40VYytCR2VSHZ8hJ
         uOgKotseuaYYyXk6ieWSPcEFbC6PFLRHesKUaBFPsyQgfwKlMZtTIp1A7Yw4MJ6fnYeW
         ok60+zKUDEfIDaEOK99ZnRnq5j8tWAD62+e/jSMz60QW9YfOHQ35SumRTuuUemqhFPrr
         4AkCZhgkfhUbEY//AuPrtgi4SM+/a9wMHylKnjnoXwdTF9k7LmQafDBkcMmSeMH2pvJS
         yZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736701816; x=1737306616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJ+RuvagMf8tl1xcnIOZN+Mj3mQMfvDjzmgmDAhHNVY=;
        b=HZNgiRFhK8VhiD+Wo7vQ8DSHsD+gkqMqG0KIW6Nx1NPiZSrbdLSyNE/wVQoxHGGldq
         oAgknsjmVqwJtp3DGLk6e6eTkfZ6xVXzd6k/fPbDvvJEX+0/wouIlbirNlBOc4E1+EFl
         m5Nzj/PCsKpBbW7L9t7UC9Qfcg01mwR3R3AtLFxXMpegN3dhCB3YdPDkIbMYUPcqNnCd
         qSYhJPfh2JOw1y6brKqd3OqrpzqBlrIyJeVDxuuBdBucfzDvmit0MA739lgQXorrr9Ag
         DEQc87bX0lk3m1RaaDZB1TiX48WVAUPfB5DRj737695AkjZF/jcrZ4hw+Ue1HkHl3bEd
         tesg==
X-Forwarded-Encrypted: i=1; AJvYcCULcwjiNdNunDSEYMF8YtssSSzg0OjBmUP9RiuOnHdhTGOeBH5OWqd3kaTw0viHA0ilZeI74VCY@lists.linux.dev
X-Gm-Message-State: AOJu0YyCih83RD+pKnwyAl9qw7tKFNSyLRjO4zDNBCQGPx6Rbqs+bER5
	RdFmqlvsu+rFy7GZRCxPrZm78bvLaJlTOoZpuNo3AcqIgK996XGVEoHWqCVgIOhIthtisaJUVn4
	ZaoIvSZxDdtPzKjoGsydFYhWvuJk=
X-Gm-Gg: ASbGncsOJ6mPlH6ZnEgNIQBlFxkxya0sb4JsCwqm/b49lA93DUoy8G0n/69Rf3t1CDF
	ccBhPlkNSAVpMNnZD4+JX6tqNJfsbY6qS2d+zAQ==
X-Google-Smtp-Source: AGHT+IHxoxUQSPlBOqQ0zh5ZIpFG+rt0AMgT3xRUQJwHEFqbYPbyKn6L/j9REv91zMAhFmPNH1dQSh8ewB3F2mgpwRw=
X-Received: by 2002:a17:90b:538f:b0:2ea:5e0c:2851 with SMTP id
 98e67ed59e1d1-2f548e3c0c8mr10050369a91.0.1736701815909; Sun, 12 Jan 2025
 09:10:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112152946.761150-1-ojeda@kernel.org> <20250112152946.761150-3-ojeda@kernel.org>
 <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
 <CANiq72kQOrvi5=1RUScEpov79RNzA3vna9KW6MoYmj8XJZhpQQ@mail.gmail.com> <CAEg-Je9Cs54SkvhzbSq=2v2QYMo=mwUuGqFcs6cvi7nFgw6+Ug@mail.gmail.com>
In-Reply-To: <CAEg-Je9Cs54SkvhzbSq=2v2QYMo=mwUuGqFcs6cvi7nFgw6+Ug@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 12 Jan 2025 18:10:04 +0100
X-Gm-Features: AbW1kvahoCxgDriEaQ0jzXg-Xw-OJQLOMZcGEkZHdji6mnUF75v6llzV78Fsi7U
Message-ID: <CANiq72=GsHUARPZqdj8TSzHLoW9SHDK72D10s2vhTN1OEW58oQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference between
 Acked-by and Reviewed-by
To: Neal Gompa <neal@gompa.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	tech-board@groups.linuxfoundation.org, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	"Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 5:36=E2=80=AFPM Neal Gompa <neal@gompa.dev> wrote:
>
> I've had my Reviewed-by tags silently ignored or deliberately stripped
> because even though I've done a technical review, the maintainer does
> not believe that I did. Therefore, what I am saying is that
> maintainers seem to speciously decide whether an Acked-by or
> Reviewed-by tag is appropriate or not *after* someone has sent it.
>
> This is the fundamental problem I have right now. This decision is not
> the maintainer's to make, it is the submitter's.

First of all, if you are referring to other cases that I may not be
aware of, then I am sorry to hear that! Things like this can cause
friction sometimes.

Sending tags is OK, but the author/maintainer ultimately decides
whether to pick them up. For Reviewed-by, I would think it is rare
that it gets ignored -- after all, maintainers usually love to get
that tag.

If you mean the case that triggered this patch series, then (as far as
I understood it), the maintainer was OK with picking your Reviewed-by
and Tested-by if you sent it, but not your (bare) Acked-by. That
seemed reasonable to me, because the rules are a bit unclear around
the latter tag. This series tries to solve that part, so that in the
future one can provide an Acked-by with a suffix in a situation like
yours.

Cheers,
Miguel
