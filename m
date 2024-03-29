Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEA33B78E
	for <patches@lists.linux.dev>; Fri, 29 Mar 2024 19:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711741724; cv=none; b=WdRs8AIaZ3rA7pXLHXT6W4PorFQPx2JAkfNALqgeJWxdsy2uV9S8a/gh+1gtTgPKYYRTIWJ6dIDP8aw4VlWamS2MNzVQi4L9ia7ei9aUQvYjKy3CJosz2OQT73L/pGwd80k6GbJ+YbkFtDCU+iSXxzJlCIxSI1dVQjGAeibRSxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711741724; c=relaxed/simple;
	bh=SP0GlAdQvjK9+ItHq3VID9iHPh7Uhnl3AVCAfr0ACJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uRYCdh5ZO7j+p5oL23P151yxlv76gkeMw/n6A9b9FLv3oDfyTlVUaBNkuD0bARTcGXBQnW4XVzHOkl8/3pjsxHR5OPx32ktEuZberRc91JPMPByn7BlMJceHho+cDIwC58sxxgtm175qOMpQZ7OdV/fSrv3hl0KenhLWy3zzSCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IAUqqIMl; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IAUqqIMl"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-53fa455cd94so1654232a12.2
        for <patches@lists.linux.dev>; Fri, 29 Mar 2024 12:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711741722; x=1712346522; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SP0GlAdQvjK9+ItHq3VID9iHPh7Uhnl3AVCAfr0ACJk=;
        b=IAUqqIMl0FD/1mhp4fmi+r2VR26k2XLRqqZePtOcKF7fNGqDooI3aGi6xLjh8n6gGk
         0B4ERQV//RHJlQyxg8qs3skU6saXVPpGDjg3HnqeiGc+TtrbzA+Db1GJRZzBxWM/qTjq
         No/oHJKss1jUaHUtcYRlkXzN6aSMPJRkbfjP2colrW8EReGguf5quX3fh9DEhiyTsf4/
         nTJzioWFAPDJpsakXCin56zvCYKv2gEiNNMqwMIPNnfBiEJ4FxL3Es/Nl2s0ebw3SiJn
         zKoPll8XjseSVNivgCT3F7pktyq6/nlCmUh/Dglts6bFx4Y74etTAeEaCLQts7FK08+Q
         xi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711741722; x=1712346522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SP0GlAdQvjK9+ItHq3VID9iHPh7Uhnl3AVCAfr0ACJk=;
        b=O0g4vu0kWohRTkIMbQViEaN1sy+I4G8IGBAV1Cf0AJLaotO7G6Vtqkosrpu2vU/vGP
         i7GDRjtwXn7FRvDAM6ZSJh7lhv3IlMc6GbBuCJtBGC3PzF0jJ8NVBHZSw3qqyfCUJiZt
         glyOEbv3LGP3qWlNgLQaozuo2h6ISZLT5Dim4FWcd+O4FT4YWVp3vaID6R+knydBNRvi
         dwrK/QkNoHNY47cDf/Y2Lsxq52tM97IJQAr/1O9dWpJhpzfGo78DrH+7yG8AuOcxGAnY
         YP2eRN2xfXKa5kAEIHOoSdMU9ua7xx1gKZgdmwZUdIb3siXlonKpFX3nKguy1ghcG1/3
         zZew==
X-Forwarded-Encrypted: i=1; AJvYcCWtCPwb9xgizmIh5KSuj1tjKDVtWBaYLoyGSiRcNPJuAosJ58bOet2pb6vGKBlOYP8rdHT+yTdSt90U1UIINLnFewuIw7T45Q==
X-Gm-Message-State: AOJu0YxaK4G9RoeiekUR+c/WHHKnGJZjgNiY4fLcH4/opkOIP9KTUwuj
	+760NihFAtMMuh3ExI8p67c3xQL5/Id4u89HmEhfctNKDkjVx9GT1NPLGnrtA4i5Qu+cRBfjuk6
	rfkQ3vYuKBrNTNYPMeKJlrHMxazsYU0I1KCk=
X-Google-Smtp-Source: AGHT+IEkS6XIuTvbJ/3z+C8PWuNXB/i/m27t0Qys0QCqsGHGu77CWl4ZsbmPvqaOmybKv9tD0zNTn7vFI8fZ6x9KvCo=
X-Received: by 2002:a05:6a21:9102:b0:1a3:57b4:ed1c with SMTP id
 tn2-20020a056a21910200b001a357b4ed1cmr3435477pzb.25.1711741722169; Fri, 29
 Mar 2024 12:48:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002717.57507-1-ojeda@kernel.org>
In-Reply-To: <20240217002717.57507-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 29 Mar 2024 20:48:08 +0100
Message-ID: <CANiq72mnbNxeO7EGR3trOrZLCTDeQWLP-UjKaq4ZrDpQRLxALQ@mail.gmail.com>
Subject: Re: [PATCH] rust: upgrade to Rust 1.77.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17, 2024 at 1:27=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the next upgrade to the Rust toolchain, from 1.76.0 to 1.77.0
> (i.e. the latest) [1].

[ Upgraded to 1.77.1. Removed `allow(dead_code)` thanks to the
previous patch. Reworded accordingly. No changes to `alloc` during the
beta. ]

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
