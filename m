Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9C24B28
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 10:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720176649; cv=none; b=S73Pl/9khPqkEAmDtm5Z/uwLQUaQuExqZILLi8TnZOHmqjizLJdCgg0iv7nebbfG5px9q2qYAdS41pXMgKTZyYZMd3DQvTylgZ2UPFesrxTgR0ewuOJRtIA/KNsDnlL+82pTxtBUZ7fslA5nFTSQm/D+9V+F9y7u+Lm4fd1Z1q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720176649; c=relaxed/simple;
	bh=mazd6SlQGoT23PxSsQCYr3vhjvCyYL5J03ptC8NDxKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d6/rxFoMcekKt/W8REf4ooWpCyoh+Bi2gi154izXPpy4wEJCGyAed+xb6FM/SACzFe3SAqgUHmFyZ+ngXsMDnP/3CCrSFznjUUnpR3CDTL7jZRuT5QmYAugMl9fwn/En7D7AnmdSQzDDJ5Y7GyjAhZPAIOM3WsBjGRFxbzBHJfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jQJ5aGCe; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQJ5aGCe"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2c967e21888so1031503a91.1
        for <patches@lists.linux.dev>; Fri, 05 Jul 2024 03:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720176647; x=1720781447; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mazd6SlQGoT23PxSsQCYr3vhjvCyYL5J03ptC8NDxKc=;
        b=jQJ5aGCeYhDa1N+OmFS3aJxwmTHJoPzThdt99kJ68n0oPZjJgtOIziorSbhXzvn3Q4
         gNoCEXCV/Wmm7V9/4H3LaSc89iZPba7RZrpFwNbzE5EiTPFEOxD9TLixdpNi9ZRKdBJa
         ENf2k1rHAeqSIp5HETUhk1gc9nE2YKGvyoy4X0hb8u7A8nG32GuQoRDNMbUh4m5HmQgY
         Ui7B2XbKI/FC89ZJ5iyhgEdR6ICADcnN38l4O2JKgMYRSvM67cf00Y3PM52sbaM2kfiw
         mozPxaB5EJJ1ri1CuqoTUvIynwYuCHjORjshHrmDYuyurhhEsEAt3RHxC6Ih7TyJBb1F
         3NxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720176647; x=1720781447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mazd6SlQGoT23PxSsQCYr3vhjvCyYL5J03ptC8NDxKc=;
        b=auvr/6p4/u7hHcDRMPgSEvlD6+dnXkzxkMEAtR5//obQzZfDORvxo+pdJ3S2EVXcbK
         hTNIcVq+TGzurSDE8mXOhkXfqrWVhVnYfbkI3W6GXL7+C4mIhQg6vBd/YEcc9AmDAvgU
         NvZ4EPTN7KEQvBrqxGcze/dPwf8QHfpl5nKE8d9G+1cXS2uhgGnuwNZfU7rpqDT8Mc/s
         kkx66RkGXNhWXt4jqxMtGhn2m8DCICz5Zz4g4jOUEwQSrjWMYkFBf8a+m4h/m8+MrKzN
         Z78ywLH6tQ/y6OIu78n9UymIbDz2B1dQcYxHfmlBhTCFDcDES+WRPchbYJr4Di1k+iDT
         chzA==
X-Forwarded-Encrypted: i=1; AJvYcCVSOadhFjFm8V7zkK3Ob2eng01WHr9m4ZBs4vot96xQTBZBaGIfiXz2ojyz9Hct7Bnw6R7dTsvKzly8gmEWCO5qRBYI5gKb6g==
X-Gm-Message-State: AOJu0YwddQDB3jZ5zz0PrtCgmMB5bZ68gq9YHl53r4bWgyeFkx7Uuu+x
	uqYPzf1JC7f76MeYUElY+csJfmeFRUwzLW0ReZrxtq+kwM3iSV17zKD4ohueN3H1+weywNr88MH
	v0X0GuYQsKuMy3FpuotXj02IlcE8=
X-Google-Smtp-Source: AGHT+IHrLSGcmR0Qvqbpf7FgUVqM+8MTahzuf5TtCI/rZDagwTn9kJDSpqaExb+OjYYeAL9Q9cwiQ0mvi6kNes3PHWU=
X-Received: by 2002:a17:90a:e005:b0:2c7:e24d:f695 with SMTP id
 98e67ed59e1d1-2c99c53b396mr3069966a91.12.1720176647373; Fri, 05 Jul 2024
 03:50:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-14-ojeda@kernel.org>
 <ZoeQVYda-AZN6PYy@gpd>
In-Reply-To: <ZoeQVYda-AZN6PYy@gpd>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 5 Jul 2024 12:50:35 +0200
Message-ID: <CANiq72==+YBoQDBwEVuncY+ygeTkQPEbK00yBCPN3YWVk1L9XA@mail.gmail.com>
Subject: Re: [PATCH 13/13] docs: rust: quick-start: add section on Linux distributions
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jan Alexander Steffens <heftig@archlinux.org>, =?UTF-8?Q?Johannes_L=C3=B6thberg?= <johannes@kyriasis.com>, 
	=?UTF-8?Q?Fabian_Gr=C3=BCnbichler?= <debian@fabian.gruenbichler.email>, 
	Josh Stone <jistone@redhat.com>, Randy Barlow <randy@electronsweatshop.com>, 
	Anna Figueiredo Gomes <navi@vlhl.dev>, Matoro Mahri <matoro_gentoo@matoro.tk>, 
	Ryan Scheel <ryan.havvy@gmail.com>, figsoda <figsoda@pm.me>, 
	=?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@thalheim.io>, 
	Theodore Ni <43ngvg@masqt.com>, Winter <nixos@winter.cafe>, William Brown <wbrown@suse.de>, 
	Xiaoguang Wang <xiaoguang.wang@suse.com>, Zixing Liu <zixing.liu@canonical.com>, 
	Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 5, 2024 at 8:19=E2=80=AFAM Andrea Righi <righi.andrea@gmail.com=
> wrote:
>
> This implicitly covers Ubuntu, since packages are sync'ed with Debian.

Do you mean the names (i.e. command) is the same, or that the newer
versions from e.g. Sid can be used in Ubuntu? If the latter, that
would be definitely worth adding, yeah -- is that supported / expected
to work?

> In addition to that Ubuntu also provides versioned packages (such as
> rustc-1.74, bindgen-0.65, etc.), so in case of special requirements
> (e.g., older kernels) users should be able to install the required
> version(s) using the packages provided by the distro.
>
> Maybe it's worth mentioning as a little note, so that users are aware of
> these extra packages.

I thought about adding a section for Ubuntu to mention those -- so far
I only added the distributions/commands that were likely to work with
the versions supported by the kernel, with the idea of expand later as
time passes. So I didn't add the versioned ones since the latest is
1.76, so it wouldn't work for the current kernel.

But it may be useful to state it nevertheless, since some people may
only look at the latest docs. (Or perhaps Ubuntu can add Rust 1.79? :)

Thanks!

Cheers,
Miguel
