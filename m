Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA4321FF55
	for <patches@lists.linux.dev>; Sat, 16 Aug 2025 21:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755379321; cv=none; b=mB36Qxrap+Nx9X6V+NUNAt/JgC/xPfz2KZ6BLaagm6xvjmJwVjjSTjQC8cW5mgHvnYb2rCga2mbOCB499PH8mBkdTG3N9pnBBiQpFt5aXpKsGaGXqfzd+5FWbeXDMbINnZBh0c3+oAcIidFJN7NFx3cEU8nWN7HhOv30voqxDdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755379321; c=relaxed/simple;
	bh=jvHsXepbd85mILs5MOLtSpqmRNq7lhyRSHBkFQ6Srjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iNmZOIEDBUp8q5a3BbGpfwK1nVak0XEF+zNAGipAurq0PB9SJ1dV8/n0B4wg7cYjpv4sGEGG8BYxOHUj39xwi79uRTl+ftIP+IWsS51Foyxz73vvExnR15Q00vp58aC5uHpY+8/9H13XlPk4sYdcVLRwAhedzfdIJ6oFHFXW/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UDT2nWCp; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UDT2nWCp"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24457f3d233so4982665ad.0
        for <patches@lists.linux.dev>; Sat, 16 Aug 2025 14:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755379319; x=1755984119; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ds8Je7KfY4GjwHXKsWk5Giau9uIeYrla8x9MggnAb0U=;
        b=UDT2nWCpy4byk+z6/xme76HLUWi8YBY87IXSL8EIkWtq8T3cxEoBUTSDBmWbBt2kxm
         +mI8i4ai85VIL5TbmKiG+rrpPsKQpbpj8MuX63XMbUBirWe4nUqGq3zqCtFSk1/RVH6R
         Uq1dH6FGAPtX89vHUEAGdm9tFYPvgB2Ma56k1t/8t1k/r/Clbsn6KxBc3M7/FxJAZ0yV
         0aDW01/vB3uYIW9gjPNw+yuwMav1B4zqirLK7ZwMpUx3xzzNRG9UOVx/zidl8twa/mqS
         6J5sSUPuO0PnVYfEQ3qrVa7YoDiHrpGZ3TWk89YdMPh0tjXuOLWDiXsOzwebXKYlyNyJ
         hf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755379319; x=1755984119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ds8Je7KfY4GjwHXKsWk5Giau9uIeYrla8x9MggnAb0U=;
        b=KgsJZgwu2WMACrLnrLfjnLiprLqcE3T2kBue4gjGi+jXWzuM5fKBZ4ZM4CCJAbzx5d
         c1mo8o4Zz2YIFvaqiKQrOU/JkU8IrNRBfqZ/xgHkuErbq2j3FrIFTEsqs7gfRt7Foji2
         dWrgB2/3PKIecxfTo2h1cfmg6sPqPSSVKJaYR4mr/L+g3s80ACqAVpOpDo32bySAzxyH
         hHcDVGn2pUqNEl4KC/IltgR+l/GY4eyc/IN2ovz4AJraGCldZGn3TUziJPzG8pdpSXz7
         zULYFl4BeMfEg/8ODDk/YEGEZdZUbZZHqIUThacKPPlmZBGw+Oo7ggE+ox51bKj8S7xp
         O1Rg==
X-Forwarded-Encrypted: i=1; AJvYcCV3csEMHonU9uRfUCpxvJSFRfOoGlTWdbaUtTe59sEvIMeqSHMoZcUT5xfYa5wHXEErzpKpdHo6@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7VOQPHlDjXcka9pJztU88bGF2FsMGosNz6pnFdT+nqBmBX4Bw
	DQT064zuD3g1BxCco1QSHpivGFEdYY0c52pnTkHRIDDF5DVGBLo3OEdDr0TMjIUnAaGwsKC5T9+
	P01wbUvRGnG65GBzSJpLPpY+JA/WrpGI=
X-Gm-Gg: ASbGnctbZvztNIRrQqJ5NZPmHOEdxsaeUukqlFUAFZf+ygCPqcF8GPDY4LyXB+Pa8gc
	fd2VLF4x2bJGv9qgvM5CT5SHEi9W0gUSKdU8KHEWqCdrzHVPnAn6K8oTUmeRYOPr/1uXPjcuT59
	HoRFqMWDXr5nmanvdozz4RgdRcBqN47NIE+i6L/Zr+QQCx4tBylgvdv1hmeJfvJhS66p6xegiO8
	jTre3XlwYaBaHJLrU4=
X-Google-Smtp-Source: AGHT+IEWjOp4P2fU8wk6DK2g7nuduw++M/0lhwl96NpMeoXDbRf1rYmaSGIzIjyIjkEruBxPEP1OhxK64EdgQTvEFwc=
X-Received: by 2002:a17:903:1a70:b0:240:725d:dd66 with SMTP id
 d9443c01a7336-2446d9c6212mr49127785ad.11.1755379318942; Sat, 16 Aug 2025
 14:21:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250726180750.2735836-1-ojeda@kernel.org> <DBOEANDMX1OU.2B47D7G6EQ38O@kernel.org>
In-Reply-To: <DBOEANDMX1OU.2B47D7G6EQ38O@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 16 Aug 2025 23:21:47 +0200
X-Gm-Features: Ac12FXzLXRqQ8BoWN6f3ka4dcgtWt6sEkaNyDNPtyslcoLw_3oMH2C2O3pfwMyc
Message-ID: <CANiq72nVJpptasJM5+Xe3MGYfP4CZ6=acPV82X=EgVf=3C25MQ@mail.gmail.com>
Subject: Re: [PATCH] rust: kernel: remove support for unused host `#[test]`s
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Rae Moar <rmoar@google.com>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025 at 10:27=E2=80=AFAM Danilo Krummrich <dakr@kernel.org>=
 wrote:
>
> Nice! This should also allow us to remove the Cmalloc allocator subsequen=
tly.

Yeah, unless we want to use it in the `macros` crate for an example or
similar -- I didn't include the removal directly here mainly to split
that decision into another step, but given this other issue in
`rusttest` I just sent:

    https://lore.kernel.org/rust-for-linux/20250816204215.2719559-1-ojeda@k=
ernel.org/

I think it is easiest to just get rid of it (and anyway eventually I
want to run the tests from the macros crate within the kernel too).

I have sent a patch for that here:

    https://lore.kernel.org/rust-for-linux/20250816211900.2731720-1-ojeda@k=
ernel.org/

Cheers,
Miguel
