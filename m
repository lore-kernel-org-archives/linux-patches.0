Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E2F1885BE
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 18:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738781692; cv=none; b=gS983a1MdR4x7q+iL5+AWFH8VOyDFHn1PSqCF4Cxy2sFdf1YGfeozwSWaIFywVFnCAvFVgdMqPXD0Lv1w1qDZBowDjIeJuJ1YEgCZ6VtukNr7nRdRfELLNVZBmHfnpauQR3x6+mEA+39MhW2WhBsNZEp9UPXO1t1JxanhqfvRso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738781692; c=relaxed/simple;
	bh=GKI/TgGTHK9mCcf0G2u02uQFtCRvXrud2LDoxZpwd4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r5Ke2MyLwP5qnxVrGg0paK88rdQarwdrmx1FpKRGTSBemk4dlxfCjFfA497YDcZ9cDcFt8WqDubF7nVi2sXs2m4QbQRzwwuDsZAfZj7wTatolZOlXBOhn5dDv2T4As3xIwK2cm+24re7N3chMm38eGBypemFiQKuoXeify38sSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hVQUlLSz; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hVQUlLSz"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-216406238f9so386645ad.2
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 10:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738781690; x=1739386490; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GKI/TgGTHK9mCcf0G2u02uQFtCRvXrud2LDoxZpwd4c=;
        b=hVQUlLSzBA5/CxWZ21hh+LbesQHZbXVTRmMHPhoorb7XcjPNRiSp/1liEtozZmmiHH
         ZB44zCQxu5HrfNXqdIYfr6zqXJw05uzdZjZAURK5a4A3kiT13oZiFXHaHnfb2TPt45xT
         OVfTog/gqQwbrfnII/CIcLtbc0ZxuUCVpycXrmeJBypn+V+2gC3i3lqJST+/N+0pjPtp
         epIZvt6EKDEMNye5y62x9hBgzZYFV8l/Hxu/T6kPhtwRsjKFnthmZzXpK/Z5pYEsHbf2
         RF1bef9HhEOH5urANN3v8dgA+XkKDiZlTb3UT1kCxZedN+4GHX3SKfF6VKZCaslJjdr0
         t7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738781690; x=1739386490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GKI/TgGTHK9mCcf0G2u02uQFtCRvXrud2LDoxZpwd4c=;
        b=eVwXA3NuCsvv4Cu3hg2RU2VHDZXuoKyZqLM4LzWSDyJPda0kA6j0kUMGpWrVnmLeaq
         gGFhGLnt4m4Q1OWoeZ0zMZs/QU/Udz+M4Fvxt0KUgbZ2a/g1Wc4hIkumcYowaUnB237q
         dTT1zs9vqW0hBXDR4RTvBwqlRf+JBVbhwc6oyd0dV9QPbs+aqzVytc7bNl8Qht3Way+u
         2baY3cz6pZe5hJ8jzvE+jZvvmMn+PzEbu9XeaK+Nt+R+57CCzkeNUJ+ud8ig3pXOglE1
         j/RqVis0hC2aw5f5qMNBtknIYStIY9oOuFdbBQhA/4gdvIsOhOY75zyFdBlZNvY+Cscx
         psrw==
X-Forwarded-Encrypted: i=1; AJvYcCUIsXqJswQ2Qqx1gIZ35RRgSrC4G7X29wD4sS/ErwaEZWQoXpULfHNq84LfZe4VwBlRA3Y8ivuO@lists.linux.dev
X-Gm-Message-State: AOJu0YwsHyfJjwxsciU5YnUdtL81NOW+9p1ki56ZEmFXNyEoXpb8thtS
	CcksO1ftj60UGFgNvR3uO+XQR1r1qCfGzUdD6XageLh23HyZJTEBWmBcBEgN1PRmOujgxMSAmw7
	2rwImR9YF8fV51mBaED30mia6Tig=
X-Gm-Gg: ASbGnctmIG1Nnn06vzAEL9kUjPHQPWpi22iAdnxs+h6vJfqfbYMVLSaId0LaD0AhAI5
	OD94Jy2mQpw1Frzpb+8E6VMgVoTtvkvSsGd+V1nyKtoI+kT8cCHzsrF3ZGK9sBLYqdXiO0Eb0
X-Google-Smtp-Source: AGHT+IGW/pLIzGfDoEdQuNy9nma0qqBDrU0/odpejhQsWKxBtsollWvE+7sbIzX1WXEs4/VLuL3GHN67pMq9fd6mhXo=
X-Received: by 2002:a17:903:46cb:b0:215:94ef:6071 with SMTP id
 d9443c01a7336-21f17f10823mr24728915ad.14.1738781689811; Wed, 05 Feb 2025
 10:54:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250129215948.135486-1-ojeda@kernel.org>
In-Reply-To: <20250129215948.135486-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 5 Feb 2025 19:54:37 +0100
X-Gm-Features: AWEUYZl2q6PUFlUvv8HUOBPZ6kUib6DW7hULi2ELqZn5-UI0MGB3ldcll9q3z3c
Message-ID: <CANiq72=e_ZZowaS4QhzxcCeN3DqaXG_ns_2MQaz0O9Z64tr0Mg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Danilo Krummrich as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
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

Applied to `rust-next` -- thanks everyone, and welcome!

Cheers,
Miguel
