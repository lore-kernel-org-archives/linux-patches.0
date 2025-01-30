Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAB951C5A
	for <patches@lists.linux.dev>; Thu, 30 Jan 2025 08:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738226182; cv=none; b=uANbwuMWOJv6EtRHNK3T3LYil6n211Qdk3SgEuv7c2nzWcx36Sc86mxocL8DUlGObuVgjUDx3/vjGcEl6oJUgPbiQAAHtuIrWr7sX4uSCii6HtIy+VIVFgq/t2IUWGzmgtcmohYqEDCPWBmPWvde+r6UNZLb3+quY1nDQZs7kYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738226182; c=relaxed/simple;
	bh=NpFyo031jesMq/Zs7w8Z4oMfinomKT3emG0OY9l0/eA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lIdk2bOhrx2RVa5siHWRxV+1NexmOni1lqTwTwCEMhdgPXT0kVJjmQxflQ6+5pF0ejSzB0yV8Y5Y7y3oC3JHgvaa9VquKBNcp8D8Hw3aBlXvqq9ozrRAK1WAst4hZjGYimzPuBlBzszVMII5YOQZ2VdnrCHAtda1YNfku+pmObA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2WNt83mR; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2WNt83mR"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43634b570c1so3230615e9.0
        for <patches@lists.linux.dev>; Thu, 30 Jan 2025 00:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738226179; x=1738830979; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NpFyo031jesMq/Zs7w8Z4oMfinomKT3emG0OY9l0/eA=;
        b=2WNt83mRy7eB2rduQav4KgjmMESCxIup/Molka8n0KlzJSebL4Cm9iS87uOJDkKzxY
         /lePkViU2gzXK7NaKx/LG/mLupbrz1E6lUD/EIcsZ/ADSZM2VgqH6rJE6+N+IGtO7qkW
         7CA2X67cJTEjhxFyWCPfypwoD9qnJTiG5rc8bVizdY0MSH5el2JTVzZuZvq6ADOrUGVb
         /p8hnP7dGbKfc0XYQ5bkQbbsfJO1rrucPfW8a7LOacsPXp+H75PWje3QOjpl8TtTpKUW
         Ef5LhHfTM9tkgdwALrdsEJzFPp/EcvlXVlIsu8kgyiRmOvoD0RVKwzEp8iIbiZGb7hLs
         JJNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738226179; x=1738830979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NpFyo031jesMq/Zs7w8Z4oMfinomKT3emG0OY9l0/eA=;
        b=fsdD4vbnH8udj2dfmZJptkcXCueZGqOvKsFVUHoRdBxXPVwfLEEfr05e31UUQH+j2A
         iFg8FqFDzqjAlzWLUv2ibDSsZ6viFW363aQBIN1D87yWeVqxlsP3vU5InAp2gTXL2FoB
         EHZIdVGUQOPfjRPLoTEPuCQsisahvmwtY1SdHVzfJtJkBtJLFrahRLBKUyjv+9rBVxlX
         6rhR+hSA3IhNUobozLC9rSgUl42LyglBmuR0rCBkKbclsDVlUq0mW9YQELCwIiKMrhkK
         YFkzYKD2DoUROxbUxtLunT7rbYQg3ZF+mMq77Tznmj8/zxS67CyTXIDpfplIEy48rtqj
         EfdQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+gKDo8VY+pWiGCKiaRO8a9rwO0EzV3oEqNbKkldmc5q3Zf+c1SB9+FHTucNEB6RPKFa+whlM2@lists.linux.dev
X-Gm-Message-State: AOJu0YzR3WrYrAyXwjP9Z3j4QFs5w9I+zOJN3fJRwKZdJePAR4wEZVFI
	y76sETgRHUIpNgLFxHajlJeIeXwPawevQaY23Vy+QKzNE6SNf2/efJtBT3ojOD8vXHOHWLodZ05
	TlC2W11iJIjMrtSD8l2Wj2khvnxGrbEj81JEr
X-Gm-Gg: ASbGncufiJfVRc3O7jZGNmv0f2S6mc0A9LLKVmrwLt55DAOr16z4f36mbxjeZYCiini
	0SI0gTmVvcFEXRzMet8E7fhzGcgl9cSgrMgsviQCYhbZHCIXukF7CGgvXTVQLohUrhjBP4LBRZ/
	zYxo9eRmQlxHN5G03AinTr0pjPZdo=
X-Google-Smtp-Source: AGHT+IHnI1LtF7nMZcqEjh9+dE8jolzjd+ED3MCX4xDE+XblHr70MsiX8qWC3045swfSoBdwoYvH2IANJawqgHJUzTU=
X-Received: by 2002:a05:600c:2d45:b0:434:ffe3:bc7d with SMTP id
 5b1f17b1804b1-438dc3c38b9mr58766015e9.16.1738226179287; Thu, 30 Jan 2025
 00:36:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250129215948.135486-1-ojeda@kernel.org>
In-Reply-To: <20250129215948.135486-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 30 Jan 2025 09:36:06 +0100
X-Gm-Features: AWEUYZmCbAuxOrTTVps7vRQ3a3AQ1uN8EqeAZv6sf-PzRBAhsABrooX2dsHc7Z8
Message-ID: <CAH5fLgiVA9wKoDmXH9KsnPt5B1_eiOwewE1pNsCusP=TE05vKA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Danilo Krummrich as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 11:00=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Danilo has been involved with the Rust for Linux project for a year now.
> He is primarily working on the Nova GPU driver [1][2].
>
> In addition, he has been active in the mailing list and most recently
> submitted the Device / Driver PCI / Platform series.
>
> He is also already a maintainer of `RUST [ALLOC]` as well as several
> other DRM-related entries.
>
> His expertise developing Rust abstractions and APIs for one of the major
> users of Rust in the kernel will be very useful to have around in the
> future. Thus add him to the `RUST` entry as reviewer.
>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Link: https://rust-for-linux.com/nova-gpu-driver [1]
> Link: https://lore.kernel.org/dri-devel/Zfsj0_tb-0-tNrJy@cassiopeiae/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Acked-by: Alice Ryhl <aliceryhl@google.com>
