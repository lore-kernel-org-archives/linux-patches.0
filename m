Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EF2149E13
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720187209; cv=none; b=dhvmurchmVM3JZ9tf1EBUFdyMmQAiUBi6pRcae+h3DY8C51vj+SJcDRCXWi9u8Z5SVL9F1IophQukKr+9kQYdJdJs1gLsmOZE5/M3+fWHW/vhb3iyQBUFUeL/WFONuG7X728rbBM5dm2tBKgI8P6ubxFqbrv1gRy3UYtL/PCyt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720187209; c=relaxed/simple;
	bh=l+1Y1+caxhVchzhr4BCyG+RAbZ2ux/UMlynAtjvAZC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gVqiMySFTL6qzFoVALmwXzSNSdZVW9GA0H6gfdcvj1my8ReBBxmJbozkPnXUlTpxumK2QO/Vn9gaX5XPGrTQCDdXw7uh96suwct4wDCIpHxZRCP557uPIWMLXNqVro0DLM9oMtmdRx/r7ZnKGduveQ1VtVY96hpTjLDCaBqHkLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZ7mnMK4; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZ7mnMK4"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2c9a7323e62so785451a91.1
        for <patches@lists.linux.dev>; Fri, 05 Jul 2024 06:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720187207; x=1720792007; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+1Y1+caxhVchzhr4BCyG+RAbZ2ux/UMlynAtjvAZC0=;
        b=dZ7mnMK4UjKVQBCi0A/8rmdzAusrYQJ1yDEHM7IUzLWMimdMgqU4LIThvBwH/374gZ
         KpZf8w1YsUHbH73VYBfaPHxqwKooPs9fEQO1T6Wm5fcg4slGapIjnuxeYb/kfouKvzD1
         E9GtSRfGbGatd3qUIQ4BL5Odl+q5SPF95T73abhmHyyoWOmBfbIKEhunUbJM0IS98W9x
         5E6i5NmBBfpmDLGPvH/qsT0+1EQV2UWzzt8eCtX4hf0NSc/EFGS/C33rbBSwBcTOEta4
         P+Vzc/MfJc5gBD8CpGVRqDLMx9w8ENdItZA67UL0QzsiXoMt8E0YEiHyu9TWH4ArVlMO
         Dyng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720187207; x=1720792007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l+1Y1+caxhVchzhr4BCyG+RAbZ2ux/UMlynAtjvAZC0=;
        b=rbH1COZxSYJm6AZPeQpfHo9tunDg810JyG3lydjCfxqbFqCBsk1Ji2dzGvO1C0fx9R
         VO0byr7FnFiR0EoZOVKz34DbzcYB0a9R8tVY9ZCW51obl3QAkYsFRjVa1Sy+jAC6amSX
         01rFGjWM33LGpB0gk4Y9x13o6mmZUheUYdsKh7eNeOF98skZbPu+RbaxV3sV6uzFFlpG
         wwNVw8w1sKSb8noO2/YnFEcGmgImblL7POJqsPxwb19ifCU1p357LMmma22uuLCKLOY6
         od6/KMEcRgKAZ2Gse9FGdwyoH1fvvxjLAvsIaNDDC+Ipgwa2Oco/lbXytEqYWx07sAdV
         fO2w==
X-Forwarded-Encrypted: i=1; AJvYcCWao79T+HKvmiHo/kdjZ/i1kybRkjq4xALaX5kYQjoX+Wijyok+ChJ1vBY3/DknEByLc/o+3Yt/bppomnmEDpLjtS3EPp/lFg==
X-Gm-Message-State: AOJu0YwJxOlGv28JtAoYkdOfI+CcGHASi3NAdFpCfNuAvZJYc/5riJ14
	BgBxvmM9fbz3xbPxz3omP2tL/Yqt2vZMXnbHNr5Yj/UDM5r/FcZcxm+sp2WajadbrWfleE6M5qj
	k/Qm8WE6f1WFQFlbvrIzxU2QCJSk=
X-Google-Smtp-Source: AGHT+IGn9pRs0VGDTMIiD7gHdJZujUU/p8nn7qMARSQbH4hdHR+SWMvpQUQdYXZvJ5a7xvLZzY8hKk5A4Nt/5wtWCgc=
X-Received: by 2002:a17:90a:d795:b0:2c8:f3b4:425 with SMTP id
 98e67ed59e1d1-2c99c6a3198mr3417780a91.23.1720187207178; Fri, 05 Jul 2024
 06:46:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-14-ojeda@kernel.org>
 <ZoeQVYda-AZN6PYy@gpd> <2qwdfogh6jd5uixxjzlagmtfvnykk3x4ztqrn4j2v6qoref5rx@ooj6gq27bq4z>
 <CANiq72n6bYt0AKNxad2+gjwHKQ1RiDxAbjm-2u20L8TcSZE-9Q@mail.gmail.com> <huatx5giw7r357zeecxngkqboiq3lfqndjjrcivxllurqpjvbi@4y5ejgwxhztm>
In-Reply-To: <huatx5giw7r357zeecxngkqboiq3lfqndjjrcivxllurqpjvbi@4y5ejgwxhztm>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 5 Jul 2024 15:46:35 +0200
Message-ID: <CANiq72=A-PZ6LoUiVQuOvN2hMVvd5pJ42OKPW61FXNrnYU+WBg@mail.gmail.com>
Subject: Re: [PATCH 13/13] docs: rust: quick-start: add section on Linux distributions
To: =?UTF-8?Q?Fabian_Gr=C3=BCnbichler?= <debian@fabian.gruenbichler.email>
Cc: Andrea Righi <righi.andrea@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jan Alexander Steffens <heftig@archlinux.org>, =?UTF-8?Q?Johannes_L=C3=B6thberg?= <johannes@kyriasis.com>, 
	Josh Stone <jistone@redhat.com>, Randy Barlow <randy@electronsweatshop.com>, 
	Anna Figueiredo Gomes <navi@vlhl.dev>, Matoro Mahri <matoro_gentoo@matoro.tk>, 
	Ryan Scheel <ryan.havvy@gmail.com>, figsoda <figsoda@pm.me>, 
	=?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@thalheim.io>, 
	Theodore Ni <43ngvg@masqt.com>, Winter <nixos@winter.cafe>, William Brown <wbrown@suse.de>, 
	Xiaoguang Wang <xiaoguang.wang@suse.com>, Zixing Liu <zixing.liu@canonical.com>, 
	Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 5, 2024 at 3:09=E2=80=AFPM Fabian Gr=C3=BCnbichler
<debian@fabian.gruenbichler.email> wrote:
>
> right now it is updated whenever its rdeps (firefox and chromium in
> stable) need newer versions. once e.g. a stable Debian kernel has
> similar requirements, I guess the same would apply there. I am not sure
> upstream kernel development on Debian stable would be enough of an
> argument to update it (or provide similar packages), but I am not a
> member of the teams that would make that decision.

That is reasonable.

> as discussed off-list, -backports might be a better place for providing
> more recent toolchain packages on Debian stable, and independent from
> this thread, I have pondered providing them there in the past already.
> backports would only ship one version as well though, and at most the
> one in testing (so it would also be affected by the freeze period, just
> like unstable and testing).

I imagine that could be useful for some (kernel or not) developers on
stable, even with the freeze period.

Thanks!

Cheers,
Miguel
