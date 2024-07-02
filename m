Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E51A1553BC
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 09:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719913301; cv=none; b=NpYmexaMvyJpnwazPP1pdxeBqB59zvnlhdsd3DqzebRqxEZUkNyUKWad1NIeEb1YSdifqO93YTCzFbKt1oTAOFaoEV7oqjiLg+bQFMRcUX+cvRY5K4keYL4Z/ds378VKb7jiskqRx49eztGlNaF+Up8IYGjo37VmXpURNyY4Tdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719913301; c=relaxed/simple;
	bh=rrHJuzABvv32dcWokveTz7Dnd/80nmaf3YwG2Ar19yE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u2jy2/ZBONVrlPmOOEzeNqEF7ikDUS1Yx3zYHA5Av0oVc3sc1W1H0NoBPAe+69+cs2fGRNfnPCCKRoXCP6Wrd83JmBKYlAplXGBUOdj8Gaat/oxr8k0h9x+pNCANh+ttrPUHIqiDp8/F7e6TBZWfJ+BJUV4gAoZ6u3dGglnDl40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EewH1SZB; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EewH1SZB"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-707040e3017so2823862a12.3
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 02:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719913300; x=1720518100; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rrHJuzABvv32dcWokveTz7Dnd/80nmaf3YwG2Ar19yE=;
        b=EewH1SZBOgiBdtFRUSCJdZODvNRXun3kfPBzKyRp6hxLxYisOKO6pMZk8REtspXHAM
         gmX03VEVmwMmp5d6wp62jdiT/6LGz69FJhZZ8Apzs8ilwvhbhq8iXHykQ4cVEgQGfAfy
         /uAVMTDQef2f4cBsURxxfTILKZGu1R7pc4J+eMxoHPZcaU/5MXsyEa+UUVcYEmbhXtOu
         rG2MuNZMojZ0h1cmg4fsXUwBixo9CyJ1Qh1rS40lPsfdDQBokO1yv1+SOvxeqZf65M3G
         v6VSMYfAhhF5B7MFKlN51qbzxDLhieG86hAyHewW9Vc59nl3Y8mQLP31unS/TktNxPss
         +bYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719913300; x=1720518100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rrHJuzABvv32dcWokveTz7Dnd/80nmaf3YwG2Ar19yE=;
        b=MwXMxvSbsxf0+rkH7KE6+M7Kcn02JD81hFihnpfYdwwqnKPC//3ZpXtI18Rvma9IGm
         aHRhSieozy3PorgGeXmLnWkfw60Nnt2d0fd/y86ixWYv4V1xxqrmHPosUmA+jTs4SdzT
         p9AoB32b7KdcQfoQvb6R2AljB1lsNVhV5aPupE6fm81ne1mnNCHa6DpJxeBhidh7PlVK
         bXnU3mWNzOnxz8euAiPhpx/Ae/Y4lmh9Kz/hHVIsyhlbnhUj+mQXt3t5QxbpVg7ET2aW
         pATUtNsa37wKM1nW88QIZBjZ79ZDqyww/g4ClGgHb72Koy40oXODllGzYrqu3VUL4q/n
         y3Pw==
X-Forwarded-Encrypted: i=1; AJvYcCVSWdfg4gucSZ0+UbZXfuxpDdGBR1mzVzUVxU/eitH26lTz4h88SG4H6T7vCDyP+IfeJ7AgP9945ddo0DPRkR5g8v/twtAasg==
X-Gm-Message-State: AOJu0YyzF3+pEKTgMOY3NlJEos0F/k2v4xS11kr78KRrC267QIRIDpbX
	xf+trPgDQlQXRT3NwAqOCGhdhT0ktXe+hZjQOoHdc90RKyRkP/iYMFtLVqGHEQtz4aJEkItDcaQ
	m6itUUWHIGWufH3+sEvBvmuXkIwg=
X-Google-Smtp-Source: AGHT+IEDftu7sk+tfSLkqpQkBEgUNXL8IgNpgAL9Frlx/qQPKc4RNAvHIN4qui+yL3vGvj/+3mk7DlNTp02STXHJzQQ=
X-Received: by 2002:a17:90b:180d:b0:2c5:32c3:a777 with SMTP id
 98e67ed59e1d1-2c93d7242f8mr6335964a91.28.1719913299802; Tue, 02 Jul 2024
 02:41:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240701183625.665574-1-ojeda@kernel.org> <4fa15761-7cab-4463-a2ff-717256c67d76@proton.me>
In-Reply-To: <4fa15761-7cab-4463-a2ff-717256c67d76@proton.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 2 Jul 2024 11:41:27 +0200
Message-ID: <CANiq72kX2yhAVwd2FVRaGZvGrhPhTnnM=v18nng___Pu+aZaSg@mail.gmail.com>
Subject: Re: [PATCH 00/13] Support several Rust toolchain versions
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 2, 2024 at 8:25=E2=80=AFAM Benno Lossin <benno.lossin@proton.me=
> wrote:
>
> I applied the series and successfully ran the kunit tests on nixos.
> I tried the following rust versions via fenix:
> - rustc 1.78.0 (9b00956e5 2024-04-29)
> - rustc 1.79.0 (129f3b996 2024-06-10)
> - 1.80.0-beta.4 (64a1fe671 2024-06-21)
> - 1.81.0-nightly (6868c831a 2024-06-30)
>
> My bindgen version is 0.69.4.
>
> Everything worked as expected :)

Thanks Benno! I tried nixpkgs' toolchain for the examples in the docs
patch, but not fenix's ones, so it's good to know those work as well. :)

Cheers,
Miguel
