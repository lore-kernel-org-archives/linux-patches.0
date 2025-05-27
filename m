Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753AF10E0
	for <patches@lists.linux.dev>; Tue, 27 May 2025 00:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748304668; cv=none; b=i44uTgWIV/2XmNicK4VoQv11VMKIu0sBzllQOI5RqmxIghVbrSrftxxBXqtinULOV9ja9kcLjYr2sf3c3ZTPdoRq+is4OAVkWI+1BfeTBgT3B88aH+7S2j/a1FEZx5Ioy/UriKFyNOcfKCvwGV7jq+YvGFq4wlQTIqCM/q9jAog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748304668; c=relaxed/simple;
	bh=tw+V54TzTF5aeL1GSdSVDzkRh6+ofawdotvvYMClxDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uRS1QgTAH+dlWe2wClmFIxwXLaq4M0EZ0vvd+lYyqqon8RoLe3f4OmJQ4CElHnhN7Doiv+tntNEsAcLqkrK9hDvet0g6BMzrjfnCqh2gVBoZ98iHzlGrvx4H1Xdm4G0PJ/osQk1JQRUKz+555456fkZGxlIRvmorbahDTVSkajc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IOAxH8cK; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IOAxH8cK"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-311676255c3so98352a91.3
        for <patches@lists.linux.dev>; Mon, 26 May 2025 17:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748304667; x=1748909467; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KtTCmrZoRrQ0JqD2tIFY3u/ae0Uri9xjv3XvvvkKWb0=;
        b=IOAxH8cKRCF2ixbSp6jbS6VSzVNv3j8tDvmTOEdsJVwlmvoCFnwHVNklovKUP9gGzG
         FeEf7WPplhjNvp89gSU5EfhUA6rWrT+vA4nuw0Y+nX4z4zOk7yNbCh9U3ivZPxphP3H9
         xnZv7er+Syh/AEInH+zvAPTRqelZVpnc0zzYUuwPheSxdIFWd9FlcmPGqz9IvKjBw1pN
         yqf1z+ti9XKhi/yKWmxkmYOxFl3bmUfm0re0VhJdb1UCpJAgOnmHWshBkkRVc1LwlftV
         yr9AGKYlKqgQUd8NqKL9eqkljWrMDWr3Jfghq2u+wVE2H9iw4G5qULEyCKD85xb1WZvt
         SDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748304667; x=1748909467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KtTCmrZoRrQ0JqD2tIFY3u/ae0Uri9xjv3XvvvkKWb0=;
        b=ujeXZacN2fDM6RCMOxfLqeH1VDAaitAsCiDCOlunz43XyS1SsSvHWdrNAmutYXR3jN
         fJBY6PuUZY2vpqWwEcLPHLbzyNDeY5cwdq4Z4ng0VtVU9zc2xYKit7dHKc2jV8PkaKzy
         nnfdLX9ccZPHaZsh+IrB88n7EpQldzotX7bg04fZWNafAUTBAQMQZzY/km4ize3wwdLj
         6eprzk0xlc8cwU3POD9fSltAGhRUDDJ51kxyvjqY5B27hbEHLDyU/Ap9c+4Br8LzHa7z
         fU9y5Zjcwpew1RWZLtHOeivTw37apwLRqVWS/wFUwK1hgGEyl6JWQAMpoqC2d58RR+ck
         FBLA==
X-Forwarded-Encrypted: i=1; AJvYcCX8lqnSZSzFhj+PFPCZeNO0/sz7i6gn7Zsfxq5psWycFnXsjcV1CRFJIivhetQpmQpu4ZmBQj4m@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1GcobjZlHQE3R5/SZoBNuSqpUGWZgmnekSL74U5o0vVUu3Yea
	A2y8h+mucq1rBg7K7ynbCPNDJin/nQCHb/bF9Bsi9f0z4L6OGBrEv9TIXKCBRrN+M/CL+ZaA/9q
	A2+/40ejeGDdrTq/GWQkesdFLd9srKG0=
X-Gm-Gg: ASbGncurGYtNGg5wTgFY5OK/D/fqN0qQ5VNuyxcGGWd9Lngl55xb5o62P4mMVyYnbX0
	aHlZQzFHoPCFp5CRQq9n3YnafrwuVoef92y6U5AL5rxmm2YR9kvSYISh3YKLC1yAVJprs+DlAPq
	XZdHHIPsVr+sf/0MjHYucmMic0JDNRVuD9
X-Google-Smtp-Source: AGHT+IHuJYZe8bONowCh96S26GJWzJMXTf8gJ+iXWDqS0aq8KaIuLAGuRkVGgNILqDbnpOeuvHai1AtCg5SRH+0v1qs=
X-Received: by 2002:a17:90b:17cb:b0:2ee:acea:9ec4 with SMTP id
 98e67ed59e1d1-3110f72c97emr6529967a91.3.1748304666678; Mon, 26 May 2025
 17:11:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org>
In-Reply-To: <20250502215133.1923676-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 May 2025 02:10:53 +0200
X-Gm-Features: AX0GCFs4jjYfVU6bcAWIwvQqEUw3eEVTRURfBNgMbKp-7WpJO6lmgJTaph6upiw
Message-ID: <CANiq72mj2yv4E7Dd+19fmP9xGWELdv6JwXULpu91oq0BMzob+g@mail.gmail.com>
Subject: Re: [PATCH 0/7] Rust KUnit `#[test]` support improvements
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 11:51=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Improvements that build on top of the very basic `#[test]` support merged=
 in
> v6.15.
>
> They are fairly minimal changes, but they allow us to map `assert*!`s bac=
k to
> KUnit, plus to add support for test functions that return `Result`s.
>
> In essence, they get our `#[test]`s essentially on par with the documenta=
tion
> tests.
>
> I also took the chance to convert some host `#[test]`s we had to KUnit in=
 order
> to showcase the feature.
>
> Finally, I added documentation that was lacking from the original submiss=
ion.
>
> I hope this helps.

Applied to `rust-next` -- thanks everyone!

    [ Used the `cfg_attr` from the TODO comment and clarified its comment
      now that the stabilization is in beta and thus quite likely stable
      in Rust 1.88.0. Simplified the `new_body` code by introducing a new
      variable. Added `#[allow(clippy::incompatible_msrv)]`. - Miguel ]

    [ Used `::kernel` for paths. - Miguel ]

    [ Split from the next commit as suggested by Tamir. - Miguel ]

    [ Split the `CString` simplification into a new commit. - Miguel ]

Cheers,
Miguel
