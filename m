Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AAD313537
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 13:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781697; cv=none; b=ishekoFQcKMwyom0DWO/ScX128A+5PKz69UXQBagc03KjcHxWyDu2pdft8aYLxm/HYjhGZSC75Tdgkj60xr6CF4TeAhw3uthAv1hpO3pHkcUbgMo6IMnFODJsG9Qb+Vah4KKfig/s9VsVBjcaBP8XwiSIJKrsIIgF4eRwtd0Yck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781697; c=relaxed/simple;
	bh=hOoHELQJUct+/jjBWDM/iGci2iRQNFOKXIkYMSUGeuo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hjdVR2ykpWrXj1yGXw79fZ+CQKpa87we2Ltd2VkD8qgevDb2JUdVoIcY9F7hhsGO+28xK66K6/6VX/MsUIuIMSElwH1evUN2BDVQFhk0M1zx4bQg8ibW0ODkaYGJBYqavbqjSL1emy8pb9wS0XYmkMYYS93YV9QVqZZRBuJuYAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cmAFPgC+; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cmAFPgC+"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477563a0c75so17711135e9.1
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 05:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762781693; x=1763386493; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hOoHELQJUct+/jjBWDM/iGci2iRQNFOKXIkYMSUGeuo=;
        b=cmAFPgC+WAlm+0DKWKcBi8PQ3nQrHjBo2gm7HxrYZkyC3guliHiym+tUwjCopRKluB
         yPX5p3SW3N+wUYrxCJKcrTFZLqpqXRrfW96+faFFjT6XEZ2KveZXaSkNbB6t0lgXsv0C
         WzAiPqxKE/FCIlye7FvcXyMgUJQYJOkQ7TRUZCBaPQeMEAdheh71m+w9eG2kz95ePJG3
         /7x2msVxnI9WQ3Yl5wkO3Gvm5D5Sh9JBWdj8SWIj2DOASYvZZGmh7FkUXWCPlDl7dgT4
         qBkLb0CJaUpSjXbeIBVKji8wELkkPYQmEobyHyIQ59p3kh2m8vNMCl4PdexIHeCLgEhp
         jjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762781693; x=1763386493;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hOoHELQJUct+/jjBWDM/iGci2iRQNFOKXIkYMSUGeuo=;
        b=h5M+sC2wCk/lGK/zE1JyZrv65w9yWFbaEp1FjDfG1YCq7zIuXXjDh0S13r2HGvoR57
         Nl/UTbd+h1mj/cgCJxcWnuEbFytwn8Z+zTkWvcaDfEOdggvJuTVhoaqntj5hygBWmoTt
         OilB29LexyVkjw1sXYjzyC/GHKhoQZTkK4n+y8CbgF6frWUy4CMNqbNbo+GKHGsa1i7F
         0JDsdfvU5Mdq/q/KCAMBcumHeY1lemYIWtdkwzI425POiarBbDsJnFZM6dGLRTiaFzvS
         Bkw50ah9jWGUuNpNI1Nzj8m2FOYCvxdz9L47YIWtuM4KPiPd1pxxqn3KSUzflWX8Z2R0
         CgbA==
X-Forwarded-Encrypted: i=1; AJvYcCWF+TkJh9Y/0BtgGQH9yj/MrwQsNWtS2d9+FfTFD9eWYukGw3P9B7rIWY5LnAQZiA23at4GV/A/@lists.linux.dev
X-Gm-Message-State: AOJu0YzUy15avrEbcAE/PJFNiw7j4WwL5Ohsml/VFmQ6onBIB5+KiAhq
	QIV0/KXeLB19qE1HS8TYX7N8cQVNs+Xxuf4/8XvTulK41GZmMBinsQJdv0FL3R7xtknh3miUruD
	HTUt5o0u8J6Kg0xk4yg==
X-Google-Smtp-Source: AGHT+IEhcd7v1I50vLKbfj11e6ZHlmUaM3O4D8Dzo9IdUzmf1+ToowaPgG4/VPB3oFSYHqCUiGhbSA+XEU/bilA=
X-Received: from wmoo8-n1.prod.google.com ([2002:a05:600d:108:10b0:477:55e7:9973])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1ca0:b0:477:7a63:611f with SMTP id 5b1f17b1804b1-4777a6362e2mr49082565e9.36.1762781693427;
 Mon, 10 Nov 2025 05:34:53 -0800 (PST)
Date: Mon, 10 Nov 2025 13:34:52 +0000
In-Reply-To: <CANiq72mGYKYZmQ8g5AbXCsRS+WPxbeaSyngR69jsEpY8akouog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-10-ojeda@kernel.org>
 <aRHOnGyLx-bEVqcY@google.com> <20251110131049.18e2f5c9@eugeo> <CANiq72mGYKYZmQ8g5AbXCsRS+WPxbeaSyngR69jsEpY8akouog@mail.gmail.com>
Message-ID: <aRHp_MadSjnYwHdy@google.com>
Subject: Re: [PATCH 09/18] rust: proc-macro2: enable support in kbuild
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 02:28:06PM +0100, Miguel Ojeda wrote:
> On Mon, Nov 10, 2025 at 2:10=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote=
:
> >
> > So I think the implementation here is sensible. I believe Miguel's
> > patch is also pretty much replicating the logic in proc-macro2's
> > build.rs.
>=20
> Exactly, I was essentially following what upstream does for stable compil=
ers.
>=20
> (More generally, even if a feature may work, if upstream doesn't
> usually test "older nightlies", then I wonder if we should enable such
> combinations/setups anyway, unless we need them for a particular
> reason).

If these features change the public API exposed by proc-macro2, then it
seems better to always disable it to prevent situations where you
accidentally wrote code that does not work on our minimum rustc version.

(Of course, this is a polyfill and no API is changed, then that's a
different situation and then this LGTM.)

Alice
