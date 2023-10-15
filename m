Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DE9CA4D
	for <patches@lists.linux.dev>; Sun, 15 Oct 2023 19:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ENX7y1e6"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-5a7dd65052aso52100047b3.0
        for <patches@lists.linux.dev>; Sun, 15 Oct 2023 12:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697398560; x=1698003360; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HzQjQrdg7nVPiGGf2LVEENqY+cByue38zFhSb9O4FAI=;
        b=ENX7y1e6vuynB8PR0UN69kaZJqy40I9z0k9a0QbxtT+l/7sCeFnX4GdbW1p6HZJsgC
         y6XwPax9lmuZIVUu25i6fGaapxtdb09tBLiiYC250XEy6jkhbvMaaGZzR94axSkW22td
         k3yVJJb9HrhOat2mDkN8IP/OnuMIMlmVuPSmpSLsTsuvTx3paLBtvApu6rUZD9rN4v37
         ALPh9Csrh7o93a7Mu7TKue1u1bxBdO37vJgrMGH+QtbtpjkEwk6zJMxMd1O0PHELzGX3
         yxpw/GhoeQ5ej8/rTTOAECYwq5dtRG9TPv6j4tlSXoRr2noTJfC12vxAob6TbGRm1K6L
         rdMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697398560; x=1698003360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HzQjQrdg7nVPiGGf2LVEENqY+cByue38zFhSb9O4FAI=;
        b=soXL4P6O/Om4IALaDyaSLHeaKZpaV5itBPsVZfygcrPzOS4E6KAfBgFWbCTBVw75L8
         fpryA50Urj1CggOtOM9FJrKvoqXYmhFVZIBmZsFXwaLxblToTYMLDvtc9heaT9g2ZcrN
         TDSF/FLmjYUR4M3mUU4VQef59n/oIBuCuijoIpqU3qfCudZUitFHsQW9L0n0/mF1hnvH
         Ygdnx8JiCZMMb7WJ9Gt4qjrnuWKvG05VIG3NZoy9tW23r6W/zNppqzW+M+BZL0txfnGI
         cbuUwqFakhMdkVN80mkih443altQREZ/AsrwfzywJI2EcfFI01lvTpa3t71wVngfdIen
         ACSA==
X-Gm-Message-State: AOJu0Yz9gmN4u6IegimpuHd2utjRM3/ZGR84hSa6QbPqWLdJ9hvfFUZK
	2yg8KZlcDARSzjwo3EYoImsCVuAOMQDVhVMDxJ0=
X-Google-Smtp-Source: AGHT+IFz6pli0XNJwt6HvsfPzBHP5yn53skXC9JUgJSrc+j7Rxpfh+YXepQf6PA6AGIH4SRhGU27cmm3dUtZEdnLg4A=
X-Received: by 2002:a81:b661:0:b0:5a7:b9b1:c0bd with SMTP id
 h33-20020a81b661000000b005a7b9b1c0bdmr17979318ywk.11.1697398559885; Sun, 15
 Oct 2023 12:35:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231005210556.466856-1-ojeda@kernel.org>
In-Reply-To: <20231005210556.466856-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 15 Oct 2023 21:35:48 +0200
Message-ID: <CANiq72=dBhrZ3ZP=Awi0h5G5wAQW6s_obUqCLJF+_fjUyk-nRw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Rust 1.73.0 upgrade
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 5, 2023 at 11:06=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the next upgrade to the Rust toolchain since the initial Rust
> merge, from 1.72.1 to 1.73.0 (i.e. the latest, released today).
>
> Please see the main patch message for a long explanation of the upgrade,
> the policy for future upgrades and some indications on how to easily
> review this.
>
> The series is based on `rust-next`.

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
